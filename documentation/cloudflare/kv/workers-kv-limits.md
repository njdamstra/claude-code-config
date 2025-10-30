Cloudflare Workers KV has specific limitations that vary between the Free and Paid plans. These limits cover aspects such as key and value sizes, storage, and operation rates.

Here's a breakdown of the key limits:

**General Limits (applicable to both Free and Paid plans):**
*   **Key Size:** Each key name can be up to 512 bytes.[1]
*   **Value Size:** Values can be up to 25 MiB. Values larger than 1 MiB require the chunked upload API.[2][1]
*   **Key Metadata:** Up to 1024 bytes.[1]
*   **Minimum `cacheTtl`:** 60 seconds.[1]
*   **Namespaces:** You can have up to 1000 Workers KV namespaces per account.[1][3][4]
*   **Keys per Namespace:** Unlimited.[1]
*   **Operations per Worker Invocation:** 1000.[1]

**Free Plan Limits (per day, unless otherwise specified):**
*   **Reads:** 100,000 read operations per day.[1][5]
*   **Writes to Different Keys:** 1,000 write operations per day.[1][5]
*   **Writes to Same Key:** Limited to 1 write operation per second.[1]
*   **Storage per Account:** 1 GB.[1][5]
*   **Storage per Namespace:** 1 GB.[1]

**Paid Plan Limits:**
*   **Reads:** Unlimited (the first 10 million requests per month are included, then $0.50 per million).[1][6]
*   **Writes to Different Keys:** Unlimited (the first 1 million requests per month are included, then $5.00 per million).[1][6]
*   **Writes to Same Key:** Limited to 1 write operation per second.[1]
*   **Storage per Account:** Unlimited (the first 1 GB is included, then $0.50 per GB-month).[1][6]
*   **Storage per Namespace:** Unlimited (the first 1 GB is included, then $0.50 per GB-month).[1]

**Important Considerations:**
*   Exceeding the daily free tier limits will result in 429 errors for further operations until the limit resets.[7]
*   If you require higher limits, you can request an adjustment by completing the Limit Increase Request Form.[1]
*   Cloudflare Workers KV is an eventually consistent database, meaning that changes to values may take up to 60 seconds to propagate globally, though often it occurs within 1-2 seconds.[2][8]
*   KV does not support search operations; it only provides list operations.[8]
*   Using the Workers KV REST API is subject to the general rate limits that apply to all Cloudflare REST API operations.[1]

Sources:
[1] cloudflare.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQE2Pt26kX2UadUeHHG7__8iRPNGO-Vijb9zDDC_Sny2F9YvdHBHxzgVcbqFXlPTW4SnpZpnFhOlzX7mj1w0cWfO-z9SMIBeVDeYjomaVsoLMECyDUX6kZpVuKs7tg5axm1tV3xXBCtQaczfyQGWpfdU)
[2] studyraid.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFHRwcyKYDyMGGGBPI8u0aoqDYorK59VQeBQKafziGBqRueL2yMH4X4wjT2OmVi4XTHtyvSrhCtz8PhcEufvplzcnpm-RrECMz3r2rPGK3h2PONjJ0rMBwtJ5nKxZn84GbWjq3htfs9qp9bP6tvrlH9d_ZMv9ZOPljJjCL-e5RsMYBKox_hm_StH1fp6qKlLdt4Z2QiCCh0vEJR)
[3] cloudflare.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEQ2fbt-kFhFaQ0soExxer0gHUKVSTcr1OWmY9k4cBTmPQvK1dJy0lDu0iWK8Z7SOXK3V1Ijf9Fvrq51DImXpguRKvuzleCS2xpnQrrC7nzHnjRWfcql19qh4L4rdH-8v7gmRcwsW05D4U5PaZyT9Y41Yjq8gUPNOSAXR-Qu0rVd28W4WLhjlXW2XBb-Tcyzcg1)
[4] bsky.app (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFPCX650nAxAjY3Tsh3IyX5L3oD2JsMQSwlQ5Xw_MWoqYuY4odFvj-EpyNVPC-xh-QYdPBDLYmo14fhfj2XopxkKcFRwqNTmlm8gPtcPo1rV0SyXhf9afN561VycacKTDK3fjcEAIA-I38L4gkzmSqsVqlf97oRY5tri6GEwvCD)
[5] brianli.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQGtTCdKz_ijCne7S20TDqFixwYBHILSKOzdq8JVKOYOAAHaVY2GOwyucVJ4WetBQFnp0mwH0raoQ8Qr1JHMNdFOyeCwCkA2sJdUzxDE1KrfzvS757TUyb0nuDl8XD5Fa7deUyB6qMnPoI1g892Bn1iHpZcHJSC3Khdw83i7257AGSFAq1VX_Q==)
[6] genspark.ai (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQEf6m5-zCfgVaT8JpmayT4DxkEwSNL5rB9FbNAJDngabA8jNgw38qXjuOlK24V802UnXJXQuFVFyrLVKBB7SBqiS6oVi1h2Qx-uoBAlUBcIJRAujtsXXdhCHl16j1YxCOS2--EKiGU5dyvf-xX6HnYBA6lLjILV8mGTDsnN_dCionUIH9eI2azYZpKkwbq320xCuE2mwx3aF8EaSlhuNQ3yDKebcRlBU96abfP01gf2FdmpJDcn1b3_Ad_5LAHAxFupCw-2BwWDnmV5LVaqmTp4HI5rk3vdc3KEcdnNvWisaQwdQv6J0LAQdKXZQl6-lDHroukM)
[7] jameskilby.co.uk (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHfUCVHjlrttXicxmwtPV98cfYPjcVrq6sdOVp_FLztUDIwtWZAY2XJawJyvoOfrHd0f4akJZefeIcrfk_gC-RXSO-UbTf0BTl2PlJL-T3y8oiRU7Q63qsCxpJmkLVsWyDBJRoqAKK5Elyy9SFtciFLvNQ9KVcUIVj_z2EHS53-AN2k_XD3CTk=)
[8] youtube.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHxyGdtE8tRBY59swa3Nqi0X1r_dYd3-A42VjOXc-ssiW5wjdjz2ooXVPP8vv4OOAEBV41VkrIFxsDxlG5a_eI8F5aqwx0x7QDgdVkvM-HFkl4PPmGLGgdWn3quGtgG9IYQkAMO_GQ=)