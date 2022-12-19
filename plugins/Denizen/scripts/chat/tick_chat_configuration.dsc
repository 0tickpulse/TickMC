tick_chat_configuration:
    type: data
    debug: false

    commands:
        # Permission: tick_chat.command.msg
        msg:
            enabled: true
            format: <n><&[emphasis]><bold>DM <player.null_if[exists].if_null[<element[REPLY].custom_color[success].underline.bold.on_hover[Click to reply to <[sender].proc[tick_chat_format_player_name]>!].on_click[/msg <[sender].name> ].type[suggest_command]>]> <[sender].proc[tick_chat_format_player_name].if_null[console]> <dark_gray>-<&gt> <[receiver].proc[tick_chat_format_player_name]> <gray>» <white><[message]><n>

    chat tab completions:
        enabled: true
        tab completions:
        - (i)
        - (l)
        - (/command)
        - (!/command)

    chat format: <player.proc[tick_chat_format_player_name]> <gray>» <white><[message]>
    player info: <[parse_value].name.on_hover[Player: <&[emphasis]><bold><[parse_value].proc[tick_chat_format_player_name]>]>
    chat replacements:
        on receive message:
            suggest command on click:
            - define message <[message].replace[regex:\(/([^\]<&rb>+)\)].with[<element[/$1].bold.custom_color[suggest].on_hover[<&[suggest]>Click to paste into chat!].on_click[/$1].type[suggest_command]>]>
            command on click:
            - define message <[message].replace[regex:\(!/([^\]<&rb>+)\)].with[<element[/$1].bold.custom_color[success].on_hover[<&[success]>Click to run command!].on_click[/$1]>]>
            #hover player info:
            #- foreach <server.online_players> as:__player:
            #    - define message <[message].replace[<player.name>].with[<[player].name.on_hover[Player: <player.name>]>]>
        on send message:
            item hover:
                to_replace: (i)
                with: <element[[<player.item_in_hand.display.if_null[<player.item_in_hand.material.translated_name.custom_color[emphasis].bold>].hover_item[<player.item_in_hand>]>]].custom_color[base]>
            location hover:
                to_replace: (l)
                with: <element[<player.location.simple.formatted>].custom_color[emphasis]>
    ping: true
    ping toast:
        text: <player.proc[tick_chat_format_player_name]> <white>pinged you!
        frame: goal
        icon: <item[arrow].with[custom_model_data=1]>