
set_led:
    mv a2, a0
    li a0, GPIO+output_val
    li a1, led_sel
    jal set_mem
    j sync_ecall_exit

exit_process:

    li t0, terminated
    sb t0, p_status(a0)
    sw a1, p_registers+1*4(a0)

    j sync_ecall_exit
    # csrw pmpcfg0, zero
    # fence.i
    #Discard killed process' gp
    # addi sp, sp, 4

    # lw t0, current_process(gp)
    # lw t1, p_stack_pointer(gp)
    # addi t1, t1, -4
    # sw t0, 0(t1)
    # sw t1, p_stack_pointer(gp)

    # lw a1, p_queue_head(gp)
    # li a2, max_process
    # addi a3, gp, p_queue
    # jal dequeue
    # sw a1, p_queue_head(gp)
    # sw a0, current_process(gp)

    # lw t0, process_count(gp)
    # addi t0, t0, -1
    # sw t0, process_count(gp)


    # j run_process

    #a0: char*
print:
    addi sp, sp, -4
    sw s0, 0(sp)
    mv s0, a0

    lw a0, current_process(gp)
    jal block_process

    lw a0, current_process(gp)
    lw a1, print_id_q_tail(gp)
    li a2, max_process
    addi a3, gp, print_id_queue
    jal enqueue
    sw a1, print_id_q_tail(gp)

    mv a0, s0
    lw a1, print_q_tail(gp)
    li a2, max_process
    addi a3, gp, print_queue
    jal enqueue
    sw a1, print_q_tail(gp)

    lw t1, print_q_n(gp)
    addi t2, t1, 1
    sw t2, print_q_n(gp)

    bne zero, t1, print_enabled

    li a0, UART_0+ie
    li a1, tx_ie
    mv a2, a1
    jal set_mem
    sw s0, print_pointer(gp)
    
print_enabled:

    lw s0, 0(sp)
    addi sp, sp, 4
    j sync_ecall_exit


yield:
    # li t1, CLINT+mtime
    # lw t2, 4(t1)
    # lw t1, 0(t1)
    li t1, CLINT+mtimecmp
    sw zero, 4(t1)
    sw zero, 0(t1) 
    j sync_ecall_exit

#a0: N, where 4*2^N is the size of the text in bytes
#a1: textpointer, which is also the initial pc
create_process:
    #Check that it is possible to start a new process

    li t0, max_text_size
    blt t0, a0, text_limit_exceeded

    la t0, user_section
    bltu a1, t0, invalid_text_range

    li t0, QSPI_FLASH_MAX
    bgt a1, t0, invalid_text_range

    lw t0, process_count(gp)
    li t1, max_process
    bge t0, t1, max_processes_called
    addi t0, t0, 1
    sw t0, process_count(gp)



    #POSSIBLE CHECKS
    #Starting address, is aligned and not system code!!
    #Over max text size max 26, 27 would give access to all memory
    #parent pid not valid/could fetch instead of take as input

    #Fetch the top free space in the process table
    lw t0, p_stack_pointer(gp)
    lw t1, (t0)
    addi t0, t0, 4
    sw t0, p_stack_pointer(gp)
    #Populate values as needed
    #Set pid
    lb t0, next_pid(gp)
    sb t0, p_process_id(t1)
    addi t0, t0, 1
    sb t0, next_pid(gp)
    #set parent pid
    lb t0, current_process(gp)
    sb t0, p_parent_id(t1)
    li t0, ready
    sb t0, p_status(t1)
    sb a0, p_text_size(t1)
    sw a1, p_pc(t1)
    sw a1, p_text_pointer(t1)
    lw t0, p_data_pointer(t1)
    sw t0, p_registers+4*2(t1)
    li t2, 0x800
    add t0, t0, t2
    sw t0, p_registers+4(t1)

    # text size saved as is, pmp modifications should happen when scheduled

    mv a0, t1
    lw a1, p_queue_tail(gp)
    li a2, max_process
    addi a3, gp, p_queue
    jal enqueue
    sw a1, p_queue_tail(gp)

    j sync_ecall_exit


text_limit_exceeded:
    la a0, text_limit_exceeded_msg
    jal print_const
    li a0, -1
    j sync_ecall_exit

invalid_text_range:
    la a0, invalid_text_range_msg
    jal print_const
    li a0, -1
    j sync_ecall_exit

max_processes_called:
    la a0, max_processes_called_msg
    jal print_const
    li a0, -1
    j sync_ecall_exit

start_scheduler:

    li t1, machine_timer_en
    csrs mie, t1
    li t1, machine_p_intr_en
    csrs mstatus, t1
    li t1, mpp_sel
    csrc mstatus, t1

    lw a1, p_queue_head(gp)
    li a2, max_process
    addi a3, gp, p_queue
    jal dequeue
    sw a1, p_queue_head(gp)
    sw a0, current_process(gp)
    
    j run_process
