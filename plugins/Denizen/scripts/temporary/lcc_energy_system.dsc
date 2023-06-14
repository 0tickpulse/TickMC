# lcc_energy_system_task:
#     type: task
#     debug: false
#     enabled: false
#     data:
#         per_second: 1
#     script:
#     # Wait for mcmmo profile to load
#     - wait 5s
#     # add 1 energy to player
#     - scoreboard add objective:magic lines:<player> score:<placeholder[objective_score_magic].add[<script.data_key[data.per_second]>].min[<player.mcmmo.level[alchemy]>]>
#     # check for cap
#     - repeat 20:
#         - scoreboard add objective:magic lines:<player> score:<placeholder[objective_score_magic].min[<player.mcmmo.level[alchemy]>]>
#         - wait 1t

# lcc_energy_system_world:
#     type: world
#     debug: false
#     enabled: false
#     events:
#         on delta time secondly:
#         - foreach <server.online_players> as:__player:
#             - run lcc_energy_system_task
