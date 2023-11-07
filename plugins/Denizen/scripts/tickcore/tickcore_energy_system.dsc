# @ ----------------------------------------------------------
# TickCore Energy System
# A simple energy system that uses the TickCore API.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tickcore_energy_system_world:
    type: world
    debug: false
    events:
        after delta time secondly:
        - foreach <server.online_players> as:__player:
            - run tickcore_energy_system_add_energy_task def.player:<player> def.amount:1

tickcore_energy_system_add_energy_task:
    type: task
    debug: false
    definitions: player|amount
    script:
    - flag <[player]> tickcore_energy_system.energy:+:<[amount]>
    # Makes sure that the player's energy doesn't go over the max energy and doesn't go below 0.
    - flag <[player]> tickcore_energy_system.energy:<[player].flag[tickcore_energy_system.energy].min[<[player].proc[tickcore_proc.script.players.get_stat].context[max_energy]>].max[0]>

energy:
    type: procedure
    debug: false
    definitions: entity
    script:
    - determine <[entity].flag[tickcore_energy_system.energy].if_null[0]>
