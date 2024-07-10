// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

/**
 * @title: Idle Perpetual Yield Tranches wrapper for senior tranche of the Euler staking PYT
 * @summary: Used for interacting with Idle senior PYTs. Has
 *           a common interface with all other protocol wrappers.
 *           This contract holds assets only during a tx, after tx it should be empty
 * @author: Idle Labs Inc., idle.finance
 */
import "./Contract.sol";

interface IMMVault {
  function maxWithdraw(address owner) external view returns (uint256);
}

// This contract should be deployed with a minimal proxy factory
contract MetamorphoPYTStrategy is IdlePYT {
  /**
   * Get the underlying balance available on the lending protocol
   *
   * @return underlying tokens available
   */
  function availableLiquidity() external override view returns (uint256) {
    IIdleCDO _idleCDO = idleCDO;
    IERC20Upgradeable _underlyingContract = underlyingContract;

    // add max withdrawal balance for the Metamorpho vault used by IdleCDO
    IMMVault mmVault = IMMVault(_idleCDO.strategyToken());

    return 
      _underlyingContract.balanceOf(address(_idleCDO)) + 
      mmVault.maxWithdraw(address(_idleCDO));
  }
}
