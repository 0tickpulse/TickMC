tickmc_specialized_panel_command:
    type: command
    debug: false
    name: panel
    description: Sends a link to the panel.
    permission: tickmc_specialized.command.panel
    usage: /panel
    script:
    - narrate <element[<&[emphasis]><bold>TickMC panel <reset><dark_gray>- <gray>Click to open!].on_hover[<&[success]>Click to open!].click_url[https://mc.bloom.host/server/44cecd4b]>