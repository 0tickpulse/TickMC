# karma_icon:
#     type: procedure
#     definitions: player
#     debug: false
#     data:
#         fallback: &c☠
#         karma_icons:
#             0-19: &c☠
#             20-39: &c💀
#             40-59: &f☯
#             60-79: &2🤍
#             80-150: &a🤍
#     script:
#     - adjust <queue> linked_player:<[player]>
#     - define karma <placeholder[objective_score_karma]>
#     - foreach <script.data_key[data.karma_icons]> key:range as:icon:
#         - define split <[range].split[-]>
#         - define min <[split].get[1]>
#         - define max <[split].get[2]>
#         - if <[karma]> >= <[min]> && <[karma]> <= <[max]>:
#             - define karma_icon <[icon]>
#             - foreach stop
#     - determine <[karma_icon].if_null[<script.data_key[data.fallback]>].parse_color>

# tnt_pearl_debug:
#     type: world
#     debug: false
#     events:
#         after primed_tnt explodes:
#         - ratelimit <context.location.block> 1s
#         - define pearl <context.location.find_entities[ender_pearl].within[10]>
#         - announce "Pearl location: <[pearl].first.location.xyz.if_null[<[pearl]>]>"
#         - announce "Own location: <context.location.xyz>"
