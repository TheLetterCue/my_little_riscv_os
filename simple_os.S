/*
Author: Thomas Jones
Program: Simple os
Description: Basic os with limited functions, for the sifive hifive1 rev b
*/
.include "immediates/mem_map.inc"
.include "immediates/config.inc"
.include "immediates/process.inc"
.include "immediates/m_globals.inc"
.include "immediates/misc.inc"

#~~~~~Constant values~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.include "ro_data.S"

#~~~~~Code~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.section .text
.globl _boot
#~~~~~boot~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#located at 0x20000000 and runs on boot
_boot:
    #inits all registers
    li ra, boot_address
    li sp, m_sp
    li gp, m_gp
    li tp, 0
    li t0, 0
    li t1, 0
    li t2, 0
    li t3, 0
    li t4, 0
    li t5, 0
    li t6, 0
    li a0, 0
    li a1, 0
    li a2, 0
    li a3, 0
    li a4, 0
    li a5, 0
    li a6, 0
    li a7, 0
    li s0, 0
    li s1, 0
    li s2, 0
    li s3, 0
    li s4, 0
    li s5, 0
    li s6, 0
    li s7, 0
    li s8, 0
    li s9, 0
    li s10, 0
    li s11, 0

    #Sets the clock to the high frequency crystal at 16MHz
    li a0, PRCI+pllcfg
    #select all bits of pllcfg
    li a1, -1
    li a2, pll_cfg_def
    jal set_mem

    #sets the rtc to the external crystal
    #for interrupts
    li a0, PRCI
    li a1, 1
    sw a1, lfclkmux(a0)

    #Sets the trap vector
    la t0, trap_handler
    andi t0, t0, ~t_base_m_sel
    ori t0, t0, intr_mode
    csrw mtvec, t0

    #sets the leds so they do not turn on when enabled
    li a0, GPIO+output_val
    li a1, led_sel
    li a2, led_off
    jal set_mem

    #enables the leds and uart_0, and enables iof on uart_0
    li t0, GPIO

    li t1, gpio_o_en_def
    sw t1, output_en(t0)

    li t1, gpio_iof_en
    sw t1, iof_en(t0)


    li t0, UART_0

    #sets the uart baud rate
    li t1, uart_div
    sw t1, div_(t0)

    #enables reading and writing to uart from /dev/ttyACM0
    li t1, tx_en
    sw t1, txctrl(t0)

    li t1, rx_en
    sw t1, rxctrl(t0)

    #set up print queue
    li t0, -1
    sw t0, print_q_head(gp)
    sw t0, print_q_tail(gp)
    sw zero, print_q_n(gp)

    sw t0, print_id_q_head(gp)
    sw t0, print_id_q_tail(gp)


    #set up interrupts in the PLIC

    li t0, PLIC+m_mode_int_en
    sw zero, (t0)
    sw zero, 4(t0)
    li t0, PLIC+m_mode_pri_thr
    sw zero, (t0)

    li t0, PLIC+plic_priority+plic_uart0
    li t1, uart_plic_priority
    sw t1, (t0)
    li a0, PLIC+m_mode_int_en
    # addi a0, a0, m_mode_int_en
    li a1, uart_plic_mask
    mv a2, a1
    jal set_mem

    # la t0, library_code
    # csrw pmpaddr4, t0
    # la t0, library_end
    # csrw pmpaddr5, t0

    # li t0, 0x00000d00
    # csrw pmpcfg1, t0







    sw zero, process_count(gp)
    li t0, -1
    sw t0, current_process(gp)

    sw zero, next_pid(gp)

    #head points to start of queue
    # addi t0, gp, p_queue+(max_process-1)*4
    li t0, -1
    sw t0, p_queue_head(gp)
    #tail points to end of queue
    sw t0, p_queue_tail(gp)


    #full descending stack
    addi t0, gp, p_stack_pointer
    sw t0, p_stack_pointer(gp)

    #push addresses in the process table into the stack
    addi t1, gp, process_table
    addi t0, t0, -4
    sw t1, (t0)
    li t2, user_data_0
    sw t2, p_data_pointer(t1)
    addi t1, t1, process_entry_size
    addi t0, t0, -4
    sw t1, (t0)
    li t2, user_data_1
    sw t2, p_data_pointer(t1)
    addi t1, t1, process_entry_size
    addi t0, t0, -4
    sw t1, (t0)
    li t2, user_data_2
    sw t2, p_data_pointer(t1)
    addi t1, t1, process_entry_size
    addi t0, t0, -4
    sw t1, (t0)
    li t2, user_data_3
    sw t2, p_data_pointer(t1)
    addi t1, t1, process_entry_size
    addi t0, t0, -4
    sw t1, (t0)
    li t2, user_data_4
    sw t2, p_data_pointer(t1)
    addi t1, t1, process_entry_size
    addi t0, t0, -4
    sw t1, (t0)
    li t2, user_data_5
    sw t2, p_data_pointer(t1)
    addi t1, t1, process_entry_size
    addi t0, t0, -4
    sw t1, (t0)
    li t2, user_data_6
    sw t2, p_data_pointer(t1)
    sw t0, p_stack_pointer(gp)
        

    # li a0, 3
    # la a1, test_program0
    # li a7, 0
    # ecall


    # li a0, 3
    # la a1, test_program1
    # li a7, 0
    # ecall

    # li a0, 3
    # la a1, test_program2
    # li a7, 0
    # ecall

    # li a0, 3
    # la a1, test_program3
    # li a7, 0
    # ecall

    # li a0, 3
    # la a1, test_program4
    # li a7, 0
    # ecall
    
    # li a0, 3
    # la a1, test_program5
    # li a7, 0
    # ecall
    
    li a0, 1
    la a1, dummy
    li a7, 0
    ecall

    li a0, 8
    la a1, printer
    li a7, 0
    ecall

    li a0, 3
    la a1, test_program0
    li a7, 0
    ecall

    li a0, 3
    la a1, test_program1
    li a7, 0
    ecall

    li a0, 3
    la a1, test_program2
    li a7, 0
    ecall

    # li a0, 4
    # la a1, proc_example_child
    # li a7, 0
    # ecall

    la a0, program_start_msg
    jal print_const

    li a7, 1
    ecall
t:
    nop
    j t


#~~~~~utility~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.include "util.S"




#~~~~~traps~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#must be 64 byte aligned, aligns 2^6
#vector mode - async traps sets pc to trap_handler + 4*code
.include "trap_handler.S"


#~~~~~user~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


.include "user_code.S"

# .align 2
# library_code:
# .include "string.S"
# library_end:

