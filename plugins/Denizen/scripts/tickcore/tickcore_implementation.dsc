# @ ----------------------------------------------------------
# TickCore Implementation
# My main implementation of TickCore. Adds slashes, an
# elemental combat system, item abilities, stat links,
# damage indicators, etc.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tickcore_stat_link:
    type: world
    debug: false
    events:
        on custom event id:tickcore_entity_spawns:
        - adjust <context.entity> max_health:<context.stats.get[max_health].if_null[<context.entity.health_max>]>
        on delta time secondly:
        - foreach <server.online_players> as:__player:
            - adjust <player> max_health:<player.proc[tickcore_proc.script.players.get_stat].context[max_health]>

tickcore_run_slash:
    type: task
    debug: false
    definitions: data|element_map|entity
    script:
    - define locations <[data].proc[slash_get_locations_proc].parse[points_between[<[entity].location>].distance[0.15].get[1].to[3]].combine>
    - foreach <[element_map]> key:element as:value:
        - if <[value]> <= 0:
            - foreach next
        - inject tickcore_effect_data path:slash_effects.<[element]>
    - definemap damage_data:
            targets: <[data].proc[slash_get_entities_in_locations_proc].exclude[<[entity]>]>
            element_map: <[element_map]>
            source: <[entity]>
            cause: magic
    - run tickcore_impl_do_damage_task defmap:<[damage_data]>
tickcore_custom_attack:
    type: world
    debug: false
    events:
        after player left clicks block:
        - if <player.proc[tickcore_proc.script.players.get_stat].context[attack_speed]> != 0:
            - ratelimit <player> <element[1].div[<player.proc[tickcore_proc.script.players.get_stat].context[attack_speed]>].as[duration]>
        - else:
            - stop
        - define element_map <map>
        - if !<player.item_in_hand.proc[tickcore_proc.script.items.is_tickitem]>:
            - stop
        - foreach <proc[tickcore_proc.script.core.get_all_stat_ids]> as:stat_id:
            - if !<[stat_id].starts_with[damage_]>:
                - foreach next
            - define element_map.<[stat_id].after[damage_]> <player.proc[tickcore_proc.script.players.get_stat].context[<[stat_id]>]>
        - definemap data:
                location: <player.eye_location>
                radius: <player.proc[tickcore_proc.script.players.get_stat].context[reach_distance].if_null[3]>
                rotation: <util.random.decimal[0].to[180]>
                points: 30
                arc: 180
        - run tickcore_run_slash def.data:<[data]> def.element_map:<[element_map]> def.entity:<player>
        on player damages entity ignorecancelled:true:
        - if <context.cause> != entity_attack:
            - stop
        - if !<player.location.facing[<context.entity.location>]>:
            - stop
        - if <context.entity.entity_type> in <script[tickcore_impl_data].data_key[damage indicator blacklist]>:
            - stop
        - determine passively cancelled
        - inject tickcore_custom_attack "path:events.after player left clicks block"

tickcore_impl_do_damage_task:
    type: task
    debug: false
    definitions: targets|element_map|source|cause|knockback|crit_chance
    script:
    - foreach <[targets]> as:target:
        - define amount 0
        - define new_element_map <map>
        - foreach <[element_map]> key:element as:element_damage:
            - if <[target].proc[tickcore_proc.script.entities.is_tickentity]>:
                - define target_defense <[target].proc[tickcore_proc.script.entities.get_stat].context[defense_<[element]>].if_null[null]>
                - if <[target_defense]> == null:
                    - define target_defense 0
                - define to_add <[element_damage].mul[<element[1].sub[<[target_defense].div[<[target_defense].add[100]>]>]>]>
            - else:
                - define to_add <[element_damage]>
            - define new_element_map.<[element]>:<[to_add]>
            - if !<[crit_chance].exists>:
                - define crit_chance <[source].proc[tickcore_proc.script.entities.get_stat].context[crit_chance]>
            - define has_crit <util.random_chance[<[crit_chance]>].if_null[false]>
            - if <[has_crit]>:
                - define amount:+:<[to_add].mul[<[source].proc[tickcore_proc.script.entities.get_stat].context[crit_damage].add[1]>]>
            - else:
                - define amount:+:<[to_add]>

        - define defense <[target].proc[tickcore_proc.script.entities.get_stat].context[defense].if_null[0]>
        - define amount <[amount].mul[<element[1].sub[<[defense].div[<[defense].add[100]>]>]>]>

        - flag <[source]> tickcore_impl.last_damage_element_map:<[new_element_map]> expire:2t
        - if <[amount]> == 0:
            - stop
        - if !<[target].is_spawned>:
            - stop
        - if <[source]> == <[target]>:
            - define velocity <[target].velocity.add[0,0.1,0]>
        - else:
            - define velocity <[target].velocity.add[<[source].location.face[<[target].location>].direction.vector.add[<[source].velocity>].div[2]>]>
        - adjust <[target]> velocity:<[velocity]>

        - hurt <[amount]> <[target]> source:<[source]> cause:<[cause].if_null[entity_attack]>

tickcore_impl_damage_indicators:
    type: world
    debug: false
    events:
        on entity damaged:
        # Blacklist
        - if <context.entity.entity_type> in <script[tickcore_impl_data].data_key[damage indicator blacklist]>:
            - stop
        # Corrects magic damage (witches have a natural resistance to magic damage)
        - if <context.entity.entity_type> == witch:
            - determine passively <context.final_damage.mul[20].div[3]>
            - define last_damage_amount <context.final_damage.mul[20].div[3]>
        - else:
            - define last_damage_amount <context.final_damage>
        - random:
            - define location <context.entity.location.left[1.2].random_offset[0.2,0.2,0.2]>
            - define location <context.entity.location.right[1.2].random_offset[0.2,0.2,0.2]>
        - if <[last_damage_amount]> == 0:
            - stop
        - define new_element_map <map>

        - define damager_element_map <context.damager.flag[tickcore_impl.last_damage_element_map].if_null[null]>
        - if <[damager_element_map]> == null:
            - define new_element_map.physical <[last_damage_amount]>
        - else:
            - if <[damager_element_map].values.sum> == 0:
                - stop
            - foreach <[damager_element_map]> key:element as:element_damage:
                - define new_element_map.<[element]> <[element_damage].mul[<[last_damage_amount]>].div[<[damager_element_map].values.sum>]>

        - define players <[location].find_players_within[50].if_null[<list>]>
        - if <[players].is_empty>:
            - stop
        - define element_displays <list>
        - foreach <[new_element_map]> key:element as:element_damage:
            - if <[element_damage]> != 0:
                - define element_displays:->:<script[icons].parsed_key[damage_indicators.<[element]>].if_null[<[element]>]><&sp.repeat[2]><[element_damage].round.to_list.parse_tag[<[parse_value]><&sp.repeat[2]>].unseparated.custom_color[<[element]>].font[damage_indicators]>
        - define hologram <entity[armor_stand[visible=false;is_small=true;custom_name=<[element_displays].separated_by[  ]>;custom_name_visible=true]]>
        - fakespawn <[hologram]> <[location]> players:<[players]> duration:2s



tickcore_trigger_non_player_abilities:
    type: task
    debug: false
    definitions: trigger|context|entity
    script:
    - define abilities <[entity].proc[tickcore_proc.script.players.get_stat].context[abilities]>
    - if <[abilities]> == null:
        - stop
    - define abilities <[abilities].combine.combine>
    - foreach <[abilities]> as:ability:
        - if <[ability.trigger].if_null[null]> == <[trigger]>:
            - define cooldown <[ability.cooldown].if_null[0s].as[duration]>
            - if <[entity].has_flag[tickcore.cooldown.<[ability.script]>]>:
                - if <[entity].is_player>:
                    - actionbar "<&[error]>This ability is on cooldown for <[entity].flag_expiration[tickcore.cooldown.<[ability.script]>].from_now.formatted>!" targets:<[entity]>
                - foreach next
            - flag <[entity]> tickcore.cooldown.<[ability.script]> expire:<[cooldown]>
            - run <[ability.script]> def.data:<[ability.data].if_null[<map>]> def.context:<[context]> save:script
            - foreach <entry[script].created_queue.determination.if_null[<list>]> as:determination:
                - determine passively <[determination]>
tickcore_trigger_abilities:
    type: task
    debug: false
    definitions: trigger|context|entity
    script:
    - define abilities <[entity].proc[tickcore_proc.script.entities.get_stat].context[abilities]>
    - if <[abilities]> == null:
        - stop
    - define abilities <[abilities].combine.combine>
    - foreach <[abilities]> as:ability:
        - if <[ability.trigger].if_null[null]> == <[trigger]>:
            - define cooldown <[ability.cooldown].if_null[0s].as[duration]>
            - if <[entity].has_flag[tickcore.cooldown.<[ability.script]>]>:
                - if <[entity].is_player>:
                    - actionbar "<&[error]>This ability is on cooldown for <[entity].flag_expiration[tickcore.cooldown.<[ability.script]>].from_now.formatted>!" targets:<[entity]>
                - foreach next
            - flag <[entity]> tickcore.cooldown.<[ability.script]> expire:<[cooldown]>
            - run <[ability.script]> def.entity:<[entity]> def.data:<[ability.data].if_null[<map>]> def.context:<[context]> save:script
            - foreach <entry[script].created_queue.determination.if_null[<list>]> as:determination:
                - determine passively <[determination]>

tickcore_is_looking_at_interactable:
    type: procedure
    debug: false
    data:
        interactables:
        - anvil
        - barrel
        - bed
        - bell
        - blast_furnace
        - brewing_stand
        - *_button
        - polished_blackstone_button
        - cartography_table
        - cauldron
        - chest
        - *_chest
        - command_block
        - composter
        - crafting_table
        - *_door
        - enchanting_table
        - end_portal_frame
        - *_fence_gate
        - furnace
        - daylight_detector
        - grindstone
        - item_frame
        - jukebox
        - lectern
        - lever
        - lodestone
        - loom
        - note_block
        - *_pressure_plate
        - pumpkin
        - respawn_anchor
        - *_shulker_box
        - smithing_table
        - smoker
        - spawner
        - stonecutter
        - tnt
        - *_trapdoor
        - repeater
        - comparator
        - dispenser
        - dropper
    definitions: player
    script:
    - define material <[player].cursor_on[4].material.name.if_null[air]>
    - foreach <script.data_key[data.interactables]> as:interactable:
        - if <[material]> matches <[interactable]>:
            - determine true
    - determine false

tickcore_ability_triggers:
    type: world
    debug: false
    run_script:
    - if !<[entity].exists>:
        - foreach <server.online_players> as:__player:
            - run tickcore_trigger_abilities save:script def.trigger:<[trigger]> def.context:<[context].if_null[<map>]> def.entity:<player>
            - foreach <entry[script].created_queue.determination.if_null[<list>]> as:determination:
                - determine passively <[determination]>
        - stop
    - run tickcore_trigger_abilities save:script def.trigger:<[trigger]> def.context:<[context].if_null[<map>]> def.entity:<[entity]>
    - foreach <entry[script].created_queue.determination.if_null[<list>]> as:determination:
        - determine passively <[determination]>

    events:
        on player clicks block:
        - if <player.is_sneaking>:
            - if <context.click_type.advanced_matches[LEFT_CLICK_*]>:
                - define trigger sneak_left_click
            - if <context.click_type.advanced_matches[RIGHT_CLICK_*]>:
                - if <player.proc[tickcore_is_looking_at_interactable]>:
                    - stop
                - define trigger sneak_right_click
        - else:
            - if <context.click_type.advanced_matches[LEFT_CLICK_*]>:
                - define trigger left_click
            - if <context.click_type.advanced_matches[RIGHT_CLICK_*]>:
                - if <player.proc[tickcore_is_looking_at_interactable]>:
                    - stop
                - define trigger right_click
        - definemap context:
                item: <context.item.if_null[null]>
                location: <context.location.if_null[null]>
                relative: <context.relative.if_null[null]>
                click_type: <context.click_type.if_null[null]>
                hand: <context.hand.if_null[null]>
        - define entity <player>
        - inject <script> path:run_script

        on player starts sneaking:
        - define trigger sneak
        - define entity <player>
        - inject <script> path:run_script

        on entity damages *:
        - define trigger attack
        - definemap context:
                entity: <context.entity.if_null[null]>
                damager: <context.damager.if_null[null]>
                cause: <context.cause.if_null[null]>
                damage: <context.damage.if_null[null]>
                final_damage: <context.final_damage.if_null[null]>
                projectile: <context.projectile.if_null[null]>
                damage_type_map: <context.damage_type_map.if_null[null]>
                was_critical: <context.was_critical.if_null[null]>
        - define entity <context.damager>
        - inject <script> path:run_script

        on delta time secondly:
        - define trigger secondly
        - inject <script> path:run_script

        on entity death:
        - define trigger death
        - definemap context:
                entity: <context.entity.if_null[null]>
                damager: <context.damager.if_null[null]>
                projectile: <context.projectile.if_null[null]>
                message: <context.message.if_null[null]>
                cause: <context.cause.if_null[null]>
                drops: <context.drops.if_null[null]>
                xp: <context.xp.if_null[null]>
        - define entity <context.entity>
        - inject <script> path:run_script

        on player walks:
        - define trigger walk
        - definemap context:
                old_location: <context.old_location.if_null[null]>
                new_location: <context.new_location.if_null[null]>
        - define entity <player>
        - inject <script> path:run_script

        # on player breaks block:
        # - define trigger break_block
        # - definemap context:
        #         location: <context.location.if_null[null]>
        #         material: <context.material.if_null[null]>
        #         xp: <context.xp.if_null[null]>
        #         should_drop_items: <context.should_drop_items.if_null[null]>
        # - define entity <player>
        # - inject <script> path:run_script

        on player joins:
        - define trigger join
        - definemap context:
                message: <context.message.if_null[null]>
        - define entity <player>
        - inject <script> path:run_script

        on player quits:
        - define trigger quit
        - definemap context:
                message: <context.message.if_null[null]>
        - define entity <player>
        - inject <script> path:run_script