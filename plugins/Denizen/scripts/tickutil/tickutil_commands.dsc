# @ ----------------------------------------------------------
# TickUtil Commands
# Adds many utility scripts that make command scripts much
# easier.
# Author: 0TickPulse
# @ ----------------------------------------------------------

command_error_registry:
    type: data
command_manager_data:
    type: data
    arg templates:
        duration:
            type: linear
            required: true
            accepted: <[value].as[duration].exists>
            explanation: Any duration. Can use y for years, w for weeks, d for days, h for hours, m for minutes, s for seconds, and t for ticks.
            result: <[value].as[duration]>
        world_default_player:
            type: linear
            required: <player.exists.not>
            accepted: <server.worlds.parse[name].contains[<[value]>]>
            explanation: The name of any loaded world. Defaults to the player's world.
            tab completes: <server.worlds.parse[name]>
            default: <player.world>
            result: <[value].as[world]>
        world:
            type: linear
            required: true
            accepted: <server.worlds.parse[name].contains[<[value]>]>
            tab completes: <server.worlds.parse[name]>
            result: <[value].as[world]>
            explanation: The name of any loaded world.
        player_strict:
            type: linear
            required: true
            accepted: <server.online_players.parse[name].contains[<[value]>]>
            tab completes: <server.online_players.parse[name]>
            result: <server.match_player[<[value]>]>
            explanation: The name of any online player.
        player:
            type: linear
            required: <player.exists.not>
            accepted: <server.online_players.parse[name].contains[<[value]>]>
            tab completes: <server.online_players.parse[name]>
            explanation: The name of any online player.
            default: <player>
            result: <server.match_player[<[value]>]>
        player_include_offline_strict:
            type: linear
            required: true
            accepted: <server.players.parse[name].contains[<[value]>]>
            tab completes: <server.players.parse[name]>
            explanation: The name of any player, can be online or offline.
            result: <server.match_offline_player[<[value]>]>
        player_include_offline:
            type: linear
            required: <player.exists.not>
            accepted: <server.players.parse[name].contains[<[value]>]>
            tab completes: <server.players.parse[name]>
            explanation: The name of any player, can be online or offline.
            default: <player>
            result: <server.match_offline_player[<[value]>]>
        silent:
            name: s
            type: prefixed
            required: false
            default: false
            accepted: <[value].is_boolean>
            usage text: true/<&lc>false<&rc>
            explanation: A boolean (true/false).
            boolean style tab complete: true
        boolean_null:
            type: prefixed
            required: false
            default: null
            accepted: <[value].is_boolean>
            usage text: true/false
            tab completes: true|false
            result: <[value].as_boolean>
            explanation: A boolean (true/false).
            boolean style tab complete: true
        boolean_default_true:
            type: prefixed
            required: false
            default: true
            accepted: <[value].is_boolean>
            usage text: <&lc>true<&rc>/false
            boolean style tab complete: true
            result: <[value].as_boolean>
            explanation: A boolean (true/false).
        boolean_default_false:
            type: prefixed
            required: false
            default: false
            accepted: <[value].is_boolean>
            usage text: true/<&lc>false<&rc>
            boolean style tab complete: true
            result: <[value].as_boolean>
            explanation: A boolean (true/false).
        any_value:
            type: prefixed
            accepted: true
command_manager_generate_usage:
    type: procedure
    debug: false
    definitions: script
    script:
    - define output /<[script].data_key[name]>
    - inject command_manager.generate_args
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

command_manager_generate_singular_usage_proc:
    type: procedure
    debug: false
    definitions: name|arg
    script:
    - define output <empty>

    # Left brace
    - if <[arg.required].parsed.if_null[false]>:
        - define output <[output]><&lb>
    - else:
        - define output <[output]>(

    - if <[arg.type].if_null[null]> == linear:
        - define output <[output]><[arg.usage text].parsed.if_null[<&lt><[name]><&gt>]>
    - else:
        - define output <[output]>-<[name]>:<[arg.usage text].parsed.if_null[<&lt><[name]><&gt>]>

    # Right brace
    - if <[arg.required].parsed.if_null[false]>:
        - define output <[output]><&rb>
    - else:
        - define output <[output]>)

    - determine <[output]>
command_manager:
    type: task
    debug: false
    script:
    - debug error "Please specify a path to inject."
    - stop
    formatted_help_same_file:
    - narrate <util.scripts.filter[filename.equals[<queue.script.filename>]].filter_tag[<[filter_value].parsed_key[enabled].if_null[true]>].filter[container_type.equals[command]].parse_tag[<&[emphasis]>/<[parse_value].data_key[name].on_click[/help <[parse_value].data_key[name]>].on_hover[<&[emphasis]>Click to get detailed info!]> <dark_gray>- <[parse_value].data_key[description].color[gray]>].separated_by[<n>]>
    # @Deprecated use the new tab_complete_engine instead
    tab_complete_helper:
    - define tab_completers <queue.script.data_key[data.tab_complete]>
    - define current_arg <context.args.size.max[1]>
    - if <context.args.size> >= 1 && <context.raw_args.ends_with[ ]>:
            - define current_arg:++

    - define tab_completions <list>
    - foreach <[tab_completers]> key:index as:arg_matchers:
        - if <[index]> contains <[current_arg]>:
            - foreach <[arg_matchers].parse[as[map]]> as:arg_matcher:
                - if <[arg_matcher.matcher].parsed>:
                    - foreach <[arg_matcher.values].parsed> as:value:
                        - define tab_completions:->:<[value]>
    - if <[tab_completers].keys> contains global:
        - foreach <[tab_completers.global].parse[as[map]]> as:arg_matcher:
            - if <[arg_matcher.matcher].parsed>:
                - foreach <[arg_matcher.values].parsed> as:value:
                    - define tab_completions:->:<[value]>

    - determine <[tab_completions]>
    flag_args:
    - define flag_args <map>
    - foreach <context.args> as:arg:
        - if !<[arg].starts_with[-]>:
            - define flag_args.linear_args:->:<[arg]>
            - foreach next
        - define flag_args.prefixed_args.<[arg].after[-]> <[arg].contains_text[:].if_true[<[arg].after_last[:]>].if_false[true]>
    generate_args:
    - if !<[script].exists>:
        - define script <queue.script>
    - if !<queue.definitions.contains[args]>:
        - define args <[script].data_key[data.args].if_null[null]>
        - if <[args]> == null:
            - stop
        - define args <[args].parse_value_tag[<[parse_key].proc[command_generator_arg_map_proc].context[<[parse_value].as[map]>]>].values.merge_maps>
    tab_complete_engine:
    - inject command_manager.generate_args
    - inject command_manager.flag_args

    - define current_arg <[flag_args.linear_args].if_null[<list>].size.max[1]>
    - if <[flag_args.linear_args].if_null[<list>].size> >= 1 && <context.raw_args.ends_with[ ]>:
        - define current_arg:++

    - define linear_args <[args].filter_tag[<[filter_value.type].equals[linear].if_null[true]>]>
    - define completions:|:<[linear_args].values.get[<[current_arg]>].get[tab completes].if_null[<empty>].parsed>

    - define prefixed_args <[args].filter_tag[<[filter_value.type].equals[prefixed].if_null[false]>]>
    - define prefixed <[prefixed_args].filter_tag[<context.raw_args.ends_with[ ].if_true[<[flag_args.prefixed_args].if_null[<map>]>].if_false[<[flag_args.prefixed_args].if_null[<map>].exclude[<context.args.last.after[-].before[:].if_null[]>]>].contains[<[filter_key]>].not>]>
    - foreach <[prefixed]> key:argname as:map:
        - if <context.args.last.ends_with[-<[argname]>:].if_null[false]>:
            - if <[map.tab completes].exists>:
                - define completions:|:<[map.tab completes].parsed.as[list].parse_tag[-<[argname]>:<[parse_value]>].if_null[-<[argname]>:]>
            - else:
                - define completions:|:<[map.boolean style tab complete].if_null[false].if_true[-<[argname]>].if_false[-<[argname]>:]>
        - else if <context.args.last.starts_with[-<[argname]>:].if_null[false]>:
            - define completions:|:<[map.tab completes].parsed.as[list].parse_tag[-<[argname]>:<[parse_value]>].if_null[-<[argname]>:]>
        - else:
            - define completions:|:<[map.boolean style tab complete].if_null[false].if_true[-<[argname]>].if_false[-<[argname]>:]>

    # Filter the completions
    - if !<context.raw_args.ends_with[ ]> && <context.args.size> > 0:
        - determine <[completions].filter[starts_with[<context.args.last.before[:]>]]>
    - determine <[completions]>
    args_manager:
    - define arg <map>
    - inject command_manager.flag_args
    - inject command_manager.generate_args
    - define linear_args <[args].filter_tag[<[filter_value.type].equals[linear].if_null[true]>]>

    - foreach <[flag_args.linear_args].if_null[<list>]> as:value:
        - define linear <[linear_args].values.get[<[loop_index]>].if_null[null]>
        - if <[linear]> == null:
            - foreach next
        - if <[linear.accepted].parsed.if_null[true]>:
            - define arg.<[linear_args].keys.get[<[loop_index]>]> <[value]>
    - define prefixed_args <[args].filter_tag[<[filter_value.type].equals[prefixed].if_null[false]>]>

    # Parse the linear args. Checks if they are valid.
    - foreach <[flag_args.linear_args].if_null[<list>]> as:excluded:
        - if <[arg].values> contains <[excluded]>:
            - foreach next
        - if <[prefixed_args]> contains <[excluded]>:
            - define flag_args.prefixed_args.<[excluded]> true
        - else if <[linear_args].keys.size> >= <[loop_index]>:
            - narrate "<&[warning]>Unknown argument '<[excluded].custom_color[emphasis]>'! <[linear_args].keys.size.is_more_than_or_equal_to[<[loop_index]>].if_true[(Here, expected input for '<[linear_args].keys.get[<[loop_index]>].proc[command_manager_generate_singular_usage_proc].context[<[linear_args].values.get[<[loop_index]>]>].custom_color[emphasis]>' is: '<[linear_args].values.get[<[loop_index]>].get[explanation].if_null[<[linear_args].keys.get[<[loop_index]>]>].custom_color[emphasis]>')].if_false[]> Did you make a typo, or misread the usage text?"
        - else:
            - narrate "<&[error]>The argument '<[excluded]>' could not be recognized!<n><&[base]>Usage: <queue.script.proc[command_manager_generate_usage]>"

    # Check if prefixed args are valid, and if so, add them to the arg map
    - foreach <[prefixed_args]> key:argname as:map:
        - foreach <[flag_args.prefixed_args].if_null[<map>]> key:flag as:value:
            - if <[flag]> == <[argname]>:
                - if <[map.accepted].parsed.if_null[true]>:
                    - define arg.<[argname]> <[value]>
                    - define flag_args.prefixed_args <[flag_args.prefixed_args].exclude[<[argname]>]>
                - else:
                    - narrate "<&[error]>The prefixed argument '<[argname].custom_color[emphasis]>' is invalid for '<[argname].proc[command_manager_generate_singular_usage_proc].context[<[map]>]>'!<[map.explanation].exists.if_true[ This arg requires: '<[map.explanation].custom_color[emphasis]>'].if_false[]>"

    # Check for unknown prefixed args
    - foreach <[flag_args.prefixed_args].if_null[<map>]> key:argname as:val:
        - if <[prefixed_args].keys> contains <[argname]>:
            - foreach next
        - narrate "<&[warning]>Unknown prefixed argument '<[argname].custom_color[emphasis]>'! Did you make a typo, or misread the usage text?"

    # Transform the args based on the result
    # @example
    # some_arg:
    #    result: <[value].before[:]>
    # @/example
    # This will transform the value of the arg 'some_arg' to the value before the first ':'
    - foreach <[arg]> key:argname as:map:
        - define value <[arg.<[argname]>]>
        - define arg.<[argname]> <[args.<[argname]>.result].parsed.if_null[<[value]>]>

    # If the arg is required, but not present, throw an error. Otherwise, set the arg to the default value.
    - foreach <[args]> key:argname as:map:
        - if <[arg].keys> !contains <[argname]>:
            - if <[map.required].parsed.if_null[false]>:
                - narrate "<&[error]>Missing required <[map.type].if_null[null].equals[prefixed].if_true[prefixed ].if_false[]>argument '<[argname].proc[command_manager_generate_singular_usage_proc].context[<[map]>]>'!<n><&[base]>Usage: <queue.script.proc[command_manager_generate_usage]>"
                - stop
            - if <[map.default].exists>:
                - define arg.<[argname]> <[map.default].parsed>
    # @Deprecated use the new arg manager instead
    require_player:
    - if <player.exists>:
        - define command_runner <player>
    - if <queue.definitions> !contains require_players:
        - define require_players <queue.script.data_key[data.require_player].if_null[null]>
    - foreach <[require_players]> as:require_player:
        - if <[require_player]> != null:
            - if !<context.args.get[<[require_player]>].exists>:
                - if !<player.exists>:
                    - narrate "<&[error]>A player is required! <queue.script.data_key[usage]>"
                    - stop
                - define player <player>
            - else:
                - define player_name <context.args.get[<[require_player]>].if_null[null]>
                - define player <server.match_player[<[player_name]>].if_null[null]>
                - if <[player]> == null:
                    - narrate "<&[error]>Invalid player name: <[player_name]>."
                    - stop
            - adjust <queue> linked_player:<[player]>
    # @Deprecated use the new arg manager instead
    require_world:
    - if !<queue.definitions> !contains require_worlds:
        - define require_worlds <queue.script.data_key[data.require_world].if_null[null]>
    - foreach <[require_worlds]> as:require_world:
        - if <[require_world]> != null:
            - if !<context.args.get[<[require_world]>].exists>:
                - if !<player.exists>:
                    - narrate "<&[error]>A world is required! <queue.script.data_key[usage]>"
                    - stop
                - define world <player.location.world>
            - else:
                - define world_name <context.args.get[<[require_world]>].if_null[null]>
                - define world <world[<[world_name]>].if_null[null]>
                - if <[world]> == null:
                    - narrate "<&[error]>Invalid world name: <[world_name]>."
                    - stop