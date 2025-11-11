Cloudflare Workers now support outbound TCP socket connections through the `connect()` API, which was announced during Developer Week 2023[1][2]. This API allows Workers to connect directly to any TCP-based service, including databases, SSH, MQTT, SMTP, FTP, and IRC[3][2]. Previously, Workers were limited to HTTP endpoints and other Cloudflare services[1][4].

Key features and considerations for Cloudflare Workers Outbound TCP sockets:
*   **`connect()` API**: The `connect()` function returns a `Socket` object with both a readable and writable stream of data, enabling continuous reading and writing as long as the connection is open[3][5].
*   **`Socket` Object**: The `Socket` object includes `readable` (ReadableStream), `writable` (WritableStream), `opened` (Promise<SocketInfo>), `closed` (Promise<void>), `close()` (Promise<void>), and `startTls()` (Socket) methods[3].
*   **`connect()` Parameters**: It accepts a URL string or `SocketAddress` (with `hostname` and `port`) and an optional `SocketOptions` object[3].
*   **`SocketOptions`**: This object allows configuration of `secureTransport` (off, on, starttls) for TLS usage and `allowHalfOpen` (boolean) to control the writable side's closure on EOF[3].
*   **Limitations**:
    *   Outbound TCP sockets to Cloudflare IP ranges are blocked[3].
    *   TCP sockets cannot be created in the global scope and shared across requests[3].
    *   Each open TCP socket counts towards the maximum number of open connections[3][6].
    *   Connecting to port 25 for SMTP mail servers is not possible[1][6].
*   **Database Connections**: While the `connect()` API enables direct database connections, Cloudflare recommends using Hyperdrive for PostgreSQL, which provides the `connect()` API with built-in connection pooling and query caching[3].
*   **Future Developments**: Cloudflare plans to support inbound TCP and UDP connections, as well as application protocols based on QUIC[1][2].
*   **Outbound Workers**: If an Outbound Worker is enabled, the `connect()` API cannot be used by the customer's Worker, as all outbound communication will go through the Outbound Worker's `fetch` method[7].

The `connect()` API is largely based on the JavaScript streams standard, aiming for compatibility with other platforms[5].

Sources:
[1] appmaster.io (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFZgz-HEbKAFDaJpHHhLZhTyCJnP-jkMTdl_vC_vjUf3ugKn6mQgWdd9yv6SvwXMfUnC9K_DLSwABGi4CXmx8gGCNr6d-AtiGD1Trt_y08GSvbsQIf82kCVOHAGgVDwXJ42z1jW6Nio4pYSLrdmj3B2AyZsbFw2)
[2] cloudflare.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQE0RCyiuHtEhbEuOzsBRXWAlm4QL-S4m63AMAZwU4cjdkJzccH6pI0tccaKzd9iLUysMvP4O4V5fn40wgsbH73e-bcxIwXC7DW1Q2iyMoFH9KEo6qoS-oRkFlP4rER_KtYpb6nSOLy19cMwl9vTx94D6epZLLMi1g2z8i9z_FnCCw==)
[3] cloudflare.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHIGCt4GPxzQ4IxCP7_35Bh3WZDS9ehqLzF9CNPOehsIRwFm2Kfrm57mPBkNG1PstliaxMrnVbFGB3DNbVhTcuBB2EArQV0IjIFp48-HZQFJc6svhHL65nJKazpLtmmWmeksdRjUDFAmfeT_lahGeGbp5ZjjqkNpFTSRLThrLc=)
[4] github.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFqUCrGNWnfpGcmvDcC_XvL4Cwdiw34RMlZxO8LzLhaH42jFm8KQlWrW1b9YkNIbm3bOZc4OdXFN5i8xctBRTBlrDQY2lwneRuxNdB4sxSyaAOY9rt26ZS4zP3B17mKQnjMZcIj6KXzKA==)
[5] ycombinator.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQE4ONL4UPW-bxCkUOqqgG2BiiwGLUDIXLBiam3X80HoX068G9fmkUmcDXC0UX7pa9C8VqOZbXSxWi0rj4iVS09VNECDFlF3IayCu-F3hUlAqAdbRRs5yEpUoEL8q5SBq9myyhzdLb4Ugw==)
[6] infoq.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQGmrJM_6I6zGjlzvRJeiA9ZdVAILkl2NSZGcveqqAAGMmKhyvqNVa60qrOrAtC8ABw2T0SXuj-27obg1imbomCxH22gLyW-xBysfEqLSHvcH43didOALkZWyojxbbHloK_yLendhdbXnEpON-rgxnjT8vs_qYH0FdYsBWQKzg==)
[7] cloudflare.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFr6WF8ADbFlJLW_rBx4cVQ1eieQpIdImckd4fE1X2QejIAaLZ7s5paz2S09jwCKhqIpNcXDglHzQlSHVOuM74J3VamGBLwI6sMkLC2GDbLyBtkii_7K58VTBxorg_1RHjd_AcKYLjYQOs3hhNW5BrAQzQbasgrz8P_0ciQZPWEsUViBZIw_HMouk2KEIbpyxK5cMFR09zjO8y6QNdmigxEkk4x0D9ZFWUUeQo=)