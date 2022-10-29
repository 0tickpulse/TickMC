tick_no_quick_join_world:
    type: world
    debug: false
    events:
        on player logs in server_flagged:tick_no_quick_join.startup_progress:
        - determine "KICKED:Slow down, the server is still loading resources! Please wait another <server.flag_expiration[tick_no_quick_join.startup_progress].from_now.formatted_words>!"
        on server prestart:
        - flag server tick_no_quick_join.startup_progress duration:10s
        on server list ping server_flagged:tick_no_quick_join.startup_progress:
        - determine passively "<red>Server is still loading, please wait!"
        - determine passively "VERSION_NAME:Still loading!"
        - determine PROTOCOL_VERSION:999