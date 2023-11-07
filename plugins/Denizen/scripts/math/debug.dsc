disassemble_chunk_proc:
    type: procedure
    debug: false
    definitions: chunk|name
    script:
    - define "lines:->:== <[name]> =="
    - define offset 0
    - while <[offset]> < <[chunk.code].size>:
        - define output <[chunk].proc[disassemble_instruction_proc].context[<[offset]>]>
        - define lines:->:<[output.line]>
        - define offset:+:<[output.offset]>
    - determine <[lines].separated_by[<n>]>

disassemble_instruction_proc:
    type: procedure
    debug: false
    definitions: chunk|offset
    script:
    # - definemap output:
    #     line:
    #     offset: <[offset].add[1]>
    - define line <[offset].pad_left[4].with[0]><&sp>
    - if <[offset]> > 0 && <[chunk.lines].get[<[offset].add[1]>]> == <[chunk.lines].get[<[offset]>]>:
        - define line "<[line]>   | "
    - else:
        - define line "<[line]><[chunk.lines].get[<[offset].add[1]>].pad_left[4]> "

    - define instruction <[chunk.code].get[<[offset].add[1]>]>
    - choose <[instruction].proc[instruction_get_string_proc]>:
        - case OP_RETURN:
            - determine <proc[simple_instruction_proc].context[OP_RETURN|<[offset]>].proc[data_prepend_line_proc].context[<[line]>]>
        - case OP_CONSTANT:
            - determine <[chunk].proc[constant_instruction_proc].context[OP_CONSTANT|<[offset]>].proc[data_prepend_line_proc].context[<[line]>]>
        - default:
            - determine <map.with[line].as[unknown opcode <[instruction]>].with[offset].as[<[offset].add[1]>].proc[data_prepend_line_proc].context[<[line]>]>

constant_instruction_proc:
    type: procedure
    debug: false
    definitions: chunk|name|offset
    script:
    - define constant <[chunk.code].get[<[offset].add[1]>]>
    - determine <map.with[line].as[<[name]> <[chunk.constants].get[<[constant]>]>].with[offset].as[<[offset].add[2]>]>

simple_instruction_proc:
    type: procedure
    debug: false
    definitions: name|offset
    script:
    - determine <map.with[line].as[<[name]>].with[offset].as[<[offset].add[1]>]>

data_prepend_line_proc:
    type: procedure
    debug: false
    definitions: data|line
    script:
    - definemap new_data:
        line: <[line]><[data.line]>
        offset: <[data.offset]>
    - determine <[new_data]>

math_test_task:
    type: task
    debug: false
    script:
    - define vm <proc[vm_init_proc]>
    - define output <[vm.chunk].proc[chunk_write_constant_proc].context[1.2]>
    - define vm.chunk <[output.chunk]>
    - define vm.chunk <[vm.chunk].proc[chunk_write_proc].context[OP_CONSTANT|123]>
    - define vm.chunk <[vm.chunk].proc[chunk_write_proc].context[<[output.index]>|123]>
    - define vm.chunk <[vm.chunk].proc[chunk_write_proc].context[OP_NEGATE|123]>
    - define vm.chunk <[vm.chunk].proc[chunk_write_proc].context[OP_RETURN|123]>
    - define x <[vm].proc[vm_interpret_proc].context[<[vm.chunk]>]>
    - narrate <[vm.chunk].proc[disassemble_chunk_proc].context[test chunk]>
