// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {LibERC721} from "../aweiToken/LibERC721.sol";
import {Config} from "../codegen/index.sol";

contract TokenSystem is System {
    function mint() external payable {
        require(
            msg.value >= Config.getMintPrice(),
            "TokenSystem: insufficient funds"
        );
        LibERC721._mint(_msgSender(), LibERC721.totalSupply() + 1);
        payable(Config.getReceiver()).transfer(msg.value);
    }
}
