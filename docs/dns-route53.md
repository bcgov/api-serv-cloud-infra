# DNS Resolution (POC)

- Create custom domain (`ggw-aws-dev.api.gov.bc.ca`) for the HTTP API under AWS API Gateway
- Create a CNAME record in NNR (Network Node Registration) at [Remedy Apps](https://remedyapps.gov.bc.ca/arsys/forms/remedyprod/AR+System+Customizable+Home+Page/Default+Administrator+View/?cacheid=8b8a26fe)

|Entry Status|Hostname|Domain|Type|TTL|Data|View|
|-|-|-|-|-|-|-|
|Active|*|aws-dev.api.gov.bc.ca|CNAME|300|ggw-aws-dev.api.gov.bc.ca|Public|