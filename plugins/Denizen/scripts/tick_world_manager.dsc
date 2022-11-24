# @ ----------------------------------------------------------
# Tick's World Manager
# ... a world manager.
# Author: 0TickPulse
# @ ----------------------------------------------------------

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

tick_world_manager_helper_command:
    type: command
    name: tickworld
    description: A list of TickWorld commands.
    usage: /tickworld
    permission: tickworld.command.tickworld
    aliases:
    - tw
    script:
    - narrate "<&[emphasis]>TickWorld commands:"
    - inject command_manager.formatted_help_same_file

tick_world_manager_createworld_command:
    type: command
    name: createworld
    description: A TickWorld command that creates or loads a world.
    debug: false
    aliases:
    - twcw
    - cw
    usage: <script[tick_world_manager_createworld_command].proc[command_manager_generate_usage]>
    permission: tickworld.command.createworld
    data:
        args:
            name:
                type: linear
                required: true
                explanation: The name of the world.
            type:
                type: linear
                required: false
                default: normal
                explanation: The type of the world.
                accepted: <server.world_types.contains[<[value]>]>
                usage text:
                    auto format: true
                    list:
                    - <&lc>normal<&rc>
                    - flat
                    - large_biomes
                    - amplified
                tab completes: <server.world_types>
            generator:
                type: prefixed
                required: false
                explanation: The generator of the world.
                default: minecraft:overworld
            environment:
                type: prefixed
                required: false
                explanation: The environment of the world.
                accepted: <list[normal|nether|the_end|custom].contains[<[value]>]>
                usage text:
                    auto format: true
                    list:
                    - <&lc>normal<&rc>
                    - nether
                    - the_end
                    - custom
                tab completes: normal|nether|the_end|custom
                default: normal
            settings:
                type: prefixed
                required: false
                template: maptag
                default: <map>
            generate_structures:
                template: boolean_default_false
            seed:
                type: prefixed
                required: false
                default: null
                explanation: The seed of the world.
            s:
                template: boolean_default_false
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <[arg.seed]> == null:
        - createworld <[arg.name]> generator:<[arg.generator]> worldtype:<[arg.type]> environment:<[arg.environment]> generate_structures:<[arg.generate_structures]>
    - else:
        - createworld <[arg.name]> generator:<[arg.generator]> worldtype:<[arg.type]> environment:<[arg.environment]> generate_structures:<[arg.generate_structures]> seed:<[arg.seed]>

    - if <[arg.s]>:
        - stop
    - if <[arg.name].as[world].exists>:
        - narrate "<element[TickWorld].format[tickutil_text_prefix]> <&[success]>Successfully created the world '<[arg.name]>'!"
    - else:
        - narrate "<element[TickWorld].format[tickutil_text_prefix]> <&[error]>Failed to create the world '<[arg.name]>'! Please check console for more information."

tick_world_manager_teleportworld_command:
    type: command
    name: teleportworld
    description: A TickWorld command that teleports you to the spawn location of another world.
    usage: <script[tick_world_manager_teleportworld_command].proc[command_manager_generate_usage]>
    permission: tickworld.command.teleportworld
    aliases:
    - twtp
    - tpworld
    - tpw
    debug: false
    data:
        args:
            world: template=world
            player: template=player
            s: template=boolean_default_false
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - teleport <[arg.player]> <[arg.world].spawn_location>
    - if <[arg.s]>:
        - stop
    - narrate "<element[TickWorld].format[tickutil_text_prefix]> <&[success]>Successfully teleported player '<[arg.player].name>' to world '<[arg.world].name>'!"

tick_world_manager_unloadworld_command:
    type: command
    name: unloadworld
    description: A TickWorld command that unloads a world.
    usage: <script[tick_world_manager_unloadworld_command].proc[command_manager_generate_usage]>
    permission: tickworld.command.unloadworld
    aliases:
    - twdw
    - dw
    debug: false
    data:
        args:
            world: template=world
            mode:
                type: prefixed
                required: false
                default: unload
                accepted: <list[unload|force_unload|destroy].contains[<[value]>]>
                tab completes: unload|force_unload|destroy
            s: template=boolean_default_false
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - define name <[arg.world].name>
    - choose <[arg.mode]>:
        - case unload:
            - adjust <[arg.world]> unload
        - case force_unload:
            - adjust <[arg.world]> force_unload
        - case destroy:
            - adjust <[arg.world]> destroy
    - if <[arg.s]>:
        - stop
    - if <server.worlds> contains <[arg.world]>:
        - narrate "<element[TickWorld].format[tickutil_text_prefix]> <&[error]>Failed to <[arg.mode].equals[unload].if_true[unload].if_false[<[arg.mode].equals[force_unload].if_true[forcibly unload].if_false[destroy]>]> world '<[name]>'! Please check console for more information."
    - else:
        - narrate "<element[TickWorld].format[tickutil_text_prefix]> <&[success]>Successfully <[arg.mode].equals[unload].if_true[unloaded].if_false[<[arg.mode].equals[force_unload].if_true[forcibly unloaded].if_false[destroyed]>]> world '<[name]>'!"

tick_world_manager_worldgamerule_command:
    type: command
    name: worldgamerule
    description: A TickWorld command that gets or sets a world's gamerule.
    usage: <script[tick_world_manager_worldgamerule_command].proc[command_manager_generate_usage]>
    permission: tickworld.command.worldgamerule
    aliases:
    - twgr
    - wgr
    data:
        args:
            world: template=world
            gamerule:
                type: linear
                required: true
                explanation: The gamerule to set.
                accepted: <server.gamerules.contains[<[value]>]>
                tab completes: <server.gamerules>
            value: template=any_value;type=linear;required=false
            s: template=boolean_default_false
    debug: false
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <[arg.value].exists>:
        - gamerule <[arg.world]> <[arg.gamerule]> <[arg.value]>
        - if <[arg.s]>:
            - stop
        - narrate "<element[TickWorld].format[tickutil_text_prefix]> <&[success]>Attempting to set gamerule '<[arg.gamerule]>' of world '<[arg.world].name>' to '<[arg.value]>'! Check console for any potential errors."
        - stop
    - narrate "<element[TickWorld].format[tickutil_text_prefix]> <&[success]>World '<[arg.world].name>' has gamerule '<[arg.gamerule]>' currently set to '<[arg.world].gamerule[<[arg.gamerule]>]>'."


# tick_world_manager_command:
#     type: command
#     name: tickworld
#     description: The main command for Tick's World Manager.
#     debug: false
#     enabled: false
#     aliases:
#     - tw
#     usage: /tickworld [teleport [world] (player)/create [name] [type] (--generator:<&lt>generator<&gt>/{minecraft:overworld}) (--seed:<&lt>seed<&gt>) (--settings:<&lt>additional generator settings in JSON<&gt>) (--worldtype:<&lt>type<&gt>/{normal}) (--environment:<&lt>environment<&gt>/{normal}) (--generate_structures/{false})]
#     data:
#         required_args: 1
#         tab_complete:
#             1:
#             - [matcher=true;values=teleport|create]
#             2:
#             - [matcher=<context.args.get[1].equals[teleport]>;values=<server.worlds.parse[name]>]
#             global:
#             - [matcher=<context.args.get[1].equals[create].if_null[false].and[<[current_arg].is_more_than[1]>]>;values=--generator:|--seed:|--settings:|--worldtype:|--environment:|--generate_structures]
#             - [matcher=<context.args.get[1].equals[create].if_null[false].and[<[current_arg].is_more_than[1]>].and[<context.raw_args.ends_with[ --worldtype:]>]>;values=<server.world_types.parse_tag[<context.args.last><[parse_value]>]>]
#             - [matcher=<context.args.get[1].equals[create].if_null[false].and[<[current_arg].is_more_than[1]>].and[<context.raw_args.ends_with[ --environment:]>]>;values=<list[NORMAL|NETHER|THE_END|CUSTOM].parse_tag[<context.args.last><[parse_value]>]>]
#     tab complete:
#     - inject command_manager.tab_complete_helper
#     script:
#     - inject command_manager.args_manager
#     - choose <context.args.get[1]>:
#         - case teleport:
#             - define require_worlds 2
#             - inject command_manager.require_world
#             - define require_players 3
#             - inject command_manager.require_player
#             - teleport <player> <[world].spawn_location>
#             - narrate "<&[success]>Teleported '<player.name>' to '<[world].name>'!"
#         - case create:
#             - define required_args 2
#             - inject command_manager.args_manager
#             - inject command_manager.flag_args
#             - define flag_args.linear_args <[flag_args.linear_args].remove[1]>
#             - define generator <[flag_args.prefixed_args.generator].if_null[minecraft:overworld]>
#             - define seed <[flag_args.prefixed_args.seed].if_null[null]>
#             - define settings <[flag_args.prefixed_args.settings].if_null[{}]>
#             - if <[flag_args.linear_args].size> < 1:
#                 - narrate "<&[error]>Please specify a world name. <script.parsed_key[usage]>"
#                 - stop
#             - define world_name <[flag_args.linear_args].get[1]>
#             - define worldtype <[flag_args.prefixed_args.worldtype].if_null[normal]>
#             - define environment <[flag_args.prefixed_args.environment].if_null[normal]>
#             - define generate_structures <[flag_args.prefixed_args.generate_structures].if_null[false]>
#             - if !<[generate_structures].is_boolean>:
#                 - define generate_structures false
#             - if <[seed]> == null:
#                 - createworld <[world_name]> generator:<[generator]> worldtype:<[worldtype]> environment:<[environment]> generate_structures:<[generate_structures]>
#             - createworld <[world_name]> generator:<[generator]> worldtype:<[worldtype]> environment:<[environment]> generate_structures:<[generate_structures]> seed:<[seed]>
#         - default:
#             - narrate <script.parsed_key[usage].custom_color[error]>