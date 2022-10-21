tick_world_manager_command:
    type: command
    name: tickworld
    description: The main command for Tick's World Manager.
    debug: false
    usage: /tickworld [teleport [world] (player)/create [name] [type] (--generator:<&lt>generator<&gt>) (--seed:<&lt>seed<&gt>) (--settings:<&lt>additional generator settings in JSON<&gt>)]
    data:
        required_args: 1
        tab_complete:
            2:
                teleport: <server.worlds.parse[name]>
    tab completions:
        1: teleport|create
        2: <script.parsed_key[data.tab_complete.2.<context.args.get[1]>].if_null[]>
    script:
    - inject command_manager path:args_manager
    - choose <context.args.get[1]>:
        - case teleport:
            - define require_worlds 2
            - inject command_manager path:require_world
            - define require_players 3
            - inject command_manager path:require_player
            - teleport <player> <[world].spawn_location>
            - narrate "<&[success]>Teleported '<player.name>' to '<[world].name>'!"
        #- case create:
        #    - createworld 