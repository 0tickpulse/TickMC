
# @ Time commands
time_shortcut:
    type: command
    name: time
    debug: false
    description: A shortcut command to change the time.
    tab completions:
        1: 1t|5s|50s|5m|10m
        2: <server.worlds.parse[name]>
    usage: /time [time] (world)
    data:
        required_args: 1
        max_args: 2
        require_world:
        - 2
    script:
    - inject command_manager path:require_world
    - define time <context.args.get[1].as[duration].if_null[null]>
    - if <[time]> == null:
        - narrate "<&[error]>Invalid time specified!"
        - stop
    - time <[time]> <[world]>
    - narrate "<&[success]>Changed the time to <[time].formatted> in <[world].name>!"

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