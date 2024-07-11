// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FLKToken} from "token/FLKToken.sol";

contract TokenTest is Test {
    FLKToken public token;

    function setUp() public {
        token = new FLKToken(address(this), "FLK Token", "FLK", 1e18);
    }

    function testMint() public {
        token.setBridgeHandler(address(this));
        token.mint(address(this), 1e18);
        assertEq(token.balanceOf(address(this)), 2e18);
    }

    function testMintOnlyBridgeHandler() public {
        vm.expectRevert();
        token.mint(address(this), 1e18);
    }

    function testOnlyOwner() public {
        vm.startPrank(address(11));
        vm.expectRevert();
        token.setBridgeHandler(address(this));
    }
}
