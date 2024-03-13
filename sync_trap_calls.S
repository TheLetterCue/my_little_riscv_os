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