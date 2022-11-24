tick_essentials_utility_injections:
    type: task
    debug: false
    script:
    - debug error "Please specify a path to inject."
    - stop
    player_only:
    - if !<player.exists>:
        - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You must be a player to use this command!"
        - stop