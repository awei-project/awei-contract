// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Config, ChainLinkConfig, Game} from "../codegen/index.sol";

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

    function setMintPrice(uint256 _price) external {
        Config.setMintPrice(_price);
    }

    function setReceiver(address _receiver) external {
        Config.setReceiver(_receiver);
    }

    function setGame(address _game, bool _allowed) external {
        Game.set(_game, _allowed);
    }
}
