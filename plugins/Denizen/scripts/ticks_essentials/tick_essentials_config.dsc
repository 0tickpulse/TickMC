tick_essentials_data:
    type: data
    lang:
        # The prefix for all messages in the script.
        # The below line is what I personally use for my server.
        prefix: <element[Tick's Essentials].format[tickutil_text_prefix]>
        # prefix: <element[Tick's Essentials].bold.custom_color[emphasis]> <dark_gray>» <reset>
        # A horizontal line
        hline: <&sp.repeat[80].color[dark_gray].strikethrough>
    commands:
        main:
            # @ The /tickessentials command
            # Simply a list of commands.
            tickessentials:
                enabled: true
        # @ Developer commands
        # These commands make it easier for developers to make their own scripts.
        developers:
            # @ The /commandlist command
            # Permission: tickessentials.command.developers.commandlist
            # Lists all commands in the server.
            commandlist:
                enabled: true
            # @ The /enum command
            # Permission: tick_essentials.command.developers.enum
            # This command allows you to get a list of all the enum values of a specified enum.
            # Useful for scripts that require an enum value.
            enum:
                enabled: true
            # @ The /pluginversions command
            # Permission: tick_essentials.command.developers.pluginversions
            # This command allows you to get a list of all the plugins and their versions.
            pluginversions:
                enabled: true
        # @ Staff commands
        # These commands make it easier as server staff.
        staff:
            # @ The /sudo command
            # Permission: tick_essentials.command.staff.sudo,
            #             tick_essentials.command.staff.sudo.exempt
            # This command allows you to run a command as another player.
            # If the target player has permission 'tick_essentials.command.staff.sudo.exempt', it fails.
            sudo:
                enabled: true
            # @ The /invsee command
            # Permission: tick_essentials.command.staff.invsee,
            #             tick_essentials.command.staff.invsee.exempt
            # This command allows you to view the inventory of a player.
            # If the target player has permission 'tick_essentials.command.staff.invsee.exempt', it fails.
            invsee:
                enabled: true
            # @ The /uploadlogs command
            # Permission: tick_essentials.command.staff.uploadlogs
            # This command allows you to read the logs file and upload the contents to hastebin.
            uploadlogs:
                # @ REQUIRES CERTAIN CONFIG OPTIONS IN DENIZEN CONFIG.YML!
                # | "Commands.File.Allow read" MUST BE SET TO TRUE!
                # | "Commands.File.Restrict path" MUST INCLUDE THE PATH TO THE LOG FILE!
                # Starts at plugins/Denizen
                enabled: true
                log path: ../../logs/latest.log
                hastebin link: https://paste.tick-mc.net
            # @ The /vanish command
            # Permission: tick_essentials.command.staff.vanish
            # This command allows you to vanish from the server.
            # This has multiple effects, including:
            # * Making you invisible
            # * Making you invincible
            # * Making you unable to be targeted by mobs
            # @ WARNING
            # Enabling this will use a player flag (tick_essentials.vanished)
            vanish:
                enabled: true
            # @ The /gamemode, /gmc, /gms, /gma, /gmsp commands
            # Permission: tick_essentials.command.staff.gamemode,
            #             tick_essentials.command.staff.gamemode.creative,
            #             tick_essentials.command.staff.gamemode.survival,
            #             tick_essentials.command.staff.gamemode.adventure,
            #             tick_essentials.command.staff.gamemode.spectator
            # This series of commands allow you to change your gamemode.
            gamemode:
                enabled: true
                # When enabled, when a player joins with the permissions, a packet will be sent.
                # This packet makes the client think they're opped, and therefore lets them use the F3+F4 and the F3+N shortcuts.
                fake op: true
            # @ The /kick command
            # Permission: tick_essentials.command.staff.kick
            # This command allows you to kick a player from the server.
            kick:
                enabled: true
            # @ The /ban command
            # Permission: tick_essentials.command.staff.ban
            # This command allows you to ban a player from the server.
            ban:
                enabled: true
            # @ The /unban command
            # Permission: tick_essentials.command.staff.unban
            # This command allows you to unban a player from the server.
            unban:
                enabled: true
        # @ World commands
        # These commands make it easier to manage worlds.
        world:
            # @ The /fly command
            # Permission: tick_essentials.command.world.fly
            # This command allows you to toggle flight regardless of gamemode.
            fly:
                enabled: true
            # @ The /sunday command
            # Permission: tick_essentials.command.world.sunday
            # This command allows you to set the time to day, and weather to sunny.
            sunday:
                enabled: true
            # @ The /weather, /sun, /storm, /thunder commands
            # Permission: tick_essentials.command.world.weather
            # This command allows you to change the weather in a world.
            weather:
                enabled: true
            # @ The /time, /day, /night commands
            # Permission: tick_essentials.command.world.time
            # This command allows you to change the time in a world.
            time:
                enabled: true
        # @ Economy commands
        # These commands make it easier to manage the economy.
        economy:
            # @ The /balance command
            # Permission: tick_essentials.command.economy.balance
            # This command allows you to check your balance.
            balance:
                enabled: true
        # @ Utility commands
        # These commands are simple utility commands that make simple tasks easier.
        utility:
            # @ The /help command
            # Permission: tick_essentials.command.utility.help
            # This command allows you to send formatted text to users.
            help:
                enabled: true
            # @ The /heal command
            # Permission: tick_essentials.command.utility.heal
            # This command allows you to heal yourself.
            heal:
                enabled: true
            # @ The /back command
            # Permission: tick_essentials.command.world.back
            # This command allows you to teleport back to your last location.
            # @ WARNING
            # Enabling this will use a player flag (tick_essentials.last_location)
            back:
                enabled: true