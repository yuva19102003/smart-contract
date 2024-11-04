// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KYCStorage {
    struct KYCInfo {
        uint id;
        string name;
        string dob;  // Date of birth in YYYY-MM-DD format
        address registeredBy;  // Address of the bank that registered the KYC
    }

    // Mappings for each KYC status
    mapping(uint => KYCInfo) public registeredKYC;
    mapping(uint => KYCInfo) public pendingKYC;
    mapping(uint => KYCInfo) public approvedKYC;
    mapping(uint => KYCInfo) public rejectedKYC;

    // Track existence in each mapping
    mapping(uint => bool) public isRegistered;
    mapping(uint => bool) public isPending;
    mapping(uint => bool) public isApproved;
    mapping(uint => bool) public isRejected;

    uint private nextId = 1;

    event KYCAlreadyExists(uint id, string message);


    // Add to registered KYC
    function addRegisteredKYC(string memory name, string memory dob, address bankAddress) external returns (uint) {
        registeredKYC[nextId] = KYCInfo(nextId, name, dob, bankAddress);
        isRegistered[nextId] = true;
        return nextId++;
    }

    // Move to pending KYC with checks for existing approved KYC using name and dob
    function moveToPendingKYC(uint id) external {
        require(isRegistered[id], "KYC must be registered before moving to pending");

        // Check if KYC is already approved by name and date of birth
        for (uint i = 1; i < nextId; i++) {
            if (isApproved[i] && 
                keccak256(abi.encodePacked(approvedKYC[i].name)) == keccak256(abi.encodePacked(registeredKYC[id].name)) && 
                keccak256(abi.encodePacked(approvedKYC[i].dob)) == keccak256(abi.encodePacked(registeredKYC[id].dob))) {
                
                // Remove from registered KYC
                emit KYCAlreadyExists(id, "KYC already approved with this name and date of birth");
                delete registeredKYC[id];
                isRegistered[id] = false;
                return;

            }

            if (isPending[i] && 
                keccak256(abi.encodePacked(pendingKYC[i].name)) == keccak256(abi.encodePacked(registeredKYC[id].name)) && 
                keccak256(abi.encodePacked(pendingKYC[i].dob)) == keccak256(abi.encodePacked(registeredKYC[id].dob))) {
                
                // Remove from registered KYC
                emit KYCAlreadyExists(id, "KYC already pending with this name and date of birth");
                delete registeredKYC[id];
                isRegistered[id] = false;
                return;

            }
        }

        // Move to pending
        pendingKYC[id] = registeredKYC[id];
        isPending[id] = true;

        // Remove from registered KYC
        delete registeredKYC[id];
        isRegistered[id] = false;
    }

    // Approve KYC
    function approveKYC(uint id) external {
        require(isPending[id], "KYC must be in pending status to approve");

        approvedKYC[id] = pendingKYC[id];
        isApproved[id] = true;

        // Remove from pending KYC
        delete pendingKYC[id];
        isPending[id] = false;
    }

    // Reject KYC
    function rejectKYC(uint id) external {
        require(isPending[id], "KYC must be in pending status to reject");

        rejectedKYC[id] = pendingKYC[id];
        isRejected[id] = true;

        // Remove from pending KYC
        delete pendingKYC[id];
        isPending[id] = false;
    }

    // Get KYC Status
    function getKYCStatus(uint id) external view returns (string memory) {
        if (isRegistered[id]) {
            return "Registered";
        } else if (isPending[id]) {
            return "Pending";
        } else if (isApproved[id]) {
            return "Approved";
        } else if (isRejected[id]) {
            return "Rejected";
        } else {
            return "KYC ID does not exist";
        }
    }

    // Function to find KYC ID by name and date of birth
    function findKYCId(string memory name, string memory dob) external view returns (uint) {
        for (uint i = 1; i < nextId; i++) { // Start from 1 assuming IDs start from 1
            if (isRegistered[i] && 
                keccak256(abi.encodePacked(registeredKYC[i].name)) == keccak256(abi.encodePacked(name)) && 
                keccak256(abi.encodePacked(registeredKYC[i].dob)) == keccak256(abi.encodePacked(dob))) {
                return registeredKYC[i].id; // Return the ID if found
            }
        }
        revert("KYC not found for the provided name and date of birth");
    }

    // List all registered KYC data
    function listRegisteredKYC() external view returns (KYCInfo[] memory) {
        KYCInfo[] memory result = new KYCInfo[](nextId);
        uint count = 0;
        for (uint i = 1; i < nextId; i++) { // Start from 1 assuming IDs start from 1
            if (isRegistered[i]) {
                result[count] = registeredKYC[i];
                count++;
            }
        }
        // Resize the array to the actual number of elements
        assembly { mstore(result, count) }
        return result;
    }

    // List all pending KYC data
    function listPendingKYC() external view returns (KYCInfo[] memory) {
        KYCInfo[] memory result = new KYCInfo[](nextId);
        uint count = 0;
        for (uint i = 1; i < nextId; i++) { // Start from 1
            if (isPending[i]) {
                result[count] = pendingKYC[i];
                count++;
            }
        }
        assembly { mstore(result, count) }
        return result;
    }

    // List all approved KYC data
    function listApprovedKYC() external view returns (KYCInfo[] memory) {
        KYCInfo[] memory result = new KYCInfo[](nextId);
        uint count = 0;
        for (uint i = 1; i < nextId; i++) { // Start from 1
            if (isApproved[i]) {
                result[count] = approvedKYC[i];
                count++;
            }
        }
        assembly { mstore(result, count) }
        return result;
    }

    // List all rejected KYC data
    function listRejectedKYC() external view returns (KYCInfo[] memory) {
        KYCInfo[] memory result = new KYCInfo[](nextId);
        uint count = 0;
        for (uint i = 1; i < nextId; i++) { // Start from 1
            if (isRejected[i]) {
                result[count] = rejectedKYC[i];
                count++;
            }
        }
        assembly { mstore(result, count) }
        return result;
    }
}
