// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {AweiTokenScore, ClaimRecord, Game} from "../codegen/index.sol";
import {LibERC721} from "../aweiToken/LibERC721.sol";
import {IAxiom} from "../axiom.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract AxiomSystem is System {
    IAxiom constant axiom = IAxiom(0xCa057924353E372d7c46F194ed0d75eABA7f1ed1);

    function claim(
        bytes calldata txPayload,
        uint8 v, // v is restricted so we don't need to worry about cheating
        IAxiom.Proof calldata proof,
        uint256 tokenId
    ) external {
        address to = address(uint160(bytes20(txPayload[23:43])));
        require(Game.get(to), "AxiomSystem: not a allowed game");

        bytes32 txHash = keccak256(txPayload);
        require(!ClaimRecord.get(txHash), "AxiomSystem: claim twice");

        require(
            axiom.areTxReceiptsValid(
                proof.keccakTxResponse,
                proof.keccakReceiptResponse,
                proof.txResponses,
                proof.receiptResponses
            ),
            "AxiomSystem: invalid proof"
        );

        // 0 -> r, 1 -> s
        address sender = ECDSA.recover(
            txHash,
            v,
            bytes32(proof.txResponses[0].value),
            bytes32(proof.txResponses[1].value)
        );
        require(sender == _msgSender(), "AxiomSystem: not from sender");
        require(
            LibERC721.ownerOf(tokenId) == _msgSender(),
            "AxiomSystem: can't claim others"
        );

        // it's CumulativeGas but indeed we need gasUsed
        // for now it's a dummy value
        uint256 gasUsed;
        bytes memory gasUsedBytes = proof.receiptResponses[0].value;
        assembly {
            gasUsed := mload(add(gasUsedBytes, 0x20))
        }

        uint256 currentScore = AweiTokenScore.getScore(tokenId);
        ClaimRecord.set(txHash, true);
        AweiTokenScore.setScore(tokenId, currentScore + gasUsed);
    }
}
