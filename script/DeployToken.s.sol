// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FLKToken} from "token/FLKToken.sol";
import {OWNER, STARTING_SUPPLY, NAME, SYMBOL} from "token/Config.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();

        new FLKToken();
    }
}
