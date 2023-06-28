# TickCore

A hyperextensible RPG stat system that supports players, entities, and items!

At a lower level, TickCore is a system that allows you to define *stats*. These stats can be stored on players, entities, and items. The method stats are stored is different for each type, but the structure is the same: A map of stat names to modifiers. Using this structure, it is easy to keep track of what modifiers are affecting a stat. For example, the `default` modifier is added to every stat, while the `item_hand` modifier only applies if you have an item in your hand with stats.

## Features

### Really easy to create things

Custom items and entities can be made with just a simple yaml-like configuration. Item lore is automatically generated from the stats of the item.

### Custom stat types

Stats are not limited to numerical values. They can be *anything* as long as you define a reducer for them.
(A reducer is something that takes in a list of values and returns a single value.)

### Easy API

The API is designed to be easy to use and easy to understand. Some important procs include:

- `tickcore_proc.script.items.get_stat` - Get the value of a stat on an item.
- `tickcore_proc.script.entities.get_stat` - Get the value of a stat on an entity.
- `tickcore_proc.script.players.get_stat` - Get the value of a stat on a player.

### Easy to extend

The system is designed to be easy to extend. You can add custom stats, reducers, etc.
I also made an extension for my own server that adds elemental combat, custom archery, damage slashes, custom abilities, (upcoming) mana system and more.

### Simple commands

TickCore includes simple commands to generate items, spawn entities, edit your item stats, and more.

## Important files

- `tickcore.dsc` - The main script.
- `tickcore_configuration.dsc` - The configuration script. You can change the default stats and reducers here.
- `tickcore_implementation.dsc` - My personal extension.

The rest are features of my server that extend TickCore.

## License

This script is licensed under the AGPLv3 License. View the license [here](https://github.com/0tickpulse/TickMC/blob/master/LICENSE)
