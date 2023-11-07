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
        - define map <context.stats.get[max_health].if_null[null]>
        - if <[map]> == null:
            - stop
        - adjust <context.entity> max_health:<script[tickcore_data].parsed_key[stats.max_health.item stat calculation].if_null[<context.entity.health_max>]>
        # heal
        - heal <context.entity>
        on delta time secondly:
        - foreach <server.online_players> as:__player:
            - adjust <player> max_health:<player.proc[tickcore_proc.script.players.get_stat].context[max_health]>

tickcore_prevent_place_gear:
    type: world
    debug: false
    events:
        on player places block:
        - if <context.item_in_hand.proc[tickcore_proc.script.items.is_tickitem]>:
            - if <context.item_in_hand.proc[tickcore_proc.script.items.get_stat].context[implementations].contains_any[weapon_melee|weapon_staff]>:
                - determine cancelled
        on player breaks block:
        - if <player.item_in_hand.proc[tickcore_proc.script.items.is_tickitem]>:
            - if <player.item_in_hand.proc[tickcore_proc.script.items.get_stat].context[implementations].contains_any[weapon_melee|weapon_staff]>:
                - determine cancelled

# tickcore_run_stab:
    # type: task
    # debug: false
    # definitions: data|element_map|entity
    # script:
    # - define hand <[entity].main_hand.if_null[right]>
    # - if <[hand]> == right:
        # - define origin <[entity].eye_location.with_pitch[0].left[0.5].below[0.2]>
    # - else:
        # - define origin <[entity].eye_location.with_pitch[0].right[0.5].below[0.2]>
    # - define target <>
tickcore_run_slash:
    type: task
    debug: false
    definitions: data|element_map|entity|random_offsets
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
                accepted: <server.damage_causes.contains_single[<[value]>]>
                result: <[value]>
            crit_chance:
                type: prefixed
                required: false
                accepted: <[value].is_decimal>
                result: <[value]>
    script:
    - define locations <[data].proc[slash_get_locations_proc].parse[points_between[<[entity].location>].distance[0.15].get[1].to[3]].combine>

    - definemap damage_data:
            slash_data: <[data]>
            targets: <[data].proc[slash_get_entities_in_locations_proc].exclude[<[entity]>]>
            element_map: <[element_map]>
            source: <[entity]>
            cause: magic
            crit_chance: <[entity].proc[tickcore_proc.script.entities.get_stat].context[crit_chance]>

    #event|cancellable|context|determination_args
    - definemap tickcore_impl_event_util_data:
            event: tickcore_entity_slash
            cancellable: true
            context: <[damage_data]>
            determination_args: <script.data_key[data.determination args]>

    - inject tickcore_impl_event_util

    # TODO Can simplify this
    - definemap new_damage_data:
            slash_data: <[determinations.slash_data].if_null[<[damage_data.slash_data]>]>
            targets: <[determinations.targets].if_null[<[damage_data.targets]>]>
            element_map: <[determinations.element_map].if_null[<[damage_data.element_map]>]>
            source: <[determinations.source].if_null[<[damage_data.source]>]>
            cause: <[determinations.cause].if_null[<[damage_data.cause]>]>
            crit_chance: <[determinations.crit_chance].if_null[<[damage_data.crit_chance]>]>

    - if <[element_map].keys> !contains physical:
        - playsound <[entity].location> sound:entity_player_attack_sweep
    - run tickcore_impl_do_damage_task defmap:<[new_damage_data]>

    # Particles and sounds
    - foreach <[element_map]> key:element as:value:
        - if <[value]> > 0:
            - run tickcore_specialized_sounds_task def.element:<[element]> def.locations:<[entity].location>
    - foreach <[locations].sub_lists[<[locations].size.div[4].round_down>]> as:sub_locations:
        - foreach <[element_map]> key:element as:value:
            - if <[value]> <= 0:
                - foreach next
            - run tickcore_specialized_effects_task def.element:<[element]> def.locations:<[sub_locations]> def.entity:<[entity]> def.sound:false
        - wait 1t

tickcore_custom_attack:
    type: world
    debug: false
    events:
        #after player animates arm_swing:
        #- flag <player> tickimpl.cursor_is_on_block:<player.cursor_on[4].exists> expire:2t
        after player left clicks block:
        - if !<[entity].exists>:
            - define entity <player>
        #- if <[entity].flag[tickimpl.cursor_is_on_block].if_null[false]> && <[entity].cursor_on[4].exists>:
        #    - stop
        #- flag <[entity]> tickimpl.cursor_is_on_block:<[entity].cursor_on[4].exists> expire:2t

        # Trigger a left click event for other scripts
        - definemap context:
                item: <[entity].item_in_hand>
        - customevent context:<[context]> id:custom_event_left_click

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
                location: <[entity].eye_location.random_offset[0.5,0.5,0.5]>
                radius: <[entity].proc[tickcore_proc.script.entities.get_stat].context[reach_distance].if_null[3]>
                rotation: <util.random.decimal[0].to[180]>
                points: 30
                arc: 180
        - run tickcore_run_slash def.data:<[data]> def.element_map:<[element_map]> def.entity:<[entity]> def.random_offsets:0.5,0.5,0.5
        on player damages entity ignorecancelled:true:
        - if <context.cause> != entity_attack:
            - stop
        - if <player.eye_location.precise_target_list[4]> !contains <context.entity>:
            - stop
        - if <context.entity.entity_type> in <script[tickcore_impl_data].data_key[damage indicator blacklist]>:
            - stop
        - determine passively cancelled
        - define entity <player>
        - inject tickcore_custom_attack "path:events.after player left clicks block"
        #on entity damages entity:
        #- if <context.cause> != entity_attack:
        #    - stop
        #- define entity <context.damager>
        #- determine passively cancelled
        #- foreach <proc[tickcore_proc.script.core.get_all_stat_ids]> as:stat_id:
        #    - if !<[stat_id].starts_with[damage_]>:
        #        - foreach next
        #    - define element_map.<[stat_id].after[damage_]> <[entity].proc[tickcore_proc.script.entities.get_stat].context[<[stat_id]>]>
        #- run tickcore_impl_do_damage_task def.targets:<context.entity> def.element_map:<[element_map]> def.source:<[entity]> def.crit_chance:<[entity].proc[tickcore_proc.script.entities.get_stat].context[crit_chance]>

tickcore_impl_calculate_damage_proc:
    type: procedure
    debug: false
    definitions: entity|element|element_damage|crit_chance
    script:
    - if !<[crit_chance].exists>:
        - define crit_chance <[source].proc[tickcore_proc.script.entities.get_stat].context[crit_chance]>
    - define has_crit <util.random_chance[<[crit_chance].mul[100]>].if_null[false]>
    - if <[has_crit]>:
        - define element_damage:*:<[source].proc[tickcore_proc.script.entities.get_stat].context[crit_damage].add[1]>
    - define element_damage:*:<[source].proc[tickcore_proc.script.entities.get_stat].context[additional_damage_<[element]>].add[1]>
    - determine <[element_damage]>
tickcore_impl_do_damage_task:
    type: task
    debug: false
    definitions: targets|element_map|source|cause|knockback|crit_chance[not required]|trigger_event[boolean]
    script:
    - foreach <[targets]> as:target:
        - define amount 0
        - define new_element_map <map>
        - foreach <[element_map]> key:element as:element_damage:
            - if <[target].proc[tickcore_proc.script.entities.is_tickentity]>:
                - define target_defense <[target].proc[tickcore_proc.script.entities.get_stat].context[defense_<[element]>].if_null[null]>
                - if <[target_defense]> == null:
                    - define target_defense 0
                - define to_add <[element_damage].mul[<element[1].sub[<[target_defense].div[<[target_defense].abs.add[100]>]>]>]>
            - else:
                - define to_add <[element_damage]>
            - if !<[crit_chance].exists>:
                - define crit_chance <[source].proc[tickcore_proc.script.entities.get_stat].context[crit_chance]>
            - define has_crit <util.random_chance[<[crit_chance].mul[100]>].if_null[false]>
            - if <[has_crit]>:
                - define to_add:*:<[source].proc[tickcore_proc.script.entities.get_stat].context[crit_damage].add[1]>
            - define to_add:*:<[source].proc[tickcore_proc.script.entities.get_stat].context[additional_damage_<[element]>].add[1]>
            - define new_element_map.<[element]>:<[to_add]>
            - define amount:+:<[to_add]>

        - define defense <[target].proc[tickcore_proc.script.entities.get_stat].context[defense].if_null[0]>
        - define amount <[amount].mul[<element[1].sub[<[defense].div[<[defense].abs.add[100]>]>]>]>

        - definemap damage_data:
                element_map: <[new_element_map]>
                knockback: <[knockback].if_null[1]>
                trigger_event: <[trigger_event].if_null[true]>
                crit: <[has_crit].if_null[false]>
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
        #on entity damaged:
        #- determine clear_modifiers
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
            - define location <context.entity.location.above[1.5].left[1.2].random_offset[0.2,0.5,0.2]>
            - define location <context.entity.location.above[1.5].right[1.2].random_offset[0.2,0.5,0.2]>
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
                - define element_displays:->:<script[icons].parsed_key[damage_indicators.<[element]>].if_null[<[element]>]><&sp><[element_damage].round.custom_color[<[element]>]>
        #- define hologram <entity[armor_stand[visible=false;is_small=true;custom_name=<[element_displays].separated_by[  ]>;custom_name_visible=true]]>
        #- fakespawn <[hologram]> <[location]> players:<[players]> duration:2s
        # use display entites
        - fakespawn text_display[text=<[element_displays].separated_by[ ]>;interpolation_duration=0.2s;scale=0,0,0;pivot=center;see_through=true;background_color=0,0,0,0;opacity=255] <[location]> players:<[players]> duration:5s save:display
        # interpolate the scale
        - define display <entry[display].faked_entity>
        - if <[damage_data.crit].if_null[false]>:
            - adjust <[display]> scale:3.5,3.5,3.5
        - else:
            - adjust <[display]> scale:2,2,2
        - wait 0.2s
        # - adjust <[display]> interpolation_duration:4s
        # - adjust <[display]> scale:0,0,0
        # - wait 4s
        # - remove <[display]>

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
            - if <[entity].is_player>:
                - define energy <[ability.energy].if_null[0]>
                - if <[entity].flag[tickcore_energy_system.energy]> < <[energy]>:
                    - actionbar "<&[error]>Not enough energy!" targets:<[entity]>
                    - foreach next
                # consume energy
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
            - if <[energy].exists>:
                - run tickcore_energy_system_add_energy_task def.player:<[entity]> def.amount:<[energy].mul[-1]>
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
        on custom event id:custom_event_left_click:
        - define trigger <player.is_sneaking.if_true[sneak_left_click].if_false[left_click]>
        - definemap contxt:
                item: <context.item.if_null[null]>
        - define entity <player>
        - inject <script> path:run_script
        on player right clicks block:
        - if <player.proc[tickcore_is_looking_at_interactable]>:
            - stop
        - define trigger <player.is_sneaking.if_true[sneak_right_click].if_false[right_click]>
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

        on custom event id:custom_arrow_hit:
        - define trigger custom_arrow_hit
        - definemap context:
                point: <context.point>
                collide_result: <context.collide_result>
                element_map: <context.element_map>
                entity: <context.entity>
        - define entity <context.entity>
        - inject <script> path:run_script

        on custom event id:player_consumes_tickcore_item:
        - define trigger player_consumes_tickcore_item
        - definemap context:
                item: <context.item.if_null[null]>
        - define entity <player>
        - inject <script> path:run_script

tickcore_consumable_override_world:
    type: world
    debug: false
    events:
        on player consumes item:
        - define item <context.item>
        - if !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
            - stop
        - if <[item].proc[tickcore_proc.script.items.get_stat].context[implementations]> !contains consumable:
            - stop
        - determine passively cancelled
        - if <player.gamemode.is_in[survival|adventure]>:
            - take iteminhand quantity:1
        - customevent id:player_consumes_tickcore_item context:<map.with[item].as[<[item]>]>
        - adjust <player> health:<player.health.add[<[item].proc[tickcore_proc.script.items.get_stat].context[restores_health]>]>
        - adjust <player> food_level:<player.food_level.add[<[item].proc[tickcore_proc.script.items.get_stat].context[restores_food]>].min[20]>
        - adjust <player> saturation:<player.saturation.add[<[item].proc[tickcore_proc.script.items.get_stat].context[restores_saturation]>]>
        - foreach <[item].proc[tickcore_proc.script.items.get_stat].context[effect_modifiers]> as:modifier:
            - define effect <[modifier].split[ ].get[1]>
            - define duration <[modifier].split[ ].get[2].as[duration]>
            - define amplifier <[modifier].split[ ].get[3].if_null[1]>
            - cast <[effect]> amplifier:<[amplifier].sub[1]> duration:<[duration]> <player>
