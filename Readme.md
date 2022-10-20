# Idle Best yield strategy for Idle PYTs
This strategy allows [Idle Best yield](https://github.com/Idle-Labs/idle-contracts) to deploy capital in [Idle Perpetual Yield Tranches](https://github.com/Idle-Labs/idle-tranches).

Cloneable instance deployed at `0xdb1b149177b5819cf467ad6519cf55416789300a` (used in Clearpool USDC PYT)

- Clearpool DAI PYT 
`0x67e78ED1cC4732816816A62F2e99CDC5CfaAc06E`

## Install

`forge install`

## Tests
run tests with the pinned block (although this should not be strictly required):

`forge test --fork-url https://eth-mainnet.alchemyapi.io/v2/$ALCHEMY_API_KEY --fork-block-number 15040750 -vvv`