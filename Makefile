make:
	make simple_os.o
	make simple_os.elf
	make simple_os.o.diss
	make simple_os.elf.diss

simple_os.o: *.S immediates/*
	/opt/riscv/bin/riscv64-unknown-elf-as -march=rv32ima_zicsr_zifencei -mno-arch-attr -g -c simple_os.S -o simple_os.o

simple_os.elf: simple_os.o
	/opt/riscv/bin/riscv64-unknown-elf-ld -T config/linker_cfg.ld -b elf32-littleriscv simple_os.o -o simple_os.elf

simple_os.o.diss: simple_os.o
	/opt/riscv/bin/riscv64-unknown-elf-objdump -D simple_os.o > diss/simple_os.o.diss

simple_os.elf.diss: simple_os.elf
	/opt/riscv/bin/riscv64-unknown-elf-objdump -D simple_os.elf > diss/simple_os.elf.diss


clear:
	rm simple_os.elf*
	rm simple_os.o*
	rm diss/*