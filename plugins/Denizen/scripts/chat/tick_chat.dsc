tick_chat_custom_tabcomplete:
    type: world
    debug: false
    events:
        on delta time minutely:
        - if !<script[tick_chat_configuration].data_key[chat tab completions.enabled].if_null[true]>:
            - stop
        - foreach <server.online_players> as:__player:
            - adjust <player> add_tab_completions:<script[tick_chat_configuration].data_key[chat tab completions.tab completions]>

tick_chat_format_chat_injection:
    type: task
    debug: false
    script:
    - foreach <script[tick_chat_configuration].data_key[chat replacements.on send message].values> as:map:
        - define message <[message].replace[<[map.to_replace].parsed>].with[<[map.with].parsed>]>
    - if <[ping]>:
        - foreach <server.online_players.filter_tag[<[message].contains[@<[filter_value].name>]>]> as:pinged:
            - playsound <[pinged]> sound:block_note_block_bell
            - define message <[message].replace_text[@<[pinged].name>].with[<element[@<[pinged].name>].custom_color[emphasis]>]>
            - define toast_map <script[tick_chat_configuration].parsed_key[ping toast]>
            - toast <[toast_map.text].if_null[Please configure some text!]> frame:<[toast_map.frame].if_null[goal]> icon:<[toast_map.icon].if_null[stone]> player:<[pinged]>
    - define formatted_message <script[tick_chat_configuration].parsed_key[chat format]>

tick_chat_world:
    type: world
    enabled: true
    debug: false
    events:
        on player chats:
        - determine passively cancelled
        - define ping <script[tick_chat_configuration].data_key[ping]>
        - define message <context.message>
        - inject tick_chat_format_chat_injection
        - customevent id:tick_chat_player_sends_message context:[message=<[message]>;formatted_message=<[formatted_message]>] save:event
        - if <entry[event].was_cancelled>:
            - stop
        - announce <[formatted_message]>
        - define log_message "<player.proc[tick_logging_util_proc.script.format_player]>: <[message]>"
        - log file:plugins/Denizen/logs/chat.log <[log_message]>
        - run tick_logging_log_info def.source:Chat def.message:<[log_message]>
        on player receives message:
        - define message <context.message>
        - foreach <script[tick_chat_configuration].data_key[chat replacements.on receive message].keys> as:path:
            - inject tick_chat_configuration "path:chat replacements.on receive message.<[path]>"
        - determine message:<[message]>

tick_chat_format_player_name:
    type: procedure
    debug: false
    definitions: player
    script:
    - determine <player.chat_prefix.replace_text[&_].with[&].parsed><player.display_name><player.chat_suffix.replace_text[&_].with[&].parsed>

tick_chat_msg_command:
    type: command
    name: msg
    enabled: <script[tick_chat_configuration].data_key[commands.msg.enabled]>
    debug: false
    description: Sends a message to another player.
    usage: <script[tick_chat_msg_command].proc[command_manager_generate_usage]>
    data:
        args:
            player:
                template: player
            message:
                type: linear
                spread: true
                required: true
                tab complete: <script[tick_chat_configuration].data_key[chat tab completions.tab completions]>
    permission: tick_chat.command.msg
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <player.exists>:
        - define sender <player>
    - define ping false
    - define receiver <[arg.player]>
    - define message <[arg.message]>
    - inject tick_chat_format_chat_injection
    - narrate <script[tick_chat_configuration].parsed_key[commands.msg.format]> targets:<[receiver]>