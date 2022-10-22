command_error_registry:
    type: data
command_manager:
    type: task
    debug: false
    script:
    - debug error "Please specify a path to inject."
    - stop
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
        - if !<[arg].starts_with[--]>:
            - define flag_args.linear_args:->:<[arg]>
            - foreach next
        - define flag_args.prefixed_args.<[arg].before_last[:].after[--]> <[arg].contains_text[:].if_true[<[arg].after_last[:]>].if_false[true]>
    player_only:
    - if <queue.script.data_key[data.player_only].if_null[false]> && !<player.exists>:
        - narrate "<&[error]>This command is player-only!"
        - stop
    args_manager:
    - if <queue.definitions> !contains required_args:
        - define required_args <queue.script.data_key[data.required_args].if_null[null]>
    - if <queue.definitions> !contains max_args:
        - define max_args <queue.script.data_key[data.max_args].if_null[null]>
    - if <[required_args]> != null:
        - if <context.args.size> < <[required_args]>:
            - narrate "<&[error]>Not enough args! <queue.script.parsed_key[usage]>"
            - stop
    - if <[max_args]> != null:
        - if <context.args.size> > <[max_args]>:
            - narrate "<&[error]>Too many args! <queue.script.parsed_key[usage]>"
            - stop
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