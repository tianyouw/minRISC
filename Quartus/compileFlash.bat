:: Cleans cached files, compiles .sof, then programs FPGA

quartus_sh.exe --clean minRISC && ^
quartus_sh.exe --flow compile minRISC && ^
quartus_pgm.exe .\minRISC.cdf
