uart0_ext_intr:
    #print characters until queue full
    #or end of string, if end of string
    #start next string and unblock process
    li s0, UART_0
    lw s1, print_pointer(gp)
    addi s1, s1, -1
uart_print_loop:
    addi s1, s1, 1
    lb s2, (s1)
    amoor.w s3, s2, txdata(s0)
    bne zero, s3, tx_q_full
    bne zero, s2, uart_print_loop

    lw a1, print_q_head(gp)
    li a2, max_process
    addi a3, gp, print_queue
    jal dequeue
    sw a1, print_q_head(gp)


    lw s1, print_q_n(gp)
    addi s1, s1, -1
    sw s1, print_q_n(gp)

    bne zero, s1, queue_not_empty
    li a0, UART_0+ie
    li a1, tx_ie
    mv a2, zero
    jal set_mem


queue_not_empty:
    addi a2, gp, print_queue
    jal get_head
    sw a0, print_pointer(gp)

    lw a1, print_id_q_head(gp)
    li a2, max_process
    addi a3, gp, print_id_queue
    jal dequeue
    sw a1, print_id_q_head(gp)

    jal unblock_process


    j exit_ext_intr
tx_q_full:
    sw s1, print_pointer(gp)
    j exit_ext_intr

