tick_chat_custom_tabcomplete:
    type: world
    debug: false
    data:
        tab completions:
        - (i)
        - (l)
        - (/command)
        - (!/command)
    events:
        on delta time minutely:
        - foreach <server.online_players> as:__player:
            - adjust <player> add_tab_completions:<script.data_key[data.tab completions]>
tick_chat_world:
    type: world
    enabled: true
    debug: false
    data:
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
        - customevent id:tick_chat_player_sends_message context:[message=<[message]>;formatted_message=<script.parsed_key[data.chat format]>] save:event
        - if <entry[event].was_cancelled>:
            - stop
        - announce <script.parsed_key[data.chat format]>
        - run tick_logging_log_info def.source:Chat "def.message:<player.proc[tick_logging_util_proc.script.format_player]>: <[message]>"
        on player receives message:
        - define message <context.message>
        - foreach <script.data_key[data.chat replacements.on receive message].keys> as:path:
            - inject tick_chat_world "path:data.chat replacements.on receive message.<[path]>"
        - determine message:<[message]>

tick_chat_format_player_name:
    type: procedure
    debug: false
    definitions: player
    script:
    - determine <player.chat_prefix.replace[&_].with[&].parsed><player.name><player.chat_suffix.replace[&_].with[&].parsed>
