.align 6
trap_handler:
    j sync_trap
    nop
    nop
    j m_soft_intr
    nop
    nop
    nop
    j m_timr_intr
    nop
    nop
    nop
    j m_extr_intr


sync_trap:
    #swap the current user sp and the machine sp if the trap was triggered in user mode
    csrr t0, mstatus
    srli t0, t0, 11
    andi t0, t0, 1
    bne t0, zero, trap_from_m_mode
    csrrw sp, mscratch, sp
    addi sp, sp, -4
    sw gp, 0(sp)
    li gp, m_gp
trap_from_m_mode:
    csrr t0, mcause
    slli t0, t0, 2
    la t1, sync_trap_jmp_tbl
    add t0, t0, t1
    jr t0
sync_trap_jmp_tbl:
    j instr_addr_misaligned
    j instr_access_fault
    j illegal_instruction
    j breakpoint
    j ldr_addr_misaligned
    j ldr_access_fault
    j str_amo_addr_misaligned
    j str_amo_access_fault
    j u_env_call
    nop
    nop
    j m_env_call

instr_addr_misaligned:
    la a0, instr_addr_misaligned_msg
    jal print_const
    j .
instr_access_fault:
    la a0, instr_access_fault_msg
    jal print_const
    j .
illegal_instruction:
    la a0, illegal_instruction_msg
    jal print_const
    j .
breakpoint:
    la a0, breakpoint_msg
    jal print_const
    j sync_trap_exit
ldr_addr_misaligned:
    la a0, ldr_addr_misaligned_msg
    jal print_const
    j .
ldr_access_fault:
    la a0, ldr_access_fault_msg
    jal print_const
    j .
str_amo_addr_misaligned:
    la a0, str_amo_addr_misaligned_msg
    jal print_const
    j .
str_amo_access_fault:
    la a0, str_amo_access_fault_msg
    jal print_const
    j .

#a0-6: ecall args
#->a0: ecall output
#a7: ecall code

.set max_u_ecall,   3
u_env_call:
    li t0, max_u_ecall
    blt t0, a7, u_ecall_inv_code
    slli a7, a7, 2
    la t0, u_env_call_tbl
    add t0, t0, a7
    jr t0
u_env_call_tbl:
    j set_led
    j exit_process
    j create_process
    j print
    j yield


.set max_m_ecall,   1
m_env_call:
    li t0, max_m_ecall
    blt t0, a7, m_ecall_inv_code
    slli a7, a7, 2
    la t0, m_env_call_tbl
    add t0, t0, a7
    jr t0
m_env_call_tbl:
    j create_process
    j start_scheduler

.include "ecall.S"


u_ecall_inv_code:
    la a0, u_ecall_inv_code_msg
    jal print_const
    j sync_ecall_exit

m_ecall_inv_code:
    la a0, m_ecall_inv_code_msg
    jal print_const
    #j sync_ecall_exit

sync_ecall_exit:
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0
sync_trap_exit:
    csrr t0, mstatus
    srli t0, t0, 11
    andi t0, t0, 1
    bne t0, zero, t_exit
    lw gp, 0(sp)
    addi sp, sp, 4
    csrrw sp, mscratch, sp
t_exit:
    mret

#async traps save the temp registers to preserve state
#Software interrupts unlikely to be used on a single hart board
#As they would function identically to a ecall
m_soft_intr:
    mret

#assumes:
#there is at least one user process, otherwise timer interrupts would not be set
#p_text_pointer and p_data_pointer are valid
m_timr_intr:

    
    csrw pmpcfg0, zero
    fence.i

    csrrw sp, mscratch, sp
    addi sp, sp, -4
    sw ra, 0(sp)
    jal save_state

    li gp, m_gp

    lw t0, p_status(a0)
    li t1, ready
    bne t0, t1, not_ready

    lw a1, p_queue_tail(gp)
    li a2, max_process
    addi a3, gp, p_queue
    jal enqueue
    sw a1, p_queue_tail(gp)

not_ready:
    la a0, process_switch_msg
    jal print_const

    lw a1, p_queue_head(gp)
    li a2, max_process
    addi a3, gp, p_queue
    jal dequeue
    sw a1, p_queue_head(gp)
    sw a0, current_process(gp)

    j run_process


m_extr_intr:
    # csrrw sp, mscratch, sp
    # addi sp, sp, -28
    # sw t6, 24(sp)
    # sw t5, 20(sp)
    # sw t4, 16(sp)
    # sw t3, 12(sp)
    # sw t2, 8(sp)
    # sw t1, 4(sp)
    # sw t0, 0(sp)
    
    # nop
    
    # lw t0, 0(sp)
    # lw t1, 4(sp)
    # lw t2, 8(sp)
    # lw t3, 12(sp)
    # lw t4, 16(sp)
    # lw t5, 20(sp)
    # lw t6, 24(sp)
    # addi sp, sp, 28
    # csrrw sp, mscratch, sp
    mret
