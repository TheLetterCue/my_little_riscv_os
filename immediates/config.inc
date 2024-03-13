.set m_gp,              0x80000000
.set m_sp,              0x80000800

.set boot_address,      0x20000000
.set user_data_0,       0x80000800
.set user_data_1,       0x80001000
.set user_data_2,       0x80001800
.set user_data_3,       0x80002000
.set user_data_4,       0x80002800
.set user_data_5,       0x80003000
.set user_data_6,       0x80003800

.set t_base_m_sel,      0x1
.set intr_mode,         0x1

.set mpp_sel,           0x1800

.set pll_cfg_def,       0x00070000

.set gpio_o_en_def,     0x006b0000
.set gpio_iof_en,       0x00030000

.set tx_ie,             0x1

.uart_plic_priority0,   1
.uart_plic_mask,        0x08

.set running,           0
.set ready,             1
.set blocked,           2
.set terminated,        3


.set uart_div,          138
.set tx_en,             0x101
.set rx_en,             0x1

.set max_text_size,     26

.set max_process,       7
.set pmp_text_na4,      0x15
.set pmp_text_napot,    0x1d
.set pmp_data,          0x1b00

.set pmp_set_high,      0x01ffffff

.set machine_timer_en,  0x80
.set machine_p_intr_en, 0x80

# quantum = ~(32178Hz*0.05seconds)
.set quantum,           1638*1
