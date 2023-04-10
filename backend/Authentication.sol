// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Authentication {
    struct Device {
        uint256 passwordHash;
        uint256 bubbleId;
    }

    mapping (int256 => mapping (int256 => Device)) private devices;

    function register(int256 deviceId, uint256 password, uint256 bubbleId) external payable {
        require(devices[int256(bubbleId)][int256(deviceId)].passwordHash == 0, "Device already registered");
        uint256 passwordHash = uint256(keccak256(abi.encodePacked(password)));
        devices[int256(bubbleId)][int256(deviceId)] = Device(passwordHash, bubbleId);
    }

    function login(int256 deviceId, uint256 password, uint256 bubbleId) external view returns (bool) {
        uint256 passwordHash = uint256(keccak256(abi.encodePacked(password)));
        return devices[int256(bubbleId)][int256(deviceId)].passwordHash == passwordHash;
    }

    mapping (int256 => mapping (int256 => mapping (uint256 => string))) private messages;

    function sendMessage(int256 senderId, int256 receiverId, uint256 bubbleId, string memory message) external {
        require(devices[int256(bubbleId)][int256(senderId)].passwordHash != 0, "Sender not registered");
        require(devices[int256(bubbleId)][int256(receiverId)].passwordHash != 0, "Receiver not registered");
        uint256 key = uint256(keccak256(abi.encodePacked(senderId, receiverId)));
        messages[int256(bubbleId)][int256(senderId)][key] = message;
    }

    function getMessage(int256 senderId, int256 receiverId, uint256 bubbleId) external view returns (string memory) {
        uint256 key = uint256(keccak256(abi.encodePacked(senderId, receiverId)));
        return messages[int256(bubbleId)][int256(receiverId)][key];
    }
}
