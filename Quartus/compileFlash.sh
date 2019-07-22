#! /bin/bash
# Cleans cached files, compiles .sof, then programs FPGA
# "noflash" option skips flashing after compile
# "flashonly" option skips compile
PROJECT_NAME=minRISC

if [ "${1}" == "noflash" ] || [ "${1}" == "" ]; then
    quartus_sh --clean "${PROJECT_NAME}"
    quartus_sh --flow compile "${PROJECT_NAME}"
fi

if [ "${1}" == "flashonly" ] || [ "${1}" == "" ]; then
    quartus_pgm "${PROJECT_NAME}.cdf"
fi
