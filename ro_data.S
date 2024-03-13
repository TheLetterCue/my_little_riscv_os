.section .rodata
.align 2
instr_addr_misaligned_msg: .string "Runtime exception: instruciton address misaligned\n"
.align 2
instr_access_fault_msg: .string "Runtime exception: instruction access fault\n"
.align 2
illegal_instruction_msg: .string "Runtime exception: illegal istruction\n"
.align 2
breakpoint_msg: .string "Breakpoint called\n"
.align 2
ldr_addr_misaligned_msg: .string "Runtime exception: load address misaligned\n"
.align 2
ldr_access_fault_msg: .string "Runtime exception: load access fault\n"
.align 2
str_amo_addr_misaligned_msg: .string "Runtime exception: store/AMO address misaligned\n"
.align 2
str_amo_access_fault_msg: .string "Runtime exception: store/AMO access fault\n"
.align 2
u_env_call_msg: .string "ecall made from user mode\n"
.align 2
m_env_call_msg: .string "ecall made from machine mode\n"
.align 2
m_ecall_inv_code_msg: .string "invalid machine ecall code\n"
.align 2
u_ecall_inv_code_msg: .string "invalid user ecall code\n"
.align 2
create_process_msg: .string "Creating init process\n"
.align 2
max_processes_called_msg: .string "Process creation failed, max number of processes currently running\n"
.align 2
process_switch_msg: .string "Switching process\n"
.align 2
program_start_msg: .string "Starting scheduler\n"
.align 2
text_limit_exceeded_msg: .string "Program text size exceeds limit\n"
.align 2
invalid_text_range_msg: .string "Program text cannot be loaded from outside flash\n"
.align 2
user_msg: .string "Hello!!\n"
