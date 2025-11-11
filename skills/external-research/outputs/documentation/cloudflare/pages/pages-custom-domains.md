The official Cloudflare Pages documentation provides a clear guide on how to set up custom domains. Here's a summary of the process: 

 **1. Add a Custom Domain** 

 *   Navigate to the Cloudflare dashboard and go to the "Workers & Pages" section.[1][2] 
 *   Select your Pages project.[1][2] 
 *   Go to "Custom domains" and click on "Set up a domain" or "Set up a custom domain".[1][2] 
 *   Enter your desired domain name and select "Continue".[1] 

 **2. Update DNS Records** 

 *   If you are deploying to an apex domain (e.g., `example.com`), you need to configure your nameservers to point to Cloudflare's nameservers. Cloudflare will then automatically create a CNAME record for you.[1] 
 *   If you are deploying to a subdomain (e.g., `shop.example.com`) and your site is not a Cloudflare zone, you will need to add a custom CNAME record with your DNS provider. This record should point your subdomain to your `.pages.dev` URL.[1] 
 *   If your site is already managed as a Cloudflare zone, the CNAME record will be added automatically after you confirm your DNS record.[1] 

 **3. Verify Domain** 

 *   After updating your DNS records, return to Cloudflare Pages and click "Verify".[3] 
 *   DNS changes may take some time to propagate. Once verified, Cloudflare will issue an SSL certificate for your domain.[3] 

 **Additional Notes:** 

 *   Cloudflare Pages provides free SSL certificates for custom domains.[3] 
 *   You can also add a custom domain to a specific branch of your Pages project.[4] 
 *   If you encounter issues, common troubleshooting steps include checking for DNS propagation delays, HTTPS certificate problems, or conflicting DNS records.[5]

Sources:
[1] cloudflare.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQElx_MldAtjxODDjWWwTCovEQr6CZwDvtW-_acGORDnuRRr-k7FDbcZ_K9ERuzuY1GFK9cVAvDhnx0NP0qHDNi3aLJzdb7KGEcUo1hl4HPihZUEmqJtofGYi27EBJ-p-942qU4WbotZeecM972n0KVy9PjRkNPYs0sTFH3D8Ou-ag==)
[2] decembergarnetsmith.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFLoC4fED3MaATUf_qg4kPKOxKcPrJe1FT6KEsXsQn2_zg70HvrwzuClnSIz2iXgmdQMEAwu8i1je-wR5UhTpzzoF2Nn1VrAAqKEDEnzStlMjn-lQ3NsXsEH-J_oVDoPucmwmNyETT0ON277AZmIUUoT3mcbYyKGaft8-ODUzXOiY0rpNNtJxwOm6Its1MJUAOLWmo4wOF_fPMvg_KCu2r5tlfklR8OWw==)
[3] medium.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQF-DU2bOm381isDWj2BmznnW52uovP1WE5AjultTq580mDJr3LgoXDl2XDUVV33846sE6DUV9CI_E4-N4isZYLpRUqQlZCyk27WavnvcCgOd88bat8T8vfSrtA7iVNgW0rFEoVeqndIBo9YyurRyei4dtpPMIjCAXn1FkL5eeGCzhCaZ-J8hiB37vW8VJUemqm0z5Cbv8w=)
[4] cloudflare.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQFleKqTIh-TDifHh5xnpjJG8KOyhoSshQj3uJ2-oVc6P5qBw-kgWzzYvaC_oo6l9VWFs3SNB0liEIZrhk5Ae8FrLi9L2mQMaJcE3cqwkzRAiuvnIgWNRPbXhoPKAhecn4iMC9_phvF1wRZE2OMskyUSes9oOhLFcf8e4ujg1auPNg==)
[5] northstarthemes.com (https://vertexaisearch.cloud.google.com/grounding-api-redirect/AUZIYQHU4ex-bKD_AkN5SBsRP4YJ9KuTQiRpLycxIZUDimn5ydkjSMEYvwUBRAxRJkRswC5gQxUMHDFPH7PBHRe4jphdGsnhLdOGj27XMb893r1ew6ybzbf95o2pVTsmBwuJkCJ4kH3ic9xl5sDdJDAr67eOFWtj6Ivh-mxtQrA=)