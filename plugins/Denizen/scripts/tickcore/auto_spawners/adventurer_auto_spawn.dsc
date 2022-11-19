adventurer_auto_spawn:
    type: data
    tickcore:
        type: auto_spawn
        data:
            location conditions:
            - <[location].world.advanced_matches[world]>
            script:
            - spawn cow