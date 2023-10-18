// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { System } from "@latticexyz/world/src/System.sol";
import { ChainLinkRequest, TxHashToChainLinkRequest, ChainLinkConfig } from "../codegen/index.sol";

contract ConfigSystem is System {
  function setSource(string memory _source) external {
    ChainLinkConfig.setSource(_source);
  }

  function setSubscriptionId(uint64 _subscriptionId) external {
    ChainLinkConfig.setSubscriptionId(_subscriptionId);
  }

  function setCallbackGasLimit(uint32 _callbackGasLimit) external {
    ChainLinkConfig.setCallbackGasLimit(_callbackGasLimit);
  }
}