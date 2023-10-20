// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

interface IAxiom {
    struct TxResponse {
        // for app usage
        uint32 blockNumber;
        uint32 txIdx;
        uint8 txType;
        uint8 fieldIdx;
        bytes value;
        // for Merkle proof usage
        uint32 leafIdx;
        bytes32[] proof;
    }

    struct ReceiptResponse {
        // for app usage
        uint32 blockNumber;
        uint32 txIdx;
        uint8 fieldIdx;
        uint8 logIdx;
        bytes value;
        // for Merkle proof usage
        uint32 leafIdx;
        bytes32[] proof;
    }

    struct Proof {
        bytes32 keccakTxResponse;
        bytes32 keccakReceiptResponse;
        IAxiom.TxResponse[] txResponses;
        IAxiom.ReceiptResponse[] receiptResponses;
    }

    function areTxReceiptsValid(
        bytes32 keccakTxResponse,
        bytes32 keccakReceiptResponse,
        TxResponse[] calldata txResponses,
        ReceiptResponse[] calldata receiptResponses
    ) external view returns (bool);
}
