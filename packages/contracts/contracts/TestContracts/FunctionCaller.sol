// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;

import '../Interfaces/ITroveManager.sol';
import '../Interfaces/ISortedCDPs.sol';
import '../Interfaces/IPriceFeed.sol';
import '../Dependencies/LiquityMath.sol';

/* Wrapper contract - used for calculating gas of read-only and internal functions. 
Not part of the Liquity application. */
contract FunctionCaller {

    ITroveManager cdpManager;
    address public cdpManagerAddress;

    ISortedCDPs sortedCDPs;
    address public sortedCDPsAddress;

    IPriceFeed priceFeed;
    address public priceFeedAddress;

    // --- Dependency setters ---

    function setTroveManagerAddress(address _cdpManagerAddress) external {
        cdpManagerAddress = _cdpManagerAddress;
        cdpManager = ITroveManager(_cdpManagerAddress);
    }
    
    function setSortedCDPsAddress(address _sortedCDPsAddress) external {
        cdpManagerAddress = _sortedCDPsAddress;
        sortedCDPs = ISortedCDPs(_sortedCDPsAddress);
    }

     function setPriceFeedAddress(address _priceFeedAddress) external {
        priceFeedAddress = _priceFeedAddress;
        priceFeed = IPriceFeed(_priceFeedAddress);
    }

    // --- Non-view wrapper functions used for calculating gas ---
    
    function cdpManager_getCurrentICR(address _address, uint _price) external returns (uint) {
        return cdpManager.getCurrentICR(_address, _price);  
    }

    function sortedCDPs_findInsertPosition(uint _ICR, uint _price, address _prevId, address _nextId) external returns (address, address) {
        return sortedCDPs.findInsertPosition(_ICR, _price, _prevId, _nextId);
    }
}
