.include "immediates/process.inc"
.include "immediates/config.inc"

#Machine globals offsets
.set _base,             0x00
.set process_count,     _base
.set current_process,   process_count+4
.set p_stack_bottom,    current_process+max_process*4
.set p_stack_pointer,   p_stack_bottom+4
.set p_queue,           p_stack_pointer+4
.set p_queue_head,      p_queue+max_process*4
.set p_queue_tail,      p_queue_head+4
.set process_table,     p_queue_tail+4
.set process_table_end, process_table+max_process*process_entry_size
.set next_pid,          process_table_end
.set print_queue,       next_pid+4
.set _end_print_q,      print_queue+4*max_process
.set print_q_head,      _end_print_q
.set print_q_tail,      print_q_head+4