tick_economy_data:
    type: data
    money give message: <&[base]>[+<[amount].proc[tick_economy_format_money]>]
    money tale message: <&[base]>[-<[amount].proc[tick_economy_format_money]>]
tick_economy_main:
    type: economy
    debug: false
    priority: normal
    # The name of the currency in the singular (such as "dollar" or "euro").
    name single: tickcoin
    # The name of the currency in the plural (such as "dollars" or "euros").
    name plural: tickcoins
    # How many digits after the decimal to include. For example, '2' means '1.05' is a valid amount, but '1.005' will be rounded.
    digits: 2
    # Format the standard output for the money in human-readable format. Use "<[amount]>" for the actual amount to display.
    # Fully supports tags.
    format: <[amount].format_number.custom_color[emphasis].bold> <element[$].font[icons].color[white]>
    # A tag that returns the balance of a linked player. Use a 'proc[]' tag if you need more complex logic.
    # Must return a decimal number.
    balance: <player.flag[tick_economy.money]>
    # A tag that returns a boolean indicating whether the linked player has the amount specified by def "<[amount]>".
    # Use a 'proc[]' tag if you need more complex logic.
    # Must return 'true' or 'false'.
    has: <player.flag[tick_economy.money].is[or_more].than[<[amount]>]>
    # A script that removes the amount of money needed from a player.
    # Note that it's generally up to the systems calling this script to verify that the amount can be safely withdrawn, not this script itself.
    # However you may wish to verify that the player has the amount required within this script.
    # The script may determine a failure message if the withdraw was refused. Determine nothing for no error.
    # Use def 'amount' for the amount to withdraw.
    withdraw:
    - flag <player> tick_economy.money:-:<[amount]>
    - narrate <script[tick_economy_data].parsed_key[money take message]>
    # A script that adds the amount of money needed to a player.
    # The script may determine a failure message if the deposit was refused. Determine nothing for no error.
    # Use def 'amount' for the amount to deposit.
    deposit:
    - flag <player> tick_economy.money:+:<[amount]>
    - narrate <script[tick_economy_data].parsed_key[money give message]>
tick_economy_first_set:
    type: world
    debug: false
    events:
        on player joins:
        - if !<player.has_flag[tick_economy.money]>:
            - flag <player> tick_economy.money:0

tick_economy_format_money:
    type: procedure
    debug: false
    definitions: amount
    script:
    - determine <script[tick_economy_main].parsed_key[format]>