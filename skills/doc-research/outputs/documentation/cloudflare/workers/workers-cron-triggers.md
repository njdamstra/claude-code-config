Cloudflare Workers Cron Triggers allow you to schedule Workers to run at specified intervals, similar to traditional cron jobs. These scheduled Workers are ideal for periodic tasks like maintenance or calling third-party APIs[1][2].

Here's a summary of how to use Cloudflare Workers Cron Triggers:

**1. How they work:**
*   Workers scheduled by Cron Triggers run on underutilized machines to efficiently use Cloudflare's capacity[1][3].
*   They differ from traditional Workers in that they do not fire on HTTP requests but on a recurring schedule[3].
*   Cron Triggers can be combined with Workflows for multi-step, long-running tasks[1].

**2. Configuration:**
*   **Wrangler (CLI tool):** If your Worker is managed with Wrangler, Cron Triggers should be exclusively managed through the `wrangler.toml` (or `wrangler.jsonc`) configuration file[1][2]. You add a `triggers` section with a `crons` array to your `wrangler.toml` file, specifying the cron expressions[4][5].
    ```toml
    # Example wrangler.toml
    name = "my-scheduled-worker"
    main = "src/index.ts"
    compatibility_date = "2023-01-01"

    [triggers]
    crons = ["0 * * * *", "30 2 * * *"] # Runs every hour at minute 0, and daily at 2:30 AM UTC
    ```
*   **Cloudflare Dashboard:** You can also configure Cron Triggers via the Cloudflare dashboard by navigating to Workers & Pages > your Worker > Settings > Triggers > Cron Triggers[1].

**3. Worker Code:**
*   To respond to a Cron Trigger, you must add a "scheduled" handler to your Worker script. This handler listens for `scheduled` events[1][2][4].
    ```javascript
    addEventListener('scheduled', event => {
      event.waitUntil(handleScheduledEvent(event));
    });

    async function handleScheduledEvent(event) {
      console.log('Scheduled event triggered');
      // Your scheduled task logic here
    }
    ```

**4. Cron Expressions:**
*   Cloudflare supports cron expressions with five fields (minute, hour, day of month, month, day of week), along with most Quartz scheduler-like cron syntax extensions[1][2][4].
    *   `*`: Matches any value.
    *   `,`: Specifies additional values.
    *   `-`: Specifies a range of values.
    *   `/`: Specifies increments[2].
*   **Important:** Scheduled Workers are triggered in GMT time, so adjust your expressions accordingly[4].

**5. Testing:**
*   The recommended way to test Cron Triggers locally is using Wrangler with the `--test-scheduled` flag (e.g., `wrangler dev --test-scheduled`). This exposes a `/__scheduled` route that can be used to test with an HTTP request, and you can pass a `cron` query parameter to simulate different cron patterns[6][4][5].

**6. Monitoring:**
*   You can monitor your scheduled tasks and view logs in the Cloudflare dashboard under the Workers log tab[4].

**7. Propagation:**
*   Changes to Cron Triggers (adding, updating, or deleting) may take several minutes (up to 15 minutes) to propagate across the Cloudflare global network[1].

Sources:
[1] cloudflare.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEP2fC-EpUiO1JdukOb_GZFSYPU_tQyo1_FjSWG1SKR0t6cOl9kXeW73SMNvL48zjKRbqlssuDdfm8i1fMDSeasuK9vIN325D-6re3Oy946NSSCxxpwqJq2gaGi_lDyPIvO6f9_zuUN9KK9dn6KmsbmTmzL1UvfoK0N9Ww5IGSOVyE=)
[2] reintech.io (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHzg1nShB6Khj4-xZcn8txXkBMez7fYPLLn-F_0JGob0-TJ4mtZL8X_RPYduOjQQjZC8MKr8zmlRw4v2BfcCWbOwWE_Wh8ngrd4xy7UksQQDW-nHHVACWR37OSpKa6-w4Au8hXL7QP5ODyraoJOD4NIXlGl7y1ayoBTNXi18Ey0)
[3] cloudflare.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFExL6W3EeuJ8SdhN1MWECDCkB8-Ndk9SNKAr8J-7X3Q2YXYQ3ZmRjNiRoOBOR-0vislthLxcWEXS2E2G3jq-7iGbPmh9u11CBLV9XOjT9yXOalRo9vJet6jsLAcCwBw6pK1o5fvgs29DpL9OJ1q4qaNdtslQu7zgHrmJD98eupCxyuamIhI1c4)
[4] dev.to (https://vertexaisearch.cloud.g