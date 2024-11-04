// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./KYCStorage.sol"; // Make sure the path is correct based on your directory structure

contract KYCListContract {
    KYCStorage public kycStorage;

    // Constructor to set the KYCStorage contract address
    constructor(address _kycStorageAddress) {
        kycStorage = KYCStorage(_kycStorageAddress);
    }

    // Function to list all registered KYC data
    function listAllRegisteredKYC() external view returns (KYCStorage.KYCInfo[] memory) {
        return kycStorage.listRegisteredKYC();
    }

    // Function to list all pending KYC data
    function listAllPendingKYC() external view returns (KYCStorage.KYCInfo[] memory) {
        return kycStorage.listPendingKYC();
    }

    // Function to list all approved KYC data
    function listAllApprovedKYC() external view returns (KYCStorage.KYCInfo[] memory) {
        return kycStorage.listApprovedKYC();
    }

    // Function to list all rejected KYC data
    function listAllRejectedKYC() external view returns (KYCStorage.KYCInfo[] memory) {
        return kycStorage.listRejectedKYC();
    }
}
