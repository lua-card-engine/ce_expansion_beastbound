# 🃏 CardEngine Expansion Set: Beastbound

This repository contains the Beastbound Base Expansion Set for CardEngine, a comprehensive collectible card framework for Garry's Mod. This expansion set introduces a variety of cards for players to collect and trade.

> [!IMPORTANT]
> **The card assets in the `design/`-directory are AI-slop.** While they are free to use in your own projects, we encourage you to have a professional artist create the card designs for your own expansion set if you have the means.

## 🚀 Usage

To use this expansion set in your Garry's Mod server, follow these steps:

1. Ensure CardEngine is already installed on your Garry's Mod server.

2. [Download](https://github.com/lua-card-engine/ce_expansion_beastbound/archive/refs/heads/main.zip) this repository to your local machine.

3. Extract the downloaded zip file into the `garrysmod/addons/` directory of your Garry's Mod installation.

4. (Optional) After downloading from git the folder will be named `ce_expansion_beastbound-main`. Rename it to `ce_expansion_beastbound`, which is a cleaner name.

5. After the above steps, the folder structure should look like this:

    ```plaintext
    garrysmod/
    └── addons/
        └── ce_expansion_beastbound/
            ├── design/
            │   └── ...
            ├── lua/
            │   ├── autorun/
            │   │   └── ce_expansion_beastbound.lua
            │   └── ce_expansion_beastbound/
            │       └── ...
            ├── materials/
            │   └── card_engine/
            │       └── expansions/
            │           └── ce_expansion_beastbound/
            ├── tools/
            │   └── ...
            └── ...
    ```

**That's it!** You can now (re)start your Garry's Mod server and enjoy the Beastbound Expansion Set in CardEngine.

[&raquo; See Advanced Usage if you want to self-host the card materials](ADVANCED_USAGE.md)
