// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {UnauthorizedSender} from "src/Errors.sol";

abstract contract AbstractHandler {
    address public immutable messageCenter;

    constructor(address _messageCenter) {
        messageCenter = _messageCenter;
    }

    modifier onlyMessageCenter() {
        if (msg.sender != messageCenter) revert UnauthorizedSender();
        _;
    }

    /// @notice Handle an outgoing message to the FLK chain
    /// @notice This function is only callable by the message center
    function handleOutgoingMessage(bytes calldata data) external onlyMessageCenter {
        _handleOutgoingMessage(data);
    }

    /// @notice Handle an incoming message from the FLK chain
    /// @notice This function is only callable by the message center
    function handleIncomingMessage(bytes calldata data) external onlyMessageCenter {
        _handleIncomingMessage(data);
    }

    /// @dev Implementors should ensure that any invalid messages to this handler revert!
    /// @dev Otherwise the message center will emit the event as if its valid!
    function _handleIncomingMessage(bytes memory data) internal virtual;

    /// @dev Implementors should ensure that any invalid messages to this handler revert!
    /// @dev Otherwise the message center will emit the event as if its valid!
    function _handleOutgoingMessage(bytes memory data) internal virtual;
}
