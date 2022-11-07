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
import "./Contract.sol";
import "./interfaces/IIdleCDOStrategy.sol";
import "./interfaces/IIdleCDOStrategyClear.sol";

// This contract should be deployed with a minimal proxy factory
contract IdlePYTClear is IdlePYT {
  /**
   * Get the underlying balance available on the lending protocol
   *
   * @return underlying tokens available
   */
  function availableLiquidity() external override view returns (uint256) {
    IERC20Upgradeable _underlying = underlyingContract;
    IIdleCDO _cdo = idleCDO;
    return _underlying.balanceOf(address(_cdo)) +
      _underlying.balanceOf(IIdleCDOStrategyClear(_cdo.strategy()).cpToken());
  }
}
