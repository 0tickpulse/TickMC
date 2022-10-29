# @ ----------------------------------------------------------
# Tick's Logging Utils
# Some simple logging utilities.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tick_logging_util_proc:
    type: procedure
    debug: false
    script:
        format_player:
        - determine "<[1].name> (UUID: <[1].uuid>)"

tick_logging_log_info:
    type: task
    debug: false
    definitions: message|source
    script:
    - announce to_console "<&[emphasis]><[source]> <dark_gray>- <&[console]><[message]>"