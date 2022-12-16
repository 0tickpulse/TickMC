# This script runs when a backpack is destroyed.
# You can use this script to add things like particles and sounds
tick_death_backpacks_backpack_clean_scripts:
    type: task
    debug: false
    definitions: backpack_entity
    script:
    - define targets <[backpack_entity].location.repeat_as_list[35].parse[random_offset[0.1,0.1,0.1]]>
    - foreach <[targets]> as:target:
        - playeffect effect:cloud quantity:4 at:<[backpack_entity].location.up[<script[tick_death_backpacks_data].parsed_key[offsets.particles]>]> velocity:<[target].sub[<[backpack_entity].location>]> offset:0.75,0.75,0.75
    - playeffect effect:campfire_cosy_smoke quantity:15 at:<[backpack_entity].location.up[<script[tick_death_backpacks_data].parsed_key[offsets.particles]>]> velocity:0,0.2,0 offset:0.75,0.75,0.75
    - playsound sound:entity_player_attack_crit <[backpack_entity].location> pitch:0

tick_death_backpacks_data:
    type: data
    debug: false
    entity: armor_stand[visible=false;equipment=[helmet=player_head[skull_skin=eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODM1MWU1MDU5ODk4MzhlMjcyODdlN2FmYmM3Zjk3ZTc5NmNhYjVmMzU5OGE3NjE2MGMxMzFjOTQwZDBjNSJ9fX0=]]]
    permissions:
        bypass_death_backpacks: tick_death_backpacks.bypass
    visibility: global
    conditions:
        keep_inventory_if_conditions_dont_meet: true
        dont_spawn_backpack_if_pvp:
            enabled: true
            pvp_timer: 5s
        disable_if:
        - <player.location.world.name.is_in[disabled_world1|disabled_world2]>
        - <player.location.material.name.equals[air].not>
    offsets:
        entity: -1.5
        hologram_base: 0.2
        hologram_line: 0.25
        particles: 1.5
    commands:
        cleanbackpacks:
            default_radius: 15
    lang:
        backpack_spawned: <&sp.repeat[80].strikethrough.color[8]><n><&[emphasis]>A death backpack has spawned where you died!<n><&[base]>Location: <[backpack_entity].location.simple.formatted.custom_color[emphasis]><n><&[warning]>You have <[despawn_duration].formatted_words> before it despawns!<n><n><&[success]>You can right click to open, or shift-right-click to empty!<n><&sp.repeat[80].strikethrough.color[8]>
        hologram_lines:
        - <&[emphasis]><bold>DEATH BACKPACK
        - <player.proc[tick_chat_format_player_name]>
        - <[despawn_duration].formatted_words.custom_color[emphasis]>
        - <&[success]><bold>RIGHT CLICK TO OPEN
        - <&[success]><bold>SHIFT+RIGHT CLICK TO EMPTY
    inventory_title: <player.proc[tick_chat_format_player_name]><&8>'s death backpack
    hologram_update_interval: 1s
    despawn:
        enabled: true
        time: 5m

tick_death_backpacks_clean_backpack_task:
    type: task
    debug: false
    definitions: entities
    script:
    - foreach <[entities]> as:entity:
        - define player <[entity].flag[tick_death_backpacks.player]>
        - flag <[player]> tick_death_backpacks.backpack_entities:<-:<[entity]>
        - flag <[player]> tick_death_backpacks.backpack_inventories:<-:<inventory[tick_death_backpacks_<[entity].flag[tick_death_backpacks.player].uuid>_<[entity].uuid>]>
        - run tick_death_backpacks_backpack_clean_scripts def.backpack_entity:<[entity]>
        - note remove as:tick_death_backpacks_<[entity].flag[tick_death_backpacks.player].uuid>_<[entity].uuid>
    - remove <[entities]>
    - remove <[entities].as[list].parse[flag[tick_death_backpacks.spawned_stands].if_null[<list>]].combine>

tick_death_backpacks_clean_backpacks_task:
    type: task
    debug: false
    script:
    - define entities <server.flag[tick_death_backpacks.backpack_entities]>
    - run tick_death_backpacks_clean_backpack_task def.entities:<[entities].filter[is_spawned]>

tick_death_backpacks_spawn_backpack_command:
    type: command
    name: spawnbackpack
    description: Spawns a death backpack
    usage: <script[tick_death_backpacks_spawn_backpack_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player
            s: template=boolean_default_false
    permission: tick_death_backpacks.command.spawn
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - run tick_death_backpacks_spawn_backpacks_task player:<[arg.player]>

tick_death_backpacks_clean_backpacks_command:
    type: command
    name: cleanbackpacks
    description: Cleans up all death backpacks from a given radius (defaults to <script[tick_death_backpacks_data].parsed_key[commands.cleanbackpacks.default_radius]>).
    usage: <script[tick_death_backpacks_clean_backpacks_command].proc[command_manager_generate_usage]>
    permission: tick_death_backpacks.command.clean
    data:
        args:
            radius:
                template: decimal
                type: linear
                usage text:
                    auto format: true
                    list:
                    - <&lt>radius<&gt>
                    - <&lc><script[tick_death_backpacks_data].parsed_key[commands.cleanbackpacks.default_radius]><&rc>
                default: <script[tick_death_backpacks_data].parsed_key[commands.cleanbackpacks.default_radius]>
            player: template=player
            s: template=boolean_default_false
    debug: false
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - define entities <server.flag[tick_death_backpacks.backpack_entities].filter[location.distance[<[arg.player].location>].is_less_than_or_equal_to[<[arg.radius]>]]>
    - run tick_death_backpacks_clean_backpack_task def.entities:<[entities].filter[is_spawned]>
    - if <[arg.s]>:
        - stop
    - narrate "Removed <[entities].size> backpacks! (Scan radius: <[arg.radius]>)"

tick_death_backpacks_spawn_backpacks_task:
    type: task
    debug: false
    script:
    - define configuration <script[tick_death_backpacks_data].data_key[]>
    - define inventory <player.inventory>
    - define backpack_entity_blueprint <[configuration.entity].parsed>

    - if <[configuration.despawn.enabled]>:
        - define despawn_time <util.time_now.add[<[configuration.despawn.time].parsed.as[duration]>]>
        - define despawn_duration <[despawn_time].from_now>
    - define fake_entity_duration <[despawn_duration].if_null[0s]>

    - announce <[configuration.visibility].equals[global].if_true[<server.online_players>].if_false[<player>]>

    - define lines <[configuration.lang.hologram_lines].parse[parsed].reverse>
    - define spawned_stands <list>
    - foreach <[lines]> as:line:
        - define stand <entity[armor_stand].with[marker=true;visible=false;invulnerable=true;custom_name_visible=true;custom_name=<[line]>]>
        - define offset <[loop_index].mul[<[configuration.offsets.hologram_line]>].add[<[configuration.offsets.hologram_base]>]>
        - fakespawn <[stand]> <player.location.above[<[offset]>]> d:<[fake_entity_duration]> save:stand players:<[configuration.visibility].equals[global].if_true[<server.online_players>].if_false[<player>]>
        - define spawned_stands:->:<entry[stand].faked_entity>
    - fakespawn <[backpack_entity_blueprint]> <player.location.above[<[configuration.offsets.entity]>]> d:<[fake_entity_duration]> save:backpack players:<[configuration.visibility].equals[global].if_true[<server.online_players>].if_false[<player>]>

    - define backpack_entity <entry[backpack].faked_entity>

    - flag <[backpack_entity]> tick_death_backpacks.spawned_stands:<[spawned_stands]>
    - flag <[backpack_entity]> tick_death_backpacks.player:<player>
    - note <inventory[generic[title=<script[tick_death_backpacks_data].parsed_key[inventory_title].if_null[]>;size=45;contents=<player.inventory.list_contents>]]> as:tick_death_backpacks_<player.uuid>_<[backpack_entity].uuid>
    - flag server tick_death_backpacks.backpack_entities:->:<[backpack_entity]>
    - flag <player> tick_death_backpacks.backpack_entities:->:<[backpack_entity]>

    - define noted_inventory <inventory[tick_death_backpacks_<player.uuid>_<[backpack_entity].uuid>]>
    - flag <player> tick_death_backpacks.backpack_inventories:->:<[noted_inventory]>
    - flag <[noted_inventory]> tick_death_backpacks.backpack_entity:<[backpack_entity]>

    - narrate <[configuration.lang.backpack_spawned].parsed>

    - while <[backpack_entity].is_spawned>:
        - define despawn_duration <[despawn_time].from_now>
        - define lines <[configuration.lang.hologram_lines].parse[parsed].reverse>
        - foreach <[lines]> as:line:
            - adjust <[spawned_stands].get[<[loop_index]>]> custom_name:<[line]>
        - wait <[configuration.hologram_update_interval]>
    - flag server tick_death_backpacks.backpack_entities:<-:<[backpack_entity]>
    - remove <[spawned_stands]>

tick_death_backpacks_world:
    type: world
    debug: false
    events:
        after player damaged by player:
        - flag <context.entity> tick_death_backpacks.pvp_timer expire:<script[tick_death_backpacks_data].parsed_key[conditions.dont_spawn_backpack_if_pvp.pvp_timer]>
        on player dies bukkit_priority:low:
        - if <player.has_flag[tick_death_backpacks.pvp_timer]> && <script[tick_death_backpacks_data].parsed_key[conditions.dont_spawn_backpack_if_pvp.enabled]>:
            - stop
        - if <script[tick_death_backpacks_data].parsed_key[conditions.disable_if].filter[].any>:
            - determine passively KEEP_INV
            - determine passively NO_DROPS
            - determine passively KEEP_LEVEL
            - stop
        #- if <player.has_permission[<script[tick_death_backpacks_data].parsed_key[permissions.bypass_death_backpacks]>]>:
        #    - stop
        - run tick_death_backpacks_spawn_backpacks_task
        - determine passively NO_DROPS
        after player right clicks fake entity:
        - if <context.entity> !in <server.flag[tick_death_backpacks.backpack_entities]>:
            - stop
        - if <context.entity.flag[tick_death_backpacks.player]> != <player>:
            - stop
        - define inventory <inventory[tick_death_backpacks_<player.uuid>_<context.entity.uuid>]>
        - if <player.is_sneaking>:
            - foreach <[inventory].map_slots> key:slot as:item:
                - if <player.inventory.slot[<[slot]>]> matches air:
                    - inventory set slot:<[slot]> o:<[item]>
                    - foreach next
                - give <[item]>
            - run tick_death_backpacks_clean_backpack_task def.entities:<context.entity>
            - stop
        - inventory open d:<[inventory]>
        after player closes inventory:
        - if <context.inventory> !in <player.flag[tick_death_backpacks.backpack_inventories]> || !<context.inventory.is_empty>:
            - stop
        - define backpack_entity <context.inventory.flag[tick_death_backpacks.backpack_entity]>
        - run tick_death_backpacks_clean_backpack_task def.entities:<[backpack_entity]>