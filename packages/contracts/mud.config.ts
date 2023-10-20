import { mudConfig } from "@latticexyz/world/register";

const ADMINS = [process.env.ADDRESS as string];

export default mudConfig({
  excludeSystems: ["ChainLinkFunctionSystem"],
  enums: {
    VoteType: ["ADD", "REMOVE"],
  },
  systems: {
    ChainLinkFunctionSystem: {
      openAccess: true,
    },
    ConfigSystem: {
      openAccess: false,
      accessList: [...ADMINS],
    },
    TokenSystem: {
      openAccess: true,
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
    Config: {
      keySchema: {},
      valueSchema: {
        mintPrice: "uint256",
        receiver: "address",
        epochStart: "uint256",
        epochPeriod: "uint256",
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
      storeArgument: true,
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
      storeArgument: true,
    },
    AweiTokenBalance: {
      keySchema: { owner: "address" },
      valueSchema: "uint256",
      tableIdArgument: true,
      storeArgument: true,
    },
    AweiTokenApproval: {
      keySchema: { owner: "address", spender: "address" },
      valueSchema: "bool",
      tableIdArgument: true,
      storeArgument: true,
    },
    AweiTokenScore: {
      keySchema: {
        tokenId: "uint256",
      },
      valueSchema: {
        score: "uint256",
      },
    },
    ClaimRecord: {
      keySchema: {
        key: "bytes32",
      },
      valueSchema: "bool",
    },
    Game: {
      keySchema: {
        key: "address",
      },
      valueSchema: "bool",
    },
    Vote: {
      keySchema: {
        voter: "address",
      },
      valueSchema: {
        game: "address",
        epoch: "uint256",
        voteType: "VoteType",
      },
    },
  },
});
