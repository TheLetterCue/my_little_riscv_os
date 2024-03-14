user_section:

.align 3
dummy:
    nop
    j dummy

.set fib_buff,  0
.align 10
fib:
    addi a0, gp, fib_buff
    la a1, fib_msg
    li a7, 5
    ecall
    addi a1, gp, fib_buff
    mv a2, a1
    jal string_to_int_fib


fib_msg: .string "Calc nth fib num:\n"
.align 2

#a0: original string address
#a1: new address
copy_reverse_string_fib:
    addi a0, a0, -1
    mv t1, sp
    # mv t1, zero
cpr_loop_fib:
    addi a0, a0, 1
    # addi t1, t1, 1
    lb t0, (a0)
    addi sp, sp, -1
    sb t0, (sp)
    bne zero, t0, cpr_loop_fib
    addi a1, a1, -1
    addi sp, sp, 1
cpr_loop_2_fib:
    addi a1, a1, 1
    lb t0, (sp)
    addi sp, sp, 1
    sb t0, (a1)
    bne sp, t1, cpr_loop_2_fib
    addi a1, a1, 1
    sb zero, (a1)
    ret

#a0: -> number
#a1: string address
#a2: buffer
string_to_int_fib:
    addi sp, sp, -4
    sw ra, (sp)
    mv a0, a1
    mv a1, a2
    jal copy_reverse_string_fib
    mv a1, a2
    lb t0, (a1)
    li t1, 45
    mv t2, zero
    bne t1, t0, pos_num_3_fib
    li t2, 1
    addi a1, a1, 1
pos_num_3_fib:
    mv a0, zero
    li t3, 1
    li t4, 10
st_t_i_loop_fib:
    lb t0, (a1)
    beq zero, t0, st_t_i_exit_fib
    addi t0, t0, -48
    mul t0, t0, t3
    mul t3, t3, t4
    add a0, a0, t0
    addi a1, a1, 1
    j st_t_i_loop_fib
st_t_i_exit_fib:
    lw ra, (sp)
    addi sp, sp, 4
    ret

.set buffer,    0
.set buffer1,   buffer+10*4
.set buffer2,   buffer+10*4
.set buffer3,   buffer+10*4
.align 10
printer:
    addi a1, gp, buffer
    la a0, printer_msg
    jal copy_string
    addi a0, gp, buffer
    li a7, 3
    ecall
    addi a0, gp, buffer
    addi a1, gp, buffer
    jal copy_reverse_string
    addi a0, gp, buffer
    li a7, 3
    ecall
    li a0, 0
    addi a1, gp, buffer
    jal int_to_string
    addi a0, gp, buffer
    li a7, 3
    ecall
    la a1, num_msg
    addi a2, gp, buffer2
    jal string_to_int
    addi a1, gp, buffer3
    jal int_to_string
    addi a0, gp, buffer3
    li a7, 3
    ecall
    li a7, 1
    ecall

#a0: original string address
#a1: new address
copy_string:
    addi a0, a0, -1
    addi a1, a1, -1
cp_loop:
    addi a0, a0, 1
    addi a1, a1, 1
    lb t0, (a0)
    sb t0, (a1)
    bne t0, zero, cp_loop
    ret

#a0: original string address
#a1: new address
copy_reverse_string:
    addi a0, a0, -1
    mv t1, sp
    # mv t1, zero
cpr_loop:
    addi a0, a0, 1
    # addi t1, t1, 1
    lb t0, (a0)
    addi sp, sp, -1
    sb t0, (sp)
    bne zero, t0, cpr_loop
    addi a1, a1, -1
    addi sp, sp, 1
cpr_loop_2:
    addi a1, a1, 1
    lb t0, (sp)
    addi sp, sp, 1
    sb t0, (a1)
    bne sp, t1, cpr_loop_2
    addi a1, a1, 1
    sb zero, (a1)
    ret

    #a0: number
#a1: buffer
int_to_string:
    addi sp, sp, -4
    sw ra, (sp)
    mv t0, zero
    li t1, 10
    mv t2, a1
    bge a0, zero, pos_num
    neg a0, a0
    li t0, 1
pos_num:
    rem t3, a0, t1
    addi t3, t3, 48
    sb t3, (a1)
    addi a1, a1, 1
    div a0, a0, t1
    bne zero, a0, pos_num
    beq zero, t0, pos_num_2
    li t3, 45
    sb t3, (a1)
    addi a1, a1, 1 
pos_num_2:
    sb zero, (a1)
    mv a1, t2
    mv a0, a1
    jal copy_reverse_string
    lw ra, (sp)
    addi sp, sp, 4
    ret

#a0: -> number
#a1: string address
#a2: buffer
string_to_int:
    addi sp, sp, -4
    sw ra, (sp)
    mv a0, a1
    mv a1, a2
    jal copy_reverse_string
    mv a1, a2
    lb t0, (a1)
    li t1, 45
    mv t2, zero
    bne t1, t0, pos_num_3 
    li t2, 1
    addi a1, a1, 1
pos_num_3:
    mv a0, zero
    li t3, 1
    li t4, 10
st_t_i_loop:
    lb t0, (a1)
    beq zero, t0, st_t_i_exit
    addi t0, t0, -48
    mul t0, t0, t3
    mul t3, t3, t4
    add a0, a0, t0
    addi a1, a1, 1
    j st_t_i_loop
st_t_i_exit:
    lw ra, (sp)
    addi sp, sp, 4
    ret

printer_msg: .string "Stuff:\n"
num_msg: .string "15"

.align 5
test_program0:
    li a0, led_red
    li a7, 0
    ecall
    j test_program0

.align 5
test_program1:
    li a0, led_green
    li a7, 0
    ecall
    li a7, 4
    ecall
    # li a7, 4
    # ecall
    j test_program1


.align 5
test_program2:
    li a0, led_blue
    li a7, 0
    ecall
    j test_program2

# .align 5
# test_program3:
#     li a0, led_cyan
#     li a7, 0
#     ecall
#     li a7, 1
#     ecall
#     # beq zero, zero, test_program3

# .align 5
# test_program4:
#     li a0, led_orange
#     li a7, 0
#     ecall
#     beq zero, zero, test_program4

# .align 5
# test_program5:
#     li a0, led_purple
#     li a7, 0
#     ecall
#     beq zero, zero, test_program5

# .align 5
# test_program6:
#     li a0, -1
#     li a7, 0
#     ecall
#     beq zero, zero, test_program6
    