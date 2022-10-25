

tick_world_manager_cache_worlds_task:
    type: task
    debug: false
    script:
    - flag server tick_world_manager.cache:<server.worlds.parse[name]>
    - debug log "Tick world manager: cached world data to server flag."
tick_world_manager_load_worlds_world:
    type: world
    debug: false
    events:
        on server prestart:
        - if <server.has_flag[tick_world_manager.cache]>:
            - foreach <server.flag[tick_world_manager.cache]> as:world:
                - if <server.worlds.parse[name]> !contains <[world]>:
                    - createworld <[world]>
                    - debug log "Tick world manager: Loaded world <[world]>"
        after world loads:
        - run tick_world_manager_cache_worlds_task
        after world unloads:
        - run tick_world_manager_cache_worlds_task
tick_world_manager_command:
    type: command
    name: tickworld
    description: The main command for Tick's World Manager.
    debug: false
    aliases:
    - tw
    usage: /tickworld [teleport [world] (player)/create [name] [type] (--generator:<&lt>generator<&gt>/{minecraft:overworld}) (--seed:<&lt>seed<&gt>) (--settings:<&lt>additional generator settings in JSON<&gt>) (--worldtype:<&lt>type<&gt>/{normal}) (--environment:<&lt>environment<&gt>/{normal}) (--generate_structures/{false})]
    data:
        required_args: 1
        tab_complete:
            1:
            - [matcher=true;values=teleport|create]
            2:
            - [matcher=<context.args.get[1].equals[teleport]>;values=<server.worlds.parse[name]>]
            global:
            - [matcher=<context.args.get[1].equals[create].if_null[false].and[<[current_arg].is_more_than[1]>]>;values=--generator:|--seed:|--settings:|--worldtype:|--environment:|--generate_structures]
            - [matcher=<context.args.get[1].equals[create].if_null[false].and[<[current_arg].is_more_than[1]>].and[<context.raw_args.ends_with[ --worldtype:]>]>;values=<server.world_types.parse_tag[<context.args.last><[parse_value]>]>]
            - [matcher=<context.args.get[1].equals[create].if_null[false].and[<[current_arg].is_more_than[1]>].and[<context.raw_args.ends_with[ --environment:]>]>;values=<list[NORMAL|NETHER|THE_END|CUSTOM].parse_tag[<context.args.last><[parse_value]>]>]
    tab complete:
    - inject command_manager.tab_complete_helper
    script:
    - inject command_manager.args_manager
    - choose <context.args.get[1]>:
        - case teleport:
            - define require_worlds 2
            - inject command_manager.require_world
            - define require_players 3
            - inject command_manager.require_player
            - teleport <player> <[world].spawn_location>
            - narrate "<&[success]>Teleported '<player.name>' to '<[world].name>'!"
        - case create:
            - define required_args 2
            - inject command_manager.args_manager
            - inject command_manager.flag_args
            - define flag_args.linear_args <[flag_args.linear_args].remove[1]>
            - define generator <[flag_args.prefixed_args.generator].if_null[minecraft:overworld]>
            - define seed <[flag_args.prefixed_args.seed].if_null[null]>
            - define settings <[flag_args.prefixed_args.settings].if_null[{}]>
            - if <[flag_args.linear_args].size> < 1:
                - narrate "<&[error]>Please specify a world name. <script.parsed_key[usage]>"
                - stop
            - define world_name <[flag_args.linear_args].get[1]>
            - define worldtype <[flag_args.prefixed_args.worldtype].if_null[normal]>
            - define environment <[flag_args.prefixed_args.environment].if_null[normal]>
            - define generate_structures <[flag_args.prefixed_args.generate_structures].if_null[false]>
            - if !<[generate_structures].is_boolean>:
                - define generate_structures false
            - if <[seed]> == null:
                - createworld <[world_name]> generator:<[generator]> worldtype:<[worldtype]> environment:<[environment]> generate_structures:<[generate_structures]>
            - createworld <[world_name]> generator:<[generator]> worldtype:<[worldtype]> environment:<[environment]> generate_structures:<[generate_structures]> seed:<[seed]>
        - default:
            - narrate <script.parsed_key[usage].custom_color[error]>