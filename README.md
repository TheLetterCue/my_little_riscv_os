Compliation requirements:
    Risc-v gnu toolchain
        https://github.com/riscv-collab/riscv-gnu-toolchain

    make
    
Running requires
    Sifive Hifive1 Revb board connected with usb

    openocd

    run commands

    openocd -f config/openocd.cfg

    /opt/riscv/bin/riscv64-unknown-elf-gdb simple_os.elf

    load

To set up a terminal
    stty -F /dev/ttyACM0 115200 -echo -opost

    Input and output can then be performed with the file /dev/ttyACM0