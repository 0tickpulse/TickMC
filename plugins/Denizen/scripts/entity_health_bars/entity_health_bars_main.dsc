entity_health_bars_data:
    type: data
    update_on_spawn: true
    update_ratelimit: 0.2s

    only_render_when_players_within_proximity: true
    render_proximity: 32

    has_timeout: true
    timeout: 5s

    disable_vanilla_name_tag: false

    total_y_offset: 0.7
    y_offset_between_lines: 0.3
    lines:
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
    - if <[entity].has_flag[entity_health_bars.bar_entities]>:
        - remove <[entity].flag[entity_health_bars.bar_entities].filter[is_spawned]>
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

    - define bar_entities <list>
    - foreach <[lines].reverse> as:line:
        - define line_offset <script[entity_health_bars_data].data_key[y_offset_between_lines].if_null[0.2]>
        - spawn armor_stand[is_small=true;marker=true;visible=false;custom_name=<[line]>;custom_name_visible=true] <[entity].eye_location.above[<script[entity_health_bars_data].data_key[total_y_offset]>].above[<[loop_index].sub[1].mul[<[line_offset]>]>]> save:entity
        - attach <entry[entity].spawned_entity> to:<[entity]> offset:0,<[entity].eye_height.add[<script[entity_health_bars_data].data_key[total_y_offset]>].add[<[loop_index].sub[1].mul[<[line_offset]>]>]>,0

        - flag <entry[entity].spawned_entity> entity_health_bars.parent:<[entity]>
        - define bar_entities:->:<entry[entity].spawned_entity>

    - flag <[entity]> entity_health_bars.bar_entities:<[bar_entities]>
    - if <script[entity_health_bars_data].data_key[has_timeout]>:
        - wait <script[entity_health_bars_data].data_key[timeout]>
        - remove <[bar_entities].filter[is_spawned]>

entity_health_bars_remove_bars:
    type: task
    debug: false
    definitions: entity
    script:
    - define entities <[entity].flag[entity_health_bars.bar_entities].if_null[<list>]>
    - remove <[entities].filter[is_spawned]>

entity_health_bars_remove_bars_on_despawn:
    type: world
    debug: false
    events:
        on entity dies:
        - run entity_health_bars_remove_bars def.entity:<context.entity>
        on entity despawns:
        - run entity_health_bars_remove_bars def.entity:<context.entity>