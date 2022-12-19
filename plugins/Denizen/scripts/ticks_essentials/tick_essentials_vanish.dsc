tick_essentials_vanish_can_see:
    type: procedure
    definitions: viewer|player
    debug: false
    script:
    - if <[viewer].has_permission[<static[<script[tick_essentials_staff_vanish_command].data_key[permission]>]>]>:
        - determine true
    - if <[player].flag[tick_essentials.vanished].if_null[false]>:
        - determine false
    - determine true

tick_essentials_get_visible_players_proc:
    type: procedure
    debug: false
    script:
    - if !<player.exists>:
        - determine <server.online_players>
    - determine <server.online_players.filter_tag[<player.proc[tick_essentials_vanish_can_see].context[<[filter_value]>]>]>
tick_essentials_get_all_visible_players_proc:
    type: procedure
    debug: false
    script:
    - if !<player.exists>:
        - determine <server.players>
    - determine <server.players.filter_tag[<player.proc[tick_essentials_vanish_can_see].context[<[filter_value]>]>]>

tick_essentials_vanish_world:
    type: world
    debug: false
    events:
        on entity targets player:
        - if <player.flag[tick_essentials.vanished].if_null[false]>:
            - determine cancelled
        on server list ping:
        - determine exclude_players:<server.online_players.filter[flag[tick_essentials.vanished].if_null[false]]>