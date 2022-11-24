# @ ----------------------------------------------------------
# Tick's Essentials
# A collection of useful things, similar to EssentialsX
# plugin.
# Author: 0TickPulse
# @ ----------------------------------------------------------


tick_essentials_proc:
    type: procedure
    script:
        visible_players:
        - define viewer <[1].if_null[null]>
        - if <[viewer]> == null:
            - determine <server.online_players>
        - determine <server.online_players.filter[flag[tick_essentials.vanished].if_null[false].not]>
        online_players:
        - determine <server.online_players>

tick_essentials_back_command_logger_world:
    type: world
    debug: false
    enabled: <script[tick_essentials_data].data_key[commands.world.back].if_null[true]>
    events:
        on player teleports:
        - flag <player> tick_essentials.back_location:<context.origin>

tick_essentials_gamemode_fake_op_world:
    type: world
    debug: false
    enabled: <script[tick_essentials_data].data_key[commands.staff.gamemode.fake op].if_null[false]>
    events:
        after player joins permission:tick_essentials.command.staff.gamemode:
        - adjust <player> fake_op_level:4