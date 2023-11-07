# DATA STRUCTURE: CHUNK
# code: list of numbers
# constants: list of numbers
# lines: list of numbers

chunk_data:
    type: data
    codes:
    - OP_CONSTANT
    - OP_NEGATE
    - OP_RETURN

instruction_get_string_proc:
    type: procedure
    debug: false
    definitions: inst
    script:
    - determine <script[chunk_data].data_key[codes].get[<[inst]>]>

chunk_init_proc:
    type: procedure
    debug: false
    script:
    - definemap chunk:
        code: <list>
        constants: <list>
        lines: <list>
    - determine <[chunk]>

chunk_write_proc:
    type: procedure
    debug: false
    definitions: chunk|byte|line
    script:
    - if !<[byte].is_decimal>:
        - define byte <script[chunk_data].data_key[codes].find[<[byte]>]>
    - determine <[chunk].with[code].as[<[chunk.code].include[<[byte]>]>].with[lines].as[<[chunk.lines].include[<[line]>]>]>

chunk_write_constant_proc:
    type: procedure
    debug: false
    definitions: chunk|value
    script:
    - definemap output:
        chunk: <[chunk].with[constants].as[<[chunk.constants].include[<[value]>]>]>
        index: <[chunk.constants].size.sub[1]>
    - determine <[output]>
