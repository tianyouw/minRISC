SHELL := /bin/bash

.PHONY: all flash recompile-fpga recompile-vexriscv recompile-soc-software

all: recompile-soc-software recompile-vexriscv recompile-fpga flash

noflash: recompile-soc-software recompile-vexriscv recompile-fpga

flash:
	pushd Quartus; \
	bash compileFlash.sh flashonly; \
	popd;

recompile-fpga:
	pushd Quartus; \
	bash compileFlash.sh noflash; \
	popd;

# Recompiles VexRiscv into Verilog
# Creates hard links to generated files for Quartus if needed
recompile-vexriscv:
	pushd VexRiscv; \
	sbt "runMain vexriscv.demo.BrieyDe2"; \
	for file in $$(ls Briey*); do \
		if [[ $$(stat --printf '%h\n' "$${file}") == 1 ]]; then ln -f "$${file}" ../Quartus; fi; \
	done; \
	popd;

# Recompiles all C programs for the Briey SoC
recompile-soc-software:
	pushd VexRiscvSocSoftware/projects/briey; \
	make clean; \
	make; \
	popd;
