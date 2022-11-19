# @ ----------------------------------------------------------
# TickCore Utils
# A few simple utility scripts that are used in my TickCore
# implementations.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tickcore_util_item_shortcut_command:
    type: command
    debug: false
    name: item
    description: A shortcut command to obtain an item for yourself.
    usage: <script.proc[command_manager_generate_usage]>
    aliases:
    - i
    data:
        args:
            item:
                type: linear
                required: true
                accepted: <server.material_types.parse[name].include[<proc[tickcore_proc.script.items.get_all_ids].if_null[<list>]>].contains[<[value]>]>
                tab completes: <server.material_types.parse[name].include[<proc[tickcore_proc.script.items.get_all_ids].if_null[<list>]>]>
                explanation: Any material name or TickItem ID.
            properties:
                type: prefixed
                required: false
                accepted: <[value].as[map].exists>
                default: <map>
                result: <[value].as[map]>
                explanation: Properties as a MapTag.
                usage text: <&lt>map<&gt>
            player:
                template: player
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager

    - define item <proc[tickcore_proc.script.items.get_all_ids].contains[<[arg.item]>].if_true[<[arg.item].proc[tickcore_proc.script.items.generate]>].if_false[<[arg.item].as[item]>]>

    - foreach <[arg.properties].as[map]> key:key as:value:
        - if <[item].supports[<[key]>]>:
            - define item <[item].with[<[key]>=<[value]>]>

    - give <[item]>
    - narrate "<&[success]>Given you <dark_gray><[item].quantity>x <&[success]><[item].proc[tickutil_items.script.hover_text]><reset><&[success]>!"

tickcore_util_formatter_death_message:
    type: format
    format: <script[icons].parsed_key[red_icons.skull]> <dark_gray>» <[text].color[gray]>