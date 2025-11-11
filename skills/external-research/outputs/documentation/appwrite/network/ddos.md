[Skip to content](https://appwrite.io/docs/products/network/ddos#main)

[![appwrite](https://appwrite.io/images/logos/appwrite.svg)![appwrite](https://appwrite.io/images/logos/appwrite-light.svg)](https://appwrite.io/)

[Go to Console](https://cloud.appwrite.io/)

Distributed Denial-of-Service (DDoS) attacks are one of the most common threats to online applications, aimed at overwhelming servers with malicious traffic to disrupt services. Appwrite provides robust, always-on DDoS protection across all Appwrite Cloud plans to ensure the reliability and security of your applications.

Appwrite's network is designed to detect and mitigate malicious traffic before it reaches your application. Using a combination of automated filtering and intelligent traffic analysis, our DDoS protection:

- Identifies and blocks large-scale attack patterns in real-time.
- Ensures legitimate traffic continues to flow uninterrupted.
- Prevents application downtime and minimizes performance impacts.

## [Design](https://appwrite.io/docs/products/network/ddos\#design)

Appwrite's DDoS protection operates across multiple OSI layers to provide comprehensive coverage:

- **Network Layer (Layer 3)**: Detects and mitigates large-scale attacks such as ICMP floods and UDP amplification.
- **Transport Layer (Layer 4)**: Protects against attacks like SYN floods and TCP-based exploits by identifying anomalous traffic patterns.
- **Application Layer (Layer 7)**: Blocks high-level attacks, such as HTTP floods, by filtering malicious requests while allowing legitimate user traffic.

## [Benefits](https://appwrite.io/docs/products/network/ddos\#benefits)

- **Cost control**: Malicious traffic blocked by DDoS protection does not count towards your bandwidth or request usage, saving you from unnecessary charges.
- **Reliability**: Keeps your application online and responsive, even during attempted attacks.
- **Zero configuration**: DDoS protection is fully managed by Appwrite and requires no manual setup or maintenance. Protection is enabled by default on all Cloud plans.

## [Availability](https://appwrite.io/docs/products/network/ddos\#availability)

DDoS mitigation is automatically enabled by default for all Appwrite Cloud plans, ensuring every application hosted on Appwrite benefits from this safeguard without additional costs. This includes:

This protection is integrated directly into Appwrite's console, edge and region infrastructure, providing seamless coverage without requiring additional setup from developers.

###### Recommended

- [API reference/Account](https://appwrite.io/docs/references/cloud/client-web/account)
- [API reference/Teams](https://appwrite.io/docs/references/cloud/client-web/teams)
- [API reference/Databases](https://appwrite.io/docs/references/cloud/client-web/databases)
- [API reference/Storage](https://appwrite.io/docs/references/cloud/client-web/storage)
