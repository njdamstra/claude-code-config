The Cloudflare Wrangler CLI is a command-line interface tool used to manage Cloudflare Worker projects, allowing users to create, develop, and deploy their Workers[1].

Here's an overview of some key Wrangler CLI commands and their functionalities:

*   **`wrangler generate <name> <template>`**: Scaffolds a new Worker project, including boilerplate for a Rust library and a Cloudflare Worker. It can also generate a project from a specified GitHub repository template[2][3].
*   **`wrangler init`**: Creates a `wrangler.toml` file for an existing project[4].
*   **`wrangler build`**: Builds your Worker project[2][4].
*   **`wrangler dev`**: Starts a local development server for your Worker, allowing you to preview changes locally[5][4].
*   **`wrangler publish`** or **`wrangler deploy`**: Publishes or deploys your Worker to Cloudflare's edge network[2][4][6].
*   **`wrangler login`**: Authorizes Wrangler with your Cloudflare account using OAuth[7][5][4].
*   **`wrangler logout`**: Removes Wrangler's authorization for accessing your account[7].
*   **`wrangler whoami`**: Retrieves your user information and tests your authentication configuration[7][2][4].
*   **`wrangler config`**: Configures your global Cloudflare user, requiring your email and API key[2][4].
*   **`wrangler tail`**: Starts a session to livestream logs from a deployed Worker[7][4].
*   **`wrangler kv:namespace`**: Manages Workers KV namespaces[7][4].
*   **`wrangler kv:key`**: Manages individual key-value pairs within a Workers KV namespace[7][4].
*   **`wrangler kv:bulk`**: Manages multiple key-value pairs within a Workers KV namespace in batches[7][4].
*   **`wrangler r2 bucket`**: Manages Workers R2 buckets[7].
*   **`wrangler r2 object`**: Manages Workers R2 objects[7].
*   **`wrangler secret`**: Manages secret variables for a Worker[7][4].
*   **`wrangler secret bulk`**: Manages multiple secret variables for a Worker[7].
*   **`wrangler pages`**: Configures Cloudflare Pages[7].
*   **`wrangler queues`**: Configures Workers Queues[7].
*   **`wrangler types`**: Generates types from bindings and module rules in the configuration[7].
*   **`wrangler check`**: Validates your Worker[7].

Global flags like `--help`, `--config`, and `--cwd` can be used with most Wrangler commands[7].

Sources:
[1] cloudflare.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEeTwE1fanpi9V6xCea7w06cvaUhIQIt1hGSrrkWa0A3bOUWsA22deAO_LsQRM2-uBb2wGdLUbVDYNxsEZH4axrcQVDhvcqCknz-VcrodFKcMsVPR5ogbQq4WUJl7Bia7_vramoBC_p-WYj22P1Lg==)
[2] github.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFGwpsXhWy5o1bX6-vdjmyaweb5lcRi8CVy6xrRf2PuIpk7MEF3yyg2ULKb6b58bqBUeWGfbyLuDODhIk1tjocFSAWeBdxbkFjLBtV5YbjgGHfk75TX-XTPWEYCNp7Qkg==)
[3] hashnode.dev (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQGJFbSsu-jGYXVeEh1jgNqvrQwJQLChFFN4zjvmrMm0viJ_w3uqx148V3nuMJx94DKKFR1w0wS9FyD6kjFo_GkQShQnHWX717xa2DX_6iBJmFHMSzDsKTJ7mLQtDucSA0gBBisHH54nBMGZZOTgvTp43QPRCgPIsBByHWsc5pE_usNr)
[4] fig.io (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEz96TMSLBeY9R7syBltQ3bHAlAEsMEtFXyqF3yn7bmwZqk3hLjOiuutUQJ8fWmXD3aoCppKL5ODSe4K9ShhgWXVubx1uf4tXU8Bsm2kZ-5bRD-LrTCmwIrNg==)
[5] egghead.io (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQE3UGNaToxxCyx3CAvv8C0d1VWpOBTX3u4ZK8D9WPfrmqo2S3TDlvvJpGDhzsrc-zFH7BgwNtGCF2m8UTdPgzMNjP9jrwdw1L1kFhlS_TCGqIjunpcjQuGsNFMm0QVML-CPQz1fPadm2oOIZyywACZbJQmWoovLKr5dwVKSZ1sNmZC_MlrFKTUH3ZLd_Fn1qD4w)
[6] x-cmd.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFV6AjfSrs6NSo6SsgJblVBk81HwvvXc5ZqyTSfafRFzGjk9o-5x8P_8roxRljdNF2DFBG6Fng2ZTilQgkon4NDuOVJr7YzzE6SE7439BGrDVkypCMSvPRBvM8rHAcMSQ==)
[7] cloudflare.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQENpa1-HLmOIzeDoPMyZ1d4WJocZKvhKby9eBFaAMX8YPlMwMMsIxpZuaiuz6O95CB22HSXvwtFs-KyKC8pE3ZDR8ztCD9dZ9xPJoMNDZsb1mS-4EyEJnK4uLOIMZkdCzgMk1z6D1DlvaHqx8VNTTtmbAhw0vPrqQ==)