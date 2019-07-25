# minRISC: Free and Open Platform Security <!-- omit in toc -->
minRISC is a trusted embedded system for code execution using open-source technology and well-known and tested cryptographic practices.

## Table of Contents <!-- omit in toc -->
- [Requirements](#Requirements)
- [Contents](#Contents)
- [Guides](#Guides)
  - [To update the Quartus project after making changes to VexRiscv](#To-update-the-Quartus-project-after-making-changes-to-VexRiscv)
  - [To program the board permanently](#To-program-the-board-permanently)
- [Info](#Info)
  - [Dhrystone Benchmark](#Dhrystone-Benchmark)
  - [Memory Test (SDRAM)](#Memory-Test-SDRAM)

## Requirements
- Quartus Prime Standard Edition 18.1.0.625
    - [Linux](http://fpgasoftware.intel.com/?edition=standard&platform=linux&download_manager=direct)
    - [Windows](http://fpgasoftware.intel.com/?edition=standard&platform=windows&download_manager=direct)
- Altera (Terasic) [DE2-115](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=502) Development Board
- SiFive Prebuilt RISC‑V GCC Toolchain v2019.05.3
   - [Ubuntu](https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.2.0-2019.05.3-x86_64-linux-ubuntu14.tar.gz) (direct download)
   - [Windows](https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.2.0-2019.05.3-x86_64-w64-mingw32.zip) (direct download)
- Follow the instructions [*here*](https://github.com/tianyouw/VexRiscv#dependencies) and [*here*](https://github.com/tianyouw/VexRiscvSocSoftware/) (use the archive downloaded above)

## Contents
- `Quartus/` Quartus FPGA project
- `Support/` Support files for Linux development
- `VexRiscv/` 32-bit RISC-V processor implemented in SpinalHDL which generates Verilog or VHDL
- `VexRiscvSocSoftware/` Source code for C programs to run on the VexRiscv processor
- `Makefile` General makefile for compiling C to binaries, SpinalHDL to Verilog, Verilog to bitstream, and flashing the board. 

## Guides
### To program the board after making changes to VexRiscv[SocSoftware]
1. `make` will recompile all Briey SocSoftware programs, recompile VexRiscv, recompile the Quartus project, and flash the board.
    - `make noflash` will do the above but will not flash the board at the end.

### To connect to UART
1. Connect an RS232 to USB adaptor from the FPGA board to your computer.
2. Open a serial port client such as `PuTTY` or `minicom`.
3. Ensure the following settings are used:
   1. Serial port: `COM[1-256]` (check which port your OS has assigned the UART adaptor)
   2. Speed (baud): `115200`
   3. Data bits: `8`
   4. Stop bits: `1`
   5. Parity: `None`
   6. Flow control: `None`
   7. Optional: Implicit CR in every LF: `✓` (if your console looks like [this](https://superuser.com/questions/654490/putty-new-line-not-working-properly))

### To manually update the Quartus project after making changes to VexRiscv
1. `cd VexRiscv; sbt "runMain vexriscv.demo.BrieyDe2"` will trigger the Scala build tool to generate Briey.v and associated *.bin files.
2. `ln Briey* ../Quartus` hard links the generated Verilog and binary files to the Quartus project directory. (Do once unless file names change)
3. `rm -rf db incremental_db` deletes the compiler cache so that *.bin changes will be recognized.
    - Or `cd Quartus` `compileFlash.sh` (`compileFlash.bat`) cleans the cache, compiles, and flashes FPGA (skip 4.).
4. Open the project in Quartus and recompile.

### To program the board permanently
1. Open the project in Quartus.
2. Go to `File`, `Convert Programming Files...`, `Open Conversion Setup Data...`.
3. Open `sof_to_pof.cof`.
4. Scroll to the bottom of the window and click `Generate`.
5. Connect the board through the USB blaster port and power it on.
6. Toggle the `RUN <-> PROG` switch at the bottom left of the board to `PROG`.
7. Launch `Programmer (Quartus Prime 18.1)`.
    - Or `quartus_pgm .\minRISCFlash.cdf` (`quartus_pgm.exe .\minRISCFlash.cdf`) (skip to 11.)
8. Open `minRISCFlash.cdf`.
9.  Ensure `USB-Blaster` is selected under `Hardware Setup...`.
10. Click `Start` to begin programming. This will take a few minutes.
11. Toggle the `RUN <-> PROG` switch to `RUN`.
12. Power cycle the board. The programmed design should be running.

## Info
`KEY0` resets the processor, `KEY1` (hold down) interrupts the processor.

Bubblesort is currently the default loaded in `Quartus/output_files/minRISC.sof`.

### Dhrystone Benchmark
After programming the board, `LEDG0` should light up and the Dhrystone benchmark will run.
After the benchmark, `LEDR[17:0]` and `LEDG[7:0]` will display the resultant DMIPS/MHz in binary coded decimal (`LEDR.LEDG` DMIPS/MHz).

Current settings results in a performance of **1.31** DMIPS/MHz.

### Bubblesort
After programming the board, `LEDG8` (located in the 7-segment cluster) should light up and the bubblesort test will run. However, the test runs quickly enough that the test result is immediately displayed.
It takes a few seconds for LEDs to light up due to startup routines clearing the memory authentication section of SDRAM running before main() is called.
The test takes less than a second to complete.

After running the test, `LEDG[7:0]` should light up to indicate that the unordered input array has been sorted correctly in ascending order.
`LEDR[17:0]` will light up if the resultant array is not sorted in ascending order, possibly due to memory issues.

UART output:
```
Bubblesort BEGIN

Input array:
[80, 82, 9, 69, 43, 7, 59, 12, 78, 26, 35, 50, 62, 3, 88, 14]

Bubblesort complete after 120 iterations.

Result array:
[3, 7, 9, 12, 14, 26, 35, 43, 50, 59, 62, 69, 78, 80, 82, 88]

Bubblesort PASS
```

### Memory Test (SDRAM)
After programming the board, `LEDG8` (located in the 7-segment cluster) should light up and the memory test will run.
It takes a few seconds for the LED to light up due to startup routines clearing the memory authentication section of SDRAM running before main() is called.
The test takes around a minute per run to complete.

Each run of the test has two parts, checking the mem. auth. section has been zeroed and checking the heap has the correct pattern written.

For the first run of the test, `LEDG[3:0]` should light up first to indicate the mem. auth. tree section has been correctly zeroed.
Afterwards, `LEDG[7:4]` should then light up to indicate writing and reading back of SDRAM has been successful.
Press `KEY1` after the first test has displayed its result to start the second test. `LEDR[17:0]` should light up afterwards to indicate that the intentionally injected error has been detected.

UART output:
```
heapStart: 0x40000000
heapEnd:   0x43FFF800
treeStart: 0x44000000
treeEnd:   0x48000000
MemTest BEGIN
Testing 0x04000000 bytes of tree
Should all be zeroed before main() is called
Reading...
MemTest Tree PASS
Testing 0x03FFF800 bytes of heap
Writing...
Reading...
MemTest PASS
heapStart: 0x40000000
heapEnd:   0x43FFF800
treeStart: 0x44000000
treeEnd:   0x48000000
MemTest BEGIN
Testing 0x04000000 bytes of tree
Should all be zeroed before main() is called
Reading...
MemTest Tree PASS
Testing 0x03FFF800 bytes of heap
Writing...
Injecting error at addr 0x43FFF7FC
Reading...
Read back 0x55555556, should be 0xAAAAAAAA
Error detected at addr 0x43FFF7FC
```

Any test results other than the ones above indicate there is an error.
