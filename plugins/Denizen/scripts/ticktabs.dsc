# @ ----------------------------------------------------------
# TickTabs
# A flexible script that adds a header and footer to tablist,
# manages players in the tablist, and as a bonus, adds a
# bossbar.
# Author: 0TickPulse
# @ ----------------------------------------------------------

ticktab_config:
    type: data

    bossbar:
        enabled: true
        update frequency: 1
        bossbar:
            text: <player.proc[tick_chat_format_player_name]>    <reset><player.location.proc[dPrevention_get_areas].flag[dprevention.name].if_null[Wilderness]>     <reset><util.time_now.format[hh:mm:ss]> UTC
            color: white
            style: SOLID
            progress: 1

    # The header and footer. They are lines of text that exist above and below the player list respectively.
    header and footer:
        enabled: true
        # How many times it should update per second. Higher = more performance intensive.
        update frequency: 1
        # Configure the header. (The text above the player list)
        header:
        - <empty>
        - <empty>
        - <empty>
        - <empty>
        - <empty>
        - <empty>
        - <script[icons].parsed_key[logo]>
        # Configure the footer. (The text below the player list)
        footer:
        - <gray>Your ping: <red><[ping]>ms
        - <gray>Tick duration: <red><[mspt]>ms    <gray>RAM: <[ram_usage_gb].round_to_precision[0.1].color[red]>/<[ram_allocated_gb].round_to_precision[0.1].color[red]><red>GB

    # The player list manager. This manages the players in the tablist, allowing you to do cool stuff in it!
    player list manager:
        enabled: true
        # What the player should be displayed as in the player list
        player list name: <&sp><player.proc[tick_chat_format_player_name]>
        # How many times it should update per second. Higher = more performance intensive.
        update frequency: 3
        # Also update the player
        also update on player join and leave: true
        sorting:
            enabled: false
            # How it should be sorted.
            # group - sorts by the Vault group. Requires the plugin Vault.
            # permission - sorts by permissions.
            type: group
            # The priority order.
            # If your type is "group", put the list of groups, from highest to lowest priority.
            # If your type is "permission", put the list of permissions, from highest to lowest priority.
            priorities:
            - admin
            - default

# Config ends here.

ticktab_main_world:
    type: world
    debug: false
    events:
        on delta time secondly:
        # So that resources aren't wasted
        - stop if:<server.online_players.is_empty>
        # Header and footer logic
        - run ticktab_header_footer_logic_task
        - run ticktab_player_list_manager_task
        - run ticktab_bossbar_task
        after player joins:
        - if <script[ticktab_config].data_key[player list manager.also update on player join and leave].if_null[false]>:
            - run ticktab_player_list_manager_task
        after player quits:
        - if <script[ticktab_config].data_key[player list manager.also update on player join and leave].if_null[false]>:
            - run ticktab_player_list_manager_task
ticktab_bossbar_task:
    type: task
    debug: false
    script:
    - define per_second <script[ticktab_config].data_key[bossbar.update frequency].if_null[1].min[20]>
    - define interval <element[1].div[<[per_second]>]>
    - repeat <[per_second]>:
        - if <script[ticktab_config].data_key[bossbar.enabled]>:
            - foreach <server.online_players> as:__player:
                - bossbar auto ticktab_bossbar_<player.uuid> players:<player> progress:<script[ticktab_config].parsed_key[bossbar.bossbar.progress].if_null[1]> style:<script[ticktab_config].parsed_key[bossbar.bossbar.style].if_null[solid]> color:<script[ticktab_config].parsed_key[bossbar.bossbar.color].if_null[red]> title:<script[ticktab_config].data_key[bossbar.bossbar.text].parsed>
            - stop
        - if <server.current_bossbars> contains ticktab_bossbar:
            - foreach <server.online_players> as:__player:
                - bossbar remove ticktab_bossbar_<player.uuid>
            - stop
        - wait <[interval]>s
ticktab_header_footer_logic_task:
    type: task
    debug: false
    script:
    # Stops if it's disabled in config
    - if !<script[ticktab_config].data_key[header and footer.enabled].if_null[true]>:
        - stop
    # Calculates how many times to run and at what interval
    - define per_second <script[ticktab_config].data_key[header and footer.update frequency].if_null[1].min[20]>
    - define interval <element[1].div[<[per_second]>]>
    - repeat <[per_second]>:
        # Loops a header/footer calculation for every online player
        - foreach <server.online_players> as:__player:
            - inject ticktab_player_definitions_task
            - define header <script[ticktab_config].parsed_key[header and footer.header].separated_by[<n><reset>]>
            - define footer <script[ticktab_config].parsed_key[header and footer.footer].separated_by[<n><reset>]>
            - adjust <player> tab_list_info:<[header]>|<[footer]>
        - wait <[interval]>s
ticktab_player_list_manager_task:
    type: task
    debug: false
    script:
    # Stops if it's disabled in config
    - if !<script[ticktab_config].data_key[player list manager.enabled].if_null[true]>:
        - stop
    - define per_second <script[ticktab_config].data_key[player list manager.update frequency].if_null[1].min[20]>
    - define interval <element[1].div[<[per_second]>]>
    - repeat <[per_second]>:
        # Loops player list name for every online player
        - foreach <server.online_players> as:__player:
            - inject ticktab_player_definitions_task
            - adjust <player> player_list_name:<script[ticktab_config].parsed_key[player list manager.player list name]>
        - wait <[interval]>s

    # Player sorting
    - if !<script[ticktab_config].data_key[player list manager.sorting.enabled].if_null[true]>:
        - stop
    - run ticktab_sort_players_task
ticktab_sort_players_task:
    type: task
    debug: false
    script:
    - define list_to_sort <script[ticktab_config].data_key[player list manager.sorting.priorities]>
    - define sorted_list <list>
    - foreach <[list_to_sort]> as:item:
        - foreach <server.online_players> as:__player:
            - inject ticktab_player_definitions_task
            - if <script[ticktab_config].data_key[player list manager.sorting.type]> == group:
                - if <player.in_group[<[item]>]>:
                    - team add:<player> name:ticktab_<[loop_index]>
            - else:
                - if <player.has_permission[<[item]>]>:
                    - team add:<player> name:ticktab_<[loop_index]>
ticktab_player_definitions_task:
    type: task
    debug: false
    script:
    - define tps <server.recent_tps.average.round_to_precision[0.1]>
    - define ping <player.ping>
    - define x <player.location.round.x>
    - define y <player.location.round.y>
    - define z <player.location.round.z>
    - define player_count <server.online_players.size>
    - define full_name <player.chat_prefix.parse_color.if_null[]><player.name><player.chat_suffix.parse_color.if_null[]>
    - define ram_percent <util.ram_usage.div[<util.ram_max>].mul[100].round>
    - define ram_usage_gb <util.ram_usage.div[1073741824]>
    - define ram_allocated_gb <util.ram_allocated.div[1073741824]>
    - define mspt <paper.tick_times.first.in_milliseconds.round_to_precision[0.1]>
