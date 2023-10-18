// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {IWorld} from "../src/codegen/world/IWorld.sol";

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

        vm.stopBroadcast();
    }
}
