# @ ----------------------------------------------------------
# TickUtil Items
# Adds many utility scripts that make item scripts much
# easier.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tickutil_items:
    type: procedure
    debug: false
    script:
        hover_text:
        - determine <[1].proc[tickutil_items.script.display].hover_item[<[1]>]>
        display:
        - determine <[1].display.if_null[<[1].material.translated_name>]>