tick_spellbook_data:
    type: data

    # @ HOW TO CONFIGURE
    # Under books, these are your books. These all have individual pages.
    # The pages are a list of text, and you can add as many as you want.
    # To link to a different page in the same book, use something like this:
    # <element[here].on_click[<[page_link.other]>].type[change_page]>
    # This prints "here" and changes page to "other" when you click it.
    # To link to a different book, use something like this:
    # <element[here].on_click[<[book_link.other]>]>
    # This prints "here" and changes book to "other" when you click it.

    #books:
    #    home:
    #        main:
    #        - Spellbook
    #        - Other page: <element[here].on_click[<[page_link.other]>].type[change_page]>
    #        - Other book: <element[here].on_click[<[book_link.other]>]>
    #        other:
    #        - bad
    #    other:
    #        home:
    #        - Other page!

    books:
        home:
            main:
            - <&hover[<&[lccblue]>Version 5 for MC: 1.18.x <red>(0TickPulse/Denizen)]><white>    <&end_hover>
            - <empty>
            - <&sp.repeat[2]><placeholder[tab_customtabname]>
            - <dark_gray><strikethrough>                            <reset>
            - <element[<white>🚫 <red>Profile].on_hover[<&6>COMING SOON]>
            #- <&click[<[book_link.profile]>]><white>▶ <&[lccblue]>Profile<&end_click>
            - <&click[<[book_link.navigation]>]><white>▶ <&[lccblue]>Navigation<&end_click>
            - <&click[<[book_link.claims]>]><white>▶ <&[lccblue]>Claims<&end_click>
            - <&click[<[book_link.quests]>]><white>▶ <&[lccblue]>Quests<&end_click>
            - <&click[<[book_link.economy]>]><white>▶ <&[lccblue]>Economy<&end_click>
            - <&click[<[book_link.mcmmo]>]><white>▶ <&[lccblue]>MCMMO/Party<&end_click>
            - <&click[<[book_link.links]>]><white>▶ <&[lccblue]>Links<&end_click>
            - <&click[<[book_link.misc]>]><white>▶ <&[lccblue]>Misc<&end_click>
            - <&click[<[book_link.leaderboards]>]><white>▶ <&[lccblue]>Leaderboards<&end_click>
        navigation:
            main:
            - <&click[<[book_link.home]>]><white>🔙     <&[lccblue]>Navigation<&end_click>
            - <dark_gray><strikethrough>                            <reset>
            - <empty>
            - <element[<white>🌍 <dark_green>Lobby].on_hover[Warp to the Lobby.].on_click[/spawn]>
            - <element[<white>🌲 <dark_green>Wilderness].on_hover[Choose a biome and go wild! <red>Danger lurks farther out!].on_click[/wild]>
            - <element[<white>↩ <dark_green>Back].on_hover[Return from whence you came! does not return to death point.].on_click[/back]>
            - <empty>
            - <element[<white>🔎 <&[lccblue]>How to make Warps].on_hover[Want to make your own warps?].on_click[https://github.com/LcorpOfficial/LCC-Minecraft-Server/wiki/Getting-Around#player-warp-commands].type[open_url]>
        claims:
            main:
            - <&click[<[book_link.home]>]><white>🔙        <&[lccblue]>Claims<&end_click>
            - <dark_gray><strikethrough>                            <reset>
            - <empty>
            - <white>🚧 <&[lccblue]>Claim Blocks: <dark_aqua><placeholder[griefdefender_player_blocks_left]>
            - <empty>
            - <element[<white>🚩 <dark_green>Claims].on_hover[Check claims list and details.].on_click[/claimslist]>
            - <element[<white>❌ <dark_green>Unclaim].on_hover[Removes the claim you are standing in, and refunds the claim blocks.].on_click[/abandonclaim]>
            - <element[<white>🏘 <dark_green>Homes].on_hover[See your homes.].on_click[/homes]>
            - <element[<white>🤝 <dark_green>Trusts].on_hover[See who you trust on the claim you are standing in.].on_click[/trustlist]>
            - <element[<white>⚒ <dark_green>Get Tools].on_hover[Get a Golden Shovel and a Stick for claims.].on_click[/kit claims]>
            - <empty>
            - <element[<white>🔎 <&[lccblue]>How to sell Claims].on_hover[Detailed instructions on Real Estate].on_click[https://github.com/LcorpOfficial/LCC-Minecraft-Server/wiki/Real-Estate].type[open_url]>
        quests:
            main:
            - <&click[<[book_link.home]>]><white>🔙        <&[lccblue]>Quests<&end_click>
            - <dark_gray><strikethrough>                            <reset>
            - <empty>
            - <element[<white>📘 <dark_green>Quest Journal].on_hover[Get your Quest Journal!].on_click[/journal]>
        economy:
            main:
            - <&click[<[book_link.home]>]><white>🔙       <&[lccblue]>Economy<&end_click>
            - <dark_gray><strikethrough>                            <reset>
            - <empty>
            - <white>🪙 <&[lccblue]>Balance: <dark_aqua>$<placeholder[vault_eco_balance_formatted]>
            - <empty>
            - <element[<white>💎 <dark_green>AuctionHouse].on_hover[View item listings for sale].on_click[/ah]>
            - <element[<white>📑 <dark_green>Current Listings].on_hover[View the items you are selling.].on_click[/ah selling]>
            - <element[<white>👁 <dark_green>Expired Listings].on_hover[View expired listings.].on_click[/ah expired]>
            - <element[<white>♻ <dark_green>Return Items].on_hover[Return all expired listings to inventory.].on_click[/ah return]>
        mcmmo:
            main:
            - <&click[<[book_link.home]>]><white>🔙        <&[lccblue]>MCMMO<&end_click>
            - <dark_gray><strikethrough>                            <reset>
            - <empty>
            - <white>👬 <&[lccblue]>Current Party: <dark_aqua><placeholder[mcmmo_party_name]><reset>
            - <empty>
            - <element[<white>📊 <dark_green>Stats Summary].on_hover[Check your Ability Stats.].on_click[/mcstats]>
            - <element[<white>👬 <dark_green>Party Summary].on_hover[See details about your Party.].on_click[/party info]>
            - <empty>
            - <element[<white>🔎 <&[lccblue]>What is MCMMO?].on_click[https://wiki.mcmmo.org/].type[open_url].on_hover[Open the MCMMO Wiki]>
            - <element[<white>🔎 <&[lccblue]>How to use Parties?].on_hover[See Party commands.].on_click[/party help]>
        rank_commands:
            main:
            - <&click[<[book_link.home]>]><white>🔙   <&[lccblue]>Rank Commands<&end_click>
            - <dark_gray><strikethrough>                            <reset>
            - <empty>
        links:
            main:
            - <&click[<[book_link.home]>]><white>🔙        <&[lccblue]>Links<&end_click>
            - <dark_gray><strikethrough>                            <reset>
            - <empty>
            - <element[<white>❓ <dark_green>Help Menu].on_hover[Open the general help menu.].on_click[/help]>
            - <element[<white>🚨 <dark_green>Rules].on_hover[Read the rules.].on_click[/rules]>
            - <element[<white> <dark_green>Discord].on_hover[Join our Discord!].on_click[/discord]>
            - <empty>
            - <element[<white>🔎 <&[lccblue]>Interactive Map].on_click[http://map.lcorpcity.com:2095].type[open_url].on_hover[Open the Interactive Map!]>
            - <element[<white>🔎 <&[lccblue]>Website].on_click[https://lcorpcity.com].type[open_url].on_hover[Visit the LCC Website!]>
            - <element[<white>🔎 <&[lccblue]>Donate].on_click[https://store.lcorpcity.com].type[open_url].on_hover[Show some appreciation for our hard work!]>
            - <element[<white>🔎 <&[lccblue]>Wiki].on_click[https://github.com/LcorpOfficial/LCC-Minecraft-Server/wiki].type[open_url].on_hover[View our wiki, covering gameplay mechanics in detail.]>
        misc:
            main:
            - <&click[<[book_link.home]>]><white>🔙        <&[lccblue]>Misc<&end_click>
            - <dark_gray><strikethrough>                            <reset>
            - <empty>
            - <element[<white>🔈 <dark_green>Audio Client].on_hover[Start the Audio Client! Click the Open button in chat!].on_click[/audio]>
            - <element[<white>📈 <dark_green>Toggle Sidebar].on_hover[Toggle sidebar visibility.].on_click[/fb toggle]>
            - <element[<white>🪑 <dark_green>Toggle Sitting].on_hover[Toggle... Sitting.].on_click[/sit]>
            - <element[<white>🛌 <dark_green>Toggle Laying].on_hover[Toggle... Laying.].on_click[/lay]>
            - <element[<white> <dark_green>Link Discord].on_hover[Sync Discord ranks between Minecraft & Discord server.].on_click[/discord link]>
            - <element[<white>📰 <dark_green>Custom Recipes].on_hover[View all the custom recipes in a menu.].on_click[/recipes]>
            - <element[<white>💼 <dark_green>Kit Menu].on_hover[View the Kits you can recieve.].on_click[/kits]>
            - <element[<white>🎒 <dark_green>Backpacks].on_hover[See a list of where your Death Backpacks are].on_click[/aclist]>
            - <element[<white>🎩 <dark_green>Wear Hat].on_hover[Wear the item in your hand as a hat.].on_click[/hat]>
            - <element[<white>🌈 <dark_green>Color Menu].on_hover[See a list of color codes you can use. (Requires Baron or higher!)].on_click[/hat]>
        leaderboards:
            main:
            - <&click[<[book_link.home]>]><white>🔙   <&[lccblue]>Leaderboards<&end_click>
            - <dark_gray><strikethrough>                            <reset>
            - <empty>
            - <element[<white>💰 <dark_green>Top Balances].on_hover[See the richest players on the server!].on_click[/baltop]>
            - <element[<white>⚔ <dark_green>MCMMO Leaderboard].on_hover[See a list of the top-level MCMMO Players!].on_click[/mctop]>

tick_spellbook_book:
    type: book
    title: Spellbook
    author: 0TickPulse
    signed: true
    text:
    - <empty>

tick_spellbook_open_command:
    type: command
    name: spellbook
    description: Opens the spellbook.
    usage: /spellbook [<&lt>player<&gt>]
    debug: false
    aliases:
    - sb
    #permission: tick_spellbook.command.spellbook
    tab completions:
        1: <server.online_players.parse[name]>
    script:
    - if <context.args.size> > 0:
        - define player_name <context.args.get[1]>
        - define player <server.match_player[<[player_name]>].if_null[null]>
        - if <[player]> == null:
            - narrate "<&[error]>Player <[player_name].custom_color[emphasis]> not found."
            - stop
    - else if !<player.exists>:
        - narrate "Player required!"
    - else:
        - define player <player>
    - if <player.exists>:
        - if <[player]> != <player> && !<player.has_permission[tick_spellbook.command.spellbook.others]>:
            - narrate "<&[error]>You do not have permission to open other player's spellbooks."
            - stop
    - run tick_spellbook_open_task player:<[player]> def.type:home
    - playsound <player> sound:item_lodestone_compass_lock  pitch:<util.random.decimal[1].to[1.2].round_to[1]>

tick_spellbook_generate_book_from_map_proc:
    type: procedure
    debug: false
    definitions: map|page_link|book_link
    script:
    - debug log <queue.definitions>
    - define book <item[tick_spellbook_book]>
    - determine <[book].with_single[book_pages=<[map].values.parse[separated_by[<n>].parsed]>]>

tick_spellbook_open_task:
    type: task
    debug: true
    definitions: type
    script:
    - define books <script[tick_spellbook_data].data_key[books]>
    - define home <[books.<[type]>]>
    - define book_link <map>
    - foreach <[books]> as:b key:name:
        - clickable save:clickable tick_spellbook_open_task def.type:<[name]>
        - define book_link.<[name]> <entry[clickable].command>
    - define book <[home].proc[tick_spellbook_generate_book_from_map_proc].context[<list_single[<[home].keys.map_with[<util.list_numbers_to[<[home].size>]>]>].include_single[<[book_link]>]>]>
    - adjust <player> show_book:<[book]>
    - playsound <player> sound:entity_villager_work_librarian pitch:<util.random.decimal[1].to[1.8].round_to[1]>