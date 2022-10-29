# @ ----------------------------------------------------------
# Tick's MOTD
# A simple script that displays a customizable message of the
# day in the Server List.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tick_motd_data:
    type: data
    line_1:
    - <&c><&gradient[from=red;to=orange]>TickMC Official <&7>|<&r> <&gradient[from=orange;to=red]><context.version_name.replace[Paper ]>+
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
    - <&c>Welcome to TickMC!
    - <&c><&l>Our Staff<&co>
    - <&7>Owner <&8>- <&c>0TickPulse
    - <empty>
    - <&c>Accept resource packs, or
    - <&c>accept your death.
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
        - determine alternate_player_text:<script[tick_motd_data].data_key[player_text].parse[parsed]>