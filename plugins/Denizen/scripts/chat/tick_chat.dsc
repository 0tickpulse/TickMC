tick_chat_world:
    type: world
    debug: false
    data:
        chat format: <player.proc[tick_chat_format_player_name]> <gray>» <white><[message]>
        player info: <[parse_value].name.on_hover[Player: <&[emphasis]><bold><[parse_value].proc[tick_chat_format_player_name]>]>
        chat replacements:
            on receive message:
                command on click:
                    to_replace: regex:\<&lt>c\<&gt>(.+)\<&lt>/c\<&gt>
                    with: <element[/$1].bold.custom_color[emphasis].on_hover[<&[emphasis]>Click to run command!].on_click[/$1]>
                    #with: <element[[/<element[$1].custom_color[emphasis].bold.on_hover[<&[emphasis]>Click to run command:<n><&[base]>/$1].on_click[/$1].type[run_command]>]].custom_color[base]>
                hover player info:
                    to_replace: regex:(\w+)
                    with: <server.online_players.parse[name].filter[equals[$1]].is_empty.if_true[$1].if_false[<list[<server.match_player[$1]>].parse_tag[<script.parsed_key[data.player info]>].unseparated>]>
            on send message:
                item hover:
                    to_replace: <&lt>i<&gt>
                    with: <element[[<player.item_in_hand.display.if_null[<player.item_in_hand.material.translated_name.custom_color[emphasis].bold>].hover_item[<player.item_in_hand>]>]].custom_color[base]>
                location hover:
                    to_replace: <&lt>l<&gt>
                    with: <element[<player.location.simple.formatted>].custom_color[emphasis]>
        ping: true
        ping toast:
            text: <player.proc[tick_chat_format_player_name]> <white>pinged you!
            frame: goal
            icon: <item[arrow].with[custom_model_data=1]>
    events:
        on player chats:
        - determine passively cancelled
        - define message <context.message>
        - foreach <script.data_key[data.chat replacements.on send message].values> as:map:
            - define message <[message].replace[<[map.to_replace].parsed>].with[<[map.with].parsed>]>
        - if <script.data_key[data.ping]>:
            - foreach <server.online_players.filter_tag[<[message].contains[@<[filter_value].name>]>]> as:pinged:
                - playsound <[pinged]> sound:block_note_block_bell
                - define message <[message].replace[@<[pinged].name>].with[<element[@<[pinged].name>].custom_color[emphasis]>]>
                - define toast_map <script.parsed_key[data.ping toast]>
                - toast <[toast_map.text].if_null[Please configure some text!]> frame:<[toast_map.frame].if_null[goal]> icon:<[toast_map.icon].if_null[stone]>
        - announce <script.parsed_key[data.chat format]>
        on player receives message:
        - define message <context.message>
        - foreach <script.data_key[data.chat replacements.on receive message].values> as:map:
            - define message <[message].replace[<[map.to_replace].parsed>].with[<[map.with].parsed>]>
        - determine message:<[message]>

tick_chat_format_player_name:
    type: procedure
    debug: false
    definitions: player
    script:
    - determine <player.chat_prefix.replace[&_].with[&].parsed><player.name><player.chat_suffix.replace[&_].with[&].parsed>
