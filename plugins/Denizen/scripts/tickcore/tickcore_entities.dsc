# @ ----------------------------------------------------------
# TickCore Entities
# All my custom mobs. Will be separated into different folders
# in the future.
# Author: 0TickPulse
# @ ----------------------------------------------------------

cool_mob:
    type: entity
    entity_type: zombie

    mechanisms:
        custom_name: Really cool mob
        equipment:
            helmet: diamond_helmet
            chestplate: diamond_chestplate
            leggings: diamond_leggings
            boots: diamond_boots
    data:
        tickcore:
            level_modifiers:
                damage_physical: 2
                attack_speed: 0.2
                defense_physical: 1
                health: 10
            stats:
                damage_physical: 15
                attack_speed: 15
                defense_physical: 90
                health: 10
            drops:
                remove_vanilla: true
                exp: 5
                money: 10
                items: stone|cobblestone
            death_messages:
            - <element[<[entity].custom_name.if_null[<[entity].translated_name>]> was too cool for <[victim].proc[tick_chat_format_player_name]>].format[tickcore_util_formatter_death_message]>