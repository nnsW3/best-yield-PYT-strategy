// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
interface IIdleCDOStrategy {
  function getApr() external view returns(uint256);
}