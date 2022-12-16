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
    description: A shortcut command to give a player an item. The item can have optional properties using the <&dq>properties<&dq> argument.
    usage: <script[tickcore_util_item_shortcut_command].proc[command_manager_generate_usage]>
    aliases:
    - i
    data:
        args:
            item:
                type: linear
                required: true
                accepted: <server.material_types.parse[name].include[<proc[tickcore_proc.script.items.get_all_ids].if_null[<list>]>].include[<server.material_types.parse[name].include[<proc[tickcore_proc.script.items.get_all_ids].if_null[<list>]>].parse[replace[_]]>].contains_single[<[value]>]>
                tab completes: <server.material_types.parse[name].include[<proc[tickcore_proc.script.items.get_all_ids].if_null[<list>]>].include[<server.material_types.parse[name].include[<proc[tickcore_proc.script.items.get_all_ids].if_null[<list>]>].parse[replace[_]]>]>
                explanation: Any material name or TickItem ID.
            quantity:
                template: integer
                usage text:
                    auto format: true
                    list:
                    - <&lt>quantity<&gt>
            properties:
                type: prefixed
                required: false
                template: maptag
                default: <map>
                explanation: Properties of the item.
            player:
                template: player
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager

    - foreach <proc[tickcore_proc.script.items.get_all_ids]> as:id:
        - if <[id]> == <[arg.item]> || <[id].replace[_]> == <[arg.item]>:
            - define item <[id].proc[tickcore_proc.script.items.generate]>
    - if !<[item].exists>:
        - foreach <server.material_types.parse[name]> as:id:
            - if <[id]> == <[arg.item]> || <[id].replace[_]> == <[arg.item]>:
                - define item <[id].as[item]>

    - define item <[item].with[quantity=<[arg.quantity].if_null[1]>]>

    - foreach <[arg.properties].as[map]> key:key as:value:
        - if <[item].supports[<[key]>]>:
            - define item <[item].with[<[key]>=<[value]>]>

    - give <[item]>
    - narrate "<&[success]>Given you <dark_gray><[item].quantity>x <&[success]><[item].proc[tickutil_items.script.hover_text]><reset><&[success]>!"

tickcore_util_formatter_death_message:
    type: format
    format: <script[icons].parsed_key[red_icons.skull]> <dark_gray>» <[text].color[gray]>