// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/interfaces/IIdleCDO.sol";
import "../src/interfaces/IIdleToken.sol";
import "../src/Contract.sol";
import "@oz-upgradeable/contracts/token/ERC20/IERC20Upgradeable.sol";

contract ContractTest is Test {
  using stdStorage for StdStorage;

  address public constant IDLE_TOKEN = 0x3fE7940616e5Bc47b0775a0dccf6237893353bB4; // idleDAI
  address public constant UNDERLYING = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI
  address public constant AA_TRANCHE = 0x852c4d2823E98930388b5cE1ed106310b942bD5a; // AA_eDAI
  address public constant CDO = 0x46c1f702A6aAD1Fd810216A5fF15aaB1C62ca826; // eDAICDO
  IIdleToken public idleToken;
  IIdleCDO public idleCDO;
  IERC20Upgradeable public underlying;
  IERC20Upgradeable public tranche;
  IdlePYT public strategy;
  uint256 public initialTrancheBalance;
  
  function setUp() public {
    idleToken = IIdleToken(IDLE_TOKEN);
    idleCDO = IIdleCDO(CDO);
    underlying = IERC20Upgradeable(UNDERLYING);
    tranche = IERC20Upgradeable(AA_TRANCHE);
    strategy = new IdlePYT();
    stdstore
      .target(address(strategy))
      .sig(strategy.token.selector)
      .checked_write(address(0));
    strategy.initialize(AA_TRANCHE, IDLE_TOKEN, CDO);
    // give 10M to this contract
    deal(address(underlying), address(this), 100000000 * 1e18, true);
    // approve idleToken to spend underlyings
    underlying.approve(IDLE_TOKEN, type(uint256).max);

    vm.label(address(strategy), "strategy");
    vm.label(UNDERLYING, "underlying");
    vm.label(IDLE_TOKEN, "idleToken");
    vm.label(CDO, "idleCDO");
    vm.label(AA_TRANCHE, "AATranche");
  }

  function testInitialize() public {
    assertTrue(address(strategy.idleCDO()) == CDO);
    assertTrue(strategy.token() == AA_TRANCHE);
    assertTrue(strategy.underlying() == UNDERLYING);
    assertTrue(strategy.idleToken() == IDLE_TOKEN);
    assertTrue(underlying.allowance(address(strategy), CDO) == type(uint256).max);
  }

  function testCannotMint() public {
    underlying.transfer(address(strategy), 1e18);
  }

  function testMint() public {
    uint256 _tranchePrice = strategy.getPriceInToken();
    uint256 _amount = 1000e18;
    deposit(_amount);

    uint256 trancheBal = tranche.balanceOf(address(idleToken));
    assertEq(trancheBal - initialTrancheBalance, _amount * 1e18 / _tranchePrice);
  }

  function testCannotRedeem() public {
    vm.expectRevert(abi.encodeWithSignature("Unauthorized()"));
    strategy.redeem(address(this));
  }

  function testRedeem() public {
    uint256 balPre = underlying.balanceOf(address(this));
    deposit(1000e18);
    skip(1 days);
    vm.roll(block.number + 1); // avoid reentrancy check
    idleToken.redeemIdleToken(idleToken.balanceOf(address(this)));
    assertGt(underlying.balanceOf(address(this)), balPre);
  }

  function testPrice() public {
    assertEq(strategy.getPriceInToken(), idleCDO.virtualPrice(address(tranche)));
  }

  function testAPR() public {
    uint256 apr = idleCDO.getApr(address(tranche));
    // fee is 10% 
    apr = apr * 9 / 10;
    assertEq(strategy.getAPR(), apr);
  }

  function testNextSupplyRate() public {
    // deposit some tokens in the junior side to balance the ratio a bit
    underlying.approve(address(idleCDO), type(uint256).max);
    idleCDO.depositBB(1000000e18);
    _updateIdleTokenStrategy(address(strategy));
    assertEq(strategy.nextSupplyRate(0), strategy.getAPR());

    uint256 apr = idleCDO.getApr(address(tranche));
    uint256 _amount = 1000000e18;
    // in PYTs apr increases for the specific tranche with more TVL
    assertGt(
      strategy.nextSupplyRate(_amount), 
      apr * 9 / 10
    );
  }

  function deposit(uint256 _amount) public {
    // move idleToken funds in to the tested strategy
    _updateIdleTokenStrategy(address(strategy));
    initialTrancheBalance = tranche.balanceOf(address(idleToken));
    // deposit
    idleToken.mintIdleToken(_amount, true, address(0));
    // put funds in the strategy
    vm.prank(idleToken.rebalancer());
    idleToken.rebalance();
  }

  // WARN: Don't call this in the setUp otherwise it won't work
  function _updateIdleTokenStrategy(address _strategy) internal {
    // set the strategy as one of the available ones
    address[] memory allTokens = idleToken.getAllAvailableTokens();
    uint256 len = allTokens.length;
    address[] memory protocolTokens = new address[](len + 1);
    address[] memory wrappers = new address[](len + 1);
    address[] memory _newGovTokens = new address[](len);
    address[] memory _newGovTokensEqualLen = new address[](len + 1);

    // loop through all the tokens and add populate the arrays
    // for the setAllAvailableTokensAndWrappers call
    for (uint256 i = 0; i < len; i++) {
      protocolTokens[i] = allTokens[i];
      wrappers[i] = idleToken.protocolWrappers(allTokens[i]);
      _newGovTokensEqualLen[i] = idleToken.getProtocolTokenToGov(allTokens[i]);
    }
    _newGovTokens = idleToken.getGovTokens();
    protocolTokens[len] = strategy.token();
    wrappers[len] = _strategy;
    _newGovTokensEqualLen[len] = address(0);

    // add the strategy to the idleToken and set unlent to 0 for easy calc
    vm.startPrank(idleToken.owner());
    idleToken.setAllAvailableTokensAndWrappers(protocolTokens, wrappers, _newGovTokens, _newGovTokensEqualLen);
    idleToken.setMaxUnlentPerc(0);
    idleToken.setFee(0);
    vm.stopPrank();

    // put funds in the strategy
    vm.startPrank(idleToken.rebalancer());
    // set allocations
    uint256[] memory alloc = new uint256[](len + 1);
    alloc[len] = 100000; // all in current strategy
    idleToken.setAllocations(alloc);

    // rebalance
    idleToken.rebalance();
    vm.stopPrank();
  }
}
