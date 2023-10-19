// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {IWorld} from "../src/codegen/world/IWorld.sol";
import {ResourceId, ResourceIdLib} from "@latticexyz/store/src/ResourceId.sol";
import {WorldResourceIdInstance} from "@latticexyz/world/src/WorldResourceId.sol";
import {RESOURCE_TABLE, RESOURCE_OFFCHAIN_TABLE} from "@latticexyz/store/src/storeResourceTypes.sol";
import {ERC721Registration} from "../src/aweiToken/ERC721Registration.sol";
import {AweiTokenBalance} from "../src/codegen/index.sol";
import {AweiToken, AweiTokenMetadata, AweiTokenBalance, AweiTokenApproval} from "../src/codegen/index.sol";

import "forge-std/console.sol";

contract PostDeploy is Script {
    function run(address worldAddress) external {
        // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        IWorld world = IWorld(worldAddress);

        // Start broadcasting transactions from the deployer account
        vm.startBroadcast(deployerPrivateKey);

        // We may need to do it manually
        // world.setSource("Hell world");
        world.setSubscriptionId(394);
        world.setCallbackGasLimit(1);
        ERC721Registration.install(world, "Awei Token", "AWEI");
        world.mint();

        vm.stopBroadcast();
    }
}
