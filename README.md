# Aptos Legacy

Aptos Legacy is a mostly on-chain Action RPG built for the [Code Collision Hackathon](https://dorahacks.io/hackathon/code-collision/).

Many thanks to the Encode Club bootcamp for introducing me to Move and Aptos, I've legitimately had a blast building on Aptos. This has been hands down the best dev experience in all my crypto years.

## Move

The Smart Contracts are written in Aptos Move, I'm not making use of anything Move 2.0 (yet).

All in all a very pleasant experience, I recommend using the free community edition of Rust Rover and the dedicated "Move on Aptos" plugin over VS code.

### About the code itself

I've tried to make use of "Objects" as much as possible and share them around as much as possible. It seems execution is extremely cheap compared to storage on Move.

### How does it work?

All items and currencies in this game are represented as Token in a single collection.

These items/tokens can then be used to define Reward tables that are both used for easier displaying, Monster loot and Mission rewards table.

These same items are also defined as buyable in our fancy ***Premium*** shop.

Make sure to setup a local network (with indexer) and make extensive use of the seed_everything script as well as included e2e tests to help with dev.

## WebApp (Sveltekit)

First off: frankly don't use three.js and just go straight for an actual game engine, there's an Aptos for Unity SDK laying around and it looks like it follows the same API as the JS one.

Google Auth will break on localnet, Petra will also break because the set URL is wrong, make sure to switch to http://127.0.0.1:8080/v1 and while that won't fix the wallet display, at least you'll be able to use the wallet in the app.

I would recommend either reworking events to make them easier to use on the frontend or implementing some kind of data layer for your assets. Things get tricky real fast with all these fungible assets. 