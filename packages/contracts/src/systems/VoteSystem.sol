// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {AweiTokenScore, Vote, Config} from "../codegen/index.sol";
import {VoteType} from "../codegen/common.sol";

// Compute vote result on-chain is expensive, hence we only record the
// decision instead of voting power
contract VoteSystem is System {
    // input all tokens a user have and output the power it have
    // off-chain call only
    function computeVotingPower(
        uint256[] calldata _tokenIds
    ) external view returns (uint256) {
        uint256 i = _tokenIds.length - 1;
        uint256 power = 0;
        for (; i >= 0; i--) {
            power += AweiTokenScore.getScore(_tokenIds[i]);
        }
        return power;
    }

    function voteTo(address game, VoteType voteType) external {
        uint256 currentEpoch = Config.getEpochStart();
        uint256 epochPeriod = Config.getEpochPeriod();
        if (block.timestamp > currentEpoch + epochPeriod) {
            Config.setEpochStart(currentEpoch + epochPeriod);
            currentEpoch = Config.getEpochStart();
        }

        Vote.set(_msgSender(), game, currentEpoch, voteType);
    }
}
