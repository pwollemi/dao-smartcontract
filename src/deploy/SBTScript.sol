// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import "../SBT.sol";

contract SBTScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        SBT sbt = new SBT("SBT", "SBT", "https://sbt.com");
        vm.stopBroadcast();
    }
}
