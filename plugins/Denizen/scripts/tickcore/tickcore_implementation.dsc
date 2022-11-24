# @ ----------------------------------------------------------
# TickCore Implementation
# My main implementation of TickCore. Adds slashes, an
# elemental combat system, item abilities, stat links,
# damage indicators, etc.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tickcore_impl_event_util:
    type: task
    debug: false
    script:
    - customevent id:<[tickcore_impl_event_util_data.event]> context:<[tickcore_impl_event_util_data.context].if_null[<map>]> save:event
    - if <entry[event].was_cancelled> && <[tickcore_impl_event_util_data.cancellable]>:
        - stop
    - define args <[tickcore_impl_event_util_data.determination_args]>
    - inject command_manager.generate_arg_maps
    - foreach <entry[event].determination_list> as:determination:
        - define determination_unfiltered.<[tickcore_impl_event_util_data.determination].before[:]> <[determination].after[:]>

    - define _linear_args <[args].filter_tag[<[filter_value.type].equals[linear].if_null[true]>]>

    - foreach <[_linear_args]> key:argname as:map:
        - foreach <[flag_args.linear_args].if_null[<list>]> as:value:
            - if <[map.accepted].parsed.if_null[true]>:
                - define determinations.<[argname]> <[value]>
                - goto potato
        - mark potato

    - define _prefixed_args <[args].filter_tag[<[filter_value.type].equals[prefixed].if_null[false]>]>
    - foreach <[flag_args.linear_args].if_null[<list>]> as:excluded:
        - if <[determinations].values> contains <[excluded]>:
            - foreach next
        - if <[_prefixed_args]> contains <[excluded]>:
            - define flag_args.prefixed_args.<[excluded]> true
        - else if <[_linear_args].keys.size> >= <[loop_index]>:
            - debug error "Unknown determination '<[excluded]>'! <[_linear_args].keys.size.is_more_than_or_equal_to[<[loop_index]>].if_true[(here, you are supposed to input <[linear_args].keys.get[<[loop_index]>]>)].if_false[]>"
    - foreach <[_prefixed_args]> key:argname as:map:
        - foreach <[flag_args.prefixed_args].if_null[<map>]> key:flag as:value:
            - if <[flag]> == <[argname]>:
                - if <[map.accepted].parsed.if_null[true]>:
                    - define determinations.<[argname]> <[value]>
                    - define flag_args.prefixed_args <[flag_args.prefixed_args].exclude[<[argname]>]>
                - else:
                    - narrate "<&[error]>The prefixed determination '<[argname]>' is invalid!<[map.explanation].exists.if_true[ This arg requires: '<[map.explanation]>'].if_false[]>"

    - if <[determinations].exists>:
        - foreach <[determinations]> key:argname as:map:
            - define value <[determinations.<[argname]>]>
            - define determinations.<[argname]> <[args.<[argname]>.result].parsed.if_null[<[value]>]>
        - foreach <[args]> key:argname as:map:
            - if <[determinations].keys> !contains <[argname]>:
                - if <[map.required].parsed.if_null[false]>:
                    - narrate "<&[error]>Missing <[map.type].if_null[null].equals[prefixed].if_true[prefixed ].if_false[]>determination '<[argname]>'!"
                    - stop
                - if <[map.default].exists>:
                    - define determinations.<[argname]> <[map.default].parsed>

tickcore_stat_link:
    type: world
    debug: false
    events:
        on custom event id:tickcore_entity_spawns:
        - adjust <context.entity> max_health:<context.stats.get[max_health].if_null[<context.entity.health_max>]>
        on delta time secondly:
        - foreach <server.online_players> as:__player:
            - adjust <player> max_health:<player.proc[tickcore_proc.script.players.get_stat].context[max_health]>

tickcore_prevent_place_gear:
    type: world
    debug: false
    events:
        on player places block:
        - if <context.item_in_hand.proc[tickcore_proc.script.items.is_tickitem]>:
            - if <context.item_in_hand.proc[tickcore_proc.script.items.get_stat].context[implementations].contains_any[weapon_melee]>:
                - determine cancelled

tickcore_run_slash:
    type: task
    debug: false
    definitions: data|element_map|entity
    data:
        determination args:
            slash_data:
                type: prefixed
                required: false
                accepted: <[value].as[map].exists>
                result: <[value].proc[slash_get_locations_proc].parse[points_between[<[entity].location>].distance[0.15].get[1].to[3]].combine>
            targets:
                type: prefixed
                required: false
                accepted: <[value].as[list].exists>
                result: <[value].proc[slash_get_entities_in_locations_proc].exclude[<[entity]>]>
            element_map:
                type: prefixed
                required: false
                accepted: <[value].as[map].exists>
                result: <[value]>
            source:
                type: prefixed
                required: false
                accepted: <[value].as[entity].exists>
                result: <[value]>
            cause:
                type: prefixed
                required: false
                accepted: <server.damage_causes.contains[<[value]>]>
                result: <[value]>
    script:
    - define locations <[data].proc[slash_get_locations_proc].parse[points_between[<[entity].location>].distance[0.15].get[1].to[3]].combine>
    - foreach <[element_map]> key:element as:value:
        - if <[value]> <= 0:
            - foreach next
        - inject tickcore_effect_data path:slash_effects.<[element]>
    - definemap damage_data:
            slash_data: <[data]>
            targets: <[data].proc[slash_get_entities_in_locations_proc].exclude[<[entity]>]>
            element_map: <[element_map]>
            source: <[entity]>
            cause: magic

    #event|cancellable|context|determination_args
    - definemap tickcore_impl_event_util_data:
            event: tickcore_entity_slash
            cancellable: true
            context: <[damage_data]>
            determination_args: <script.data_key[data.determination args]>

    - inject tickcore_impl_event_util

    - definemap new_damage_data:
            slash_data: <[determinations.slash_data].if_null[<[damage_data.slash_data]>]>
            targets: <[determinations.targets].if_null[<[damage_data.targets]>]>
            element_map: <[determinations.element_map].if_null[<[damage_data.element_map]>]>
            source: <[determinations.source].if_null[<[damage_data.source]>]>
            cause: <[determinations.cause].if_null[<[damage_data.cause]>]>

    - if <[element_map].keys> !contains physical:
        - playsound <[entity].location> sound:entity_player_attack_sweep
    - run tickcore_impl_do_damage_task defmap:<[new_damage_data]>

tickcore_custom_attack:
    type: world
    debug: false
    events:
        after player left clicks block:
        - if !<[entity].exists>:
            - define entity <player>
        - if <[entity].item_in_hand> matches air || !<[entity].item_in_hand.proc[tickcore_proc.script.items.is_tickitem]>:
            - stop
        - if <player.item_in_hand.proc[tickcore_proc.script.items.get_stat].context[implementations]> !contains weapon_melee:
            - stop
        - if <[entity].proc[tickcore_proc.script.entities.get_stat].context[attack_speed]> != 0:
            - ratelimit <[entity]> <element[1].div[<[entity].proc[tickcore_proc.script.entities.get_stat].context[attack_speed]>].as[duration]>
        - else:
            - stop
        - define element_map <map>
        - if !<player.item_in_hand.proc[tickcore_proc.script.items.is_tickitem]>:
            - stop
        - foreach <proc[tickcore_proc.script.core.get_all_stat_ids]> as:stat_id:
            - if !<[stat_id].starts_with[damage_]>:
                - foreach next
            - define element_map.<[stat_id].after[damage_]> <[entity].proc[tickcore_proc.script.entities.get_stat].context[<[stat_id]>]>
        - definemap data:
                location: <[entity].eye_location>
                radius: <[entity].proc[tickcore_proc.script.entities.get_stat].context[reach_distance].if_null[3]>
                rotation: <util.random.decimal[0].to[180]>
                points: 30
                arc: 180
        - run tickcore_run_slash def.data:<[data]> def.element_map:<[element_map]> def.entity:<[entity]>
        on player damages entity ignorecancelled:true:
        - if <context.cause> != entity_attack:
            - stop
        - if !<player.location.facing[<context.entity.location>]>:
            - stop
        - if <context.entity.entity_type> in <script[tickcore_impl_data].data_key[damage indicator blacklist]>:
            - stop
        - determine passively cancelled
        - define entity <player>
        - inject tickcore_custom_attack "path:events.after player left clicks block"
        on entity damages entity:
        - if <context.cause> != entity_attack:
            - stop
        - define entity <context.damager>
        - determine passively cancelled
        - foreach <proc[tickcore_proc.script.core.get_all_stat_ids]> as:stat_id:
            - if !<[stat_id].starts_with[damage_]>:
                - foreach next
            - define element_map.<[stat_id].after[damage_]> <[entity].proc[tickcore_proc.script.entities.get_stat].context[<[stat_id]>]>
        - run tickcore_impl_do_damage_task def.targets:<context.entity> def.element_map:<[element_map]> def.source:<[entity]> def.crit_chance:<[entity].proc[tickcore_proc.script.entities.get_stat].context[crit_chance]>


tickcore_impl_do_damage_task:
    type: task
    debug: false
    definitions: targets|element_map|source|cause|knockback|crit_chance|trigger_event
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

        - definemap damage_data:
                element_map: <[new_element_map]>
                knockback: <[knockback].if_null[1]>
                trigger_event: <[trigger_event].if_null[true]>
        - flag <[source]> tickcore_impl.last_damage_data:<[damage_data]> expire:2t
        - if <[amount]> == 0:
            - foreach next
        - if !<[target].is_spawned>:
            - foreach next

        - hurt <[amount]> <[target]> source:<[source]> cause:<[cause].if_null[magic]>
        - adjust <[target]> no_damage_duration:0

tickcore_impl_damage_indicators:
    type: world
    debug: false
    events:
        on entity damaged:
        - determine clear_modifiers
        on entity damaged bukkit_priority:monitor:
        # Blacklist
        - if <context.entity.entity_type> in <script[tickcore_impl_data].data_key[damage indicator blacklist]>:
            - stop
        ## Corrects magic damage (witches have a natural resistance to magic damage)
        #- if <context.entity> matches witch:
        #    - define last_damage_amount <context.final_damage.mul[20].div[3]>
        #- else:

        - define last_damage_amount <context.final_damage>
        - random:
            - define location <context.entity.location.left[1.2].random_offset[0.2,0.5,0.2]>
            - define location <context.entity.location.right[1.2].random_offset[0.2,0.5,0.2]>
        - if <[last_damage_amount]> == 0:
            - stop
        - define new_element_map <map>

        - define damage_data <context.damager.flag[tickcore_impl.last_damage_data].if_null[null]>
        - define trigger_event <[damage_data.trigger_event].if_null[true]>

        - define damager_element_map <[damage_data.element_map].if_null[null]>

        # Knockback, only if custom elemental damage
        - if <[damager_element_map]> != null:
            - if <context.damager> == <context.entity>:
                - define velocity <context.entity.velocity.add[0,0.1,0]>
            - else:
                - define velocity <context.entity.velocity.add[<context.damager.location.face[<context.entity.location>].direction.vector.add[<context.damager.velocity>].div[2]>]>
            # Account for knockback modifier + knockback resistance
            - adjust <context.entity> velocity:<[velocity].mul[<[damage_data.knockback].if_null[1]>].mul[<context.entity.proc[tickcore_proc.script.entities.get_stat].context[knockback_resistance].if_null[<context.entity.attribute_value[generic_knockback_resistance]>].mul[-1].add[1]>]>

        # Calculate element map
        - if <[damager_element_map]> == null:
            - define new_element_map.physical <[last_damage_amount]>
        - else:
            - if <[damager_element_map].values.sum> == 0:
                - stop
            - foreach <[damager_element_map]> key:element as:element_damage:
                - define new_element_map.<[element]> <[element_damage].mul[<[last_damage_amount]>].div[<[damager_element_map].values.sum>]>

        - customevent id:custom_damage context:<map.with[source].as[<context.damager.if_null[null]>].with[damage_data].as[<[damage_data]>].with[entity].as[<context.entity>]>

        - define players <[location].find_players_within[50].if_null[<list>]>
        - if <[players].is_empty>:
            - stop
        - define element_displays <list>
        - foreach <[new_element_map]> key:element as:element_damage:
            - if <[element_damage]> != 0:
                - define element_displays:->:<script[icons].parsed_key[damage_indicators.<[element]>].if_null[<[element]>]><&sp.repeat[2]><[element_damage].round.to_list.parse_tag[<[parse_value]><&sp.repeat[2]>].unseparated.custom_color[<[element]>].font[tickmc:damage_indicators]>
        - define hologram <entity[armor_stand[visible=false;is_small=true;custom_name=<[element_displays].separated_by[  ]>;custom_name_visible=true]]>
        - fakespawn <[hologram]> <[location]> players:<[players]> duration:2s

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
                - if <[entity].is_player> && <[ability.cooldown message].if_null[true]>:
                    - definemap progress_bar:
                        from: 0
                        to: <[cooldown].in_seconds>
                        value: <[entity].flag_expiration[tickcore.cooldown.<[ability.script]>].from_now.in_seconds>
                        length: 15
                        characters: <script[tickutil_progress_bar_data].parsed_key[default_bar.characters]>
                        cursor: false
                    - actionbar "<[ability.name].color[white]> <proc[tickutil_progress_bar_proc].context[<[progress_bar].values>].custom_color[emphasis]> <gray><[entity].flag_expiration[tickcore.cooldown.<[ability.script]>].from_now.equals[<duration[0s]>].if_true[0s].if_false[<[entity].flag_expiration[tickcore.cooldown.<[ability.script]>].from_now.formatted>]>" targets:<[entity]>
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
        on custom event id:entity_runs_slash:
        - define trigger slash
        - define entity <context.source>
        - define context <context.data.if_null[<map>]>
        - inject <script> path:run_script
        on custom event id:custom_damage:
        - define entity <context.source>
        - if <[entity]> == null:
            - stop
        - define trigger custom_damage
        - define context <context.data.if_null[<map>]>
        - inject <script> path:run_script
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

        on entity damages entity:
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