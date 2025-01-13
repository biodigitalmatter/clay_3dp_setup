# Robot setup

## Set up task

Add `T_TX_SPD` to Tasks under `Configuration - Controller`.

Copy module `tx_spd.mod`.

## Signals

Under `Configuration - I/O System`

### Digital out

- `do_extrudeRelSpd` (assigned)
- `do_forceExtrude` (assigned)
- `do_forceRetract` (assigned)
- `do_MOn` (internal)

### Group signal out

- `go_TCPSpd` (8 bits, assign to device and setup mapping)

### Analog out

- ao_TCPSpd

## System Output

- `ao_TCPSpd` assigned to `TCP Speed ROB_1`
- `do_MOn` assigned to `Motors On`
