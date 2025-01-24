# Robot setup

## Set up task

Add `T_TX_SPD` to Tasks under `Configuration - Controller`.

Copy module `tx_spd.mod`.

## Signals

Under `Configuration - I/O System`

Assumptions: Digital output signals availble (2 used) and one group output with 8 bits.

These are mapped in `tx_spd.mod` using `AliasIO`.

### Digital out

Not assigned to IO device.

- `do_extrudeRelSpd`
- `do_forceExtrude`
- `do_forceRetract`
- `do_MOn`

### Analog out

Not assigned to IO device.

- `ao_TCPSpd`

## System Output

- `ao_TCPSpd` assigned to `TCP Speed ROB_1`
- `do_MOn` assigned to `Motors On`
