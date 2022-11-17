# Idle Best yield strategy for Idle PYTs
This strategy allows [Idle Best yield](https://github.com/Idle-Labs/idle-contracts) to deploy capital in [Idle Perpetual Yield Tranches](https://github.com/Idle-Labs/idle-tranches).

Cloneable instance for both tranches deployed at `0xa575b3a6d88e9c1b5196cb7e2a14962a5c533559` 

- 0x7eC173d5bE66c83487f16f1ca304AC72639e80d4 ->  cpwinusdc.BBTranche
- 0xD19f42Ce3b799a4D23176da193673b146968C934 ->  rfolusdc.BBTranche
- 0xfE92E0973ff0267447f8C711d16A849837C73264 ->  bb tranche of cpfolusdc
- 0x3225cb1d7bDFddEA35178FD1667D8BD62afb0DDe ->  bb tranche of rwinusdc

## Install

`forge install`

## Tests
run tests with the pinned block (although this should not be strictly required):

`forge test --fork-url https://eth-mainnet.alchemyapi.io/v2/$ALCHEMY_API_KEY --fork-block-number 15867256 -vvv`