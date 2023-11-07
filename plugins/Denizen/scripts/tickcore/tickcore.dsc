# @ ----------------------------------------------------------
# TickCore
# The main TickCore script. Adds a fully customizable stat
# system for entities, items, and mobs.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tickcore_recalculate_stats_task:
    type: task
    debug: false
    script:
    - flag <player> tickcore.stat_map:<player.proc[tickcore_proc.script.players.get_stat_map_raw]>
tickcore_apply_stats_to_players_world:
    type: world
    debug: false
    events:
        after delta time secondly every:3:
        - foreach <server.online_players> as:__player:
            - run tickcore_recalculate_stats_task
        after player scrolls their hotbar:
        - run tickcore_recalculate_stats_task
        after player clicks item in inventory:
        - ratelimit <player> 2t
        - run tickcore_recalculate_stats_task
        after player equips item:
        - ratelimit <player> 2t
        - run tickcore_recalculate_stats_task
        after player unequips item:
        - ratelimit <player> 2t
        - run tickcore_recalculate_stats_task
        after player consumes item:
        - run tickcore_recalculate_stats_task
        after player item takes damage:
        - run tickcore_recalculate_stats_task
        # An event which MythicCrucible forgot about
        after player breaks held item:
        - run tickcore_recalculate_stats_task
        after player drops item:
        - run tickcore_recalculate_stats_task
        after player picks up item:
        - wait 1t
        - run tickcore_recalculate_stats_task
        after player dies:
        - run tickcore_recalculate_stats_task
        after player respawns:
        - run tickcore_recalculate_stats_task
        after player joins:
        - run tickcore_recalculate_stats_task

tickcore_spawn_mob_task:
    type: task
    debug: false
    definitions: id|level
    script:
    - define level <[level].if_null[0]>
    - customevent id:tickcore_entity_prespawns context:[id=<[id]>] save:prespawn_event
    - if <entry[prespawn_event].was_cancelled>:
        - stop
    - spawn <[id].proc[tickcore_proc.script.entities.generate]> save:entity
    - define entity <entry[entity].spawned_entity>
    - define stats <script[<[id]>].parsed_key[data.tickcore.stats].parse_value_tag[<map[base=<[parse_value]>]>]>
    - adjust def:entity custom_name_visible:false
    # Add level modifiers
    - foreach <script[<[id]>].parsed_key[data.tickcore.level_modifiers].if_null[<map>]> key:modifier_stat as:modifier_stat_value:
        - define stats.<[modifier_stat]>.LEVEL <[modifier_stat_value].mul[<[level]>]>
    - flag <[entity]> tickcore.id:<[id]>
    - flag <[entity]> tickcore.level:<[level]>
    - flag <[entity]> tickcore.stats:<[stats]>
    - customevent id:tickcore_entity_spawns context:[id=<[id]>;entity=<[entity]>;stats=<[stats]>] save:spawn_event
tickcore_proc:
    type: procedure
    debug: false
    script:
        util:
            sign_prefix:
            - if <[1]> >= 0:
                - determine +<[1]>
            - else:
                - determine <[1]>
        core:
            get_all_stat_ids:
            - determine <script[tickcore_data].list_keys[stats]>
        items:
            get_all_scripts:
            - determine <util.scripts.filter[container_type.equals[ITEM]].filter[data_key[data.tickcore].exists]>
            get_all_ids:
            - determine <proc[tickcore_proc.script.items.get_all_scripts].parse[name]>
            # definitions: original_item|attribute_map
            add_attribute:
            - define attribute_map <[2].parse_value_tag[<list[<map[operation=ADD_NUMBER;amount=<[parse_value]>]>]>]>
            - determine <[1].with_single[attribute_modifiers=<[1].attribute_modifiers.include[<[attribute_map]>]>]>
            # definitions: item|stat
            get_stat:
            - if !<[1].proc[tickcore_proc.script.items.is_tickitem]>:
                - stop
            - define map <[1].flag[tickcore.stats.<[2]>].if_null[null]>
            - if <[map]> == null:
                - determine null
            - determine <script[tickcore_data].parsed_key[stats.<[2]>.item stat calculation]>
            # definitions: item
            get_stat_map:
            - if !<[1].proc[tickcore_proc.script.items.is_tickitem]>:
                - determine <map>
            - determine <[1].flag[tickcore.stats]>
            get_stat_map_simple:
            - determine <[1].proc[tickcore_proc.script.items.get_stat_map].parse_value_tag[<[1].proc[tickcore_proc.script.items.get_stat].context[<[parse_key]>]>]>
            # definitions: item
            is_tickitem:
            - if <[1].material.name> == air:
                - determine false
            - determine <[1].has_flag[tickcore.stats]>
            generate:
            - define id <[1]>
            - define default_nonstackable_item_properties <script[tickcore_data].parsed_key[default nonstackable properties].if_null[<map>]>
            - define default_item_properties <script[tickcore_data].parsed_key[default properties].if_null[<map>]>
            - define item_data <script[<[id]>].data_key[data].if_null[null]>
            - define stat_global_map <script[tickcore_data].data_key[stats].if_null[null]>

            - if <[item_data]> == null || <[stat_global_map]> == null:
                - stop

            - define item <[id].as[item]>
            - if <[item].material.max_stack_size> == 1:
                - define item <[item].with_map[<[default_nonstackable_item_properties]>]>
            - define item <[item].with_map[<[default_item_properties]>]>

            # Stat manager
            - define stat_map <[item_data.tickcore.stats].parse_value_tag[<map.with[base].as[<[parse_value]>]>].if_null[null]>
            - if <[stat_map]> == null:
                - debug error "Item '<[id]>' is missing a data.tickcore.stats key in the item script!"
                - stop
            - define item <[item].proc[tickcore_proc.script.items.override_stats].context[<[stat_map]>]>

            # Flag the item
            - define item <[item].with_flag[tickcore.id:<[id]>]>

            # Return the item
            - determine <[item]>
            # definitions: item|stat_map
            override_stats:
            - define item <[1]>
            - define stat_map <[2]>
            - define stat_global_map <script[tickcore_data].data_key[stats].if_null[null]>
            - define lore <list>
            - define stats_to_add "<script[tickcore_data].data_key[lore order]>"
            - define item <[item].with_flag[tickcore.stats:<[stat_map]>]>
            - foreach <[stats_to_add]> as:stat_id:
                - if <[stat_map].keys> !contains <[stat_id]>:
                    - if <proc[tickcore_proc.script.core.get_all_stat_ids]> !contains <[stat_id]>:
                        - define lore:->:<[stat_id].parsed>
                    - foreach next
                - define map <[stat_map.<[stat_id]>].parse_value_tag[<[parse_value].parsed>]>
                - define value <[stat_global_map.<[stat_id]>.item stat calculation].parsed>
                - if <[stat_global_map.<[stat_id]>].keys> contains "new item on generate":
                    - define item "<[stat_global_map.<[stat_id]>.new item on generate].parsed>"

                - foreach "<[stat_global_map.<[stat_id]>.lore format]>" as:line:
                    - define lore:->:<[line].parsed.parsed>
                - define value:!
            # Flag the item
            # Add the generated lore to the item
            - define item <[item].with[lore=<[lore]>]>
            - determine <[item]>
            add_stats:
            - define item <[1]>
            - define stat_map <[2]>
            - define old_stat_map <[1].proc[tickcore_proc.script.items.get_stat_map]>
            - foreach <[stat_map]> key:stat as:modifier_map:
                - foreach <[modifier_map]> key:modifier as:value:
                    - define old_stat_map.<[stat]>.<[modifier]> <[value]>
            - determine <[item].proc[tickcore_proc.script.items.override_stats].context[<[old_stat_map]>]>
        entities:
            get_level:
            - determine <[1].flag[tickcore.level].if_null[0]>
            is_tickentity:
            - if <[1].is_player>:
                - determine true
            - determine <[1].has_flag[tickcore.stats]>
            get_stat:
            - if <[1].is_player>:
                - determine <[1].proc[tickcore_proc.script.players.get_stat].context[<[2]>]>
            - if <[2]> !in <proc[tickcore_proc.script.core.get_all_stat_ids]>:
                - debug error "<[2]> is not a valid TickCore stat!"
                - stop
            - define map <[1].proc[tickcore_proc.script.entities.get_stat_map].get[<[2]>].if_null[<map[DEFAULT=<script[tickcore_data].parsed_key[stats.<[2]>.entity default].if_null[null]>]>]>
            - determine <script[tickcore_data].parsed_key[stats.<[2]>.player stat calculation]>
            get_stat_map:
            - define entity <[1]>
            - if <[entity].is_player>:
                - determine <[entity].proc[tickcore_proc.script.players.get_stat_map]>
            - define map <map>
            - if !<[entity].equipment_map.exists>:
                - determine <map>
            - foreach <[entity].equipment_map.include[hand=<[entity].item_in_hand.if_null[<item[stone]>]>;offhand=<[entity].item_in_offhand.if_null[<item[stone]>]>].if_null[<map>]> key:slot as:item:
                - if <[item].material.name> == AIR || !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
                    - foreach next
                - foreach <proc[tickcore_proc.script.core.get_all_stat_ids]> as:stat:
                    - if <[item].proc[tickcore_proc.script.items.get_stat].context[<[stat]>]> != null:
                        - define map.<[stat]>.ITEM_<[slot]> <[item].proc[tickcore_proc.script.items.get_stat].context[<[stat]>]>
            - determine <[entity].flag[tickcore.stats].if_null[<map>].include[<[map]>]>
            get_all_scripts:
            - determine <util.scripts.filter[container_type.equals[ENTITY]].filter[data_key[data.tickcore].exists]>
            get_all_ids:
            - determine <proc[tickcore_proc.script.entities.get_all_scripts].parse[name]>
            generate:
            - define id <[1]>
            - define entity_data <script[<[id]>].data_key[data].if_null[null]>
            - define stat_global_map <script[tickcore_data].data_key[stats].if_null[null]>

            - if <[entity_data]> == null || <[stat_global_map]> == null:
                - stop

            - define entity <[id].as[entity]>

            # Return the entity
            - determine <[entity]>
        players:
            get_stat_map:
            - determine <[1].flag[tickcore.stat_map].if_null[<[1].proc[tickcore_proc.script.players.get_stat_map_raw]>]>
            get_stat_map_raw:
            - define __player <[1]>
            - define map <map>
            - foreach <script[tickcore_data].data_key[player items to check for stats].parse[parsed.as[map]].if_null[<list>]> as:slot_map:
                - define item <[slot_map.item]>
                - define slot <[slot_map.name]>
                - if <[item].material.name> == AIR || !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
                    - foreach next
                - define implementations <[item].proc[tickcore_proc.script.items.get_stat].context[implementations]>
                - foreach <proc[tickcore_proc.script.core.get_all_stat_ids]> as:stat:
                    - if <[item].proc[tickcore_proc.script.items.get_stat].context[<[stat]>]> != null && <[implementations].parse_tag[<script[tickcore_data].data_key[implementation slots.<[parse_value]>]>].combine.if_null[<list>]> contains <[slot]>:
                        - define map.<[stat]>.ITEM_<[slot]> <[item].proc[tickcore_proc.script.items.get_stat].context[<[stat]>]>
            - foreach <proc[tickcore_proc.script.core.get_all_stat_ids]> as:stat:
                - if <script[tickcore_data].data_key[stats.<[stat]>].keys> contains "entity default":
                    - define map.<[stat]>.DEFAULT <script[tickcore_data].parsed_key[stats.<[stat]>.entity default]>
            - determine <[map]>
            # definitions: player|stat
            get_stat:
            - define map <[1].proc[tickcore_proc.script.players.get_stat_map].get[<[2]>].if_null[<map[DEFAULT=<script[tickcore_data].parsed_key[stats.<[2]>.item default].if_null[null]>]>]>
            - if <[map]> == null:
                - determine null
            - determine <script[tickcore_data].parsed_key[stats.<[2]>.player stat calculation]>
# Utility procedure scripts
# Item updater
tickcore_update_item:
    type: procedure
    debug: false
    definitions: item
    script:
    - if !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
        - determine <[item]>
    - define new_item <[item].script.name.proc[tickcore_proc.script.items.generate]>
    - define old_modifier_map <[item].proc[tickcore_proc.script.items.get_stat_map].parse_value_tag[<[parse_value].exclude[BASE]>]>
    - determine <[new_item].proc[tickcore_proc.script.items.add_stats].context[<[old_modifier_map]>]>
tickcore_update_items_task:
    type: task
    debug: false
    definitions: inventory
    script:
    - define contents <[inventory].list_contents>
    - foreach <[contents]> as:item:
        - if !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
            - foreach next
        - define contents <[contents].overwrite[<[item].proc[tickcore_update_item]>].at[<[loop_index]>]>
    - adjust <[inventory]> contents:<[contents]>
    - determine <[inventory]>
tickcore_update_items_world:
    type: world
    debug: false
    events:
        on player opens inventory:
        - stop if:<script[tickcore_data].data_key[item updating.container open].if_null[true].not>
        - if <context.inventory.id_holder.object_type> == location:
            - run tickcore_update_items_task def:<context.inventory>
        on player picks up item:
        - stop if:<script[tickcore_data].data_key[item updating.item pickup].if_null[true].not>
        - determine ITEM:<context.item.proc[tickcore_update_item]>

tickcore_main_command:
    type: command
    debug: false
    name: tickcore
    aliases:
    - tc
    description: tickcore main command.
    usage: <script[tickcore_main_command].proc[command_manager_generate_usage]>
    data:
        enable_subcommands: true
        subcommand_permissions:
            getitem:
            - tickcore.command.main.getitem
            getstat:
            - tickcore.command.main.getstat
            giveitem:
            - tickcore.command.main.giveitem
            statmap:
            - tickcore.command.main.statmap
            modifyitemstat:
            - tickcore.command.main.modifyitemstat
            updateitems:
            - tickcore.command.main.updateitem
            spawnmob:
            - tickcore.command.main.spawnmob
            damage:
            - tickcore.command.main.damage
        subcommands:
            getitem:
                item:
                    type: linear
                    accepted: <proc[tickcore_proc.script.items.get_all_ids].contains[<[value]>]>
                    tab completes: <proc[tickcore_proc.script.items.get_all_ids]>
                    required: true
                    result: <[value].proc[tickcore_proc.script.items.generate]>
            getstat:
                stat:
                    type: linear
                    accepted: <proc[tickcore_proc.script.core.get_all_stat_ids].contains[<[value]>]>
                    tab completes: <proc[tickcore_proc.script.core.get_all_stat_ids]>
                    required: true
                player:
                    template: player
            giveitem:
                item:
                    type: linear
                    accepted: <proc[tickcore_proc.script.items.get_all_ids].contains[<[value]>]>
                    tab completes: <proc[tickcore_proc.script.items.get_all_ids]>
                    required: true
                    result: <[value].proc[tickcore_proc.script.items.generate]>
                player:
                    template: player
            statmap:
                player:
                    template: player
                raw:
                    template: boolean_default_false
            modifyitemstat:
                player: template=visible_player
                stat:
                    type: linear
                    accepted: <proc[tickcore_proc.script.core.get_all_stat_ids].contains[<[value]>]>
                    tab completes: <proc[tickcore_proc.script.core.get_all_stat_ids]>
                    required: true
                value:
                    type: linear
                    required: true
            updateitems:
                player: template=visible_player
            spawnmob:
                mob:
                    type: linear
                    accepted: <proc[tickcore_proc.script.entities.get_all_ids].contains[<[value]>]>
                    tab completes: <proc[tickcore_proc.script.entities.get_all_ids]>
                    required: true
                level:
                    template: integer
                    required: false
                    default: 0
            damage:
                source:
                    type: linear
                    accepted: <[value].as[entity].exists.or[<server.online_players.parse[name].contains_single[<[value]>]>]>
                    tab completes: <server.online_players.parse[name].include[<player.target.uuid.if_null[]>].filter[equals[].not]>
                    required: true
                    result: <[value].as[entity].if_null[<server.match_player[<[value]>]>]>
                target:
                    type: linear
                    accepted: <[value].as[entity].exists.or[<server.online_players.parse[name].contains_single[<[value]>]>]>
                    tab completes: <server.online_players.parse[name].include[<player.target.uuid.if_null[]>].filter[equals[].not]>
                    required: true
                    result: <[value].as[entity].if_null[<server.match_player[<[value]>]>]>
                amount:
                    template: integer
                    required: true
                element:
                    type: linear
                    accepted: <[value].is_in[<script[tickcore_data].data_key[elements]>]>
                    tab completes: <script[tickcore_data].data_key[elements]>
                    required: false
                    default: physical
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - choose <[subcommand]>:
        - case getitem:
            - give <[arg.item]>
        - case getstat:
            - narrate <[arg.player].proc[tickcore_proc.script.players.get_stat].context[<[arg.stat]>]>
        - case giveitem:
            - give <[arg.item]> player:<[arg.player]>
        - case statmap:
            - narrate <[arg.player].proc[tickcore_proc.script.players.get_stat_map<[arg.raw].if_true[_raw].if_false[]>].to_yaml>
        - case modifyitemstat:
            - define item <[arg.player].item_in_hand>
            - if !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
                - narrate "You must be holding a tick item to modify its stats."
                - stop
            - define original_flag_map <[item].proc[tickcore_proc.script.items.get_stat_map]>
            - define original_flag_map.<[arg.stat]>.MODIFYITEMSTAT_COMMAND <[arg.value]>
            - define item <[item].proc[tickcore_proc.script.items.override_stats].context[<[original_flag_map]>]>
            - inventory set slot:hand o:<[item]>
        - case updateitems:
            - run tickcore_update_items_task def:<[arg.player].inventory>
        - case spawnmob:
            - run tickcore_spawn_mob_task def.id:<[arg.mob]> def.level:<[arg.level]>
        - case damage:
            - run tickcore_impl_do_damage_task def.targets:<[arg.target]> def.source:<[arg.source]> def.element_map:<map.with[<[arg.element]>].as[<[arg.amount]>]>
# tickcore_main_command:
#     type: command
#     debug: false
#     name: tickcore
#     aliases:
#     - ti
#     description: tickcore main command.
#     usage: /tickcore [getitem [item]/getstat [stat] (player)/giveitem [player] [item]/statmap (player)/modifyitemstat [stat] [value]]
#     data:
#         tab_complete:
#             2:
#                 getitem: <proc[tickcore_proc.script.items.get_all_ids]>
#                 giveitem: <server.online_players.parse[name]>
#                 getstat: <proc[tickcore_proc.script.core.get_all_stat_ids]>
#                 statmap: <server.online_players.parse[name]>
#                 modifyitemstat: <proc[tickcore_proc.script.core.get_all_stat_ids]>
#                 spawnmob: <proc[tickcore_proc.script.entities.get_all_ids]>
#     tab completions:
#         1: getitem|giveitem|getstat|statmap|updateitems|modifyitemstat|spawnmob
#         2: <script.parsed_key[data.tab_complete.2.<context.args.get[1]>].if_null[]>
#         3: <context.args.get[1].is_in[giveitem|getstat].if_true[<proc[tickcore_proc.script.items.get_all_ids]>].if_false[]>
#     permission: tickcore.command.main
#     script:
#     - if <context.args.size> < 1:
#         - narrate <&[error]><script.data_key[usage]>
#         - stop
#     - choose <context.args.get[1]>:

#         - case getitem:
#             - if <context.args.size> < 2:
#                 - narrate <&[error]><script.data_key[usage]>
#                 - stop
#             - define id <context.args.get[2]>
#             - if <proc[tickcore_proc.script.items.get_all_ids]> !contains <[id]>:
#                 - narrate "<&[error]>Invalid item ID!"
#                 - stop
#             - give <[id].proc[tickcore_proc.script.items.generate]>

#         - case giveitem:
#             - if <context.args.size> < 3:
#                 - narrate <&[error]><script.data_key[usage]>
#                 - stop
#             - define player <server.match_player[<context.args.get[2]>].if_null[null]>
#             - if <[player]> == null:
#                 - narrate "<&[error]>Invalid player name!"
#                 - stop
#             - adjust <queue> linked_player:<[player]>
#             - define id <context.args.get[3]>
#             - if <proc[tickcore_proc.script.items.get_all_ids]> !contains <[id]>:
#                 - narrate "<&[error]>Invalid item ID!"
#                 - stop
#             - give <[id].proc[tickcore_proc.script.items.generate]>

#         - case getstat:
#             - if <context.args.size> < 2:
#                 - narrate <&[error]><script.data_key[usage]>
#                 - stop
#             - define stat <context.args.get[2]>
#             - if <context.args.size> >= 3 || !<player.exists>:
#                 - if <proc[tickcore_proc.script.core.get_all_stat_ids]> !contains <[stat]>:
#                     - narrate "<&[error]>Invalid stat ID!"
#                     - stop
#                 - define player <server.match_player[<context.args.get[3]>].if_null[null]>
#                 - if <[player]> == null:
#                     - narrate "<&[error]>Invalid player name!"
#                     - stop
#                 - adjust <queue> linked_player:<[player]>
#             - narrate <player.proc[tickcore_proc.script.players.get_stat].context[<[stat]>]>

#         - case statmap:
#             - if <context.args.size> > 1 || !<player.exists>:
#                 - define player <server.match_player[<context.args.get[2]>].if_null[null]>
#                 - if <[player]> == null:
#                     - narrate "<&[error]>Invalid player name!"
#                     - stop
#                 - adjust <queue> linked_player:<[player]>
#             - narrate <player.proc[tickcore_proc.script.players.get_stat_map_raw].to_yaml>

#         - case updateitems:
#             - foreach <server.players.parse[inventory]> as:inventory:
#                 - run tickcore_update_items_task def:<[inventory]>
#             - narrate "<&[success]>Updated items!"

#         - case modifyitemstat:
#             - if !<player.exists>:
#                     - narrate "<&[error]>Only a player can run this."
#                     - stop
#             - define item <player.item_in_hand>
#             - if !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
#                 - narrate "<&[error]>This is not a TickCore item."
#                 - stop
#             - if <context.args.size> < 3:
#                 - narrate <&[error]><script.data_key[usage]>
#             - define stat_id <context.args.get[2]>
#             - if <proc[tickcore_proc.script.core.get_all_stat_ids]> !contains <[stat_id]>:
#                 - narrate "<&[error]>Invalid stat ID!"
#                 - stop
#             - define stat_value <context.args.get[3]>

#             - define original_flag_map <[item].proc[tickcore_proc.script.items.get_stat_map]>
#             - define original_flag_map.<[stat_id]>.MODIFYITEMSTAT_COMMAND <[stat_value]>
#             - define item <[item].proc[tickcore_proc.script.items.override_stats].context[<[original_flag_map]>]>
#             - inventory set slot:hand o:<[item]>

#         - case spawnmob:
#             - define location <context.args.get[3].to[last].separated_by[,].as[location].if_null[null]>
#             - if <[location]> == null:
#                 - if <player.exists>:
#                     - define location <player.location>
#                 - else:
#                     - narrate "<&[error]>Please specify a location."
#                     - stop
#             - define id <context.args.get[2]>
#             - if <proc[tickcore_proc.script.entities.get_all_ids]> !contains <[id]>:
#                 - narrate "<&[error]>Invalid entity ID!"
#                 - stop

#             - define level <context.args.get[3].if_null[0]>

#             - run tickcore_task path:script.entities.spawnmob def:<[id]>|<[level]>

#         - default:
#             - narrate <&[error]><script.data_key[usage]>
#             - stop
