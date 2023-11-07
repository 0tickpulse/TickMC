bloodyscreen_temp_task:
    type: task
    definitions: player|duration
    debug: false
    script:
    - worldborder <[player]> center:<[player].location.add[10000,0,10000]> size:1
    - wait <[duration]>
    - worldborder <[player]> reset

bloodyscreen_enable_task:
    type: task
    definitions: player
    debug: false
    script:
    - worldborder <[player]> center:<[player].location.add[10000,0,10000]> size:1

bloodyscreen_reset_task:
    type: task
    definitions: player
    debug: false
    script:
    - worldborder <[player]> reset

bloodyscreen_player_task:
    type: task
    definitions: player
    debug: false
    script:
    - if <[player].health_percentage> < 25:
        - run bloodyscreen_enable_task def.player:<[player]> def.duration:1s
    - else:
        - run bloodyscreen_reset_task def.player:<[player]>

bloodyscreen_world:
    type: world
    debug: false
    events:
        after player damaged:
        # - run bloodyscreen_player_task def.player:<player>
        - if <context.damage> >= <player.health_max.mul[0.4]>:
            # high damage
            - playsound sound:entity_player_hurt <player> pitch:0
        # after player heals:
        # - run bloodyscreen_player_task def.player:<player>
