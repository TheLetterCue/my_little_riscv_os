.set DEBUG,         0x00000000

.set MODE_SELECT,   0x00001000

.set ERROR_DEVICE,  0x00003000

.set MASK_ROM,      0x00010000

.set OTP_MEM_REG,   0x00020000

.set CLINT,         0x02000000
.set msip,          0x0000
.set mtimecmp,      0x4000
.set mtime,         0xbff8

.set ITIM,          0x08000000

.set PLIC,          0x0C000000
.set plic_priority, 0x00000000
.set pending_array, 0x00001000
.set m_mode_int_en, 0x00002000
.set m_mode_pri_thr,0x00200000
.set plic_claim,    0x00200004

.set plic_uart0,    3*4


.set AON,           0x10000000

.set PRCI,          0x10008000
.set hfrosccfg,     0x00
.set hfxosccfg,     0x04
.set pllcfg,        0x08
.set plloutdiv,     0x0c
.set lfrosccfg,     0x70
.set lfclkmux,      0x7c
.set procmoncfg,    0xf0

.set OTP_ctrl,      0x10010000

.set GPIO,          0x10012000
.set input_val,     0x00
.set input_en,      0x04
.set output_en,     0x08
.set output_val,    0x0c
.set pue,           0x10
.set ds,            0x14
.set rise_ie,       0x18
.set rise_ip,       0x1c
.set fall_ie,       0x20
.set fall_ip,       0x24
.set high_ie,       0x28
.set high_ip,       0x2c
.set low_ie,        0x30
.set low_ip,        0x34
.set iof_en,        0x38
.set iof_sel,       0x3c
.set out_xor,       0x40
.set passthru_high_ie,  0x44
.set passthru_low_ie,   0x48

.set UART_0,        0x10013000
.set UART_1,        0x10023000
.set txdata,        0x00
.set rxdata,        0x04
.set txctrl,        0x08
.set rxctrl,        0x0c
.set ie,            0x10
.set ip,            0x14
.set div_,           0x18

.set QSPI_0,        0x10014000
.set SPI_1,         0x10024000
.set SPI_2,         0x10034000

.set PWM_0,         0x10015000
.set PWM_1,         0x10025000
.set PWM_2,         0x10035000

.set I2C_0,         0x10016000

.set QSPI_FLASH,    0x20000000
.set QSPI_FLASH_MAX,0x3fffffff

.set DTIM,          0x80000000
