// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {IWorld} from "../src/codegen/world/IWorld.sol";
import {ResourceId, ResourceIdLib} from "@latticexyz/store/src/ResourceId.sol";
import {WorldResourceIdInstance} from "@latticexyz/world/src/WorldResourceId.sol";
import {RESOURCE_TABLE, RESOURCE_OFFCHAIN_TABLE} from "@latticexyz/store/src/storeResourceTypes.sol";
import {ERC721Registration} from "../src/aweiToken/ERC721Registration.sol";
import {TxHashToChainLinkRequest, ChainLinkRequest, Config, ChainLinkConfig} from "../src/codegen/index.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";

import "forge-std/console.sol";

contract PostDeploy is Script {
    function run(address worldAddress) external {
        StoreSwitch.setStoreAddress(worldAddress);
        // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.envAddress("ADDRESS");
        IWorld world = IWorld(worldAddress);

        // Start broadcasting transactions from the deployer account
        vm.startBroadcast(deployerPrivateKey);

        // We may need to do it manually
        // world.setSource("Hell world");
        world.setSubscriptionId(394);
        world.setCallbackGasLimit(1);
        ERC721Registration.install(world, "Awei Gotchi", "AWEI");
        world.setMintPrice(0.00001 ether);
        world.setReceiver(deployerAddress);

        Config.setEpochStart(block.timestamp - (block.timestamp % (1 weeks)));
        Config.setEpochPeriod(1 weeks);

        ChainLinkConfig.setPolygonSource(vm.readFile("script/functions/provePolygon.source.js"));
        ChainLinkConfig.setScrollSource(vm.readFile("script/functions/proveScroll.source.js"));
        ChainLinkConfig.setOptimismSource(vm.readFile("script/functions/proveOptimism.source.js"));

        vm.stopBroadcast();

        /*// ChainLink tests
        vm.startBroadcast(deployerPrivateKey);
        TxHashToChainLinkRequest.set(
            world,
            0x47ac8908a0a6715c6b267e40ce13cff455e54bed6b8aeadfc4e73a3aaf56bc63,
            0x47ac8908a0a6715c6b267e40ce13cff455e54bed6b8aeadfc4e73a3aaf56bc63
        );
        ChainLinkRequest.set(
            world,
            0x47ac8908a0a6715c6b267e40ce13cff455e54bed6b8aeadfc4e73a3aaf56bc63,
            0x47ac8908a0a6715c6b267e40ce13cff455e54bed6b8aeadfc4e73a3aaf56bc63,
            hex"0000000000000000000000004281ecf07378ee595c564a59048801330f3084ee000000000000000000000000326c977e6efc84e512bb9c30f76e30c160ed06fb000000000000000000000000000000000000000000000000000000000000879e",
            ""
        );
        vm.stopBroadcast();
        vm.startPrank(0x4281eCF07378Ee595C564a59048801330f3084eE);
        world.mint{value: 0.01 ether}();
        world.claim(
            0x47ac8908a0a6715c6b267e40ce13cff455e54bed6b8aeadfc4e73a3aaf56bc63,
            1
        );
        vm.stopPrank();
        // end chainlink tests */
    }
}
