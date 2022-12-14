# @ ----------------------------------------------------------
# Tick's MOTD
# A simple script that displays a customizable message of the
# day in the Server List.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tick_motd_data:
    type: data
    server_icons:
    - plugins/Denizen/icons/tickmc-64x64.png
    line_1:
    - <&[emphasis]><&gradient[from=red;to=orange]>TickMC Official <&7>|<&r> <&gradient[from=orange;to=red]><context.version_name.replace_text[Paper ]>+
    line_2:
    - <&8>»<&r><&6> ʙᴇsᴛ sᴇʀᴠᴇʀ ᴇᴠᴇʀ.
    - <&8>»<&r><&6><&l> Join or Die.
    - <&8>»<&r><&6><&l> I am under your bed.
    - <&8>»<&r><&3><&l> Use your imagination.
    - <&8>»<&r><&d> The server below is bad.
    - <&8>»<&r><&4><&l> No Hacks Allowed!
    - <&8>»<&r><&c><&l> Look behind.
    - <&8>»<&4> Can connect to server
    player_text:
    - <red><&l>Welcome to TickMC!
    - <&8><strikethrough><&sp.repeat[40]>
    - <red>Our Staff<&8><&co>
    - <&7>  Owner<&8>: <red>0TickPulse
    - <empty>
    - <red>Please accept resourcepacks!
    - <&8><strikethrough><&sp.repeat[40]>
tick_motd_world:
    type: world
    debug: false
    events:
        on server list ping:
        - if <server.has_flag[tick_no_quick_join.startup_progress]>:
            - stop
        - define ip <context.address>
        - define line1 <script[tick_motd_data].data_key[line_1].random.parsed>
        - define line2 <script[tick_motd_data].data_key[line_2].random.parsed>
        - determine passively <[line1]><n><[line2]>
        - determine passively icon:<script[tick_motd_data].data_key[server_icons].random.parsed>
        - determine alternate_player_text:<script[tick_motd_data].data_key[player_text].parse[parsed]>