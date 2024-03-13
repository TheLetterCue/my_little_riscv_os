user_section:

# .align 6 #Gives 32 lines
# proc_example:
#     la a0, breakpoint_msg
#     li a7, 3
#     ecall
#     la a0, led_blue
#     li a7, 0
#     ecall
#     li a0, 4
#     la a1, proc_example_child
#     li a7, 2
#     ecall
#     li a7, 1
#     ecall
#     # j proc_example

# .align 6
# proc_example_child:
#     la a0, breakpoint_msg
#     li a7, 3
#     ecall
#     la a0, led_red
#     li a7, 0
#     ecall
#     li a0, 4
#     la a1, proc_example
#     li a7, 2
#     ecall
#     li a7, 1
#     ecall
#     # j proc_example_child

.align 3
dummy:
    nop
    j dummy

printer:
    


# .align 5
# test_program0:
#     li a0, led_red
#     li a7, 0
#     ecall
#     j test_program0

# .align 5
# test_program1:
#     li a0, led_green
#     li a7, 0
#     ecall
#     j test_program1


# .align 5
# test_program2:
#     li a0, led_blue
#     li a7, 0
#     ecall
#     beq zero, zero, test_program2

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
    