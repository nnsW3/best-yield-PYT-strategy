// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import {IdlePYTClear} from "../src/ClearpoolStrategy.sol";

contract DeployClearpoolStrategy is Script {
  // cpfasusdt
  // address public TRANCHE = 0x50BA0c3f940f0e851f8e30f95d2A839216EC5eC9;
  // address public CDO = 0x94e399Af25b676e7783fDcd62854221e67566b7f;
  // // cpporusdt
  // address public TRANCHE = 0x8552801C75C4f2b1Cac088aF352193858B201D4E;
  // address public CDO = 0x8771128e9E386DC8E4663118BB11EA3DE910e528;
  // // cpwincusdcv2
  // address public TRANCHE = 0x6AB470a650E1E0E68b8D1C0f154E78ca1a7147BF;
  // address public CDO = 0xe49174F0935F088509cca50e54024F6f8a6E08Dd;
  // cpbasusdt
  address public TRANCHE = 0x8324cB085Ffdce6256C2aEe4a63Bc878870Ff04d;
  address public CDO = 0x67D07aA415c8eC78cbF0074bE12254E55Ad43f3f;
  // idleUSDT RWA
  address public IDLE_TOKEN = 0x9Ebcb025949FFB5A77ff6cCC142e0De649801697;

  // forge script ./script/DeployClearpoolStrategy.s.sol \
  // --fork-url $OPTIMISM_RPC_URL \
  // --ledger \
  // --broadcast \
  // --optimize \
  // --optimizer-runs 99999 \
  // --verify \
  // --sender "0xE5Dab8208c1F4cce15883348B72086dBace3e64B" \
  // --with-gas-price 100000000 \
  // -vvv

  function run() external {
    vm.startBroadcast();
    IdlePYTClear strategy = new IdlePYTClear();
    strategy.initialize(
      TRANCHE, // tranche token address
      IDLE_TOKEN, // idleToken address
      CDO // contract address 
    );
    vm.stopBroadcast();
  }
}