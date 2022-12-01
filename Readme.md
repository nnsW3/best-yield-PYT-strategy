# Idle Best yield strategy for Idle PYTs
This strategy allows [Idle Best yield](https://github.com/Idle-Labs/idle-contracts) to deploy capital in [Idle Perpetual Yield Tranches](https://github.com/Idle-Labs/idle-tranches).

Cloneable instance for both tranches deployed at `0xa575b3a6d88e9c1b5196cb7e2a14962a5c533559` 

- 0x7eC173d5bE66c83487f16f1ca304AC72639e80d4 ->  bb tranche of cpwinusdc
- 0xfE92E0973ff0267447f8C711d16A849837C73264 ->  bb tranche of cpfolusdc
- 0xD19f42Ce3b799a4D23176da193673b146968C934 ->  bb tranche of rfolusdc
- 0x3225cb1d7bDFddEA35178FD1667D8BD62afb0DDe ->  bb tranche of rwinusdc

- 0xDd585E6e3AcB30594E7b70DCee34400E172cee31 -> aa tranche of cpfoldai
- 0xFF12A5eaE3E60096c774AD7211AE5C0c5b5Cc0F5 -> aa tranche of cpwinusdc
- 0x75DA360514532813B460b2Ba30F444A1fa28c9d7 -> aa tranche of rwindai

## Install

`forge install`

## Tests
run tests with the pinned block (although this should not be strictly required):

`forge test --fork-url https://eth-mainnet.alchemyapi.io/v2/$ALCHEMY_API_KEY --fork-block-number 15867256 -vvv`