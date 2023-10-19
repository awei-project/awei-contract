// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {IBaseWorld} from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import {ERC721Proxy} from "./ERC721Proxy.sol";
import {ResourceId} from "@latticexyz/store/src/ResourceId.sol";
import {AweiToken, AweiTokenMetadata, AweiTokenBalance, AweiTokenApproval} from "../codegen/index.sol";
import {RESOURCE_TABLE} from "@latticexyz/store/src/storeResourceTypes.sol";
import {ROOT_NAMESPACE} from "@latticexyz/world/src/constants.sol";

library ERC721Registration {
    function install(
        IBaseWorld world,
        bytes16 namespace,
        string memory _name,
        string memory _symbol
    ) internal {
        ERC721Proxy proxy = new ERC721Proxy(world, namespace);

        ResourceId metadataTableId = registerTables(world, namespace);

        address proxyAddress = address(proxy);

        // set token metadata
        AweiTokenMetadata.setProxy(world, metadataTableId, proxyAddress);
        AweiTokenMetadata.setName(world, metadataTableId, _name);
        AweiTokenMetadata.setSymbol(world, metadataTableId, _symbol);

        proxyAddress = AweiTokenMetadata.getProxy(world, metadataTableId);

        // let the proxy contract modify tables directly
        world.grantAccess(
            ResourceId.wrap(
                bytes32(
                    abi.encodePacked(
                        RESOURCE_TABLE,
                        bytes14(namespace),
                        bytes16("AweiTokenMetadat")
                    )
                )
            ),
            proxyAddress
        );
        world.grantAccess(
            ResourceId.wrap(
                bytes32(
                    abi.encodePacked(
                        RESOURCE_TABLE,
                        bytes14(namespace),
                        bytes16("AweiTokenApprova")
                    )
                )
            ),
            proxyAddress
        );
        world.grantAccess(
            ResourceId.wrap(
                bytes32(
                    abi.encodePacked(
                        RESOURCE_TABLE,
                        bytes14(namespace),
                        bytes16("AweiTokenBalance")
                    )
                )
            ),
            proxyAddress
        );
        world.grantAccess(
            ResourceId.wrap(
                bytes32(
                    abi.encodePacked(
                        RESOURCE_TABLE,
                        bytes14(namespace),
                        bytes16("AweiToken")
                    )
                )
            ),
            proxyAddress
        );
    }

    function install(
        IBaseWorld world,
        string memory _name,
        string memory _symbol
    ) internal {
        install(world, ROOT_NAMESPACE, _name, _symbol);
    }

    function registerTables(
        IBaseWorld world,
        bytes16 namespace
    ) private returns (ResourceId tableId) {
        tableId = ResourceId.wrap(
            bytes32(
                abi.encodePacked(
                    RESOURCE_TABLE,
                    bytes14(namespace),
                    bytes16("AweiTokenBalance")
                )
            )
        );
        AweiTokenBalance.register(world, tableId);

        tableId = ResourceId.wrap(
            bytes32(
                abi.encodePacked(
                    RESOURCE_TABLE,
                    bytes14(namespace),
                    bytes16("AweiTokenApprova")
                )
            )
        );
        AweiTokenApproval.register(world, tableId);

        tableId = ResourceId.wrap(
            bytes32(
                abi.encodePacked(
                    RESOURCE_TABLE,
                    bytes14(namespace),
                    bytes16("AweiToken")
                )
            )
        );
        AweiToken.register(world, tableId);

        tableId = ResourceId.wrap(
            bytes32(
                abi.encodePacked(
                    RESOURCE_TABLE,
                    bytes14(namespace),
                    bytes16("AweiTokenMetadat")
                )
            )
        );
        AweiTokenMetadata.register(world, tableId);
    }
}
