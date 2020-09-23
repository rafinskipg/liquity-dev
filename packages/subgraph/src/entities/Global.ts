import { Value, BigInt } from "@graphprotocol/graph-ts";

import { Global } from "../../generated/schema";

import { BIGINT_ZERO } from "../utils/bignumbers";

const onlyGlobalId = "only";

export function getGlobal(): Global {
  let globalOrNull = Global.load(onlyGlobalId);

  if (globalOrNull != null) {
    return globalOrNull as Global;
  } else {
    let newGlobal = new Global(onlyGlobalId);

    newGlobal.systemStateCount = 0;
    newGlobal.transactionCount = 0;
    newGlobal.changeCount = 0;
    newGlobal.liquidationCount = 0;
    newGlobal.redemptionCount = 0;
    newGlobal.rawTotalRedistributedCollateral = BIGINT_ZERO;
    newGlobal.rawTotalRedistributedDebt = BIGINT_ZERO;

    return newGlobal;
  }
}

function increaseCounter(key: string): i32 {
  let global = getGlobal();

  let count = global.get(key).toI32();
  global.set(key, Value.fromI32(count + 1));
  global.save();

  return count;
}

export function getSystemStateSequenceNumber(): i32 {
  return increaseCounter("systemStateCount");
}

export function getTransactionSequenceNumber(): i32 {
  return increaseCounter("transactionCount");
}

export function getChangeSequenceNumber(): i32 {
  return increaseCounter("changeCount");
}

export function getLiquidationSequenceNumber(): i32 {
  return increaseCounter("liquidationCount");
}

export function getRedemptionSequenceNumber(): i32 {
  return increaseCounter("redemptionCount");
}

export function updateTotalRedistributed(L_ETH: BigInt, L_CLVDebt: BigInt): void {
  let global = getGlobal();

  global.rawTotalRedistributedCollateral = L_ETH;
  global.rawTotalRedistributedDebt = L_CLVDebt;
  global.save();
}