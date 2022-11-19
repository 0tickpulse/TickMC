# @ ----------------------------------------------------------
# Tick's Sidebar
# A highly flexible sidebar system, with presets, lines,
# conditions, and more!
# Author: 0TickPulse
# @ ----------------------------------------------------------

tick_sidebar_data:
    type: data
    refresh rate: 5
    presets:
        admin:
            enabled: false
            conditions:
            - <player.groups.contains[admin]>
            title:
                text:
                - Admin only haha
                animation interval: 1s
                has animation: true
            lines:
                1:
                    text:
                    - haha lol
                2:
                    text:
                    - 1
                    - 2
                    animation interval: 1s
                    has animation: false
                    conditions:
                    - <player.gamemode.equals[creative]>
                3:
                    text:
                    - only in gmc!
                    - lol
                    animation interval: 5t
                    has animation: true
                    conditions:
                    - <player.gamemode.equals[creative]>
                4:
                    text:
                    - only in gmc!
                    - lol
                    animation interval: 34t
                    has animation: true
                    conditions:
                    - <player.gamemode.equals[creative]>
                5:
                    text:
                    - only in gmc!
                    - lol
                    animation interval: 3s
                    has animation: true
                    conditions:
                    - <player.gamemode.equals[creative]>
                6:
                    text:
                    - only in gmc!
                    - lol
                    animation interval: 5t
                    has animation: true
                    conditions:
                    - <player.gamemode.equals[creative]>
                7:
                    text:
                    - only in gmc!
                    - lol
                    animation interval: 2t
                    has animation: true
                    conditions:
                    - <player.gamemode.equals[creative]>
        default:
            title:
                text:
                - <&sp.repeat[15].strikethrough.color_gradient[from=black;to=red]><reset> <&[emphasis]><bold>TickMC<reset> <&sp.repeat[15].strikethrough.color_gradient[from=red;to=black]>
                has animation: false
            lines:
                stats:
                    text:
                    - <empty>
                    - <&sp.repeat[4].strikethrough.color_gradient[from=black;to=red]><reset> <&[emphasis]><bold>Vitals
                    - <red>❤ <player.flag[tickutil_progress_bar.health]>
                    - <yellow>☕ <player.flag[tickutil_progress_bar.hunger]>
                money:
                    text:
                    - <empty>
                    - <player.formatted_money>
                    - <empty>
                    - TPS <server.flag[tickutil_progress_bar.tps]>
                    - <empty>
                server:
                    text:
                    - <gray>tick-mc.net
                    - <red>tick-mc.net
                    animation interval: 0.5s
                    has animation: true
tick_sidebar_change_preset_command:
    type: command
    name: sidebarpreset
    description: Does something
    usage: /sidebarpreset [preset] (player)
    permission: tick_sidebar.command.sidebarpreset
    debug: false
    tab completions:
        1: <player.proc[tick_sidebar_get_available_presets_proc].if_null[]>
        2: <server.online_players.parse[name]>
    script:
    - define caster <player.if_null[null]>
    - if <context.args.size> < 1:
        - narrate "<&[error]>Invalid! <script.data_key[usage]>"
        - stop
    - if <context.args.size> >= 2:
        - define player <server.match_player[<context.args.get[2]>].if_null[null]>
        - if <[player]> == null:
            - narrate "<&[error]>Invalid player name <[player]>"
            - stop
        - adjust <queue> linked_player:<[player]>
    - else if !<player.exists>:
        - narrate "<&[error]>Specify a player!"
        - stop
    - if <player.proc[tick_sidebar_get_available_presets_proc]> !contains <context.args.get[1]>:
        - if <[caster]> != null:
            - if <[caster].proc[tick_sidebar_get_available_presets_proc]> !contains <context.args.get[1]>:
                - narrate "<&[error]>This player cannot use this preset, and neither can you!" targets:<[caster]>
                - stop
    - if <[caster]> != null:
        - if <[caster]> != <player> && !<[caster].has_permission[tick_sidebar.command.sidebarpreset.other]>:
            - narrate "<&[error]>You do not have the permission to do this on others!" targets:<[caster]>
            - stop
    - flag <player> tick_sidebar.preset:<context.args.get[1]>
    - run tick_sidebar_process_sidebar_task
tick_sidebar_get_available_presets_proc:
    type: procedure
    debug: false
    definitions: player
    script:
    - define __player <[player]>
    - determine <script[tick_sidebar_data].data_key[presets].filter_tag[<[filter_value.conditions].if_null[<list>].parse[parsed.not].filter[].is_empty>].filter_tag[<[filter_value.enabled].if_null[true]>].keys>
tick_sidebar_process_sidebar_task:
    type: task
    debug: false
    script:
    - define sidebar_preset <player.flag[tick_sidebar.preset].if_null[<player.proc[tick_sidebar_get_available_presets_proc].first.if_null[__null]>]>
    - if <[sidebar_preset]> == __null:
        - stop
    - define sidebar_data <player.proc[tick_sidebar_process_lines_proc].context[<[sidebar_preset]>]>
    - sidebar title:<[sidebar_data.title]> values:<[sidebar_data.lines]> players:<player>
tick_sidebar_main_runner_world:
    type: world
    debug: false
    events:
        after delta time secondly:
        - define per_second <script[tick_sidebar_data].parsed_key[refresh rate]>
        - define interval <element[1].div[<[per_second]>]>
        - repeat <[per_second]>:
            - run tick_sidebar_main_runner_task
            - wait <[interval]>
tick_sidebar_main_runner_task:
    type: task
    debug: false
    script:
    - foreach <server.online_players> as:__player:
        - run tick_sidebar_process_sidebar_task
tick_sidebar_process_animations_proc:
    type: procedure
    debug: false
    definitions: player|lines|animation_interval
    script:
    - define rate <element[1].div[<[animation_interval].in_seconds>]>
    - define count <[lines].size>
    - define index <util.current_time_millis.div[1000].mul[<[rate]>].round.mod[<[count]>].add[1]>
    - determine <[lines].get[<[index]>].parsed>
tick_sidebar_process_lines_proc:
    type: procedure
    debug: false
    definitions: player|preset
    script:
    - define __player <[player]>
    - if <script[tick_sidebar_data].list_keys[presets]> !contains <[preset]>:
        - debug error "The preset '<[preset]>' is missing!"
        - stop

    - define title_data <script[tick_sidebar_data].data_key[presets.<[preset]>.title]>
    - define title_lines <[title_data.text].if_null[null]>
    - if <[title_lines]> == null:
        - debug error "The preset '<[preset]>' has a missing title text!"
        - stop
    - define title_animation_interval <duration[<[title_data.animation interval].if_null[1s]>]>
    - define title <player.proc[tick_sidebar_process_animations_proc].context[<list_single[<[title_lines]>].include_single[<[title_animation_interval]>]>]>

    - define lines <script[tick_sidebar_data].data_key[presets.<[preset]>.lines].filter_tag[<[filter_value.conditions].if_null[<list>].parse[parsed.not].filter[].is_empty>]>

    - define output_lines <list>
    - foreach <[lines]> key:line_name as:line:
        - define text <[line.text].if_null[null]>
        - if <[text]> == null:
            - debug error "The preset '<[preset]>' has an invalid line at <[line_name]> - missing text key! Skipping..."
            - foreach next
        - if <[text].size> <= 1:
            - define output_lines:->:<[text].get[1].parsed>
            - foreach next
        - if <[line.has animation].if_null[false]>:
            - define animation_interval <duration[<[line.animation interval].if_null[1s]>]>
            - define output_lines:->:<player.proc[tick_sidebar_process_animations_proc].context[<list_single[<[text]>].include_single[<[animation_interval]>]>]>
        - else:
            - define output_lines <[output_lines].include[<[text].parse[parsed]>]>
    - definemap output_map:
            title: <[title]>
            lines: <[output_lines]>
    - determine <[output_map]>