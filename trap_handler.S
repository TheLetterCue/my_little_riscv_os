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

.include "sync_trap_calls.S"

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

    lb t0, p_status(a0)
    li t1, ready
    bne t0, t1, not_ready


    lw a1, p_queue_tail(gp)
    li a2, max_process
    addi a3, gp, p_queue
    jal enqueue
    sw a1, p_queue_tail(gp)

not_ready:
    li t1, terminated
    bne t0, t1, not_terminated

    lw t1, p_stack_pointer(gp)
    addi t1, t1, -4
    sw a0, 0(t1)
    sw t1, p_stack_pointer(gp)
    lw t1, process_count(gp)
    addi t1, t1, -1
    sw t1, process_count(gp)
    
    

not_terminated:
    # la a0, process_switch_msg
    # jal print_const

    lw a1, p_queue_head(gp)
    li a2, max_process
    addi a3, gp, p_queue
    jal dequeue
    sw a1, p_queue_head(gp)
    sw a0, current_process(gp)

    j run_process


m_extr_intr:
    csrrw sp, mscratch, sp
    addi sp, sp, -(4*10)
    sw a4, 36(sp)
    sw s0, 32(sp)
    sw s1, 28(sp)
    sw s2, 24(sp)
    sw s3, 20(sp)
    sw a0, 16(sp)
    sw a1, 12(sp)
    sw a2, 8(sp)
    sw a3, 4(sp)
    sw gp, 0(sp)
    li gp, m_gp

    li s3, PLIC+plic_claim
    lw s3, (s3)
    addi sp, sp, -4
    sw s3, 0(sp)
    slli s0, s3, 2
    la s1, ext_intr_tbl
    add s0, s0, s1
    jr s0

ext_intr_tbl:
    nop
    nop
    nop
    j uart0_ext_intr


exit_ext_intr:
    lw s2, 0(sp)
    addi sp, sp, 4
    li s3, PLIC+plic_claim
    sw s2, (s3)

    lw gp, 0(sp)
    lw a3, 4(sp)
    lw a2, 8(sp)
    lw a1, 12(sp)
    lw a0, 16(sp)
    lw s3, 20(sp)
    lw s2, 24(sp)
    lw s1, 28(sp)
    lw s0, 32(sp)
    lw a4, 36(sp)

    addi sp, sp, 4*10
    csrr sp, mscratch
    mret



.include "ext_trap_calls.S"