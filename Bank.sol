// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./KYCStorage.sol";

contract Bank {
    KYCStorage public kycStorage;
    address public bankAddress;

    modifier onlyBank() {
        require(msg.sender == bankAddress, "Only this bank can perform this action");
        _;
    }

    constructor(address _kycStorage) {
        kycStorage = KYCStorage(_kycStorage);
        bankAddress = msg.sender; // The bank's address is set upon deployment
    }

    // Register KYC
    function registerKYC(string memory name, string memory dob) external onlyBank returns (uint) {
        return kycStorage.addRegisteredKYC(name, dob, bankAddress);
    }

    // Move KYC to pending
    function moveToPendingKYC(uint id) external onlyBank {
        kycStorage.moveToPendingKYC(id);
    }

    function findKYCId(string memory name, string memory dob) external view returns (uint) {
        return kycStorage.findKYCId(name, dob); // Call the findKYCId function from KYCStorage
    }
}
