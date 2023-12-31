// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/libraries/FunctionsRequest.sol";
import {ChainLinkRequest, TxHashToChainLinkRequest, ChainLinkConfig, AweiTokenScore, ClaimRecord, Game} from "../codegen/index.sol";
import {LibERC721} from "../aweiToken/LibERC721.sol";

// Suppose to be changed when deploying
address constant ChainLinkFunctionRouter = 0x6E2dc0F9DB014aE19888F539E59285D2Ea04244C;
bytes32 constant jobId = "fun-polygon-mumbai-1";

contract ChainLinkFunctionSystem is System, FunctionsClient {
    using FunctionsRequest for FunctionsRequest.Request;

    enum Chain {
        Polygon,
        Optimism,
        Scroll
    }

    event Response(bytes32 indexed requestId, bytes response, bytes err);

    constructor() FunctionsClient(ChainLinkFunctionRouter) {}

    function claim(bytes32 txHash, uint256 tokenId) external {
        require(
            !ClaimRecord.get(txHash),
            "ChainLinkFunctionSystem: claim twice"
        );
        bytes memory response = ChainLinkRequest.getResponse(
            TxHashToChainLinkRequest.get(txHash)
        );
        require(
            response.length != 0,
            "ChainLinkFunctionSystem: request is not fulfilled"
        );

        // decode layout: address<from>,address<to>,uint256<gasUsed>
        (address from, address to, uint256 gasUsed, uint256 chainId) = abi.decode(
            response,
            (address, address, uint256, uint256)
        );
        require(
            from == _msgSender(),
            "ChainLinkFunctionSystem: not from sender"
        );
        require(
            LibERC721.ownerOf(tokenId) == _msgSender(),
            "ChainLinkFunctionSystem: can't claim others"
        );
        require(Game.get(to, chainId), "ChainLinkFunctionSystem: not a allowed game");

        uint256 currentScore = AweiTokenScore.getScore(tokenId);
        ClaimRecord.set(txHash, true);
        AweiTokenScore.setScore(tokenId, currentScore + gasUsed);
    }

    // TODO: We need some way for people to pay for fee when sending request.
    //       For now, we assume there is no abusement.
    function sendRequest(bytes32 txHash, Chain chain) external {
        FunctionsRequest.Request memory req;
        string[] memory args = new string[](1);

        // <bytes32> to <string>
        bytes memory txHashString = new bytes(66);
        uint256 txHashNum = uint256(txHash);
        txHashString[0] = "0";
        txHashString[1] = "x";
        for (uint8 j = 66; j > 2; j--) {
            uint8 i = uint8(txHashNum % 16);
            txHashNum /= 16;
            if (i < 10) txHashString[j] = bytes1(i + 48);
            else txHashString[j] = bytes1(i + 87);
        }
        args[0] = string(txHashString);

        if (chain == Chain.Polygon) {
            req.initializeRequestForInlineJavaScript(ChainLinkConfig.getPolygonSource());
        } else if (chain == Chain.Optimism) {
            req.initializeRequestForInlineJavaScript(ChainLinkConfig.getOptimismSource());
        } else if (chain == Chain.Scroll) {
            req.initializeRequestForInlineJavaScript(ChainLinkConfig.getScrollSource());
        } else {
            revert("ChainLinkFunctionSystem: invalid chain");
        }
        req.setArgs(args);

        bytes32 requestId = _sendRequest(
            req.encodeCBOR(),
            ChainLinkConfig.getSubscriptionId(),
            ChainLinkConfig.getCallbackGasLimit(),
            jobId
        );

        ChainLinkRequest.set(requestId, txHash, "", "");
        TxHashToChainLinkRequest.set(txHash, requestId);
    }

    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        ChainLinkRequest.setResponse(requestId, response);
        ChainLinkRequest.setError(requestId, err);
    }
}
