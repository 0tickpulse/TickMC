tickcore_util_item_shortcut_command:
    type: command
    debug: false
    name: item
    description: A shortcut command to obtain an item for yourself.
    usage: /item [item] (properties as tickmap)
    aliases:
    - i
    tab completions:
        1: <server.material_types.parse[name].include[<proc[tickcore_proc.script.items.get_all_ids].if_null[<list>]>]>
    data:
        required_args: 1
        max_args: 2
        player_only: true
    script:
    - inject command_manager path:args_manager
    - inject command_manager path:player_only
    - define item_input <context.args.get[1]>
    - define properties <context.args.get[2].if_null[<map>]>

    - if <[item_input]> in <proc[tickcore_proc.script.items.get_all_ids]>:
        - define item <proc[tickcore_proc.script.items.generate].context[<[item_input]>]>
    - else if <[item_input]> in <server.material_types.parse[name]>:
        - define item <[item_input].as[item]>
    - else:
        - narrate "<&[error]>Invalid item '<[item_input]>'."
        - stop

    - foreach <[properties].as[map]> key:key as:value:
        - if <[item].supports[<[key]>]>:
            - define item <[item].with[<[key]>=<[value]>]>

    - give <[item]>
    - narrate "<&[success]>Given you <dark_gray><[item].quantity>x <&[success]><[item].proc[tickutil_items.script.hover_text]><reset><&[success]>!"

tickcore_util_formatter_death_message:
    type: format
    format: <script[icons].parsed_key[red_icons.skull]> <dark_gray>» <[text].color[gray]>