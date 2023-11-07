tickmc_specialized_vanilla_flags_world:
    type: world
    debug: false
    events:
        after server resources reloaded:
        - execute as_server reloadvanillaflags
        after player joins:
        - execute as_server reloadvanillaflags

tickmc_specialized_vanilla_flags_reload_command:
    type: command
    name: reloadvanillaflags
    description: Reloads the custom vanilla flags
    permission: tickmc_specialized.command.reloadvanillaflags
    usage: /reloadvanillaflags
    debug: false
    aliases:
    - rvf
    - reloadvf
    script:
    - narrate "<element[TickMC].format[tickutil_text_prefix]> <&[success]>Reloading vanilla flags..."
    - adjust <material[chain]> vanilla_tags:<material[chain].vanilla_tags.include[climbable]>
    - narrate "<element[TickMC].format[tickutil_text_prefix]> <&[success]>Reloaded vanilla flags!"
