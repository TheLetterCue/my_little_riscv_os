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
    li t3, 1
    li t4, 10
st_t_i_loop:
    lb t0, (a1)
    beq zero, t0, st_t_i_exit
    addi t0, t0, -48
    mul t0, t0, t3
    mul t3, t3, t4
    add a0, a0, t0
    j st_t_i_loop
st_t_i_exit:
    lw ra, (sp)
    addi sp, sp, 4
    ret

