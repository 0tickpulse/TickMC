# @ ----------------------------------------------------------
# Tick's Daily Restarts
# A script that restarts the server every 24 hours, with a
# bossbar timer, countdown, title messages. It also restarts
# the server early if no players are online, and kicks players
# a few seconds before the restart for safety.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tick_daily_restarts_stop_restart_task:
    type: task
    debug: false
    script:
    - foreach <script[tick_daily_restarts_restart_task].queues> as:queue:
        - queue <[queue]> stop
    - bossbar remove tick_daily_restart_bar
tick_daily_restarts_restart_task:
    type: task
    debug: false
    data:
        automatically_run: false
        kick_message: TickMC is restarting! Please join back in about 1 minute!
        title: <&[emphasis]>Warning!
        subtitle: <&[base]>Server is restarting in <[time].from_now.formatted_words>!
        bossbar:
            text: <&[base]>Server restarting in <[time].from_now.formatted.custom_color[emphasis]>
            color: red
        waits:
        - 60s
        - 30s
        - 15s
        - 10s
        - 5s
    script:
    - define now <util.time_now>
    - define duration <script.parsed_key[data.waits].parse[as[duration].in_seconds].sum.as[duration]>
    #- define duration <duration[<script.parsed_key[data.waits].parse_tag[<duration[<[parse_value]>].in_seconds>].sum>]>
    - define time <util.time_now.add[<[duration]>]>
    - bossbar auto tick_daily_restart_bar color:<script.parsed_key[data.bossbar.color]> title:<script.parsed_key[data.bossbar.text]> players:<server.online_players> progress:<element[1].sub[<util.time_now.duration_since[<[now]>].in_seconds.div[<[duration].in_seconds>]>]>
    - foreach <script.parsed_key[data.waits]> as:wait:
        - title title:<script.parsed_key[data.title]> subtitle:<script.parsed_key[data.subtitle]> targets:<server.online_players>
        - repeat <duration[<[wait]>].in_seconds> as:seconds:
            - if <server.online_players.is_empty>:
                - repeat stop
            - wait 1s
            - bossbar auto tick_daily_restart_bar color:<script.parsed_key[data.bossbar.color]> title:<script.parsed_key[data.bossbar.text]> progress:<element[1].sub[<util.time_now.duration_since[<[now]>].in_seconds.div[<[duration].in_seconds>]>]>
    - bossbar remove tick_daily_restart_bar
    - flag server tick_daily_restarts.restart_in_progress expire:5s
    - kick <server.online_players> reason:<script.parsed_key[data.kick_message]>
    - wait 2s
    - adjust server restart
tick_daily_restarts_world:
    type: world
    debug: false
    events:
        on system time 19:00:
        - if !<script[tick_daily_restarts_restart_task].parsed_key[data.automatically_run]>:
            - stop
        - run tick_daily_restarts_restart_task
        on player logs in server_flagged:tick_daily_restarts.restart_in_progress:
        - determine kicked:<script.parsed_key[data.kick_message]>

tick_daily_restart_command:
    type: command
    name: dailyrestart
    description: Starts the daily restart sequence.
    usage: /dailyrestart
    permission: tick_daily_restarts.command.dailyrestart
    debug: false
    script:
    - run tick_daily_restarts_restart_task
tick_daily_restart_stop_restart_command:
    type: command
    name: stopdailyrestart
    description: Stops the daily restart sequence.
    permission: tick_daily_restarts.command.stopdailyrestart
    usage: /stopdailyrestart
    debug: false
    script:
    - run tick_daily_restarts_stop_restart_task
    - narrate "<&[success]>Stopped the daily restart sequence!"
tick_auto_save_task:
    type: task
    debug: false
    script:
    - run tick_logging_log_info "def.source:Tick's autosaver" def.message:Saving...
    - adjust server save
tick_auto_save_world:
    type: world
    debug: false
    events:
        on delta time hourly:
        - run tick_auto_save_task
