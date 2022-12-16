tick_essentials_vanish_can_see:
    type: procedure
    definitions: viewer|player
    script:
    - if <[viewer].has_permission[<static[<script[tick_essentials_staff_vanish_command].data_key[permission]>]>]>:
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
        on server list ping:
        - determine exclude_players:<server.online_players.filter[flag[tick_essentials.vanished].if_null[false]]>