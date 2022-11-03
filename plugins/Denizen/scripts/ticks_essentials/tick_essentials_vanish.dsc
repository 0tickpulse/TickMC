tick_essentials_vanish_can_see:
    type: procedure
    definitions: viewer|player
    script:
    - if <[viewer].has_permission[tick_essentials.command.vanish]>:
        - determine true
    - if <[player].flag[tick_essentials.vanished].if_null[false]>:
        - determine false
    - determine true
tick_essentials_vanish_world:
    type: world
    debug: false
    events:
        on entity targets player:
        - if <player.flag[tick_essentials.vanished].if_null[false]>:
            - determine cancelled
tick_essentials_vanish_command:
    type: command
    debug: false
    name: vanish
    description: Toggles vanish mode.
    enabled: <script[tick_essentials_data].data_key[enable vanish].if_null[false]>
    usage: /vanish (player)
    permission: tick_essentials.command.vanish
    data:
        require_player: 1
    script:
    - inject command_manager.require_player
    - flag <player> tick_essentials.vanished:<player.flag[tick_essentials.vanished].if_null[false].not>
    - if <player.flag[tick_essentials.vanished].if_null[false]>:
        - foreach <player.location.find_entities.within[40].filter[target.equals[<player>]]> as:entity:
            - attack <[entity]> cancel
        - adjust <player> invulnerable:true
        - adjust <player> hide_from_players
        - adjust <player> affects_monster_spawning:false
    - else:
        - adjust <player> invulnerable:false
        - adjust <player> hide_from_players:false
        - adjust <player> affects_monster_spawning:true
    - narrate "<element[Tick's Essentials].format[tickutil_text_prefix]> <&[success]>'<player.name>' is <player.flag[tick_essentials.vanished].if_true[now vanished].if_false[no longer vanished]>!"
