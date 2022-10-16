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
            - stop
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
                    - narrate "<&[error]>Invalid player name: <[player_name]>."
                    - stop
            - adjust <queue> linked_player:<[player]>
    require_world:
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
# @ Time commands
time_shortcut:
    type: command
    name: time
    debug: false
    description: A shortcut command to change the time.
    tab completions:
        1: s
    usage: /time [time] (world)
    data:
        required_args: 1
        max_args: 2
        require_world:
        - 2
    script:
    - inject command_manager path:require_world
    - adjust <[world]> time:<context.args.get[1].sub[<[world].time>]>

# @ Gamemode commands
gamemode_shortcut:
    type: command
    name: gm
    debug: false
    description: A shortcut command to change your gamemode.
    tab completions:
        1: <script.parsed_key[data.gamemode_aliases].to_pair_lists.parse[combine].combine>
        2: <server.online_players.parse[name]>
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
    - adjust <player> gamemode:<[to_set]>
    - narrate "<&[success]>Set your gamemode to <[to_set]>!"

gmc_command:
    type: command
    name: gmc
    debug: false
    description: A shortcut command to change your gamemode to creative.
    tab completions:
        1: <server.online_players.parse[name]>
    usage: /gmc (player)
    data:
        require_player:
        - 1
    script:
    - inject command_manager path:require_player
    - adjust <player> gamemode:creative
    - narrate "<&[success]>Set your gamemode to creative!"
gms_command:
    type: command
    name: gms
    debug: false
    description: A shortcut command to change your gamemode to survival.
    tab completions:
        1: <server.online_players.parse[name]>
    usage: /gms (player)
    data:
        require_player:
        - 1
    script:
    - inject command_manager path:require_player
    - adjust <player> gamemode:survival
    - narrate "<&[success]>Set your gamemode to survival!"
gma_command:
    type: command
    name: gma
    debug: false
    description: A shortcut command to change your gamemode to adventure.
    tab completions:
        1: <server.online_players.parse[name]>
    usage: /gma (player)
    data:
        require_player:
        - 1
    script:
    - inject command_manager path:require_player
    - adjust <player> gamemode:adventure
    - narrate "<&[success]>Set your gamemode to adventure!"
gmsp_command:
    type: command
    name: gmsp
    debug: false
    description: A shortcut command to change your gamemode to spectator.
    tab completions:
        1: <server.online_players.parse[name]>
    usage: /gmsp (player)
    data:
        require_player:
        - 1
    script:
    - inject command_manager path:require_player
    - adjust <player> gamemode:spectator
    - narrate "<&[success]>Set your gamemode to spectator!"

# @ Heal/feed commands
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
    - feed <player>
    - narrate <&[success]>Healed!
feed_command:
    type: command
    name: feed
    debug: false
    description: A shortcut command to feed.
    tab completions:
        1: <server.online_players.parse[name]>
    usage: /feed (player)
    data:
        require_player:
        - 1
    script:
    - inject command_manager path:require_player
    - feed <player>
    - narrate <&[success]>Fed!