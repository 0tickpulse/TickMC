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
        - define element_map <map>
        - foreach <proc[tickcore_proc.script.core.get_all_stat_ids]> as:stat_id:
            - if !<[stat_id].starts_with[damage_]>:
                - foreach next
            - define element_map.<[stat_id].after[damage_]> <player.proc[tickcore_proc.script.players.get_stat].context[<[stat_id]>]>
        - definemap data:
                location: <player.eye_location>
                radius: <player.proc[tickcore_proc.script.players.get_stat].context[reach_distance].if_null[3]>
                rotation: <util.random.decimal[0].to[180]>
                points: 50
                arc: 180
        - run tickcore_run_slash def.data:<[data]> def.element_map:<[element_map]> def.entity:<player>
        on player damages entity ignorecancelled:true:
        - if <context.cause> != entity_attack:
            - stop
        - if !<player.location.facing[<context.entity.location>]>:
            - stop
        - inject tickcore_custom_attack "path:events.after player left clicks block"

tickcore_impl_do_damage_task:
    type: task
    debug: false
    definitions: targets|element_map|source|cause|knockback
    script:
    - foreach <[targets]> as:target:
        - define amount 0
        - define new_element_map <map>
        - foreach <[element_map]> key:element as:element_damage:
            - if <[target].proc[tickcore_proc.script.entities.is_tickentity]>:
                - define target_resistance <[target].proc[tickcore_proc.script.entities.get_stat].context[resistance_<[element]>].if_null[null]>
                - if <[target_resistance]> == null:
                    - define target_resistance 0
                - define amount:+:<[element_damage].mul[<element[1].sub[<[target_resistance]>]>]>
                - define new_element_map.<[element]>:<[element_damage].mul[<element[1].sub[<[target_resistance]>]>]>
            - else:
                - define amount:+:<[element_damage]>
                - define new_element_map.<[element]>:<[element_damage]>
        - if <[amount]> == 0:
            - stop
        - if !<[target].is_spawned>:
            - stop
        - random:
            - define location <[target].location.left[1.2].random_offset[0.2,0.2,0.2]>
            - define location <[target].location.right[1.2].random_offset[0.2,0.2,0.2]>
        - adjust <[target]> velocity:<[target].velocity.add[<[source].location.face[<[target].location>].direction.vector.add[<[source].velocity>].div[2]>]>
        - define players <[location].find_players_within[50].if_null[<list>]>
        - if <[players].is_empty>:
            - stop
        - define element_displays <list>

        - hurt <[amount]> <[target]> source:<[source]> cause:<[cause].if_null[entity_attack]>
        - define last_damage_amount <[target].last_damage.amount.if_null[<[amount]>]>
        - define multiplier <[last_damage_amount].div[<[amount]>]>

        - foreach <[new_element_map]> key:element as:element_damage:
            - if <[element_damage]> != 0:
                - define element_displays:->:<script[tickcore_effect_data].parsed_key[symbol.<[element]>].if_null[<[element]>]><&sp.repeat[2]><[element_damage].mul[<[multiplier]>].round>
        - define hologram <entity[armor_stand[visible=false;is_small=true;custom_name=<[element_displays].separated_by[  ]>;custom_name_visible=true]]>
        - fakespawn <[hologram]> <[location]> players:<[players]> duration:2s

tickcore_no_attack:
    type: world
    debug: false
    events:
        on player damages entity:
        - if <context.cause> == ENTITY_ATTACK:
            - determine cancelled

tickcore_crit:
    type: world
    debug: false
    events:
        # Crit system
        on entity damaged by player:
        - define has_crit <util.random_chance[<player.proc[tickcore_proc.script.players.get_stat].context[crit_chance].mul[100]>]>
        - if !<[has_crit]>:
            - stop
        - define damage <context.final_damage.mul[<element[1].add[<player.proc[tickcore_proc.script.players.get_stat].context[crit_damage]>]>]>
        - definemap context:
                entity: <context.entity.if_null[null]>
                damager: <context.damager.if_null[null]>
                cause: <context.cause.if_null[null]>
                damage: <context.damage.if_null[null]>
                final_damage: <context.final_damage.if_null[null]>
                projectile: <context.projectile.if_null[null]>
                damage_type_map: <context.damage_type_map.if_null[null]>
                was_vanilla_crit: <context.was_critical.if_null[null]>
                damage_after_crit: <[damage]>
        - customevent id:player_crits_entity
        - determine <[damage]>
        on custom event id:player_crits_entity:
        - narrate "You crit!"

        # Defense calculations
        on player damaged:
        - define defense <player.proc[tickcore_proc.script.players.get_stat].context[defense]>
        - define damage_reduction <[defense].div[<[defense].add[100]>]>
        - determine <context.final_damage.mul[<element[1].sub[<[damage_reduction]>]>]>

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
            - run <[ability.script]> def.data:<[ability.data].if_null[<map>]> def.context:<[context]> save:script
            - foreach <entry[script].created_queue.determination.if_null[<list>]> as:determination:
                - determine passively <[determination]>
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
                - define trigger sneak_right_click
        - else:
            - if <context.click_type.advanced_matches[LEFT_CLICK_*]>:
                - define trigger left_click
            - if <context.click_type.advanced_matches[RIGHT_CLICK_*]>:
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

        on player breaks block:
        - define trigger break_block
        - definemap context:
                location: <context.location.if_null[null]>
                material: <context.material.if_null[null]>
                xp: <context.xp.if_null[null]>
                should_drop_items: <context.should_drop_items.if_null[null]>
        - define entity <player>
        - inject <script> path:run_script

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