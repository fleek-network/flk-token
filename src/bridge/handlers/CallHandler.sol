// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {AbstractHandler} from "bridge/handlers/AbstractHandler.sol";
import {CallFailed, UnauthorizedSender} from "bridge/Errors.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

struct CallHandlerIncomingMessage {
    address sender;
    address target;
    bytes data;
}

/// The handler in charge of passing arbitray messges between fleek and ethereum
contract CallHandler is AbstractHandler {
    /// @notice map the senders from the other side of the bridge to an indivual address
    /// @dev needed to avoid auth vulns
    mapping(address => Puppet) public puppet;

    /// @notice The puppet implementation deployed by this
    address public immutable puppetImpl;

    constructor(address _messageCenter) AbstractHandler(_messageCenter) {
        puppetImpl = address(new Puppet());
    }

    /// @notice No op, all data is valid
    function _handleOutgoingMessage(bytes memory) internal view override {
        // no op, all calls are valid into this handler
    }

    /// @dev Handle messages from the message center
    /// @dev implementors should take care to validate the sender of the message is the message center
    function _handleIncomingMessage(bytes memory data) internal override {
        CallHandlerIncomingMessage memory message = abi.decode(data, (CallHandlerIncomingMessage));

        // need to check if weve deployed a puppet for this sender before
        Puppet maybePuppet = puppet[message.sender];
        if (address(maybePuppet) == address(0)) {
            maybePuppet = Puppet(address(Clones.clone(puppetImpl)));

            puppet[message.sender] = Puppet(maybePuppet);
        }

        maybePuppet.doCall(message.target, message.data);
    }
}

contract Puppet {
    address public immutable owner;

    // inline immutable var at construction
    // this will get shared with all the clones
    constructor() {
        owner = msg.sender;
    }

    function doCall(address target, bytes calldata data) external {
        if (msg.sender != owner) revert UnauthorizedSender();

        (bool success,) = target.call(data);
        if (!success) revert CallFailed();
    }
}
