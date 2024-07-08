// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {OWNER, STARTING_SUPPLY, NAME, SYMBOL} from "src/token/Config.sol";

/// @notice The FLK token
contract FLK is ERC20, Ownable {
    constructor(address _owner) ERC20(NAME, SYMBOL) Ownable(_owner) {
        _mint(OWNER, STARTING_SUPPLY);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
