# minRISC: Free and Open Platform Security
minRISC is a trusted embedded system for code execution using open-source technology and well-known and tested cryptographic practices.

## Requirements
- Quartus Prime Standard Edition 18.1.0.625
- Altera (Terasic) DE2-115 Development Board
- SiFive Prebuilt RISC‑V GCC Toolchain v2019.05.3
- Follow https://github.com/tianyouw/VexRiscv#dependencies

## Contents
- `Quartus/` Quartus FPGA project
- `VexRiscvSocSoftware/` Source code for C programs to run on the VexRiscv processor

## Guide
To update the Quartus project after making changes to VexRiscv:
 1. `cd VexRiscv; sbt "runMain vexriscv.demo.BrieyDe2"`
 2. `mv Briey* ../Quartus`
 3. Open the project in Quartus and recompile.

## Info
After programming the board, LEDG[7:0] should count up in binary. KEY0 resets the processor.
