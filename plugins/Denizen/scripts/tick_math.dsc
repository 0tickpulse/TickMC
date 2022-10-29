# @ ----------------------------------------------------------
# Tick's Math
# A math system that uses tokenization and parsing to evaluate
# certain math expressions.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tick_math_evaluate_proc:
    type: procedure
    debug: false
    data:
        character sets:
            numbers: 1234567890.
            operators: +-*/^
    script:
        tokenize:
        - define string <[1].replace_text[ ].replace_text[regex:\<&lb>|\{].with[(].replace_text[regex:\<&rb>|\}].with[)].replace_text[÷].with[/].replace_text[regex:×|x|x|X].with[*].replace_text[regex:–|—].with[-]>
        - define length <[string].length>
        - define i 1
        - define error <map[error=false]>
        - define tokens <list>
        - while <[i]> <= <[length]>:
            - define chr <[string].to_list.get[<[i]>]>
            - if <[chr].matches_character_set[<script.parsed_key[data.character sets.numbers]>]>:
                - define res <empty>
                - while <[chr].matches_character_set[<script.parsed_key[data.character sets.numbers]>]> && <[i]> <= <[length]>:
                    - define res <[res]><[chr]>
                    - define i:++
                    - if <[i]> >= <[length]>:
                        - while next
                    - define chr <[string].to_list.get[<[i]>]>
                - define tokens:->:<map[type=number;value=<[res]>]>
            - if <[chr]> == <element[(]>:
                - define res <empty>
                - define i:++
                - define chr <[string].to_list.get[<[i]>]>
                - while <[chr]> != <element[)]> && <[i]> < <[length]>:
                    - define res <[res]><[chr]>
                    - define i:++
                    - define chr <[string].to_list.get[<[i]>]>
                - if <[chr]> != <element[)]>:
                    - define error <map[error=true;error=unclosed_parantheses]>
                    - define tokens <list>
                    - determine <map[error=<[error]>;tokens=<[tokens]>]>
                - define tokens:->:<map[type=expression;value=<[res]>]>
            - if <[chr].matches_character_set[<script.parsed_key[data.character sets.operators]>]>:
                - define tokens:->:<map[type=operator;value=<[chr]>]>
                - define i:++

        - determine <map.with[error].as[<[error]>].with[tokens].as[<[tokens]>]>
        calculate_from_tokens:
        - define tokens <[1.tokens].parse_tag[<[parse_value.type].equals[expression].if_true[<map[type=calculated_expression;value=<[parse_value.value].proc[tick_math_evaluate_proc.script.calculate_from_string]>]>].if_false[<[parse_value]>]>]>
        - debug log "New tokens: <[tokens]>"
        - while <[tokens].size> > 1:
            - foreach <[tokens]> as:token:
                - if <[loop_index]> >= <[tokens].size>:
                    - foreach next
                - define token <[token]>
                - define next_token <[tokens].get[<[loop_index].add[1]>]>
                - define final_token <[tokens].get[<[loop_index].add[2]>].if_null[<map[type=null;value=null]>]>
                - if <[token.type]> in calculated_expression|number && <[next_token.type]> == calculated_expression:
                    - define calculation <[token.value].mul[<[next_token.value]>]>
                    - define tokens <[tokens].remove[<[loop_index]>].to[<[loop_index].add[1]>].insert[<map[type=number;value=<[calculation]>]>].at[<[loop_index]>]>
                    - debug log "New tokens after evaluation of expressions: <[tokens]>"
                - else if <[token.type]> == number && <[next_token.type]> == operator && <[final_token.type]> == number:
                    - choose <[next_token.value]>:
                        - case *:
                            - define calculation <[token.value].mul[<[final_token.value]>]>
                        - case /:
                            - define calculation <[token.value].div[<[final_token.value]>]>
                        - case +:
                            - define calculation <[token.value].add[<[final_token.value]>]>
                        - case -:
                            - define calculation <[token.value].sub[<[final_token.value]>]>
                    - if <[calculation].exists>:
                        - define tokens <[tokens].remove[<[loop_index]>].to[<[loop_index].add[2]>].insert[<map[type=number;value=<[calculation]>]>].at[<[loop_index]>]>
                - else:
                    - debug error "Unhandled token: <[token].to_json>!"
                    - stop
        - determine <[tokens].first.get[value]>
        calculate_from_string:
        - define tokens <[1].proc[tick_math_evaluate_proc.script.tokenize]>
        - if <[tokens.error.error]> != false:
            - debug error "Error when tokenizing: <[tokens.error.error]>"
            - stop
        - debug log <[tokens]>
        - determine <[tokens].proc[tick_math_evaluate_proc.script.calculate_from_tokens]>

