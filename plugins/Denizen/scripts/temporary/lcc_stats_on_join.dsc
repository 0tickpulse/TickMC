# lcc_firstjoin_command:
#     type: command
#     name: firstjoin
#     description: Manages the lcc_first_join flag
#     usage: /firstjoin [check <&lt>player<&gt>]/[add|remove <&lt>player/*<&gt>]
#     permission: lcc.command.firstjoin
#     debug: false
#     tab completions:
#         1: add|remove|check
#         2: <server.players.parse[name]>
#     script:
#     # check arg count
#     - if <context.args.length> < 2:
#         - narrate "<red>Usage: /firstjoin add|remove|check <&lt>player<&gt>"
#         - stop

#     # check operation
#     - define operation <context.args.get[1]>
#     - if <[operation]> !in add|remove|check:
#         - narrate "<red>Invalid operation!<n>Usage: /firstjoin add|remove|check <&lt>player<&gt>"
#         - stop

#     # check player
#     - define name <context.args.get[2]>
#     - if <[name]> == *:
#         - define players <server.players>
#     - else:
#         - define players <server.match_offline_player[<[name]>].if_null[null]>
#         - if <[players]> == null:
#             - narrate "<red>Player not found!"
#             - stop
#         - define players <list[<[players]>]>

#     - choose <[operation]>:
#         - case add:
#             - foreach <[players]> as:__player:
#                 - flag <player> lcc_first_join
#             - narrate "<green>Added first join flag to <[players].parse[name].comma_separated>!"
#         - case remove:
#             - foreach <[players]> as:__player:
#                 - flag <player> lcc_first_join:!
#             - narrate "<green>Removed first join flag from <[players].parse[name].comma_separated>"
#         - case check:
#             - foreach <[players]> as:__player:
#                 - if <player.has_flag[lcc_first_join]>:
#                     - narrate "<green><player.name> has the first join flag"
#                 - else:
#                     - narrate "<red><player.name> does not have the first join flag"

# stats_on_join:
#     type: world
#     debug: false
#     data:
#         group: guest
#         advancements:
#         - lcc:root
#     events:
#         after player join:
#         # wait until player is fully loaded
#         - wait 5s
#         - waituntil <player.mcmmo.level[alchemy].exists>

#         # check for alchemy (ignores first join flag)
#         - if <player.mcmmo.level[alchemy]> < 10:
#             - mcmmo set levels skill:alchemy quantity:10

#         # check for flag
#         - if <player.has_flag[lcc_first_join]>:
#             - stop

#         # set flag
#         - flag <player> lcc_first_join

#         # set group
#         - group add <script.parsed_key[data.group]>

#         # grant root advancement
#         - foreach <script.parsed_key[data.advancements]> as:adv:
#             - adjust <player> award_advancement:<[adv]>

#         - mcmmo set levels skill:alchemy quantity:10

#         # set karma
#         - scoreboard add objective:karma score:50 lines:<player>
