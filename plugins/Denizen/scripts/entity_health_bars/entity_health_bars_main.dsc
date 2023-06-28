entity_health_bars_data:
    type: data
    update_on_spawn: true
    update_ratelimit: 0.2s

    only_render_when_players_within_proximity: true
    render_proximity: 32

    has_timeout: true
    timeout: 5s

    disable_vanilla_name_tag: false

    y_offset: 1
    lines:
    - <[entity].custom_name.if_null[<[entity].translated_name>]>
    - <[entity].health.round.color[<color[red].with_hue[<[entity].health_percentage.mul[0.73].round>]>]>/<[entity].health_max.round.color[green]> <red>❤
    - <[entity].flag[tickutil_progress_bar.health].color[<color[red].with_hue[<[entity].health_percentage.mul[0.73].round>]>]>

    entity_filter: "!player|armor_stand"

entity_health_bars_update_entity_bar_world:
    type: world
    debug: false
    events:
        after entity spawns:
        - if !<script[entity_health_bars_data].data_key[update_on_spawn]>:
            - stop
        - run entity_health_bars_update_bar_on_entity_task def.entity:<context.entity>
        after entity damaged bukkit_priority:monitor:
        - run entity_health_bars_update_bar_on_entity_task def.entity:<context.entity>

entity_health_bars_update_bar_on_entity_task:
    type: task
    debug: false
    definitions: entity
    script:
    - if <[entity].has_flag[entity_health_bars.bar_entity]>:
        - remove <[entity].flag[entity_health_bars.bar_entity]> if:<[entity].flag[entity_health_bars.bar_entity].is_spawned>
    - if !<[entity].is_living> || !<[entity].is_spawned>:
        - stop
    - if ( <script[entity_health_bars_data].data_key[only_render_when_players_within_proximity]> && <[entity].location.find_entities[player].within[<script[entity_health_bars_data].data_key[render_proximity]>].is_empty> ) || <[entity].has_flag[entity_health_bars.parent]>:
        - stop

    - if !<[entity].advanced_matches[<script[entity_health_bars_data].data_key[entity_filter]>]>:
        - stop

    - ratelimit <[entity]> <script[entity_health_bars_data].data_key[update_ratelimit]>
    - run tickutil_progress_bar_update_entity_task def.entity:<[entity]>
    - define lines <script[entity_health_bars_data].parsed_key[lines]>

    - if <script[entity_health_bars_data].data_key[disable_vanilla_name_tag]>:
        - adjust <[entity]> custom_name_visible:false

    - define bar_entity <entity[text_display]>
    - adjust def:bar_entity text:<[lines].separated_by[<n>]>
    - adjust def:bar_entity pivot:center
    - adjust def:bar_entity see_through:false
    - adjust def:bar_entity opacity:255
    - adjust def:bar_entity background_color:0,0,0,0
    #- adjust def:bar_entity translation:0,<[entity].eye_height.add[<script[entity_health_bars_data].data_key[y_offset]>]>,0
    - spawn <[bar_entity]> <[entity].location.above[<[entity].eye_height.add[<script[entity_health_bars_data].data_key[y_offset]>]>]> save:entity
    #- mount <list_single[<entry[entity].spawned_entity>].include_single[<[entity]>]>
    - attach <entry[entity].spawned_entity> to:<[entity]> offset:0,<[entity].eye_height.add[<script[entity_health_bars_data].data_key[y_offset]>]>,0

    - flag <entry[entity].spawned_entity> entity_health_bars.parent:<[entity]>
    - define bar_entity <entry[entity].spawned_entity>

    - flag <[entity]> entity_health_bars.bar_entity:<[bar_entity]>
    - if <script[entity_health_bars_data].data_key[has_timeout]>:
        - wait <script[entity_health_bars_data].data_key[timeout]>
        - remove <[bar_entity]> if:<[bar_entity].is_spawned>

entity_health_bars_remove_bars:
    type: task
    debug: false
    definitions: entity
    script:
    - define e <[entity].flag[entity_health_bars.bar_entity].if_null[null]>
    - if <[e]> == null:
        - stop
    - remove <[e]> if:<[e].is_spawned>

entity_health_bars_remove_bars_on_despawn:
    type: world
    debug: false
    events:
        on entity dies:
        - run entity_health_bars_remove_bars def.entity:<context.entity>
        on entity despawns:
        - run entity_health_bars_remove_bars def.entity:<context.entity>
