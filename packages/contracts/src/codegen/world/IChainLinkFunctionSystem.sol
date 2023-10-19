// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IChainLinkFunctionSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IChainLinkFunctionSystem {
  function sendRequest(bytes32 txHash) external;

  function claim(bytes32 txHash, uint256 tokenId) external;
}