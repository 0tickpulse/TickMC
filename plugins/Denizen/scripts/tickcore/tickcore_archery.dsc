# @ ----------------------------------------------------------
# TickCore Archery
# Overhauls the archery system in Minecraft.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tickcore_archery_world:
    type: world
    debug: false
    events:
        on entity shoots bow:
        - if !<context.bow.proc[tickcore_proc.script.items.is_tickitem].if_null[false]>:
            - stop

        - if !<context.bow.proc[tickcore_proc.script.items.get_stat].context[implementations].contains_any[weapon_bow]>:
            - stop

        - determine passively cancelled

        - define element_map <map>
        - foreach <proc[tickcore_proc.script.core.get_all_stat_ids]> as:stat_id:
            - if !<[stat_id].starts_with[damage_]>:
                - foreach next
            - define element_map.<[stat_id].after[damage_]> <context.entity.proc[tickcore_proc.script.entities.get_stat].context[<[stat_id]>].mul[<context.force.div[3]>]>
            # ^^ Multiply by force because force is the damage multiplier
        - definemap data:
            range: <context.entity.proc[tickcore_proc.script.entities.get_stat].context[arrow_range]>
            speed: <context.entity.proc[tickcore_proc.script.entities.get_stat].context[arrow_speed].div[100].add[1].mul[<context.force.div[2.1]>]>
            # ^^ Divide by 100 because the stat is a percentage
        - run tickcore_archery_shoot_task def.data:<[data]> def.entity:<context.entity> def.element_map:<[element_map]>

        # Consume arrow
        - take item:arrow

tickcore_archery_point_is_colliding_proc:
    type: procedure
    debug: false
    definitions: point|entity|distance
    script:
    - define ray <[point].ray_trace[range=<[distance]>;entities=*;ignore=<[entity]>].if_null[null]>
    # No blocks
    - if <[ray]> == null:
        - determine <map[type=none]>
    # Block
    - define entities <[ray].find.living_entities.within[0.2].exclude[<[entity]>]>
    - if <[entities].size> > 0:
        - determine <map[type=entity].with[entities].as[<[entities]>]>
    - determine <map[type=block].with[location].as[<[point]>]>

tickcore_archery_shoot_task:
    type: task
    debug: false
    definitions: data[Map with range, speed]|element_map|entity|origin|target
    script:
    - if !<queue.definitions.contains[origin]>:
        - define origin <[entity].eye_location>
    - if !<queue.definitions.contains[target]>:
        - define target <[origin].forward[<[data.speed]>]>
    - define point <[origin].face[<[target]>]>
    - playsound sound:entity_arrow_shoot <[origin]>
    - define distance_for_each_tick <[data.speed]>
    - define gravitational_acceleration 0.04
    - define gravity <[gravitational_acceleration]>

    - define target <[point].forward[<[distance_for_each_tick]>].below[<[gravity]>]>
    - define collide_result <[point].proc[tickcore_archery_point_is_colliding_proc].context[<[entity]>|<[distance_for_each_tick]>]>
    - define cumulative_distance 0
    - while <[collide_result].get[type]> == none:
        - if <[cumulative_distance]> > <[data.range]>:
            - stop
        - define target <[point].forward[<[distance_for_each_tick]>].below[<[gravity]>]>
        - define cumulative_distance:+:<[point].distance[<[target]>]>
        - define points <[target].points_between[<[point]>].distance[0.2]>
        - foreach <[element_map]> key:element as:value:
            - if <[value]> <= 0:
                - foreach next
            - run tickcore_specialized_effects_task def.element:<[element]> def.locations:<[points]> def.entity:<[entity]> def.sound:false def.offset:0,0,0
        - define point <[target]>
        - define collide_result <[point].proc[tickcore_archery_point_is_colliding_proc].context[<[entity]>|<[distance_for_each_tick]>]>
        # Gravitational acceleration
        - define gravity:+:<[gravitational_acceleration]>
        - wait 1t

    - definemap context:
        point: <[point].ray_trace[range=<[distance_for_each_tick]>;default=air]>
        collide_result: <[collide_result]>
        element_map: <[element_map]>
        entity: <[entity]>
    - customevent id:custom_arrow_hit context:<[context]>

    - define points <[point].ray_trace[range=<[distance_for_each_tick]>;default=air].points_between[<[point]>].distance[0.2]>
    - foreach <[element_map]> key:element as:value:
        - if <[value]> <= 0:
            - foreach next
        - run tickcore_specialized_effects_task def.element:<[element]> def.locations:<[points]> def.entity:<[entity]> def.sound:false def.offset:0,0,0

    - playsound sound:entity_arrow_hit <[point]> pitch:1.5 volume:3

    - if <[collide_result.type]> == entity:
        - run tickcore_impl_do_damage_task def.source:<[entity]> def.targets:<[collide_result.entities]> def.element_map:<[element_map]>
