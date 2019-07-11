# minRISC: Free and Open Platform Security
minRISC is a trusted embedded system for code execution using open-source technology and well-known and tested cryptographic practices.

## Requirements
- Quartus Prime Standard Edition 18.1.0.625
    - [Linux](http://fpgasoftware.intel.com/?edition=standard&platform=linux&download_manager=direct)
    - [Windows](http://fpgasoftware.intel.com/?edition=standard&platform=windows&download_manager=direct)
- Altera (Terasic) [DE2-115](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=502) Development Board
- SiFive Prebuilt RISC‑V GCC Toolchain v2019.05.3
   - [Ubuntu](https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.2.0-2019.05.3-x86_64-linux-ubuntu14.tar.gz) (direct download)
   - [Windows](https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.2.0-2019.05.3-x86_64-w64-mingw32.zip) (direct download)
- Follow the instructions [*here*](https://github.com/tianyouw/VexRiscv#dependencies)

## Contents
- `Quartus/` Quartus FPGA project
- `VexRiscv/` 32-bit RISC-V processor implemented in SpinalHDL which generates Verilog or VHDL
- `VexRiscvSocSoftware/` Source code for C programs to run on the VexRiscv processor

## Guide
### To update the Quartus project after making changes to VexRiscv:
 1. `cd VexRiscv; sbt "runMain vexriscv.demo.BrieyDe2"` will trigger the Scala build tool to generate Briey.v and associated *.bin files.
 2. `mv Briey* ../Quartus` moves the generated Verilog and binary files to the Quartus project directory.
 3. `rm -rf db incremental_db` deletes the compiler cache so that *.bin changes will be recognized.
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
`KEY0` resets the processor, `KEY1` (hold down) interrupts the processor.

### Dhrystone Benchmark
Bitstream located at `Quartus/output_files/minRISC.sof` (default).

After programming the board, `LEDG0` should light up and the Dhrystone benchmark will run.
After the benchmark, `LEDR[17:0]` and `LEDG[7:0]` will display the resultant DMIPS/MHz in binary coded decimal (`LEDR.LEDG` DMIPS/MHz).

Current settings results in a performance of **1.31** DMIPS/MHz.

### Memory Test (SDRAM)
Bitstream located at `Quartus/output_files/minRISCMemTest.sof`.

After programming the board, `LEDG8` (located in the 7-segment cluster) should light up and the memory test will run. 
The test takes around a minute per run to complete.

After the first run of the test, `LEDG[7:0]` should light up to indicate writing and reading back of SDRAM has been successful.
Press `KEY1` after the first test has displayed its result to start the second test. `LEDR[17:0]` should light up afterwards to indicate that the intentionally injected error has been detected.

Any test results other than the ones above indicate there is an error.
