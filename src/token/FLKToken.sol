// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {OWNER, STARTING_SUPPLY, NAME, SYMBOL} from "src/token/Config.sol";

/// @notice The FLK token
contract FLKToken is ERC20Permit, Ownable {
    error OnlyBridgeHandler();

    address public bridgeHandler;

    modifier onlyBridgeHandler() {
        if (msg.sender != bridgeHandler) revert OnlyBridgeHandler();
        _;
    }

    constructor() ERC20Permit(NAME) ERC20(NAME, SYMBOL) Ownable(OWNER) {
        _mint(OWNER, STARTING_SUPPLY);
    }

    function mint(address to, uint256 amount) external onlyBridgeHandler {
        _mint(to, amount);
    }

    function setBridgeHandler(address handler) external onlyOwner {
        bridgeHandler = handler;
    }
}