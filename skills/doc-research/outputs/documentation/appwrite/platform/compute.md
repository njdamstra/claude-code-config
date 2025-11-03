[Skip to content](https://appwrite.io/docs/advanced/platform/compute#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

##### Note

Pricing changes will take effect on March 1st, 2025. Learn more on our [blog announcement](https://appwrite.io/blog/post/introducing-new-compute-capabilities-appwrite-functions) for more information.

Appwrite's paid plans give you the ability to change your function's allocated CPU Cores and Memory, enabling functions and builds to perform more computionally demanding actions quicker.

These options enable greater performance and flexibility, allowing developers to optimize their functions based on specific requirements. For instance, resource-intensive tasks such as real-time data processing or complex computational operations can now be executed more efficiently. Additionally, enhanced memory configurations support larger datasets and more demanding applications, broadening the scope of what can be achieved with Appwrite Functions.

## [Specifications](https://appwrite.io/docs/advanced/platform/compute\#specifications)

Appwrite Cloud has the following specifications available:

| Memory | CPU cores | Hourly usage |
| --- | --- | --- |
| 512MB | 0.5 | 0.25 |
| 512MB | 1 | 0.5 |
| 1GB | 1 | 1 |
| 2GB | 2 | 4 |
| 4GB | 2 | 8 |
| 4GB | 4 | 16 |

##### Note

Only customers on either Pro or Scale are able to change their specification from the default 512MB & 0.5 CPU option. For custom compute options please contact our [sales team](https://appwrite.io/contact-us/enterprise).

## [GB-Hours](https://appwrite.io/docs/advanced/platform/compute\#gb-hours)

GB-hours is a metric used to quantify the consumption of compute resources by combining both memory usage and the duration of that usage. Specifically, it represents the number of gigabytes (GB) of memory utilized multiplied by the number of hours those resources are active. This metric provides a comprehensive view of resource usage over time, allowing for accurate tracking, optimization, and billing based on actual compute needs.

How It Works:

- Memory allocation: Determine the amount of memory (in GB) that your application or function requires while running.
- Duration: Measure the total time (in hours) that the allocated memory is in use.
- Calculation: Multiply the memory allocated by the duration to obtain the total GB-hours consumed.

**Example:**

Assuming you have a function that requires 4 GB of memory to operate. If this function runs continuously for 2 hours, the compute resource usage would be:

**4GB \* 2 hours = 8 GB-hours**

This means the function has consumed 8 GB-hours of compute resources.

### [Pricing](https://appwrite.io/docs/advanced/platform/compute\#pricing)

- Free plan includes up to 100 GB-hours of execution and build time per month.

- Pro and Scale plans include up to 1,000GB of execution and build time per month. Additional usage is available at a rate of $0.09 per GB-hour.


Once the monthly GB-hours limit is reached, additional usage will automatically apply add-ons to your Pro or Scale account. It is recommended to set budget alerts and a budget cap to prevent unexpected payments.

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
