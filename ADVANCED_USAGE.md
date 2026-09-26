# 🧩 Advanced Usage

We already serve the card materials for this expansion set through Cloudflare R2, so you don't have to worry about hosting them yourself. However, if you want to self-host the card materials, you can follow the instructions below.

## 📦 Distribution

The files in this expansion set are distributed through Cloudflare R2. See [the `sync-to-r2` GitHub Action configuration](.github/workflows/sync-to-r2.yml) to understand how the distribution works.

**In short:** Whenever the contents of the `materials/` folder are changed and pushed to the `main` branch, those changes are automatically uploaded to Cloudflare R2 for distribution. In [the `sh_init.lua` configuration file of this expansion set](lua/ce_expansion_beastbound/sh_init.lua), the R2 URL is setup as the remote location where CardEngine should look for the card materials:

```lua
CardEngine.ExpansionSet.Register({
    RemoteDownloadURL = "https://<the URL to CloudFlare R2>/",
    --- ... (other configuration options)
})
```

If a new player connects and does not have the card materials yet, CardEngine will download them from that R2 URL.

### Required Setup in GitHub

To enable the automatic synchronization to Cloudflare R2, you need to set up the following GitHub Secrets in your repository settings:

- `R2_ACCOUNT_ID`: You can find this in your Cloudflare R2 dashboard under "R2 object storage" > "Overview" > "Account Details".
- `R2_ACCESS_KEY_ID`: This can be created in your Cloudflare R2 dashboard under "Manage Account" > "Account API Tokens". It can only be seen once when created, so it's probably best to store this as an organization secret if you have multiple repositories using the same R2 bucket. Make sure the token gets both "Read" and "Write" permissions for R2.
- `R2_SECRET_ACCESS_KEY`: See the instructions for `R2_ACCESS_KEY_ID`.
- `R2_BUCKET_NAME`: The name of the R2 bucket where the card materials will be stored.

Additionally, add this variable to the repository, to specify the expansion subfolder in the R2 bucket:

- `EXPANSION_FOLDER`: Set this to `ce_expansion_beastbound` for this expansion set.

## 🛠️ Tools

This expansion set comes with a handy tool to convert `.png` card designs into the required `.vtf` format for use in Garry's Mod.

### PNG to VTF Converter

To convert your `.png` card designs to `.vtf`, follow these steps:

1. Open a terminal or command prompt.

2. Navigate to the [`tools/`](tools/) directory of this repository:

    ```bash
    cd tools/
    ```

3. Install the required node modules:

    ```bash
    npm install
    ```

4. To convert all `.png` files in the `design/` folder to `.vtf` format in the `materials/card_engine/expansions/ce_expansion_beastbound` folder, run the following command:

    ```bash
    npm run convert
    ```
