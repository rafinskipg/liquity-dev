// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;

import "./TroveManager.sol";
import "./SortedTroves.sol";

/*  Helper contract for grabbing CDP data for the front end. Not part of the core Liquity system. */
contract MultiCDPGetter {
    struct CombinedCDPData {
        address owner;

        uint debt;
        uint coll;
        uint stake;

        uint snapshotETH;
        uint snapshotLUSDDebt;
    }

    TroveManager public troveManager; // XXX Troves missing from ITroveManager?
    ISortedTroves public sortedTroves;

    constructor(TroveManager _troveManager, ISortedTroves _sortedTroves) public {
        troveManager = _troveManager;
        sortedTroves = _sortedTroves;
    }

    function getMultipleSortedTroves(int _startIdx, uint _count)
        external view returns (CombinedCDPData[] memory _cdps)
    {
        uint startIdx;
        bool descend;

        if (_startIdx >= 0) {
            startIdx = uint(_startIdx);
            descend = true;
        } else {
            startIdx = uint(-(_startIdx + 1));
            descend = false;
        }

        uint sortedTrovesSize = sortedTroves.getSize();

        if (startIdx >= sortedTrovesSize) {
            _cdps = new CombinedCDPData[](0);
        } else {
            uint maxCount = sortedTrovesSize - startIdx;

            if (_count > maxCount) {
                _count = maxCount;
            }

            if (descend) {
                _cdps = _getMultipleSortedTrovesFromHead(startIdx, _count);
            } else {
                _cdps = _getMultipleSortedTrovesFromTail(startIdx, _count);
            }
        }
    }

    function _getMultipleSortedTrovesFromHead(uint _startIdx, uint _count)
        internal view returns (CombinedCDPData[] memory _cdps)
    {
        address currentCDPowner = sortedTroves.getFirst();

        for (uint idx = 0; idx < _startIdx; ++idx) {
            currentCDPowner = sortedTroves.getNext(currentCDPowner);
        }

        _cdps = new CombinedCDPData[](_count);

        for (uint idx = 0; idx < _count; ++idx) {
            _cdps[idx].owner = currentCDPowner;
            (
                _cdps[idx].debt,
                _cdps[idx].coll,
                _cdps[idx].stake,
                /* status */,
                /* arrayIndex */
            ) = troveManager.Troves(currentCDPowner);
            (
                _cdps[idx].snapshotETH,
                _cdps[idx].snapshotLUSDDebt
            ) = troveManager.rewardSnapshots(currentCDPowner);

            currentCDPowner = sortedTroves.getNext(currentCDPowner);
        }
    }

    function _getMultipleSortedTrovesFromTail(uint _startIdx, uint _count)
        internal view returns (CombinedCDPData[] memory _cdps)
    {
        address currentCDPowner = sortedTroves.getLast();

        for (uint idx = 0; idx < _startIdx; ++idx) {
            currentCDPowner = sortedTroves.getPrev(currentCDPowner);
        }

        _cdps = new CombinedCDPData[](_count);

        for (uint idx = 0; idx < _count; ++idx) {
            _cdps[idx].owner = currentCDPowner;
            (
                _cdps[idx].debt,
                _cdps[idx].coll,
                _cdps[idx].stake,
                /* status */,
                /* arrayIndex */
            ) = troveManager.Troves(currentCDPowner);
            (
                _cdps[idx].snapshotETH,
                _cdps[idx].snapshotLUSDDebt
            ) = troveManager.rewardSnapshots(currentCDPowner);

            currentCDPowner = sortedTroves.getPrev(currentCDPowner);
        }
    }
}
