
#a0: word aligned address
#a1: word bit selection (bit mask)
#a2: new bit value
set_mem:
    lw t0, (a0)
    not a1, a1
    and t0, t0, a1
    or t0, t0, a2
    sw t0, (a0)
    ret

#a0: value
#a1: tail of q -> new tail
#a2: length of q
#a3: addr of queue
enqueue:
    addi a1, a1, 1
    blt a1, a2, not_over_e
    mv a1, zero
not_over_e:
    slli a4, a1, 2
    add a3, a3, a4
    sw a0, (a3)
    ret

#a0:  -> newvalue
#a1: head of q -> new head
#a2: length of q
#a3: addr of queue
dequeue:
    addi a1, a1, 1
    blt a1, a2, not_over_d
    mv a1, zero
not_over_d:
    slli a2, a1, 2
    add a3, a3, a2
    lw a0, (a3)
    ret
#a0:  -> newvalue
#a1: head of q
#a2: addr of queue
get_head:
    slli a1, a1, 2
    add a2, a1, a2
    lw a0, (a2)
    ret

#a0: address of constant null terminated string
print_const:
    li t0, UART_0
    addi a0, a0, -1
print_const_body:
    addi a0, a0, 1
    lb t1, (a0)
print_const_write:
    amoor.w t2, t1, txdata(t0)
    bne zero, t2, print_const_write
    bne zero, t1, print_const_body
    ret

#a0: ptr to process
#a1: process sp
block_process:
    li t0, blocked
    sb t0, p_status(a0)
    sw a1, p_registers+1*4(a0)
    ret

#a0: ptr to process
unblock_process:
    li t0, ready
    sb t0, p_status(a0)
    #a0 in place
    lw a1, p_queue_tail(gp)
    li a2, max_process
    addi a3, gp, p_queue
    jal enqueue
    sw a1, p_queue_tail(gp)
    ret



#a0: process pointer
run_process:
    # lw a1, p_queue_head(gp)
    # li a2, max_process
    # addi a3, gp, p_queue
    # jal dequeue
    # sw a1, p_queue_head(gp)
    # mv t0, a0
    # sw t0, current_process(gp)
    mv t0, a0
    
    lw t1, p_text_pointer(t0)
    srli t1, t1, 2
    lb t2, p_text_size(t0)
    li t3, 1
    # t2==0 -> word aligned so no modification
    # t2==1 -> double word aligned, assumes correct alignment
    # but not modification required for pmp
    ble t2, t3, set_pmp_addr0
    li t3, pmp_set_high
    li t5, max_text_size
    sub t5, t5, t2
    srl t3, t3, t5
    or t1, t1, t3

set_pmp_addr0:
    csrw pmpaddr0, t1

    lw t1, p_data_pointer(t0)
    srli t1, t1, 2
    andi t1, t1, ~0x100
    ori t1, t1, 0xff
    csrw pmpaddr1, t1

    #set pmp1cfg
    li t2, pmp_data
    # or t2, zero, t2

    lb t1, p_text_size(t0)
    beq t1, zero, set_na4
    ori t2, t2, pmp_text_napot
    j set_pmp_cfg
set_na4:
    ori t2, t2, pmp_text_na4
set_pmp_cfg:
    csrw pmpcfg0, t2
    #zero status is running
    sb zero, p_status(t0)
    lw t1, p_pc(t0)
    csrw mepc, t1

    lw x1, p_registers+0*4(t0)
    lw x3, p_registers+2*4(t0)
    lw x4, p_registers+3*4(t0)
    lw x8, p_registers+7*4(t0)
    lw x9, p_registers+8*4(t0)
    lw x10, p_registers+9*4(t0)
    lw x11, p_registers+10*4(t0)
    lw x12, p_registers+11*4(t0)
    lw x13, p_registers+12*4(t0)
    lw x14, p_registers+13*4(t0)
    lw x15, p_registers+14*4(t0)
    lw x16, p_registers+15*4(t0)
    lw x17, p_registers+16*4(t0)
    lw x18, p_registers+17*4(t0)
    lw x19, p_registers+18*4(t0)
    lw x20, p_registers+19*4(t0)
    lw x21, p_registers+20*4(t0)
    lw x22, p_registers+21*4(t0)
    lw x23, p_registers+22*4(t0)
    lw x24, p_registers+23*4(t0)
    lw x25, p_registers+24*4(t0)
    lw x26, p_registers+25*4(t0)
    lw x27, p_registers+26*4(t0)
    lw x29, p_registers+28*4(t0)
    lw x30, p_registers+29*4(t0)
    lw x31, p_registers+30*4(t0)

    csrw mscratch, sp

    lw x2, p_registers+1*4(t0)

    li t1, CLINT+mtime
    lw t2, 4(t1)
    lw t1, 0(t1)
    li t4, quantum
    add t3, t1, t4
    sltu t1, t3, t1
    add t2, t2, t1
    li t1, CLINT+mtimecmp
    sw t2, 4(t1)
    sw t3, 0(t1) 


    lw x6, p_registers+5*4(t0)
    lw x7, p_registers+6*4(t0)
    lw x28, p_registers+27*4(t0)
    lw x5, p_registers+4*4(t0)

    mret



#Assume stack pointer switched into mscratch
#Return address to save is pushed to stack
# -> a0: process ptr
#    a1: process status
save_state:
    addi sp, sp, -12
    #save gp, t0 and t1, to allow logic while saving registers
    sw x3, 8(sp)
    sw x5, 4(sp)
    sw x6, 0(sp)

    li gp, m_gp
    lw t0, current_process(gp)
    # lw t0, (t0)
    #save gp
    lw t1, 8(sp)
    sw t1, p_registers+2*4(t0)
    #save t0
    lw t1, 4(sp)
    sw t1, p_registers+4*4(t0)
    #save t1
    lw t1, 0(sp)
    sw t1, p_registers+5*4(t0)
    addi sp, sp, 12

    #pop ra from stack and save
    lw t1, 0(sp)
    sw t1, p_registers+0*4(t0)
    addi sp, sp, 4


    #save user pc
    csrr t1, mscratch
    sw t1, p_registers+1*4(t0)

    sw x4, p_registers+3*4(t0)
    sw x7, p_registers+6*4(t0)
    sw x8, p_registers+7*4(t0)
    sw x9, p_registers+8*4(t0)
    sw x10, p_registers+9*4(t0)
    sw x11, p_registers+10*4(t0)
    sw x12, p_registers+11*4(t0)
    sw x13, p_registers+12*4(t0)
    sw x14, p_registers+13*4(t0)
    sw x15, p_registers+14*4(t0)
    sw x16, p_registers+15*4(t0)
    sw x17, p_registers+16*4(t0)
    sw x18, p_registers+17*4(t0)
    sw x19, p_registers+18*4(t0)
    sw x20, p_registers+19*4(t0)
    sw x21, p_registers+20*4(t0)
    sw x22, p_registers+21*4(t0)
    sw x23, p_registers+22*4(t0)
    sw x24, p_registers+23*4(t0)
    sw x25, p_registers+24*4(t0)
    sw x26, p_registers+25*4(t0)
    sw x27, p_registers+26*4(t0)
    sw x28, p_registers+27*4(t0)
    sw x29, p_registers+28*4(t0)
    sw x30, p_registers+29*4(t0)
    sw x31, p_registers+30*4(t0)

    csrr t1, mepc
    sw t1, p_pc(t0)
    # li t1, 1
    lb t1, p_status(t0)
    bne zero, t1, not_running
    li t2, ready
    sb t2, p_status(t0)

    not_running:

    mv a0, t0
    # lw a1, p_status(t0)

    ret

