//MIT-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract FundMeDeployScript is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        address availablePriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(availablePriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
