import { mudConfig } from "@latticexyz/world/register";

const ADMINS = ["0xe71D06F3720908FA56cfC88d7F37dbEca8a0DE61"];

export default mudConfig({
  systems: {
    ChainLinkFunctionSystem: {
      openAccess: true,
    },
    ConfigSystem: {
      openAccess: false,
      accessList: [...ADMINS],
    },
  },
  tables: {
    ChainLinkConfig: {
      keySchema: {},
      valueSchema: {
        subscriptionId: "uint64",
        callbackGasLimit: "uint32",
        source: "string",
      },
    },
    ChainLinkRequest: {
      valueSchema: {
        txHash: "bytes32",
        response: "bytes",
        error: "bytes",
      },
      keySchema: {
        requestId: "bytes32",
      },
    },
    TxHashToChainLinkRequest: {
      valueSchema: {
        requestId: "bytes32",
      },
      keySchema: {
        txHash: "bytes32",
      },
    },
    AweiTokenMetadata: {
      keySchema: {},
      valueSchema: {
        totalSupply: "uint256",
        proxy: "address",
        name: "string",
        symbol: "string",
      },
      tableIdArgument: true,
    },
    AweiToken: {
      keySchema: {
        tokenId: "uint256",
      },
      valueSchema: {
        owner: "address",
        tokenApproval: "address",
        uri: "string",
      },
      tableIdArgument: true,
    },
    AweiTokenBalance: {
      keySchema: { owner: "address" },
      valueSchema: "uint256",
      tableIdArgument: true,
    },
    AweiTokenApproval: {
      keySchema: { owner: "address", spender: "address" },
      valueSchema: "bool",
      tableIdArgument: true,
    },
  },
});
