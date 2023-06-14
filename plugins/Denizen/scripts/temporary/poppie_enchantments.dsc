# enchant_on_click_data:
#     type: data

#     # Multiplies the enchantment XP cost.
#     # This makes it so there's still an incentive to use an enchanting table, but also let experienced/rich players enchant more conveniently.
#     # Set to 1 to disable this feature.
#     enchant cost multiplier: 1

#     # Conditions to check before enchanting an item.
#     # The key can be anything, but it's recommended to use a descriptive name.
#     # The value is a map with the following keys:
#     #   condition: The condition to check. If this condition is false, the player will not be able to enchant the item.
#     #   error: The error message to send to the player if the condition is false. If this is not specified, a default error message will be sent.
#     enchant conditions:
#         permission_1:
#             condition: <player.has_permission[enchant_on_click.apply]>
#             error: You do not have permission to enchant items!

# enchant_on_click_world:
#     type: world
#     debug: false
#     events:
#         on player left clicks item in inventory:
#         # Config
#         - define config <static[<script[enchant_on_click_data].data_key[]>]>

#         # Definitions to organize stuff
#         - define item <context.item>
#         - define target_item <[item]>
#         - define cursor_item <context.cursor_item>
#         - define cursor_enchants <[cursor_item].enchantment_map>

#         # If the item is air or the cursor item isn't a book, stop. This is a quick optimization as it reduces unnecessary processing.
#         - if <[item]> matches air || <[cursor_item]> !matches enchanted_book:
#             - stop

#         - define xp_cost 0
#         - foreach <[cursor_enchants]> key:enchant_name as:level:
#             - define enchant <enchantment[<[enchant_name]>]>
#             # If the enchantment is not applicable to the item, stop.
#             - if !<[enchant].can_enchant[<context.item>]>:
#                 - narrate "<&[error]>You cannot enchant <[item].display_name.if_null[<[item].material.translated_name>]> with <[enchant].name>!"
#                 - stop
#             - define xp_cost:+:<[enchant].min_cost[<[level]>]>

#         # Error if the player doesn't have enough XP.
#         - define xp_cost:*:<[config.enchant cost multiplier]>
#         - if <[xp_cost]> > <player.calculate_xp>:
#             - narrate "<&[error]>You do not have enough XP to enchant <[item].display_name.if_null[<[item].material.translated_name>]>! (Cost: <[xp_cost]>, your xp: <player.calculate_xp>)"
#             - stop

#         - foreach <[config.enchant conditions]> key:condition_name as:condition_map:
#             - if !<[condition_map.condition].parsed>:
#                 - narrate <&[error]><[condition_map.error].if_null[You do not satisfy the condition <[condition_name]>!]>
#                 - stop

#         # From this point onwards, the player has clicked an item with an enchanted book in their cursor.
#         # We can assume that the player has the required XP to enchant the item.
#         # Therefore, we will take the XP from the player and enchant the item.

#         - experience take <[xp_cost]>

#         # Enchant the item
#         - foreach <[cursor_enchants]> key:enchant_name as:level:
#             - define enchant <enchantment[<[enchant_name]>]>
#             - adjust def:target_item enchantments:<[item].enchantment_map.include[<[cursor_enchants]>]>

#         # Re-set the item in the inventory
#         - inventory set d:<context.clicked_inventory> slot:<context.slot> o:<[target_item]>

#         - take cursoritem
# #
