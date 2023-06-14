# lcc_health_temp_fix:
#     type: world
#     debug: false
#     events:
#         on player quits:
#         - flag <player> lcc_disconnect_health:<player.health>
#         after player joins flagged:lcc_disconnect_health:
#         - adjust <player> health:<player.flag[lcc_disconnect_health]>
