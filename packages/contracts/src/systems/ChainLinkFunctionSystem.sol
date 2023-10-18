// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { System } from "@latticexyz/world/src/System.sol";
import { FunctionsClient } from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/FunctionsClient.sol";
import { FunctionsRequest } from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/libraries/FunctionsRequest.sol";
import { ChainLinkRequest, TxHashToChainLinkRequest, ChainLinkConfig } from "../codegen/index.sol";

// Suppose to be changed when deploying
address constant ChainLinkFunctionRouter = 0x6E2dc0F9DB014aE19888F539E59285D2Ea04244C;
bytes32 constant jobId = "fun-polygon-mumbai-1";

contract ChainLinkFunctionSystem is System, FunctionsClient {
  using FunctionsRequest for FunctionsRequest.Request;

  event Response(bytes32 indexed requestId, bytes response, bytes err);

  constructor() FunctionsClient(ChainLinkFunctionRouter) {}

  // TODO: We need some way for people to pay for fee when sending request.
  //       For now, we assume there is no abusement.
  function sendRequest(bytes32 txHash) external {
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

    req.initializeRequestForInlineJavaScript(ChainLinkConfig.getSource());
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

  function fulfillRequest(bytes32 requestId, bytes memory response, bytes memory err) internal override {
    ChainLinkRequest.setResponse(requestId, response);
    ChainLinkRequest.setError(requestId, err);
  }
}
