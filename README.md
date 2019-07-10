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
### To update the Quartus project after making changes to VexRiscv:
 1. `cd VexRiscv; sbt "runMain vexriscv.demo.BrieyDe2"`
 2. `mv Briey* ../Quartus`
 3. `rm -rf db incremental_db` to delete the compiler cache so that .bin changes will be recognized.
 3. Open the project in Quartus and recompile.

### To program the board permanently:
 1. Open the project in Quartus.
 2. Go to `File`, `Convert Programming Files...`, `Open Conversion Setup Data...`.
 3. Open `sof_to_pof.cof`.
 4. Scroll to the bottom of the window and click `Generate`.
 5. Connect the board through the USB blaster port and power it on.
 6. Toggle the `RUN <-> PROG` switch at the bottom left of the board to `PROG`.
 7. Launch `Programmer (Quartus Prime 18.1)`.
 8. Open `minRISCFlash.cdf`.
 9. Ensure `USB-Blaster` is selected under `Hardware Setup...`.
 10. Click `Start` to begin programming. This will take a few minutes.
 11. Toggle the `RUN <-> PROG` switch to `RUN`.
 12. Power cycle the board. The programmed design should be running.

## Info
After programming the board, LEDG0 should light up and the Dhrystone benchmark will run.
After the benchmark, `LEDR[17:0]` and `LEDG[7:0]` will display the resultant DMIPS/MHz in binary coded decimal (`LEDR.LEDG` DMIPS/MHz).
`KEY0` resets the processor, `KEY1` (hold down) interrupts the processor.

Current settings results in a performance of 1.31 DMIPS/MHz.
