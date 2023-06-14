tickutil_progress_bar_data:
    type: data
    # Per second
    update_frequency: 2
    default_bar:
        from: 0
        to: 10
        value: 0
        characters:
            full:
                left: <&font[tickmc:sharp_bar]>L<script[icons].parsed_key[spaces.1]>
                middle: <&font[tickmc:sharp_bar]>M<script[icons].parsed_key[spaces.1]>
                right: <&font[tickmc:sharp_bar]>R<script[icons].parsed_key[spaces.1]>
            empty:
                left: <&font[tickmc:sharp_bar]>l<script[icons].parsed_key[spaces.1]>
                middle: <&font[tickmc:sharp_bar]>m<script[icons].parsed_key[spaces.1]>
                right: <&font[tickmc:sharp_bar]>r<script[icons].parsed_key[spaces.1]>
            cursor:
                left: <&font[tickmc:sharp_bar]>0<script[icons].parsed_key[spaces.1]>
                middle: <&font[tickmc:sharp_bar]>1<script[icons].parsed_key[spaces.1]>
                right: <&font[tickmc:sharp_bar]>2<script[icons].parsed_key[spaces.1]>
        cursor: false
    bars:
        entity:
            health:
                from: 0
                to: <[entity].health_max>
                value: <[entity].health>
                length: 10
        server:
            ram:
                from: 0
                to: <util.ram_allocated>
                value: <util.ram_usage>
                length: 10
            tps:
                from: 0
                to: 20
                value: <server.recent_tps.get[1]>
                length: 10
                cursor: true
        player:
            health:
                from: 0
                to: <player.health_max>
                value: <player.health>
                length: 10
                #cursor: true
            hunger:
                from: 0
                to: 20
                value: <player.food_level>
                length: 10

tickutil_progress_bar_update_world:
    type: world
    debug: false
    events:
        on delta time secondly:
        - define frequency <script[tickutil_progress_bar_data].parsed_key[update_frequency]>
        - define interval <element[1].div[<[frequency]>]>
        - repeat <[frequency]>:
            - run tickutil_progress_bar_update_task
            - wait <[interval]>

tickutil_progress_bar_update_entity_task:
    type: task
    debug: false
    definitions: entity
    script:
    - foreach <script[tickutil_progress_bar_data].data_key[bars.entity].keys> as:bar_preset:
        - flag <[entity]> tickutil_progress_bar.<[bar_preset]>:<proc[tickutil_progress_bar_from_preset_proc].context[<list_single[entity].include_single[<[bar_preset]>].include_single[<[entity]>]>]>

tickutil_progress_bar_update_task:
    type: task
    debug: false
    script:
    - foreach <server.online_players> as:__player:
        - foreach <script[tickutil_progress_bar_data].data_key[bars.player].keys> as:bar_preset:
            - flag <player> tickutil_progress_bar.<[bar_preset]>:<proc[tickutil_progress_bar_from_preset_proc].context[player|<[bar_preset]>]>

    - foreach <script[tickutil_progress_bar_data].data_key[bars.server].keys> as:bar_preset:
        - flag server tickutil_progress_bar.<[bar_preset]>:<proc[tickutil_progress_bar_from_preset_proc].context[server|<[bar_preset]>]>

tickutil_progress_bar_from_preset_proc:
    type: procedure
    debug: false
    definitions: type|preset|entity
    script:
    - define bar_data <script[tickutil_progress_bar_data].parsed_key[default_bar]>
    - choose <[type]>:
        - case entity:
            - define override <script[tickutil_progress_bar_data].parsed_key[bars.entity.<[preset]>]>
        - case server:
            - define override <script[tickutil_progress_bar_data].parsed_key[bars.server.<[preset]>]>
        - case player:
            - define override <script[tickutil_progress_bar_data].parsed_key[bars.player.<[preset]>]>

    - foreach <[override].deep_keys> as:key:
        - define bar_data <[bar_data].deep_with[<[key]>].as[<[override].deep_get[<[key]>]>]>

    - define bar <proc[tickutil_progress_bar_proc].context[<list[<[bar_data.from].if_null[0]>|<[bar_data.to].if_null[10]>|<[bar_data.value].if_null[0]>|<[bar_data.length].if_null[10]>].include_single[<[bar_data.characters]>].include_single[<[bar_data.cursor].if_null[false]>]>]>

    - determine <[bar]>

tickutil_progress_bar_proc:
    type: procedure
    debug: false
    definitions: from|to|value|length|characters|cursor
    script:
    - define bar <empty>
    - define progress <[value].sub[<[from]>].div[<[from].add[<[to]>]>].min[1].if_null[1]>
    - define progress_fixed <[progress].mul[<[length]>].round>
    # Progress > 0 - add full characters
    - if <[progress_fixed]> > 0:
        # Adds empty characters + cursor
        - if <[cursor]>:
            - if <[progress_fixed]> == 1:
                - define bar <[bar]><[characters.cursor.left]>
                - define bar <[bar]><[characters.empty.middle].repeat[<[progress_fixed].sub[1].max[0]>]>
            - else:
                - define bar <[bar]><[characters.empty.left]>
                - define bar <[bar]><[characters.empty.middle].repeat[<[progress_fixed].sub[2].max[0]>]>
                - define bar <[bar]><[characters.cursor.middle]>
        - else:
            - define bar <[bar]><[characters.full.left]>
            - define bar <[bar]><[characters.full.middle].repeat[<[progress_fixed].sub[1]>]>

    # Add empty characters
    - if <[progress_fixed]> == 0:
        - if <[cursor]>:
            - define bar <[bar]><[characters.cursor.left]>
        - else:
            - define bar <[bar]><[characters.empty.left]>
        - define bar <[bar]><[characters.empty.middle].repeat[<[length].sub[<[progress_fixed]>].sub[2].max[0]>]>
    - else:
        - define bar <[bar]><[characters.empty.middle].repeat[<[length].sub[<[progress_fixed]>].sub[1].max[0]>]>

    # Progress = length - add full right character, replacing the last full middle character
    - if <[progress_fixed]> == <[length]>:
        - if <[cursor]>:
            - define bar <[bar].before_last[<[characters.cursor.middle]>]><[characters.cursor.right]>
        - else:
            - define bar <[bar].before_last[<[characters.full.middle]>]><[characters.full.right]>
    - else:
        - define bar <[bar]><[characters.empty.right]>

    - determine <[bar]>
