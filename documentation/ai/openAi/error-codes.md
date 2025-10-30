# Error codes

Explore API error codes and solutions.

This guide includes an overview on error codes you might see from both the [API](https://platform.openai.com/docs/introduction) and our [official Python library](https://platform.openai.com/docs/libraries#python-library). Each error code mentioned in the overview has a dedicated section with further guidance.

## API errors

| Code | Overview |
| --- | --- |
| 401 - Invalid Authentication | **Cause:** Invalid Authentication <br>**Solution:** Ensure the correct [API key](https://platform.openai.com/settings/organization/api-keys) and requesting organization are being used. |
| 401 - Incorrect API key provided | **Cause:** The requesting API key is not correct. <br>**Solution:** Ensure the API key used is correct, clear your browser cache, or [generate a new one](https://platform.openai.com/settings/organization/api-keys). |
| 401 - You must be a member of an organization to use the API | **Cause:** Your account is not part of an organization. <br>**Solution:** Contact us to get added to a new organization or ask your organization manager to [invite you to an organization](https://platform.openai.com/settings/organization/people). |
| 401 - IP not authorized | **Cause:** Your request IP does not match the configured IP allowlist for your project or organization. <br>**Solution:** Send the request from the correct IP, or update your [IP allowlist settings](https://platform.openai.com/settings/organization/security/ip-allowlist). |
| 403 - Country, region, or territory not supported | **Cause:** You are accessing the API from an unsupported country, region, or territory. <br>**Solution:** Please see [this page](https://platform.openai.com/docs/supported-countries) for more information. |
| 429 - Rate limit reached for requests | **Cause:** You are sending requests too quickly. <br>**Solution:** Pace your requests. Read the [Rate limit guide](https://platform.openai.com/docs/guides/rate-limits). |
| 429 - You exceeded your current quota, please check your plan and billing details | **Cause:** You have run out of credits or hit your maximum monthly spend. <br>**Solution:** [Buy more credits](https://platform.openai.com/settings/organization/billing) or learn how to [increase your limits](https://platform.openai.com/settings/organization/limits). |
| 500 - The server had an error while processing your request | **Cause:** Issue on our servers. <br>**Solution:** Retry your request after a brief wait and contact us if the issue persists. Check the [status page](https://status.openai.com/). |
| 503 - The engine is currently overloaded, please try again later | **Cause:** Our servers are experiencing high traffic. <br>**Solution:** Please retry your requests after a brief wait. |
| 503 - Slow Down | **Cause:** A sudden increase in your request rate is impacting service reliability. <br>**Solution:** Please reduce your request rate to its original level, maintain a consistent rate for at least 15 minutes, and then gradually increase it. |

For complete details on each error type, handling strategies, and Python library error types, see the full documentation.
