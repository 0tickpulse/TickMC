# @ ----------------------------------------------------------
# Elevators
# A script that allows you to create elevators that move between floors.
# Based on Mcmonkey's [elevator script](https://forum.denizenscript.com/resources/incomplete-elevator-script.121/).
# Author: 0TickPulse, with help from mcmonkey
# @ ----------------------------------------------------------
tick_elevators_data:
    type: data
    elevators:
        test:
            name: test
            schematic: test
            location: 70,-60,-85,flat
            floors:
            - 0
            - 10
            - 20
        test2:
            name: test2
            schematic: test2
            location: 51,-61,-111,flat
            floors:
            - 0
            - 10
            - 30

tick_elevators_run_task:
    type: task
    definitions: elevator[An elevator to move.]|floor[The floor to move to.]
    debug: false
    script:
    # for now
    - define speed 0.25

    - if <server.has_flag[tick_elevators.elevators.<[elevator.name]>.in_progress]>:
        - debug error "Elevator '<[elevator.name]>' is already in progress!"
        - stop
    - flag server tick_elevators.elevators.<[elevator.name]>.in_progress

    - if !<schematic[<[elevator.schematic]>].exists>:
        - ~schematic load name:<[elevator.schematic]>
    - if !<schematic[<[elevator.schematic]>].exists>:
        - debug error "Elevator schematic '<[elevator.schematic]>' does not exist!"
        - stop

    - define elevator_cfg_location <[elevator.location].as[location]>

    - define floor_y <[elevator.floors].get[<[floor]>]>
    - define origin <schematic[<[elevator.schematic]>].origin>

    # Chunk loading
    - define chunks <list>
    - foreach <[elevator.floors]> as:floor:
        - define loc <[elevator_cfg_location].up[<[floor]>]>
        - define chunks:|:<schematic[<[elevator.schematic]>].cuboid[<[elevator_cfg_location]>].chunks.deduplicate>
    - chunkload add <[chunks]>

    # Preparation
    - define floor_1 <[elevator_cfg_location].up[<[elevator.floors].first>]>
    - define from_location <server.flag[tick_elevators.elevators.<[elevator.name]>.location].if_null[<[elevator_cfg_location]>]>
    - define end_location <[elevator_cfg_location].up[<[floor_y]>]>
    - define move_vec <[end_location].sub[<[from_location]>].normalize>
    - define dist <[end_location].distance[<[from_location]>]>
    - define area <schematic[<[elevator.schematic]>].cuboid[<[from_location]>].expand[0,5,0]>

    - define move <[move_vec].mul[<[speed]>]>

    # Delete old platform
    - define start_cuboid <schematic[<[elevator.schematic]>].cuboid[<[origin].with_world[<[from_location].world>]>]>
    - define block_ents <list>
    - foreach <[start_cuboid].blocks> as:rel_loc:
        - define mat <schematic[<[elevator.schematic]>].block[<[rel_loc]>]>
        - if <[mat]> matches air|*_air|structure_void:
            - foreach next
        - define block_loc <[from_location].add[<[rel_loc]>].sub[<[origin]>].block>
        - modifyblock <[block_loc]> air
        - spawn tick_elevators_block_entity[fallingblock_type=<[mat]>] <[block_loc].add[0.5,0.5,0.5]> save:e
        - define block_ents:->:<entry[e].spawned_entity>

    # Prepare for movement
    - define current_floor <[from_location]>
    - define start_area <schematic[<[elevator.schematic]>].cuboid[<[origin].with_world[<[from_location].world>]>].expand[0,10,0]>
    - define riders <[area].entities[player|npc|mob]>
    - foreach <[riders]> as:rider:
        - flag <[rider]> tick_elevators.temp_offset:<[rider].location.sub[<[from_location]>]> expire:1h
        - flag <[rider]> tick_elevators.temp_location:<[rider].location> expire:1s
        - adjust <[rider]> gravity:false
        - if <[move_vec].y> > 0.1:
            # Upwards
            - teleport <[rider]> <[rider].location.above[1]> relative
        # - else if <[move_vec].y> < -0.1:
            # Downwards
            # - teleport <[rider]> <[rider].location.below[0.5]> relative
    - define full_move <location[0,0,0]>

    # Move (TODO: speed option?)
    - repeat <[dist].div[<[speed]>]>:
        - define current_floor <[current_floor].add[<[move]>]>
        - define full_move <[full_move].add[<[move]>]>
        - define current_area <[area].shift[<[full_move]>]>

        # DEBUG current_area
        # - playeffect effect:fireworks_spark at:<[current_area].blocks> offset:0,0,0

        - foreach <[riders]> as:old_rider:
            - if !<[old_rider].is_spawned.if_null[false]>:
                - define riders:<-:<[old_rider]>
                - flag <[old_rider]> tick_elevators.temp_offset:!
            - else if !<[current_area].contains[<[old_rider].location>]>:
                - define riders:<-:<[old_rider]>
                - adjust <[old_rider]> gravity:true
                - flag <[old_rider]> tick_elevators.temp_offset:!
        - define new_riders <[current_area].entities[player|npc|mob].exclude[<[riders]>]>
        - adjust <[new_riders]> gravity:false
        - define riders:|:<[new_riders]>
        - foreach <[riders]> as:rider:
            - flag <[rider]> tick_elevators.fall_protect expire:5s
            - flag <[rider]> elevator_fallprotect expire:5s
            - if <[rider].object_type> != player:
                - define y_extra <[move].y.is_more_than[0].if_true[1].if_false[0.5]>
                - teleport <[rider]> <[current_area].add[<[rider].flag[tick_essentials.temp_offset]>].above[<[y_extra]>].with_pose[<[rider]>]>
                - adjust <[rider]> velocity:<[move]>
            - else:
                - if <[move_vec].y.abs> > 0.95:
                    - define rel <[rider].location.sub[<[rider].flag[tick_essentials.temp_location]||<[rider].location>>]>
                    - define y_off <[rider].has_flag[tick_essentials.temp_offset].if_true[<[current_area].y.add[<[rider].flag[tick_essentials.temp_offset].y>].sub[<[rider].location.y>]>].if_false[0]>
                    - define y <[move].y.add[<[y_off].is_less_than[-0.1].if_true[0.5].if_false[0]>]>
                    - adjust <[rider]> velocity:<[rel].mul[0.8].with_y[<[move].y>]>
                    #- teleport <[rider]> <[rider].location.with_y[<[rider].location.y.add[<[rel].y>]>]> relative
                    - flag <[rider]> tick_essentials.temp_location:<[rider].location> expire:1s
                - else:
                    - adjust <[rider]> velocity:<[move]>
        - foreach <[block_ents]> as:ent:
            - adjust <[ent]> velocity:<[move]>
        - wait 1t

    # Put back the platform and wrap up
    - schematic paste <[end_location]> noair name:<[elevator.schematic]>
    - remove <[block_ents]>
    - foreach <[riders]> as:rider:
        - if <[rider].has_flag[tick_elevators.temp_offset]>:
            - flag <[rider]> tick_elevators.temp_no_fall_damage expire:5s
            - teleport <[rider]> <[rider].location.with_y[<[end_location].y.add[<[rider].flag[tick_elevators.temp_offset].y>]>]> relative
            - flag <[rider]> tick_elevators.temp_offset:!
        - adjust <[rider]> gravity:true
    - chunkload remove <[chunks]>
    - flag server tick_elevators.elevators.<[elevator.name]>.location:<[end_location]>
    - flag server tick_elevators.elevators.<[elevator.name]>.in_progress:!

tick_elevators_world:
    type: world
    debug: false
    events:
        on entity_flagged:tick_elevators.fall_protect damaged by fall:
        - determine cancelled
        on player kicked for flying flagged:tick_elevators.fall_protect:
        - determine passively fly_cooldown:10s
        - determine cancelled
tick_elevators_block_entity:
    type: entity
    debug: false
    entity_type: falling_block
    mechanisms:
        force_no_persist: true
        gravity: false
        fallingblock_drop_item: false
        fallingblock_hurt_entities: false
        time_lived: -2147483648t
        auto_expire: false
        velocity: 0,0,0

