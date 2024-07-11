// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "solmate/tokens/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @notice The FLK token
contract FLKToken is ERC20, Ownable {
    error InvalidSender();

    mapping(address => bool) isMinter;

    modifier onlyMinter() {
        if (!isMinter[msg.sender]) revert InvalidSender();
        _;
    }

    constructor(
        address _owner,
        string memory _name,
        string memory _symbol,
        uint256 startingSupply
    ) ERC20(_name, _symbol, 18) Ownable(_owner) {
        _mint(_owner, startingSupply);
    }

    function mint(address to, uint256 amount) external onlyMinter {
        _mint(to, amount);
    }

    function setMinter(address minter) external onlyOwner {
        isMinter[minter] = true;
    }
}
