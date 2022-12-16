# @ ----------------------------------------------------------
# Tick's Essentials
# A collection of useful things, similar to EssentialsX
# plugin.
# Author: 0TickPulse
# @ ----------------------------------------------------------

# @ MAIN COMMAND
tick_essentials_main_tickessentials_command:
    type: command
    debug: false
    name: tickessentials
    description: Shows a list of Tick's Essentials commands.
    usage: /tickessentials
    permission: tick_essentials.command.main.tickessentials
    aliases:
    - te
    - tessentials
    - ticksessentials
    data:
        args:
            page:
                template: integer
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - define title "<&[emphasis]>Tick's Essentials commands:"
    - define page <[arg.page].if_null[1]>
    - inject command_manager.formatted_help_same_file
# @ DEVELOPERS COMMANDS
tick_essentials_developer_commandlist_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.developer.commandlist.enabled].if_null[true]>
    name: commandlist
    description: Enhanced Bukkit /help.
    usage: <script[tick_essentials_developer_commandlist_command].proc[command_manager_generate_usage]>
    permission: tick_essentials.command.developers.commandlist
    aliases:
    - commandslist
    - cmdlist
    - cmds
    data:
        args:
            command:
                type: linear
                required: false
                explanation: The name of any command.
                accepted: <server.commands.include[<server.plugins.parse[commands.values.parse[get[aliases].if_null[<list>].combine]]>].contains_single[<[value]>]>
                tab completes: <server.commands.include[<server.plugins.parse[commands.values.parse[get[aliases].if_null[<list>].combine]]>]>
            #player: template=player
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <[arg.command].exists>:
        - define search <[arg.command].to_list.contains[:].if_true[<[arg.command].after[:]>].if_false[<[arg.command]>]>
        - define plugin <server.command_plugin[<[arg.command]>].if_null[null]>
        - if <[plugin]> == null:
            - define script <util.scripts.filter[container_type.equals[command]].filter_tag[<[filter_value].data_key[aliases].if_null[<list>].include[<[filter_value].data_key[name]>].contains[<[search]>]>]>
            - if <[script].is_empty>:
                - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>There are no plugins or scripts handling the command '/<[arg.command]>', and therefore I can't show the help for it."
                - stop
            - definemap command_info:
                name: <[script].first.data_key[name]>
                description: <[script].first.parsed_key[description]>
                usage: <[script].first.parsed_key[usage]>
            - if <[script].first.data_key[aliases].exists>:
                - define command_info.aliases <[script].first.data_key[aliases]>
        - else:
            - define command_info_raw <[plugin].commands.filter_tag[<[filter_value.aliases].if_null[<list>].include[<[filter_key]>].contains[<[search]>]>]>
            - define command_info <[command_info_raw].values.first.include[name=<[command_info_raw].keys.first>]>
        - define lines <list>
        - define lines:->:<script[tick_essentials_data].parsed_key[lang.hline]>
        - define "lines:->:<&[emphasis]>Command: <&[base]>/<[arg.command]><[arg.command].equals[<[command_info.name]>].if_true[].if_false[ <dark_gray>(Alias of /<[command_info.name]>)]>"
        - if <[plugin]> != null:
            - define "lines:->:<&[emphasis]>Plugin: <&[base]><[plugin].name>"
        - define lines:->:<empty>
        - define "lines:->:<&[emphasis]>Description: <&[base]><[command_info.description]>"
        - define lines:->:<empty>
        - define "lines:->:<&[emphasis]>Usage: <&[base]><[command_info.usage].if_null[/<[command_info.name]>].replace[<&lt>command<&gt>].with[<[command_info.name]>]>"
        - if <[command_info].keys> contains aliases:
            - define lines:->:<empty>
            - define lines:->:<&[emphasis]>Aliases<&co>
            - define "lines:->:<&[base]><[command_info.aliases].parse_tag[<gray>- <[parse_value].custom_color[emphasis]>].separated_by[<n>]>"
        - define lines:->:<script[tick_essentials_data].parsed_key[lang.hline]>
        - define text <[lines].separated_by[<n>]>
        - narrate <[text]>
tick_essentials_developer_enchant_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.developer.enchant.enabled].if_null[true]>
    name: enchant
    description: Enchants an item in the player's inventory.
    usage: <script[tick_essentials_developer_enchant_command].proc[command_manager_generate_usage]>
    permission: tick_essentials.command.developers.enchant
    aliases:
    - ench
    data:
        args:
            enchantment:
                type: linear
                required: true
                accepted: <server.enchantments.parse[name].contains_single[<[value]>]>
                tab completes: <server.enchantments.parse[name]>
                result: <[value].as[enchantment]>
            level:
                type: linear
                required: false
                accepted: <[value].is_integer.or[<[value].equals[remove]>]>
                tab completes: remove
                default: 1
                usage text:
                    auto format: true
                    list:
                    - <&lt>level<&gt>
                    - <&lc>1<&rc>
                    - remove
            bypass: template=boolean_default_false
            player: template=player
            s: template=boolean_default_false
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <player.exists>:
        - if !<player.has_permission[tick_essentials.command.developer.enchant.bypass]>:
            - define <[arg.bypass]> false
        - if <player> != <[arg.player]> && !<player.has_permission[tick_essentials.command.developer.enchant.other]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You do not have permission to do this to other players!"
            - stop
    - define item <[arg.player].item_in_hand>
    - if <[item]> matches air:
        - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You must be holding an item to enchant it!"
        - stop
    - if <[arg.level].is_integer>:
        - if !<[arg.enchantment].can_enchant[<[item]>]> && !<[arg.bypass]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You cannot enchant this item with <[arg.enchantment].name>!"
            - stop
        - if <[arg.level]> > <[arg.enchantment].max_level> && !<[arg.bypass]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>The maximum level for <[arg.enchantment].name> is <[arg.enchantment].max_level>!"
            - stop
        - inventory adjust d:<[arg.player].inventory> slot:hand enchantments:<[item].enchantment_map.include[<map.with[<[arg.enchantment].name>].as[<[arg.level]>]>]>
        - define message "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Successfully enchanted <[arg.player].name>'s <[item].display.if_null[<[item].material.translated_name>]> <&[success]>with <[arg.enchantment].name> <[arg.level]>!"
    - else:
        - inventory adjust d:<[arg.player].inventory> slot:hand remove_enchantments:<[arg.enchantment]>
        - define message "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Successfully removed <[arg.enchantment].name> from <[arg.player].name>'s <[item].display.if_null[<[item].material.translated_name>]><&[success]>!"
    - if <[arg.s]>:
        - stop
    - narrate <[message]>

tick_essentials_developer_enum_command:
    type: command
    name: enum
    enabled: <script[tick_essentials_data].parsed_key[commands.developers.enum.enabled].if_null[true]>
    description: Returns spigot enums.
    usage: /enum [<&lt>type<&gt>] (<&lt>value<&gt>)
    permission: tick_essentials.command.developers.enum
    tab completions:
        1: material|sound|particle|attribute
        2: <context.args.get[1].if_null[null].equals[material].if_true[<server.material_types.parse[name]>].if_false[<context.args.get[1].if_null[null].equals[sound].if_true[<server.sound_types>].if_false[<context.args.get[1].if_null[null].equals[particle].if_true[<server.particle_types>].if_false[<context.args.get[1].if_null[null].equals[attribute].if_true[<server.nbt_attribute_types>].if_false[]>]>]>]>
    debug: false
    script:
    - choose <context.args.get[1].if_null[null]>:
        - case material:
            - define name <context.args.get[2].if_null[null]>
            - if <[name]> == null:
                - narrate "Spigot material names - <element[click here].click_url[https://hub.spigotmc.org/javadocs/spigot/org/bukkit/Material.html].color[blue]>"
                - stop
            - if <server.material_types.parse[name]> !contains <[name]>:
                - narrate "<&[error]>This material does not exist in this server!"
                - stop
            - narrate "Spigot material <[name]> - <element[click here].click_url[https://hub.spigotmc.org/javadocs/spigot/org/bukkit/Material.html#<[name].to_uppercase>].color[blue]>"
        - case sound:
            - define name <context.args.get[2].if_null[null]>
            - if <[name]> == null:
                - narrate "Spigot sound names - <element[click here].click_url[https://hub.spigotmc.org/javadocs/spigot/org/bukkit/Sound.html].color[blue]>"
                - stop
            - if <server.sound_types> !contains <[name]>:
                - narrate "<&[error]>This sound does not exist in this server!"
                - stop
            - narrate "Spigot sound <[name]> - <element[click here].click_url[https://hub.spigotmc.org/javadocs/spigot/org/bukkit/Sound.html#<[name].to_uppercase>].color[blue]>"
        - case particle:
            - define name <context.args.get[2].if_null[null]>
            - if <[name]> == null:
                - narrate "Spigot particle names - <element[click here].click_url[https://hub.spigotmc.org/javadocs/spigot/org/bukkit/Particle.html].color[blue]>"
                - stop
            - if <server.particle_types> !contains <[name]>:
                - narrate "<&[error]>This particle does not exist in this server!"
                - stop
            - narrate "Spigot particle <[name]> - <element[click here].click_url[https://hub.spigotmc.org/javadocs/spigot/org/bukkit/Particle.html#<[name].to_uppercase>].color[blue]>"
        - case attribute:
            - define name <context.args.get[2].if_null[null]>
            - if <[name]> == null:
                - narrate "Spigot attribute names - <element[click here].click_url[https://hub.spigotmc.org/javadocs/spigot/org/bukkit/attribute/Attribute.html].color[blue]>"
                - stop
            - if <server.nbt_attribute_types> !contains <[name]>:
                - narrate "<&[error]>This attribute does not exist in this server!"
                - stop
            - narrate "Spigot attribute <[name]> - <element[click here].click_url[https://hub.spigotmc.org/javadocs/spigot/org/bukkit/attribute/Attribute.html#<[name].to_uppercase>].color[blue]>"
        - default:
            - narrate "<&[error]>Invalid type! Valid types: material, sound, particle"
            - stop
tick_essentials_developer_pluginversions_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.developers.pluginversions.enabled].if_null[true]>
    name: pluginversions
    description: Returns the versions of all plugins on the server.
    usage: /pluginversions
    permission: tick_essentials.command.developers.pluginversions
    script:
    - narrate <server.plugins.parse_tag[<&[base]><[parse_value].name.custom_color[emphasis]> - Version <[parse_value].version.custom_color[emphasis]>].separated_by[<n>]>
# @ STAFF COMMANDS
tick_essentials_staff_sudo_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.staff.sudo.enabled].if_null[true]>
    name: sudo
    description: Executes a command as another player.
    usage: <script[tick_essentials_staff_sudo_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player_strict
            command:
                required: true
                type: linear
            s: template=boolean_default_false
            op: template=boolean_default_false
    permission: tick_essentials.command.staff.sudo
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <[arg.player].has_permission[tick_essentials.command.staff.sudo.exempt]> && !<player.has_permission[tick_essentials.command.staff.sudo.bypass_exempt].if_null[true]>:
        - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You cannot execute commands as <[arg.player].name>!"
        - stop
    - if <[arg.op]>:
        - execute as_op <[arg.command]> player:<[arg.player]>
    - else:
        - execute as_player <[arg.command]> player:<[arg.player]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Running command '/<[arg.command]>' as player '<[arg.player].name>'..."
tick_essentials_staff_invsee_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.staff.invsee.enabled].if_null[true]>
    name: invsee
    description: Opens the inventory of another player.
    usage: <script[tick_essentials_staff_invsee_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player_strict
    permission: tick_essentials.command.staff.invsee
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject tick_essentials_utility_injections.player_only
    - inject command_manager.args_manager
    - if !<player.exists>:
        - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You must be a player to use this command!"
        - stop
    - if <[arg.player].has_permission[tick_essentials.command.staff.invsee.exempt]> && !<player.has_permission[tick_essentials.command.staff.invsee.bypass_exempt].if_null[true]>:
        - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You cannot view this player's inventory!"
        - stop
    - inventory open d:<[arg.player].inventory>
tick_essentials_staff_uploadlogs_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.staff.uploadlogs.enabled].if_null[true]>
    name: uploadlogs
    description: Uploads logs to hastebin, returning a link to the logs.
    usage: /uploadlogs
    permission: tick_essentials.command.staff.uploadlogs
    script:
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[warning]>Uploading logs..."
    - define log_path <script[tick_essentials_data].data_key[commands.staff.uploadlogs.log path]>
    - define hastebin_link <script[tick_essentials_data].parsed_key[commands.staff.uploadlogs.hastebin link]>
    - ~fileread path:<[log_path]> save:logs
    - define log_contents <entry[logs].data.utf8_decode>
    - ~webget <[hastebin_link]>/documents method:post data:<[log_contents]> save:link
    - define key <entry[link].result.parse_yaml.get[key].if_null[null]>
    - if <[key]> == null:
        - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>An unexpected error occurred while uploading logs! Perhaps an invalid link was specified in the configuration?"
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Logs uploaded! Link: <[hastebin_link]>/<[key]>.log"
tick_essentials_staff_vanish_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.staff.vanish.enabled].if_null[true]>
    name: vanish
    description: Toggles vanish mode.
    usage: /vanish (player)
    permission: tick_essentials.command.staff.vanish
    data:
        args:
            player: template=player
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - flag <[arg.player]> tick_essentials.vanished:<[arg.player].flag[tick_essentials.vanished].if_null[false].not>
    - if <[arg.player].flag[tick_essentials.vanished].if_null[false]>:
        - foreach <[arg.player].location.find_entities.within[40].filter[target.equals[<[arg.player]>]]> as:entity:
            - attack <[entity]> cancel
        - adjust <[arg.player]> invulnerable:true
        - adjust <[arg.player]> visible:false
        - adjust <[arg.player]> affects_monster_spawning:false
    - else:
        - adjust <[arg.player]> invulnerable:false
        - adjust <[arg.player]> visible:true
        - adjust <[arg.player]> affects_monster_spawning:true
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>'<[arg.player].name>' is <[arg.player].flag[tick_essentials.vanished].if_true[now vanished].if_false[no longer vanished]>!"
#   | Gamemode commands
tick_essentials_staff_gamemode_shortcut:
    type: command
    name: gamemode
    enabled: <script[tick_essentials_data].parsed_key[commands.staff.gamemode.enabled].if_null[true]>
    debug: false
    description: A shortcut command to change your gamemode.
    usage: <script[tick_essentials_staff_gamemode_shortcut].proc[command_manager_generate_usage]>
    permission: tick_essentials.command.staff.gamemode
    aliases:
    - gm
    data:
        args:
            gamemode:
                type: linear
                required: true
                accepted: <queue.script.parsed_key[data.gamemode_aliases].parse_value_tag[<[parse_value].include[<[parse_key]>]>].values.combine.contains_single[<[value]>]>
                tab completes: <queue.script.parsed_key[data.gamemode_aliases].keys>
                explanation: The gamemode to set the player to.
            player: template=player
            s: template=boolean_default_false
        gamemode_aliases:
            survival:
            - 0
            - s
            creative:
            - 1
            - c
            adventure:
            - 2
            - a
            spectator:
            - 3
            - sp
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - foreach <script.parsed_key[data.gamemode_aliases]> key:gamemode as:aliases:
        - if <[arg.gamemode]> in <[aliases].include[<[gamemode]>]>:
            - define to_set <[gamemode]>
    - if <player.exists>:
        - if !<player.has_permission[tick_essentials.command.staff.gamemode.<[to_set]>]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You do not have permission to use this gamemode!"
            - stop
        - if <player> != <[arg.player]> && !<player.has_permission[tick_essentials.command.staff.gamemode.other]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You do not have permission to do this to other players!"
            - stop
    - adjust <[arg.player]> gamemode:<[to_set]>
    - if <[flag_args.prefixed_args.silent].if_null[false]>:
        - stop
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Set the gamemode of '<[arg.player].name>' to <[to_set]>!"

tick_essentials_staff_gmc_command:
    type: command
    name: gmc
    enabled: <script[tick_essentials_data].parsed_key[commands.staff.gamemode.enabled].if_null[true]>
    debug: false
    description: A shortcut command to change your gamemode to creative.
    usage: <script[tick_essentials_staff_gmc_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player
            s: template=boolean_default_false
    permission: tick_essentials.command.staff.gamemode.creative
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <player.exists>:
        - if <player> != <[arg.player]> && !<player.has_permission[tick_essentials.command.staff.gamemode.other]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You do not have permission to do this to other players!"
            - stop
    - adjust <[arg.player]> gamemode:creative
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Set your gamemode to creative!"
tick_essentials_staff_gms_command:
    type: command
    name: gms
    enabled: <script[tick_essentials_data].parsed_key[commands.staff.gamemode.enabled].if_null[true]>
    debug: false
    description: A shortcut command to change your gamemode to survival.
    usage: <script[tick_essentials_staff_gms_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player
            s: template=boolean_default_false
    permission: tick_essentials.command.staff.gamemode.survival
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <player.exists>:
        - if <player> != <[arg.player]> && !<player.has_permission[tick_essentials.command.staff.gamemode.other]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You do not have permission to do this to other players!"
            - stop
    - adjust <[arg.player]> gamemode:survival
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Set your gamemode to survival!"
tick_essentials_staff_gma_command:
    type: command
    name: gma
    enabled: <script[tick_essentials_data].parsed_key[commands.staff.gamemode.enabled].if_null[true]>
    debug: false
    description: A shortcut command to change your gamemode to adventure.
    usage: <script[tick_essentials_staff_gma_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player
            s: template=boolean_default_false
    permission: tick_essentials.command.staff.gamemode.adventure
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <player.exists>:
        - if <player> != <[arg.player]> && !<player.has_permission[tick_essentials.command.staff.gamemode.other]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You do not have permission to do this to other players!"
            - stop
    - adjust <[arg.player]> gamemode:adventure
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Set your gamemode to adventure!"
tick_essentials_staff_gmsp_command:
    type: command
    name: gmsp
    enabled: <script[tick_essentials_data].parsed_key[commands.staff.gamemode.enabled].if_null[true]>
    debug: false
    description: A shortcut command to change your gamemode to spectator.
    usage: <script[tick_essentials_staff_gmsp_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player
            s: template=boolean_default_false
    permission: tick_essentials.command.staff.gamemode.spectator
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <player.exists>:
        - if <player> != <[arg.player]> && !<player.has_permission[tick_essentials.command.staff.gamemode.other]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You do not have permission to do this to other players!"
            - stop
    - adjust <[arg.player]> gamemode:spectator
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Set your gamemode to spectator!"
#   | Moderation commands
tick_essentials_staff_kick_command:
    type: command
    name: kick
    enabled: <script[tick_essentials_data].parsed_key[commands.staff.kick.enabled].if_null[true]>
    debug: false
    description: A shortcut command to kick a player.
    usage: <script[tick_essentials_staff_kick_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player
            reason:
                type: linear
                required: false
                default: Kicked by <player.name.if_null[console]>.
                spread: true
            s: template=boolean_default_false
    permission: tick_essentials.command.staff.kick
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - kick <[arg.player]> reason:<[arg.reason]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Kicked <[arg.player].name>!"

tick_essentials_staff_ban_command:
    type: command
    name: ban
    enabled: <script[tick_essentials_data].parsed_key[commands.staff.ban.enabled].if_null[true]>
    debug: false
    description: Bans a player, making them unable to play on the server.
    usage: <script[tick_essentials_staff_ban_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player_include_offline_strict
            duration:
                type: linear
                required: false
                accepted: <[value].as[duration].exists.or[<[value].equals[permanent]>]>
                default: permanent
                usage text:
                    auto format: true
                    list:
                    - <&lt>duration<&gt>
                    - <&lc>permanent<&rc>
                tab completes: permanent
            reason:
                type: linear
                required: false
                spread: true
                default: Banned by <player.name.if_null[console]>.
            ip: template=boolean_default_false;explanation=Whether to ban the player's IP address instead of just the player.
            s: template=boolean_default_false
    permission: tick_essentials.command.staff.ban
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <[arg.duration].as[duration].exists>:
        - if <[arg.ip]>:
            - ban addresses:<[arg.player].ip> reason:<[arg.reason]> source:<player.name.if_null[console]> expire:<[arg.duration]>
        - else:
            - ban <[arg.player]> reason:<[arg.reason]> source:<player.name.if_null[console]> expire:<[arg.duration]>
    - else if <[arg.ip]>:
            - ban addresses:<[arg.player].ip> reason:<[arg.reason]> source:<player.name.if_null[console]>
    - else:
        - ban <[arg.player]> reason:<[arg.reason]> source:<player.name.if_null[console]> expire:<[arg.duration]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Banned <[arg.player].name><[arg.ip].if_true['s address].if_false[]><[arg.duration].as[duration].exists.if_true[ for <[arg.duration].as[duration].formatted>].if_false[ permanently]> for: '<[arg.reason]>'"

tick_essentials_staff_unban_command:
    type: command
    name: unban
    enabled: <script[tick_essentials_data].parsed_key[commands.staff.unban.enabled].if_null[true]>
    debug: false
    description: Unbans a player, allowing them to play on the server again.
    usage: <script[tick_essentials_staff_unban_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player_include_offline_strict
            ip: template=boolean_default_false;explanation=Whether to unban the player's IP address instead of just the player.
            s: template=boolean_default_false
    permission: tick_essentials.command.staff.unban
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if !<[arg.ip].if_true[<server.is_banned[<[arg.player].ip>]>].if_false[<[arg.player].is_banned>]>:
        - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>That player<[arg.ip].if_true['s address].if_false[]> is not banned!"
        - stop
    - if <[arg.ip]>:
        - ban remove addresses:<[arg.player].ip>
    - else:
        - ban remove <[arg.player]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Unbanned <[arg.player].name><[arg.ip].if_true['s address].if_false[]>!"
# @ WORLD COMMANDS
tick_essentials_world_speed_command:
    type: command
    name: speed
    enabled: <script[tick_essentials_data].parsed_key[commands.world.speed.enabled].if_null[true]>
    debug: false
    description: Lets you change your walking/flying speed.
    usage: <script[tick_essentials_world_speed_command].proc[command_manager_generate_usage]>
    data:
        args:
            speed: type=linear;accepted=<[value].is_decimal>;required=true
            type:
                type: linear
                required: false
                default: walk
                tab completes: walk|fly
            player: template=player
            s: template=boolean_default_false
    permission: tick_essentials.command.world.speed
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <[arg.speed]> <= 0 || <[arg.speed]> > 1:
        - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>Speed must be between 0 and 1!"
        - stop
    - choose <[arg.type]>:
        - case walk:
            - adjust <player> walk_speed:<[arg.speed]>
        - case fly:
            - adjust <player> fly_speed:<[arg.speed]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Set <[arg.type]> speed of '<[arg.player].name>' to <[arg.speed]>!"
tick_essentials_world_fly_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.world.fly.enabled].if_null[true]>
    name: fly
    description: Toggles flight mode (unless you specify true/false).
    usage: <script[tick_essentials_world_fly_command].proc[command_manager_generate_usage]>
    permission: tick_essentials.command.world.fly
    data:
        args:
            player: template=player
            mode: template=boolean_null
            s: template=boolean_default_false
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - define player <[arg.player]>
    - define mode <[arg.mode].if_null[null]>
    - if <[mode]> == null:
        - define mode <[player].can_fly.not>
    - adjust <[player]> can_fly:<[mode]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]><[mode].if_true[Enabled].if_false[Disabled]> fly for '<[player].name>'!"
#   | Sunday shortcut (both weather and time)
tick_essentials_sunday_shortcut:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.world.sunday.enabled].if_null[true]>
    name: sunday
    description: Sets the time to day and the weather to sunny.
    usage: <script[tick_essentials_sunday_shortcut].proc[command_manager_generate_usage]>
    permission: tick_essentials.command.world.sunday
    data:
        args:
            world: template=world_default_player
            s: template=boolean_default_false
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - time 5m <[arg.world]>
    - weather global sunny <[arg.world]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Set time to day and weather to sunny in '<[arg.world].name>'!"
#   | Weather commands
tick_essentials_world_weather_shortcut:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.world.weather.enabled].if_null[true]>
    name: weather
    description: As shortcut command to change the weather.
    usage: <script[tick_essentials_world_weather_shortcut].proc[command_manager_generate_usage]>
    permission: tick_essentials.command.world.weather
    data:
        args:
            weather:
                type: linear
                required: true
                tab completes: <list[sunny|storm|thunder|reset]>
                accepted: <list[sunny|storm|thunder|reset].contains_single[<[value]>]>
                usage text:
                    auto format: true
                    list:
                    - sunny
                    - storm
                    - thunder
                    - reset
            world: template=world_default_player
            duration:
                type: prefixed
                template: duration
                required: false
                default: null
            s: template=boolean_default_false
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <[arg.duration]> == null:
        - weather global <[arg.weather]> <[arg.world]>
    - else:
        - weather global <[arg.weather]> <[arg.world]> reset:<[arg.duration]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Changed the weather to '<[arg.weather]>' in world '<[arg.world].name>'!"
tick_essentials_world_weather_sun_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.world.weather.enabled].if_null[true]>
    name: sun
    description: A shortcut command to change the weather to sunny.
    usage: <script[tick_essentials_world_weather_sun_command].proc[command_manager_generate_usage]>
    permission: tick_essentials.command.world.weather
    data:
        args:
            world: template=world_default_player
            duration:
                type: prefixed
                template: duration
                required: false
                default: null
            s: template=boolean_default_false
    script:
    - inject command_manager.args_manager
    - if <[arg.duration]> == null:
        - weather global sunny <[arg.world]>
    - else:
        - weather global sunny <[arg.world]> reset:<[arg.duration]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Changed the weather to 'sunny' in world '<[arg.world].name>'!"
tick_essentials_world_weather_storm_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.world.weather.enabled].if_null[true]>
    name: storm
    description: A shortcut command to change the weather to storm.
    usage: <script[tick_essentials_world_weather_storm_command].proc[command_manager_generate_usage]>
    permission: tick_essentials.command.world.weather
    data:
        args:
            world: template=world_default_player
            duration:
                type: prefixed
                template: duration
                required: false
                default: null
            s: template=boolean_default_false
    script:
    - inject command_manager.args_manager
    - if <[arg.duration]> == null:
        - weather global storm <[arg.world]>
    - else:
        - weather global storm <[arg.world]> reset:<[arg.duration]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Changed the weather to 'storm' in world '<[arg.world].name>'!"
tick_essentials_world_weather_thunder_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.world.weather.enabled].if_null[true]>
    name: thunder
    description: A shortcut command to change the weather to thunder.
    usage: <script[tick_essentials_world_weather_thunder_command].proc[command_manager_generate_usage]>
    permission: tick_essentials.command.world.weather
    data:
        args:
            world: template=world_default_player
            duration:
                type: prefixed
                template: duration
                required: false
                default: null
            s: template=boolean_default_false
    script:
    - inject command_manager.args_manager
    - if <[arg.duration]> == null:
        - weather global thunder <[arg.world]>
    - else:
        - weather global thunder <[arg.world]> reset:<[arg.duration]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Changed the weather to 'thunder' in world '<[arg.world].name>'!"
#   | Time commands
tick_essentials_world_time_shortcut:
    type: command
    name: time
    enabled: <script[tick_essentials_data].parsed_key[commands.world.time.enabled].if_null[true]>
    debug: false
    description: A shortcut command to change the time.
    usage: <script[tick_essentials_world_time_shortcut].proc[command_manager_generate_usage]>
    data:
        args:
            time:
                type: linear
                required: true
                accepted: <[value].as[duration].exists>
                explanation: The time to set the world to.
                result: <[value].as[duration]>
            world: template=world_default_player
            s: template=boolean_default_false
    permission: tick_essentials.command.world.time
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - define time <[arg.time]>
    - define world <[arg.world].as[world]>
    - time <[time]> <[world]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Changed the time to <[time].formatted> in world '<[world].name>'!"
tick_essentials_world_time_day_shortcut:
    type: command
    name: day
    enabled: <script[tick_essentials_data].parsed_key[commands.world.time.enabled].if_null[true]>
    debug: false
    description: A shortcut command to change the time to day.
    usage: <script[tick_essentials_world_time_day_shortcut].proc[command_manager_generate_usage]>
    data:
        args:
            world: template=world_default_player
            s: template=boolean_default_false
    permission: tick_essentials.command.world.time
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - define world <[arg.world].as[world]>
    - time 5m <[world]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Changed the time to day in world '<[world].name>'!"
tick_essentials_world_time_night_shortcut:
    type: command
    name: night
    enabled: <script[tick_essentials_data].parsed_key[commands.world.time.enabled].if_null[true]>
    debug: false
    description: A shortcut command to change the time to night.
    usage: <script[tick_essentials_world_time_night_shortcut].proc[command_manager_generate_usage]>
    data:
        args:
            world: template=world_default_player
            s: template=boolean_default_false
    permission: tick_essentials.command.world.time
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - define world <[arg.world].as[world]>
    - time 15m <[world]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Changed the time to night in world '<[world].name>'!"
# @ ECONOMY COMMANDS
tick_essentials_economy_pay_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.economy.pay.enabled].if_null[true]>
    name: pay
    description: A shortcut command to pay another player.
    usage: <script[tick_essentials_economy_pay_command].proc[command_manager_generate_usage]>
    permission: tick_essentials.command.economy.pay
    data:
        args:
            player: template=player_include_offline_strict
            amount:
                type: linear
                required: true
                accepted: <[value].is_decimal>
                explanation: The amount to pay.
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <[arg.amount]> <= 0:
        - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>Amount must be more than 0!"
    - if <player.exists>:
        - if <[arg.player]> == <player>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You can't pay yourself!"
            - stop
        - if <player.money> < <[arg.amount]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You don't have enough money to do that!"
            - stop
    - money give quantity:<[arg.amount]> players:<[arg.player]>
    - if <player.exists>:
        - money take quantity:<[arg.amount]>
        - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>You gave <[arg.player].name> <server.economy.format[<[arg.amount]>]>!"
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]><player.name> gave you <server.economy.format[<[arg.amount]>]>!" targets:<[arg.player]>
tick_essentials_economy_balance_shortcut:
    type: command
    name: balance
    enabled: <script[tick_essentials_data].parsed_key[commands.economy.balance.enabled].if_null[true]>
    debug: false
    description: A shortcut command to check your balance.
    usage: <script[tick_essentials_economy_balance_shortcut].proc[command_manager_generate_usage]>
    aliases:
    - bal
    data:
        args:
            player: template=player_include_offline
    permission: tick_essentials.command.economy.balance
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>The balance of <[arg.player].name> is <[arg.player].formatted_money>!"
# @ UTILITY COMMANDS
tick_essentials_utility_help_command:
    type: command
    name: help
    enabled: <script[tick_essentials_data].parsed_key[commands.utility.help.enabled].if_null[true]>
    debug: false
    description: Sends formmated help text.
    aliases:
    - ?
    usage: <script[tick_essentials_utility_help_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player
    permission: tick_essentials.command.utility.help
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager

tick_essentials_utility_trash_command:
    type: command
    name: trash
    enabled: <script[tick_essentials_data].parsed_key[commands.utility.trash.enabled].if_null[true]>
    debug: false
    description: Opens a Trash GUI.
    aliases:
    - disposal
    - dispose
    usage: <script[tick_essentials_utility_trash_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player
            s: template=boolean_default_false
    permission: tick_essentials.command.utility.trash
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <player.exists>:
        - if <player> != <[arg.player]> && !<player.has_permission[tick_essentials.command.utility.trash.other]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You do not have permission to open the trash GUI for other players!"
            - stop
    - adjust <queue> linked_player:<[arg.player]>
    - inventory open d:generic[holder=chest;title=Trash;size=54]
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Opened the trash GUI for player '<player.name>'!"
tick_essentials_utility_nickname_command:
    type: command
    name: nickname
    enabled: <script[tick_essentials_data].parsed_key[commands.utility.nickname.enabled].if_null[true]>
    debug: false
    description: Changes your nickname.
    usage: <script[tick_essentials_utility_nickname_command].proc[command_manager_generate_usage]>
    data:
        args:
            nickname:
                type: linear
                required: <[arg.reset].exists.not>
                explanation: The nickname to set.
            player: template=player
            s: template=boolean_default_false
            reset: template=boolean_default_false
    permission: tick_essentials.command.utility.nickname
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <player.exists>:
        - if <player> != <[arg.player]> && !<player.has_permission[tick_essentials.command.utility.nickname.other]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You do not have permission to do this to other players!"
            - stop
    - if !<[arg.reset].exists>:
        - if <[arg.nickname].contains[ ]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>Nicknames cannot contain spaces!"
            - stop
        - adjust <[arg.player]> player_list_name:<[arg.nickname]>
        - adjust <[arg.player]> display_name:<[arg.nickname]>
        - if <[arg.s]>:
            - stop
        - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Changed <[arg.player].name>'s nickname to '<[arg.nickname]>'!"
        - stop
    - adjust <[arg.player]> player_list_name:<player.name>
    - adjust <[arg.player]> display_name:<player.name>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Reset <[arg.player].name>'s nickname!"
tick_essentials_utility_heal_command:
    type: command
    name: heal
    enabled: <script[tick_essentials_data].parsed_key[commands.utility.heal.enabled].if_null[true]>
    debug: false
    description: Replenishes your health, hunger, saturation, and optionally removes potion effects and fire.
    usage: <script[tick_essentials_utility_heal_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player
            remove_fire: template=boolean_default_true
            remove_effects: template=boolean_default_false
            s: template=boolean_default_false
    permission: tick_essentials.command.utility.heal
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <player.exists>:
        - if <player> != <[arg.player]> && !<player.has_permission[tick_essentials.command.utility.heal.other]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You do not have permission to do this to other players!"
            - stop
    - heal <[arg.player]>
    - feed <[arg.player]>
    - adjust <[arg.player]> saturation:20
    - if <[arg.remove_effects]>:
        - foreach <player.effects_data> as:effect:
            - cast <[effect.type]> remove
    - if <[arg.remove_fire]>:
        - burn <[arg.player]> 0
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Healed '<[arg.player].name>', <[arg.remove_effects].if_true[].if_false[without ]>removing effects, <[arg.remove_fire].if_true[].if_false[without ]>extinguishing!"
tick_essentials_utility_feed_command:
    type: command
    name: feed
    enabled: <script[tick_essentials_data].parsed_key[commands.utility.feed.enabled].if_null[true]>
    debug: false
    description: Restores your hunger and saturation.
    usage: <script[tick_essentials_utility_feed_command].proc[command_manager_generate_usage]>
    data:
        args:
            player: template=player
            s: template=boolean_default_false
    permission: tick_essentials.command.utility.feed
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - if <player.exists>:
        - if <player> != <[arg.player]> && !<player.has_permission[tick_essentials.command.utility.feed.other]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You do not have permission to do this to other players!"
            - stop
    - feed <[arg.player]>
    - adjust <[arg.player]> saturation:20
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Fed '<[arg.player].name>'!"
tick_essentials_utility_back_command:
    type: command
    debug: false
    enabled: <script[tick_essentials_data].parsed_key[commands.utility.back.enabled].if_null[true]>
    name: back
    description: Go to your previous location (before teleporting).
    usage: <script[tick_essentials_utility_back_command].proc[command_manager_generate_usage]>
    permission: tick_essentials.command.utility.back
    data:
        args:
            player: template=player
            s: template=boolean_default_false
    tab complete:
    - inject command_manager.tab_complete_engine
    script:
    - inject command_manager.args_manager
    - define player <[arg.player]>
    - define location <[player].flag[tick_essentials.back_location].if_null[null]>
    - if <[location]> == null:
        - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>The player '<[player].name>' does not have a previous location logged!"
        - stop
    - if <player.exists>:
        - if <[player]> != <player> && !<player.has_permission[tick_essentials.command.utility.back.other]>:
            - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[error]>You do not have permission to do this to other players!"
            - stop
    - teleport <[player]> <[location]>
    - if <[arg.s]>:
        - stop
    - narrate "<script[tick_essentials_data].parsed_key[lang.prefix]> <&[success]>Teleported '<[player].name>' to their previous location!"

