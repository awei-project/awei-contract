// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";

import { IAxiomSystem } from "./IAxiomSystem.sol";
import { IConfigSystem } from "./IConfigSystem.sol";
import { ITokenSystem } from "./ITokenSystem.sol";
import { IVoteSystem } from "./IVoteSystem.sol";

/**
 * @title IWorld
 * @notice This interface integrates all systems and associated function selectors
 * that are dynamically registered in the World during deployment.
 * @dev This is an autogenerated file; do not edit manually.
 */
interface IWorld is IBaseWorld, IAxiomSystem, IConfigSystem, ITokenSystem, IVoteSystem {

}
