
tick_essentials_data:
    type: data
    # Logs player teleports for the /back command.
    log teleports: true


back_command:
    type: command
    debug: false
    name: back
    description: Go to your previous location (before teleporting).
    enabled: <script[tick_essentials_data].data_key[log teleports].if_null[false]>
    usage: /back (player)
    permission: tick_essentials.command.back
    data:
        require_player: 1
    script:
    - inject command_manager path:require_player
    - define location <player.flag[tick_essentials.back_location].if_null[null]>
    - if <[location]> == null:
        - narrate "<&[error]>The player '<player.name>' does not have a previous location logged!"
        - stop
    - if <[command_runner]> != null:
        - if <[command_runner]> != <player> && !<[command_runner].has_permission[tick_essentials.command.back.other]>:
            - narrate "<&[error]>You do not have permission to do this to other players!" targets:<[command_runner]>
            - stop
    - teleport <player> <[location]>
    - narrate "<&[success]>Teleported '<player.name>' to their previous location!"
back_command_logger_world:
    type: world
    debug: false
    enabled: <script[tick_essentials_data].data_key[log teleports].if_null[false]>
    events:
        on player teleports:
        - flag <player> tick_essentials.back_location:<player.location>

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
    permission: tick_essentials.command.time
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
    permission: tick_essentials.command.gm
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
    - if <[command_runner].exists>:
        - if !<[command_runner].has_permission[tick_essentials.command.gm.<[to_set]>]>:
            - narrate "<&[error]>You do not have permission to use this gamemode!" targets:<[command_runner]>
            - stop
        - if <[command_runner]> != <player> && !<[command_runner].has_permission[tick_essentials.command.gm.other]>:
            - narrate "<&[error]>You do not have permission to do this to other players!" targets:<[command_runner]>
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
    permission: tick_essentials.command.gm.creative
    script:
    - inject command_manager path:require_player
    - if <[command_runner].exists>:
        - if <[command_runner]> != <player> && !<[command_runner].has_permission[tick_essentials.command.gm.other]>:
            - narrate "<&[error]>You do not have permission to do this to other players!" targets:<[command_runner]>
            - stop
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
    permission: tick_essentials.command.gm.survival
    script:
    - inject command_manager path:require_player
    - if <[command_runner].exists>:
        - if <[command_runner]> != <player> && !<[command_runner].has_permission[tick_essentials.command.gm.other]>:
            - narrate "<&[error]>You do not have permission to do this to other players!" targets:<[command_runner]>
            - stop
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
    permission: tick_essentials.command.gm.adventure
    script:
    - inject command_manager path:require_player
    - if <[command_runner].exists>:
        - if <[command_runner]> != <player> && !<[command_runner].has_permission[tick_essentials.command.gm.other]>:
            - narrate "<&[error]>You do not have permission to do this to other players!" targets:<[command_runner]>
            - stop
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
    permission: tick_essentials.command.gm.spectator
    script:
    - inject command_manager path:require_player
    - if <[command_runner].exists>:
        - if <[command_runner]> != <player> && !<[command_runner].has_permission[tick_essentials.command.gm.other]>:
            - narrate "<&[error]>You do not have permission to do this to other players!" targets:<[command_runner]>
            - stop
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
    permission: tick_essentials.command.heal
    script:
    - inject command_manager path:require_player
    - if <[command_runner].exists>:
        - if <[command_runner]> != <player> && !<[command_runner].has_permission[tick_essentials.command.heal.other]>:
            - narrate "<&[error]>You do not have permission to do this to other players!" targets:<[command_runner]>
            - stop
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
    permission: tick_essentials.command.feed
    script:
    - inject command_manager path:require_player
    - if <[command_runner].exists>:
        - if <[command_runner]> != <player> && !<[command_runner].has_permission[tick_essentials.command.feed.other]>:
            - narrate "<&[error]>You do not have permission to do this to other players!" targets:<[command_runner]>
            - stop
    - feed <player>
    - narrate <&[success]>Fed!