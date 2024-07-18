// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "../../lib/solmate/src/tokens/ERC20.sol";
import {Ownable} from "../../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {OWNER, STARTING_SUPPLY, NAME, SYMBOL} from "./Config.sol";

/// @notice The FLK token
contract FLKToken is ERC20, Ownable {
    error InvalidSender();

    mapping(address => bool) isMinter;

    modifier onlyMinter() {
        if (!isMinter[msg.sender]) revert InvalidSender();
        _;
    }

    constructor() ERC20(NAME, SYMBOL, 18) Ownable(OWNER) {
        _mint(OWNER, STARTING_SUPPLY);
    }

    function mint(address to, uint256 amount) external onlyMinter {
        _mint(to, amount);
    }

    function setMinter(address minter) external onlyOwner {
        isMinter[minter] = true;
    }
}
