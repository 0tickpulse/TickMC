# @ ----------------------------------------------------------
# TickUtil Commands
# Adds many utility scripts that make command scripts much
# easier.
# Author: 0TickPulse
# @ ----------------------------------------------------------

command_manager_data:
    type: data
    # If set to true, when receiving a fatal error, the script will instantly print the error and stop.
    # This means that the arguments will stop processing, which has a side effect being that future errors would not be printed.
    # However, this will improve your script's performance.
    # Hence, set it to true if you want to improve performance, and false if you want to see more verbose errors.
    instantly terminate command execution on fatal error: true
    formatting:
        lang:
            prefixed_value_separator: =
            hline: <&sp.repeat[80].color[dark_gray].strikethrough>
            formatted_help_same_file:
                page_text: <[left_arrow].if_null[]><&[base]>Page <[page].custom_color[emphasis]> of <[pages].custom_color[emphasis]><[right_arrow].if_null[]>
                left_arrow: <&[emphasis]><&lt>--<&sp>
                right_arrow: <&[emphasis]><&sp>--<&gt>
                command_line: <&[emphasis]>/<[parse_value].data_key[name].on_click[/commandlist <[parse_value].data_key[name]>].on_hover[<&[emphasis]>Click to get detailed info!]> <dark_gray>- <[parse_value].data_key[description].color[gray]>
        colors:
            prefixed_arg_dash: <&3>
            prefixed_arg_key: <empty>
            prefixed_arg_colon: <&7>
            prefixed_arg_value: <&3>
            literal_arg_text: <&3>
            nonliteral_arg_text: <&7>
            # In "{a}/b/c", the "{a}" part
            default_choice_text: <&b>
        symbols:
            required_arg_prefix: <&lb.color[9]>
            required_arg_suffix: <&rb.color[9]>
            optional_arg_prefix: <element[(].color[3]>
            optional_arg_suffix: <element[)].color[3]>
            literal_arg_prefix: <empty>
            literal_arg_suffix: <empty>
            nonliteral_arg_prefix: <&lt.color[7]>
            nonliteral_arg_suffix: <&gt.color[7]>
            slash: <element[/].color[7]>
            spread: <element[...].color[7]>
    # @ Argument templates
    # These can be used in your args via "template: <template_name>"
    # For example:
    #
    # args:
    #     player:
    #         template: player
    arg templates:
        # The name for the argument
        duration:
            # The type for the argument.
            # linear - A linear ordered argument. In "/say hi", "hi" is a linear argument.
            # prefixed - A prefixed argument. In "/say -message:hi", "-message:hi" is a prefixed argument.
            # Prefixed arguments use the "-<key>:<value>" syntax.
            type: linear
            # Whether they are necessary.
            required: true
            # A boolean that determines whether the argument is accepted.
            # Can make use of <[value]> definition.
            # If this is not defined, the argument is always accepted.
            accepted: <[value].as[duration].exists>
            # An explanation for the argument. Will be printed in error messages.
            explanation: Any duration. Can use y for years, w for weeks, d for days, h for hours, m for minutes, s for seconds, and t for ticks.
            # If accepted, optionally specify what the value becomes - in this case, it transforms the value, converting to a DurationTag.
            result: <[value].as[duration]>
        world_default_player:
            type: linear
            # Dynamic requre - if a player running it, it is required, otherwise it is not.
            required: <player.exists.not>
            accepted: <server.worlds.parse[name].contains_single[<[value]>]>
            explanation: The name of any loaded world. Defaults to the player's world.
            # Tab completes for the argument.
            tab completes: <server.worlds.parse[name]>
            # If not specified/accepted, optionally specify a default value.
            default: <player.world>
            result: <[value].as[world]>
        world:
            type: linear
            required: true
            accepted: <server.worlds.parse[name].contains_single[<[value]>]>
            tab completes: <server.worlds.parse[name]>
            result: <[value].as[world]>
            explanation: The name of any loaded world.
        minimessage:
            result: <[value].parse_minimessage>
        player_strict:
            type: linear
            required: true
            accepted: <server.online_players.parse[name].contains_single[<[value]>]>
            tab completes: <server.online_players.parse[name]>
            result: <server.match_player[<[value]>]>
            explanation: The name of any online player.
        player:
            type: linear
            required: <player.exists.not>
            accepted: <server.online_players.parse[name].contains_single[<[value]>]>
            tab completes: <server.online_players.parse[name]>
            explanation: The name of any online player.
            default: <player>
            result: <server.match_player[<[value]>]>
        visible_player_include_offline_strict:
            type: linear
            required: true
            accepted: <proc[tick_essentials_get_all_visible_players_proc].parse[name].contains_single[<[value]>]>
            tab completes: <proc[tick_essentials_get_all_visible_players_proc].parse[name]>
            explanation: The name of any online player.
            result: <server.match_player[<[value]>]>
        visible_player_include_offline:
            type: linear
            required: <player.exists.not>
            accepted: <proc[tick_essentials_get_all_visible_players_proc].parse[name].contains_single[<[value]>]>
            tab completes: <proc[tick_essentials_get_all_visible_players_proc].parse[name]>
            explanation: The name of any online player.
            default: <player>
            result: <server.match_player[<[value]>]>
        visible_player_strict:
            type: linear
            required: true
            accepted: <proc[tick_essentials_get_visible_players_proc].parse[name].contains_single[<[value]>]>
            tab completes: <proc[tick_essentials_get_visible_players_proc].parse[name]>
            explanation: The name of any online player.
            result: <server.match_player[<[value]>]>
        visible_player:
            type: linear
            required: <player.exists.not>
            accepted: <proc[tick_essentials_get_visible_players_proc].parse[name].contains_single[<[value]>]>
            tab completes: <proc[tick_essentials_get_visible_players_proc].parse[name]>
            explanation: The name of any online player.
            default: <player>
            result: <server.match_player[<[value]>]>
        player_include_offline_strict:
            type: linear
            required: true
            accepted: <server.players.parse[name].contains_single[<[value]>]>
            tab completes: <server.players.parse[name]>
            explanation: Any player who has ever joined the server.
            result: <server.match_offline_player[<[value]>]>
        player_include_offline:
            type: linear
            required: <player.exists.not>
            accepted: <server.players.parse[name].contains_single[<[value]>]>
            tab completes: <server.players.parse[name]>
            explanation: Any player who has ever joined the server.
            default: <player>
            result: <server.match_offline_player[<[value]>]>
        boolean_null:
            type: prefixed
            required: false
            accepted: <[value].is_boolean>
            usage text:
                auto format: true
                list:
                - true
                - false
            tab completes: true|false
            result: <[value].as_boolean>
            explanation: A boolean (true/false).
            boolean style tab complete: true
        boolean_default_true:
            type: prefixed
            required: false
            default: true
            accepted: <[value].is_boolean>
            usage text:
                auto format: true
                list:
                - <&lc>true<&rc>
                - false
            boolean style tab complete: true
            tab completes: true|false
            result: <[value].as_boolean>
            explanation: A boolean (true/false).
        boolean_default_false:
            type: prefixed
            required: false
            default: false
            accepted: <[value].is_boolean>
            usage text:
                auto format: true
                list:
                - true
                - <&lc>false<&rc>
            boolean style tab complete: true
            tab completes: true|false
            result: <[value].as_boolean>
            explanation: A boolean (true/false).
        any_value:
            type: prefixed
            accepted: true
        maptag:
            type: linear
            accepted: <[value].as[map].exists>
            result: <[value].as[map]>
            explanation: A Denizen MapTag (syntax<&co> key=value;key=value;...).
            usage text:
                auto format: true
                list:
                - <&lt>map<&gt>
            default: <map>
        integer:
            type: linear
            accepted: <[value].is_integer>
            explanation: Any integer.
            usage text:
                auto format: true
                list:
                - <&lt>#<&gt>
        decimal:
            type: linear
            accepted: <[value].is_decimal>
            explanation: Any decimal.
            usage text:
                auto format: true
                list:
                - <&lt>#.#<&gt>

command_manager_get_subcommand_data_proc:
    type: procedure
    debug: false
    definitions: script
    script:
    - define subcommand_permissions_data <[script].data_key[data.subcommand_permissions].if_null[<map>]>
    - define subcommands_data_unfiltered <[script].data_key[data.subcommands].if_null[<map>]>
    - define subcommands_data <map>
    - if !<player.exists>:
        - define subcommands_data <[subcommands_data_unfiltered]>
    - else:
        - foreach <[subcommands_data_unfiltered]> key:subcommand_data_key as:data:
            - if <[subcommand_permissions_data].keys> contains <[subcommand_data_key]>:
                - if <[subcommand_permissions_data.<[subcommand_data_key]>].filter_tag[<player.has_permission[<[filter_value]>].not>].any>:
                    - foreach next
            - define subcommands_data.<[subcommand_data_key]> <[data]>
    - determine <[subcommands_data]>
command_manager_generate_usage:
    type: procedure
    debug: false
    definitions: script
    script:
    - define colors <static[<script[command_manager_data].parsed_key[formatting.colors]>]>
    - define symbols <static[<script[command_manager_data].parsed_key[formatting.symbols]>]>
    - define output /<[script].data_key[name]>
    - if <[script].data_key[data.enable_subcommands].if_null[false]>:
        - define subcommand_strings <list>
        - foreach <[script].proc[command_manager_get_subcommand_data_proc]> key:key as:args:
            - inject command_manager.generate_arg_maps
            - define "subcommand_strings:->:<[colors.literal_arg_text]><[key]> <[args].parse_value_tag[<[parse_key].proc[command_manager_generate_singular_usage_proc].context[<[parse_value]>]>].values.separated_by[ ]>"
        - define output "<[output]> <[symbols.required_arg_prefix]><[subcommand_strings].separated_by[/]><[symbols.required_arg_suffix]>"
        # Also include global args
        - define args <[script].data_key[data.args].if_null[<map>]>
    - inject command_manager.generate_arg_maps
    - define output "<[output]> <[args].parse_value_tag[<[parse_key].proc[command_manager_generate_singular_usage_proc].context[<[parse_value]>]>].values.separated_by[ ]>"
    - determine <[output]>
command_generator_arg_map_proc:
    type: procedure
    debug: false
    definitions: template_key|template_map
    script:
    - if <[template_map.template].exists>:
        - define template_map <[template_key].proc[command_generator_arg_map_proc].context[<script[command_manager_data].data_key[arg templates.<[template_map.template]>].include[<[template_map].exclude[template]>]>].values.first>
    - define output <map.with[<[template_map.name].if_null[<[template_key]>]>].as[<[template_map]>]>
    - determine <[output]>

command_manager_generate_choices_colored_proc:
    type: procedure
    debug: false
    definitions: list|type
    script:
    - define colors <static[<script[command_manager_data].parsed_key[formatting.colors]>]>
    - define symbols <static[<script[command_manager_data].parsed_key[formatting.symbols]>]>
    - define formatted_choices <list>
    - define list <[list].parse[parsed]>

    - foreach <[list]> as:choice:
        # Default choice, like "{a}"
        - if <[choice].strip_color.starts_with[<&lc>]> && <[choice].strip_color.ends_with[<&rc>]>:
            - define formatted_choices:->:<[colors.default_choice_text]><[choice]>
        # Nonliteral choice, like "<a>"
        - else if <[choice].strip_color.starts_with[<[symbols.nonliteral_arg_prefix].strip_color>]> && <[choice].strip_color.ends_with[<[symbols.nonliteral_arg_suffix].strip_color>]>:
            - define text <[choice].substring[2,<[choice].length.sub[1]>]>
            - define formatted_choices:->:<[symbols.nonliteral_arg_prefix]><[colors.nonliteral_arg_text]><[text]><[symbols.nonliteral_arg_suffix]>
        # Literal choice, like "a"
        - else:
            - define formatted_choices:->:<[symbols.literal_arg_prefix]><[colors.literal_arg_text]><[choice]><[symbols.literal_arg_suffix]>

    - define slash <[symbols.slash]>

    - define output <list>
    - foreach <[formatted_choices]> as:choice:
        - define output:->:<[colors.literal_arg_text]><[choice]>
    - determine <[output].separated_by[<[slash]>]>

command_manager_generate_singular_usage_proc:
    type: procedure
    debug: false
    definitions: name|arg
    script:
    - define colors <static[<script[command_manager_data].parsed_key[formatting.colors]>]>
    - define symbols <static[<script[command_manager_data].parsed_key[formatting.symbols]>]>
    - define sep <script[command_manager_data].parsed_key[formatting.lang.prefixed_value_separator]>
    - define output <empty>

    # Left brace
    - if <[arg.required].parsed.if_null[false]>:
        - define output <[output]><[symbols.required_arg_prefix]>
    - else:
        - define output <[output]><[symbols.optional_arg_prefix]>

    # Usage text
    - define usage_text <[arg.usage text.auto format].if_null[false].if_true[<[arg.usage text.list].proc[command_manager_generate_choices_colored_proc].context[<[arg.type].if_null[prefixed]>]>].if_false[<[arg.usage text.text].parsed.if_null[<[symbols.nonliteral_arg_prefix]><[colors.nonliteral_arg_text]><[name]><[symbols.nonliteral_arg_suffix]>]>]>
    - if <[arg.type].if_null[null]> == linear:
        - define output <[output]><[arg.spread].if_null[false].if_true[<script[command_manager_data].parsed_key[formatting.symbols.spread]>].if_false[]><[usage_text]>
    - else:
        - define output <[output]><[colors.prefixed_arg_dash]>-<[colors.prefixed_arg_key]><[name]><[colors.prefixed_arg_colon]><[sep]><[usage_text]>

    # Right brace
    - if <[arg.required].parsed.if_null[false]>:
        - define output <[output]><[symbols.required_arg_suffix]>
    - else:
        - define output <[output]><[symbols.optional_arg_suffix]>

    - determine <[output]>
command_manager_formatted_help_same_file_task:
    type: task
    definitions: script|size|page|title
    debug: false
    script:
    - define commands <util.scripts.filter[filename.equals[<[script].filename>]].filter_tag[<[filter_value].parsed_key[enabled].if_null[true]>].filter[container_type.equals[command]].parse_tag[<script[command_manager_data].parsed_key[formatting.lang.formatted_help_same_file.command_line]>]>
    - define pages <[commands].sub_lists[<[size]>].size>
    - if <[page]> > <[pages]>:
        - define page <[pages]>
    - define page_content <[commands].sub_lists[<[size]>].get[<[page]>]>
    - define hline <script[command_manager_data].parsed_key[formatting.lang.hline]>
    - if <[page]> > 1:
        - clickable save:previous_page:
            - run command_manager_formatted_help_same_file_task def.script:<[script]> def.size:<[size]> def.page:<[page].sub[1]> def.title:<[title]>
        - define left_arrow <script[command_manager_data].parsed_key[formatting.lang.formatted_help_same_file.left_arrow].on_click[<entry[previous_page].command>]>
    - if <[page]> < <[pages]>:
        - clickable save:next_page:
            - run command_manager_formatted_help_same_file_task def.script:<[script]> def.size:<[size]> def.page:<[page].add[1]> def.title:<[title]>
        - define right_arrow <script[command_manager_data].parsed_key[formatting.lang.formatted_help_same_file.right_arrow].on_click[<entry[next_page].command>]>
    - define page_message <script[command_manager_data].parsed_key[formatting.lang.formatted_help_same_file.page_text]>
    - narrate <[hline]><[title].if_null[]><n><[page_content].separated_by[<n>]><n.repeat[2]><[page_message]><n><[hline]>

command_manager_tab_complete_arg_proc:
    type: procedure
    debug: false
    definitions: map|input_arg
    script:
    - determine null
command_manager:
    type: task
    debug: false
    script:
    - debug error "Please specify a path to inject."
    - stop
    formatted_help_same_file:
    - run command_manager_formatted_help_same_file_task def.script:<queue.script> def.size:10 def.page:<[arg.page].if_null[1]> def.title:<[title].if_null[]>
    flag_args:
    - define flag_args <map.with[linear_args].as[<list>].with[prefixed_args].as[<map>]>
    - define sep <script[command_manager_data].parsed_key[formatting.lang.prefixed_value_separator]>
    - foreach <context.args> as:arg:
        - if !<[arg].starts_with[-]>:
            - define flag_args.linear_args:->:<[arg]>
            - foreach next
        - define flag_args.prefixed_args <[flag_args.prefixed_args].with[<[arg].after[-].before[<[sep]>]>].as[<[arg].contains_text[<[sep]>].if_true[<[arg].after[<[sep]>]>].if_false[true]>]>
    #- define flag_args.linear_args <context.args.filter[starts_with[-].not]>
    #- define flag_args.prefixed_args <context.args.filter[starts_with[-]].parse_tag[<list_single[<[parse_value].after[-].before[<[sep]>]>].include_single[<[parse_value].contains_text[<[sep]>].if_true[<[parse_value].after[<[sep]>]>].if_false[true]>]>]>
    #- narrate <[flag_args].to_yaml>
    generate_arg_maps:
    - define is_tabcompleting <[is_tabcompleting].if_null[false]>
    - if !<[script].exists>:
        - define script <queue.script>
    - define subcommands_enabled <[script].data_key[data.enable_subcommands].if_null[false]>
    - if !<queue.definitions.contains[args]>:
        - define subcommands_data <[script].proc[command_manager_get_subcommand_data_proc]>
        - define subcommand_arg_map <map.with[_subcommand].as[<map.with[type].as[linear].with[required].as[true].with[accepted].as[true].with[explanation].as[Internally generated arg].with[tab completes].as[<[subcommands_data].keys>]>].include[<[script].data_key[data.args].if_null[<map>]>]>
        - if <[subcommands_enabled]>:
            - define subcommand <[flag_args.linear_args].if_null[<list>].first.if_null[null]>
            - if <[subcommand]> == null:
                - define args <[subcommand_arg_map]>
            - else:
                - if <[subcommands_data].keys> !contains <[subcommand]>:
                    - if <[subcommands_data].keys.filter[starts_with[<[subcommand]>]].any> && <[is_tabcompleting]>:
                        - determine <[subcommands_data].keys.filter[starts_with[<[subcommand]>]]>
                    - define tickutil_commands.args_manager.panic true
                    - define tickutil_commands.args_manager.close_match <[subcommands_data].keys.closest_to[<[subcommand]>]>
                    - if <[tickutil_commands.args_manager.close_match].to_lowercase.difference[<[subcommand].to_lowercase>]> <= 3 && <[tickutil_commands.args_manager.close_match]> != <empty>:
                        - define tickutil_commands.args_manager.close_match_text " Did you mean '<white><[tickutil_commands.args_manager.close_match]>?<&[error]>"
                    - define "tickutil_commands.args_manager.error_messages:->:<&[error]>Unknown subcommand '<white><[subcommand]><&[error]>'!<[tickutil_commands.args_manager.close_match_text].if_null[]>"
                    - goto fatal_error
                - define args <[subcommand_arg_map].include[<[subcommands_data.<[subcommand]>]>]>
        - else:
            - define args <[script].data_key[data.args].if_null[null]>
        - if <[args]> == null:
            - stop
    - define args <[args].parse_value_tag[<[parse_key].proc[command_generator_arg_map_proc].context[<[parse_value].as[map]>]>].values.merge_maps.exclude[_permission]>
    tab_complete_engine:
    - define sep <script[command_manager_data].parsed_key[formatting.lang.prefixed_value_separator]>
    - define is_tabcompleting true
    - inject command_manager.flag_args
    - inject command_manager.generate_arg_maps

    - define completions <list>
    - define unfiltered_completions <list>

    - define current_arg <[flag_args.linear_args].if_null[<list>].size.max[1]>
    - if <[flag_args.linear_args].if_null[<list>].size> >= 1 && <context.raw_args.ends_with[ ]>:
        - define current_arg:++

    - define linear_args <[args].filter_tag[<[filter_value.type].equals[linear].if_null[true]>]>
    - if <[linear_args].size> >= <[current_arg]>:
        - define current_linear_arg <[linear_args].to_pair_lists.get[<[current_arg]>]>
    - else if <[linear_args].values.last.get[spread].if_null[false]>:
        - define current_linear_arg <[linear_args].to_pair_lists.last>

    - define current_value <context.args.last.if_null[]>

    - if <[current_linear_arg].exists>:
        - define will_complete_with <[current_linear_arg].get[2].get[tab completes].parsed.if_null[<[current_linear_arg].get[1].proc[command_manager_generate_singular_usage_proc].context[<[current_linear_arg].get[2]>].strip_color>].as[list]>
        - define usage <[current_linear_arg].get[1].proc[command_manager_generate_singular_usage_proc].context[<[current_linear_arg].get[2]>].strip_color>
        - if <[flag_args.linear_args].exists>:
            - define value <[flag_args.linear_args].get[<[current_arg]>].if_null[]>
            - if <[current_linear_arg].get[2].keys> contains "tab completes" && <[current_linear_arg].get[2].get[tab completes].parsed.as[list].filter[starts_with[<[value].before[<[sep]>]>]].any>:
                - define completions:|:<[current_linear_arg].get[2].get[tab completes].parsed>
            - else if <[current_linear_arg].get[2].get[accepted].parsed.if_null[true]>:
                - define completions:|:<[usage]>
            # Make sure that the user isn't trying to input a prefixed arg
            - else if <context.args.get[<[current_arg]>].exists> && !<context.args.get[<[current_arg]>].if_null[null].starts_with[-]>:
                - definemap err_completion:
                    expected: <[usage]>
                    actual: <[value]>
                    possible_values: <[will_complete_with].exclude[<[usage]>]>
                - if <[current_linear_arg].get[2].keys> contains explanation:
                    - define err_completion.explanation <[current_linear_arg].get[2].get[explanation]>
            - else:
                - define completions:<[will_complete_with]>
        - else if <[current_linear_arg].get[2].keys.contains[tab completes]>:
            - define completions:<[will_complete_with]>

    - define prefixed_args <[args].filter_tag[<[filter_value.type].equals[prefixed].if_null[false]>]>
    - define prefixed <[prefixed_args].filter_tag[<context.raw_args.ends_with[ ].if_true[<[flag_args.prefixed_args].if_null[<map>]>].if_false[<[flag_args.prefixed_args].if_null[<map>].exclude[<context.args.last.after[-].before[<[sep]>].if_null[]>]>].contains[<[filter_key]>].not>]>
    - foreach <[prefixed]> key:argname as:map:
        - define prefix -<[argname]><[sep]>
        - define will_complete_with <[map.tab completes].parsed.as[list].parse_tag[<[prefix]><[parse_value]>].if_null[<[prefix]>].as[list]>
        - if <[map].keys> contains permissions:
            - if <[map.permissions].filter_tag[<player.has_permission[<[filter_value]>].not>].any>:
                - foreach next
        - if <context.args.last.starts_with[<[prefix]>].if_null[false]>:
            - if <[flag_args.prefixed_args].exists>:
                - if <[flag_args.prefixed_args].contains[<[argname]>]>:
                    - define value <[flag_args.prefixed_args.<[argname]>].if_null[]>
                    - if <[will_complete_with].filter[starts_with[<[prefix]><[value]>]].any>:
                        - define completions:|:<[will_complete_with]>
                    - else if <[map.accepted].parsed.if_null[true]>:
                        - define completions:|:<[argname].proc[command_manager_generate_singular_usage_proc].context[<[map]>].strip_color>
                    - else:
                        - definemap err_completion:
                            expected: <[argname].proc[command_manager_generate_singular_usage_proc].context[<[map]>].strip_color>
                            actual: <[prefix]><[value]>
                            possible_values: <[will_complete_with].exclude[<[prefix]>]>
                        - if <[map].keys> contains explanation:
                            - define err_completion.explanation <[map.explanation]>
            - else:
                - define completions:|:<[will_complete_with]>
        - else if <context.args.last.if_null[null]> == -<[argname]>:
            - define completions:|:<[prefix]>
        - else:
            - define completions:|:<[map.boolean style tab complete].if_null[false].if_true[-<[argname]>].if_false[<[prefix]>]>

    # Process errors
    - if <[err_completion].exists>:
        - define error_message "<&[error]>Invalid <&[base]><[err_completion.expected]> <&[error]>value!"
        - if <[err_completions.explanation].exists>:
            - define erro_message "<[error_message]> <&[error]>Expected: <white><[err_completion]>"
        - if <[err_completion.possible_values].any>:
            - define closest <[err_completion.possible_values].closest_to[<[err_completion.actual]>]>
            - if <[closest].to_lowercase.difference[<[err_completion.actual].to_lowercase>]> <= 3 && <[closest]> != <empty>:
                - define error_message "<[error_message]> <&[error]>Close match: <white><[closest]>"
        - define unfiltered_completions:|:<[error_message]>

    # Filter the completions
    - if !<context.raw_args.ends_with[ ]> && <context.args.size> > 0:
        - determine <[completions].filter[starts_with[<context.args.last.before[<[sep]>]>]].include[<[unfiltered_completions]>]>
    - determine <[completions].include[<[unfiltered_completions]>]>

    - mark fatal_error
    - determine <[tickutil_commands.args_manager.error_messages].if_null[<list>]>
    args_manager:
    - define sep <script[command_manager_data].parsed_key[formatting.lang.prefixed_value_separator]>
    - define arg <map>
    - inject command_manager.flag_args
    - inject command_manager.generate_arg_maps
    - define tickutil_commands.args_manager.linear_args <[args].filter_tag[<[filter_value.type].equals[linear].if_null[true]>]>

    - define tickutil_commands.args_manager.error_messages <list>

    - if <[subcommands_enabled]> && <[subcommand]> == null:
        - define "tickutil_commands.args_manager.error_messages:|:No subcommand was specified!"
        - define tickutil_commands.args_manager.panic true
        - goto fatal_error

    - foreach <[flag_args.linear_args].if_null[<list>]> as:value:
        - define tickutil_commands.args_manager.linear <[tickutil_commands.args_manager.linear_args].values.get[<[loop_index]>].if_null[null]>
        - if <[tickutil_commands.args_manager.linear]> == null:
            - define "tickutil_commands.args_manager.error_messages:|:'<[value].custom_color[emphasis]>' could not be parsed as a valid argument."
            - foreach next
        - if <[tickutil_commands.args_manager.linear_args].values.get[<[loop_index]>].get[spread].if_null[false]>:
            - define value <[flag_args.linear_args].get[<[loop_index]>].to[last].separated_by[ ]>
        - if <[tickutil_commands.args_manager.linear.accepted].parsed.if_null[true]>:
            - define arg.<[tickutil_commands.args_manager.linear_args].keys.get[<[loop_index]>]> <[value]>
        - else:
            # Generate a suggestion "(Did you mean '...'?)"
            - define tickutil_commands.args_manager.suggestion <[tickutil_commands.args_manager.linear.suggestions].if_null[<[tickutil_commands.args_manager.linear.tab completes]>].parsed.as[list].closest_to[<[value]>]>
            - if <[tickutil_commands.args_manager.suggestion].to_lowercase.difference[<[value].to_lowercase>]> <= 3 && <[tickutil_commands.args_manager.suggestion]> != <empty>:
                - define tickutil_commands.args_manager.suggestion_message " <&[base]>(Did you mean '<[tickutil_commands.args_manager.suggestion].custom_color[emphasis]>'?)"

            - define "tickutil_commands.args_manager.error_messages:|:'<[value].custom_color[emphasis]>' is not a valid value for the <[tickutil_commands.args_manager.linear.required].parsed.if_null[false].if_true[required ].if_false[].custom_color[emphasis]>arg '<[tickutil_commands.args_manager.linear_args].keys.get[<[loop_index]>].proc[command_manager_generate_singular_usage_proc].context[<[tickutil_commands.args_manager.linear_args].values.get[<[loop_index]>]>].custom_color[emphasis]>'!<[tickutil_commands.args_manager.suggestion_message].if_null[]>"
            - if <[tickutil_commands.args_manager.linear.required].parsed.if_null[false]>:
                - define tickutil_commands.args_manager.panic true
                - if <script[command_manager_data].parsed_key[instantly terminate command execution on fatal error]>:
                    - goto fatal_error
            - foreach next
        - if <[tickutil_commands.args_manager.linear_args].values.get[<[loop_index]>].get[spread].if_null[false]>:
            - foreach stop
    - define tickutil_commands.args_manager.prefixed_args <[args].filter_tag[<[filter_value.type].equals[prefixed].if_null[false]>]>

    # Check if prefixed args are valid, and if so, add them to the arg map
    - foreach <[tickutil_commands.args_manager.prefixed_args]> key:argname as:map:
        - foreach <[flag_args.prefixed_args].if_null[<map>]> key:flag as:value:
            - if <[flag]> == <[argname]>:
                - if <[map.accepted].parsed.if_null[true]>:
                    - define arg.<[argname]> <[value]>
                    - define flag_args.prefixed_args <[flag_args.prefixed_args].exclude[<[argname]>]>
                - else:
                    - if <[map].keys.contains_any[suggestions|tab completes]>:
                        - define tickutil_commands.args_manager.suggestion <[map.suggestions].if_null[<[map.tab completes]>].parsed.as[list].closest_to[<[value]>]>
                        - if <[tickutil_commands.args_manager.suggestion].difference[<[value]>]> <= 3 && <[tickutil_commands.args_manager.suggestion]> != <empty>:
                            - define tickutil_commands.args_manager.suggestion_message " <&[base]>(Did you mean '<[tickutil_commands.args_manager.suggestion].custom_color[emphasis]>'?)"
                    - define "tickutil_commands.args_manager.error_messages:->:Invalid prefixed argument '<element[-<[argname]><[sep]><[value]>].custom_color[emphasis]>' for arg '<[argname].proc[command_manager_generate_singular_usage_proc].context[<[map]>].custom_color[emphasis]>'!<[map.explanation].exists.if_true[ Expected: '<[map.explanation].parsed.custom_color[emphasis]>'].if_false[]><[tickutil_commands.args_manager.suggestion_message].if_null[]>"

    # Check for unknown prefixed args
    - foreach <[flag_args.prefixed_args].if_null[<map>]> key:argname as:val:
        - if <[tickutil_commands.args_manager.prefixed_args].keys> contains <[argname]>:
            - foreach next
        - define tickutil_commands.args_manager.suggestion <[tickutil_commands.args_manager.prefixed_args].keys.closest_to[<[argname]>]>
        - if <[tickutil_commands.args_manager.suggestion].difference[<[argname]>]> <= 3 && <[tickutil_commands.args_manager.suggestion]> != <empty>:
            - define tickutil_commands.args_manager.suggestion_message " <&[base]>(Did you mean '<[tickutil_commands.args_manager.suggestion].proc[command_manager_generate_singular_usage_proc].context[<[tickutil_commands.args_manager.prefixed_args.<[tickutil_commands.args_manager.suggestion]>]>].custom_color[emphasis]>'?)"
        - define "tickutil_commands.args_manager.error_messages:->:Unknown prefixed argument '<element[-<[argname]>].custom_color[emphasis]>'!<[tickutil_commands.args_manager.suggestion_message].if_null[]>"

    # Transform the args based on the result
    # @example
    # some_arg:
    #    result: <[value].before[:]>
    # @/example
    # This will transform the value of the arg 'some_arg' to the value before the first ':'
    - foreach <[arg]> key:argname as:map:
        - define value <[arg.<[argname]>]>
        - define arg.<[argname]> <[args.<[argname]>.result].parsed.if_null[<[value]>]>

    # Check for permissions
    - if <player.exists>:
        - foreach <[args]> key:argname as:map:
            - if <[map].keys> !contains permissions:
                - foreach next
            - if <[arg].keys> !contains <[argname]>:
                - foreach next
            - if <[map.permissions].parsed.as[list].filter_tag[<player.has_permission[<[filter_value]>].not>].any>:
                - define "tickutil_commands.args_manager.error_messages:->:You do not have permission to use the argument '<[argname].proc[command_manager_generate_singular_usage_proc].context[<[map]>].custom_color[emphasis]>'!"
                - define arg.<[argname]>:!

    # If the arg is required, but not present, throw an error. Otherwise, set the arg to the default value.
    - foreach <[args]> key:argname as:map:
        - if <[arg].keys> contains <[argname]>:
            - foreach next
        - if <[map.required].parsed.if_null[false]>:
            - define "tickutil_commands.args_manager.error_messages:->:Missing required <[map.type].if_null[null].equals[prefixed].if_true[prefixed ].if_false[]>argument '<[argname].proc[command_manager_generate_singular_usage_proc].context[<[map]>].custom_color[emphasis]>'!"
            - define tickutil_commands.args_manager.panic true
            - if <script[command_manager_data].parsed_key[instantly terminate command execution on fatal error]>:
                - goto fatal_error
            - goto fatal_error
            - foreach next
        - if <[map.default].exists>:
            - define arg.<[argname]> <[map.default].parsed>

    - mark fatal_error
    - if !<[tickutil_commands.args_manager.error_messages].is_empty>:
        - narrate "<script[command_manager_data].parsed_key[formatting.lang.hline]><n><&[error]>There <[tickutil_commands.args_manager.error_messages].size.is_more_than[1].if_true[were].if_false[was]> <[tickutil_commands.args_manager.error_messages].size.color[white]> error message<[tickutil_commands.args_manager.error_messages].size.is_more_than[1].if_true[s].if_false[]> when parsing the arguments for command <white>/<context.alias><&[error]>!<n.repeat[2]><[tickutil_commands.args_manager.error_messages].parse_tag[<white><[parse_value]>].separated_by[<n.repeat[2]>].color[white]><n.repeat[2]><white>Usage: <&[base]><queue.script.proc[command_manager_generate_usage]><n><white>Attempted: <&[base]>/<context.alias> <context.raw_args><n.repeat[2]><[tickutil_commands.args_manager.panic].if_null[false].if_true[<&[warning]>Was fatal! Aborting command execution!].if_false[<&[warning]>Was not fatal, continuing execution...]><n><script[command_manager_data].parsed_key[formatting.lang.hline]>"
        - if <[tickutil_commands.args_manager.panic].if_null[false]>:
            - stop

    - define tickutil_commands.args_manager:!

