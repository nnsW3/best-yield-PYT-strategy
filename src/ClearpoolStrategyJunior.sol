// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

/**
 * @title: Idle Perpertual Yield Tranches wrapper for senior tranche
 * @summary: Used for interacting with Idle senior PYTs. Has
 *           a common interface with all other protocol wrappers.
 *           This contract holds assets only during a tx, after tx it should be empty
 * @author: Idle Labs Inc., idle.finance
 */
import "@oz-upgradeable/contracts/token/ERC20/IERC20Upgradeable.sol";
import "@oz-upgradeable/contracts/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "./ClearpoolStrategy.sol";

// This contract should be deployed with a minimal proxy factory
contract IdlePYTClearJunior is IdlePYTClear {
  using SafeERC20Upgradeable for IERC20Upgradeable;

    /**
   * Gets all underlying tokens in this contract and mints cTokenLike Tokens
   * tokens are then transferred to msg.sender
   * NOTE: underlying tokens needs to be sent here before calling this
   *
   * @return minted : tranche tokens minted
   */
  function mint()
    external override
    returns (uint256 minted) {
      _onlyIdle();
      uint256 balance = underlyingContract.balanceOf(address(this));
      if (balance != 0) {
        idleCDO.depositBB(balance);
        IERC20Upgradeable _token = tokenContract;
        minted = _token.balanceOf(address(this));
        _token.safeTransfer(msg.sender, minted);
      }
  }

  /**
   * Gets all cTokenLike in this contract and redeems underlying tokens.
   * underlying tokens are then transferred to `_account`
   * NOTE: cTokenLike needs to be sent here before calling this
   *
   * @return tokens underlying tokens redeemd
   */
  function redeem(address _account)
    external override
    returns (uint256 tokens) {
      _onlyIdle();
      idleCDO.withdrawBB(tokenContract.balanceOf(address(this)));
      IERC20Upgradeable _underlying = underlyingContract;
      tokens = _underlying.balanceOf(address(this));
      _underlying.safeTransfer(_account, tokens);
  }
}
