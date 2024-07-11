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
        token.setMinter(address(this));
        token.mint(address(this), 1e18);
        assertEq(token.balanceOf(address(this)), 2e18);
    }

    function testMintOnlyBridgeHandler() public {
        vm.expectRevert();
        token.mint(address(this), 1e18);
    }

    function testOnlyOwner(address owner) public {
        vm.assume(owner != address(this));
        vm.startPrank(owner);
        vm.expectRevert();
        token.setMinter(address(this));
    }
}
