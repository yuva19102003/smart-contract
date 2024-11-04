// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./KYCStorage.sol";

contract Admin {
    address constant admin = 0x83E501EA97Dc4738be1Cd0D9BB48b0C05Bcb1AAD;
    KYCStorage public kycStorage;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor(address _kycStorage) {
        kycStorage = KYCStorage(_kycStorage);
    }

    // Approve KYC
    function approveKYC(uint id) external onlyAdmin {
        kycStorage.approveKYC(id);
    }

    // Reject KYC
    function rejectKYC(uint id) external onlyAdmin {
        kycStorage.rejectKYC(id);
    }

    // Get KYC Status
    function getKYCStatus(uint id) external view returns (string memory) {
        return kycStorage.getKYCStatus(id);
    }

    function findKYCId(string memory name, string memory dob) external view returns (uint) {
        return kycStorage.findKYCId(name, dob); // Call the findKYCId function from KYCStorage
    }
}