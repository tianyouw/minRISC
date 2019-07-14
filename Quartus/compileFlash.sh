#! /bin/sh
# Cleans cached files, compiles .sof, then programs FPGA

quartus_sh --clean minRISC &&
quartus_sh --flow compile minRISC &&
quartus_pgm minRISC.cdf

