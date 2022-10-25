tick_daily_restarts_restart_task:
    type: task
    debug: false
    data:
        title: <&[emphasis]>Warning!
        subtitle: <&[base]>Server is restarting in <[time].from_now.formatted_words>!
        waits:
        - 60s
        - 30s
        - 15s
        - 10s
        - 5s
    script:
    - define now <util.time_now>
    - define duration <script.parsed_key[data.waits].parse[as[duration].in_seconds].sum.as[duration]>
    - bossbar create tick_daily_restart_bar color:red "title:Server restart!" players:<server.online_players> progress:<util.time_now.duration_since[<[now]>].in_seconds.div[<[duration].in_seconds>]>
    - define time <util.time_now.add[<[duration]>]>
    - foreach <script.parsed_key[data.waits]> as:wait:
        - title title:<script.parsed_key[data.title]> subtitle:<script.parsed_key[data.subtitle]> targets:<server.online_players>
        - repeat <[wait].as[duration].in_seconds> as:seconds:
            - wait 1s
            - bossbar update tick_daily_restart_bar progress:<util.time_now.duration_since[<[now]>].in_seconds.div[<[duration].in_seconds>]>
    - bossbar remove tick_daily_restart_bar
    - adjust server restart
tick_daily_restarts_world:
    type: world
    debug: false
    events:
        on system time 19:00:
        - run tick_daily_restarts_restart_task
