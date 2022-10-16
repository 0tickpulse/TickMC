command_manager:
    type: task
    debug: false
    script:
    - debug error "Please specify a path to inject."
    args_manager:
    - define required_args <queue.script.data_key[data.required_args].if_null[null]>
    - define max_args <queue.script.data_key[data.max_args].if_null[null]>
    - if <[required_args]> != null:
        - if <context.args.size> < <[required_args]>:
            - narrate "<&[error]>Not enough args! <queue.script.data_key[usage]>"
            - stop
    - if <[max_args]> != null:
        - if <context.args.size> > <[max_args]>:
            - narrate "<&[error]>Too many args! <queue.script.data_key[usage]>"
    require_player:
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
                    - narrate "<&[error]>A player name is required, but got <[player_name]>."
                    - stop
            - adjust <queue> linked_player:<[player]>

gamemode_shortcut:
    type: command
    name: gm
    debug: false
    description: A shortcut command to change your gamemode.
    tab completions:
        1: <script.parsed_key[data.gamemode_aliases].to_pair_lists.parse[combine].combine>
    usage: /gm [gamemode] (player)
    data:
        required_args: 1
        max_args: 2
        require_player:
        - 2
        gamemode_aliases:
            survival:
            - 0
            - s
            creative:
            - 1
            - c
            adventure:
            - 2
            - a
            spectator:
            - 3
            - sp
    script:
    - inject command_manager path:args_manager
    - if <context.args.size> == 0:
        - narrate <&[error]><script.data_key[usage]>
        - stop
    - foreach <script.parsed_key[data.gamemode_aliases]> key:gamemode as:aliases:
        - if <context.args.get[1]> in <[aliases].include[<[gamemode]>]>:
            - define to_set <[gamemode]>
    - if !<[to_set].exists>:
        - narrate "<&[error]>Invalid gamemode!"
        - stop
    - inject command_manager path:require_player

heal_command:
    type: command
    name: heal
    debug: false
    description: A shortcut command to heal.
    tab completions:
        1: <server.online_players.parse[name]>
    usage: /heal (player)
    data:
        require_player:
        - 1
    script:
    - inject command_manager path:require_player
    - heal <player>
    - narrate <&[success]>Healed!