# DATA STRUCTURE: VM
# chunk: a chunk of instructinos
# ip: instruction pointer. Because pointers don't exist in this language, we use an index into the chunk
# stack: a list of numbers

vm_init_proc:
    type: procedure
    debug: false
    script:
    - definemap vm:
        chunk: <proc[chunk_init_proc]>
        ip: 0
    - determine <[vm]>

vm_interpret_proc:
    type: procedure
    debug: false
    definitions: vm|chunk
    script:
    - define vm.chunk <[chunk]>
    - define vm.ip 0
    - define vm.stack <list>
    - determine <[vm].proc[vm_run_proc]>

vm_reset_stack_proc:
    type: procedure
    debug: false
    definitions: vm
    script:
    - definemap new_vm:
        chunk: <[vm.chunk]>
        ip: <[vm.ip]>
        stack: <list>
    - determine <[new_vm]>

vm_stack_push_proc:
    type: procedure
    debug: false
    definitions: vm|value
    script:
    - define vm.stack <[vm.stack].include[<[value]>]>
    - determine <[vm]>

vm_stack_pop_proc:
    type: procedure
    debug: false
    definitions: vm
    script:
    - define last <[vm.stack].last>
    - define vm.stack <[vm.stack].remove[-1]>
    - determine <map.with[vm].as[<[vm]>].with[last].as[<[last]>]>

vm_run_proc:
    type: procedure
    debug: true
    definitions: vm
    script:
    - while true:
        - define instruction <[vm.chunk.code].get[<[vm.ip].add[1]>]>
        - define vm.ip:++
        - choose <[instruction].proc[instruction_get_string_proc]>:
            - case OP_NEGATE:
                - define popped <[vm].proc[vm_stack_pop_proc]>
                - define vm <[popped.vm]>
                - define vm <[vm].proc[vm_stack_push_proc].context[<[popped.last].mul[-1]>]>
            - case OP_RETURN:
                - define popped <[vm].proc[vm_stack_pop_proc]>
                - define vm <[popped.vm]>
                - debug log <[popped.last]>
                - determine true
            - case OP_CONSTANT:
                - define constant <[vm.chunk.constants].get[<[vm.chunk.code].get[<[vm.ip].add[1]>]>]>
                - define vm.ip:++
                - define vm <[vm].proc[vm_stack_push_proc].context[<[constant]>]>
