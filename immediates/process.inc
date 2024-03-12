#process table entry struct
.set p_process_id,          0x00
.set p_parent_id,           0x01
.set p_status,              0x02
.set p_text_size,           0x03
.set p_pc,                  0x04
.set p_text_pointer,        0x08
.set p_data_pointer,        0x0c
.set p_registers,           0x10

#size of struct
.set process_entry_size,    140

