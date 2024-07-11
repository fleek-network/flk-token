// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @notice The FLK token
contract FLKToken is ERC20Permit, Ownable {
    error InvalidSender();

    mapping(address => bool) isMinter;

    modifier onlyMinter() {
        if (!isMinter[msg.sender]) revert InvalidSender();
        _;
    }

    constructor(
        address owner,
        string memory _name,
        string memory _symbol,
        uint256 startingSupply
    ) ERC20Permit(_name) ERC20(_name, _symbol) Ownable(owner) {
        _mint(owner, startingSupply);
    }

    function mint(address to, uint256 amount) external onlyMinter {
        _mint(to, amount);
    }

    function setMinter(address minter) external onlyOwner {
        isMinter[minter] = true;
    }
}
