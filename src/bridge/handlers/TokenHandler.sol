// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {AbstractHandler} from "bridge/handlers/AbstractHandler.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

struct TokenHandlerMessage {
    address token;
    address recipient;
    uint256 amount;
}

contract TokenHandler is Ownable, AbstractHandler {
    using SafeERC20 for IERC20;

    mapping(address => bool) public authorizedTokens;

    constructor(address _messageCenter, address _owner) Ownable(_owner) AbstractHandler(_messageCenter) {}

    /// @notice Attmepts to transfer the token from the sender into this contract
    /// @dev requires approval from the sender
    function _handleOutgoingMessage(bytes memory data) internal override {
        TokenHandlerMessage memory message = abi.decode(data, (TokenHandlerMessage));

        IERC20(message.token).safeTransferFrom(msg.sender, address(this), message.amount);
    }

    /// @dev Handle messages from the message center
    function _handleIncomingMessage(bytes memory data) internal override {
        TokenHandlerMessage memory message = abi.decode(data, (TokenHandlerMessage));

        IERC20(message.token).safeTransfer(message.recipient, message.amount);
    }

    /// @notice Authorizes a token to be used by this handler
    function toggleToken(address token) external onlyOwner {
        authorizedTokens[token] = !authorizedTokens[token];
    }
}
