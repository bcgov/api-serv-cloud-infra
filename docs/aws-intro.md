# AWS

List of services available/compatible with secure environment accelerator

<https://developer.gov.bc.ca/AWS-Services>

## Secure Environment Accelerator (SEA)

The AWS Accelerator is a tool designed to help deploy and operate secure multi-account, multi-region AWS environments on an ongoing basis. The power of the solution is the configuration file that drives the architecture deployed by the tool. This enables extensive flexibility and for the completely automated deployment of a customized architecture within AWS without changing a single line of code.

allows for organizations to operate, evolve, and maintain their cloud architecture and security controls over time and as they grow, with minimal effort, often using native AWS tools. Customers don't have to change the way they operate in AWS

- Deploys with AWS Cloud Formation
- Delivered by AWS Solutions Architects or Professional Service Consultants
- Highly Configurable
- Contains 3rd party firewall devices

### AWS Control Tower (ACT)

- Enterprises with large number of applications and distributed teams could make cloud setup and governance complex and also its time consuming

- ACT provides easiest solution to govern, secure and compliant multi account AWS environment

- ACT can be setup using blue prints. Then through it, an AWS environment can be configured with components such as:
  - Multi-account structure
  - Identity and federeated access management
  - Account provisioning workloads

### Guardrails

Guardrails are used to enforce security and compliance policies

- They block deployment of resources that don't conform to policies

- Detect and remidiate non compliant accounts and resources

#### Allowed

- Access the account provided
- Inherit policy
- Use dev, test prod Organizational Units (OUs)
- Inherit PBMM controls

#### Not Allowed

- Create/update VPCs
- Use Services Outside of Canada^
- Use VMs*
- Create own policy
- Use DirectConnect/ExpressRoute services
- Use own OU
- Change firewall rules
- Disable logging
- Change password or IAM policies

### AWS Landing Zone

- AWS Landing Zone helps customers more quickly set up a secure, multi-account AWS environment based on AWS best practices. With the large number of design choices, setting up a multi-account environment can take a significant amount of time, involve the configuration of multiple accounts and services, and require a deep understanding of AWS services.

- AWS Landing Zone can help save time by automating the set-up of an environment for running secure and scalable workloads while implementing an initial security baseline through the creation of core accounts and resources. It also provides a baseline environment to get started with a multi-account architecture, identity and access management, governance, data security, network design, and logging

## Services Scope

### In-Scope

- Compute
- Storage
- Serverless (Fargate/lambda)
- Elastic Container Services
- Landing Zone and Deployments

### Out-Scope

- IAM Users Management
- AD integration
- VPC integration
- 3rd party integrations
- External `Organizations`
- Elastic Kubernetes Services (EKS)

## AWS Components

### ECS (Elastic Container Service)

- It is a container management service, used to run, stop and manage containers
- A task definition is required to run a task or set of tasks within a service
- A service configuration can be used to maintain specified number of tasks simultaneously in a cluster
- Tasks and services can be run on serverless infra managed by AWS fargate
- Running these tasks and services using EC2 instances gives more control
- ECS can be configured to use ELB to distribute traffic evenly across the tasks in a service
- ECS can use ALB, NLB and CLB, however fargate can only use ALB or NLB.

#### Task Definition

It is a point in time capture of the configuration for running the docker image

- Docker image
- CPU and Memory requirements for each container
- Links between containers
- Networking and port settings
- Data storage volumes
- Security (IAM) roles

#### Services

- Manage long running workloads
- Automate the `RUN TASK` process
- Actively monitor running tasks
- Restart tasks if they fail
- A service definition includes the name of task definition, count of instances of task and task placement options
- Task placement strategies
  - Balance tasks across AZs
  - pack tasks for efficiency
  - Run number of tasks per EC2
  - Custom task placements

##### Auto Scaling (Fargate Launch Type)

It is the ability to increase or decrease the desired count of tasks based on the autoscaling policies such as,

- Target tracking scaling policies
- Step scaling policies
- Scheduled scaling

#### Auto Scaling Groups (ASGs) (EC2 Taunch Type)

- An Auto Scaling group contains a collection of Amazon EC2 instances that are treated as a logical grouping for the purposes of automatic scaling and management

- An Auto Scaling group also enables you to use Amazon EC2 Auto Scaling features such as health check replacements and scaling policies. Both maintaining the number of instances in an Auto Scaling group and automatic scaling are the core functionality of the Amazon EC2 Auto Scaling service

### ELB (Elastic Load Balancer) & Types

- A load balancer distributes incoming application traffic across multiple targets, such as EC2 instances, in multiple availability zones (AZs)
- It is equivalent of Reverse Proxy
- ELB can be placed in public or private subnets

|Feature|ALB|NLB|
|-|-|-|
|Protocol Listeners |  HTTP,HTTPS,gRPC | TCP,UDP,TLS    |
| Target Type | IP,Instance,Lambda,ECS | IP, Instance |
|PrivateLink Support | No | TCP and TLS|
|Static IP Address | No | Yes |
| HTTP Header Based | Yes | No|
| Source IP preservation | x-forwarded-for | Native |
| SSL Termination | Load Balancer | Load Balancer or Target |

#### Application Load Balancer

- Operates at Request level (Layer 7)
- Routes based on content of the request
- Supports part based routing, host-based routing, query string parameter based routing and source IP address based routing
- Supports instances, IP addresses, Lambda Functions and containers as targets
- HTTP and HTTPS

#### Network Load Balancer

- Operates at the connection level (Layer 4)
- Routes connections based on IP protocol data
- Offers ultra high performance, low latency and TLS offloading at scale
- Can have static or Elastic IP
- Support UDP and static IP addresses as targets
- TCP, TLS, UDP and TCP_UDP

#### Classic Load Balancer (Old Generation)

- Performs routing at layer 4 and layer 7
- TCP, SSL, HTTP and HTTPS

### Security Groups (SGs)

Its a virtual firewall that control the traffic to and from the resources. As an example, when SG is associated with an EC2 instance, then the inbound and outbound traffic is governed by the SG.

Virtual Private Cloud (VPC) comes with default SG but multiple SGs can be added. Each SG can have multiple rules to control the traffic based on protocols and port numbers. Separate set of rules can be configured for inbound and outbound traffic.

Default Security Group configuration

- Inbound

| Source | Protocol | Port range | Description |
|-|-|-|-|
|Security Group ID | All | All | Allows inbound traffic from resources that are assigned to the same security group |

- Outbound

| Destination | Protocol | Port range | Description |
|-|-|-|-|
|0.0.0.0/0 | All | All | Allows all outbount IPv4 traffic |
|::/0 | All | All | Allows all outbount IPv6 traffic |

### Networking

#### Virtial Private Cloud (VPC)

- VPC is a virtual network dedicated to AWS account. It is logically isolated from other virtual networks in the cloud space
- We can specify IP address range, add subnets, associate security groups and configure route tables
- Every AWS account comes with default VPC (a default internet gateway and a default subnet are included)
- Resources inside subnets can be protected through security groups and network access control lists (ACL)
- Instances launched inside default subnet in VPC would have both public and private addresses and can communicate to internet through interent gateway. However, when instances launched inside non-default subnet require an elastic or public IP to be configured manually and attach internet gateway to that VPC for accessing internet

#### Internet Gateway (IGW)

- It allows VPC to reach the public internet
- It allows resources which already have public address/elastic address and are placed in public subnet to connect directly to the internet
- There shall be only one IGW per VPC

#### Routing Table

- A route table contains set of rules called routes, used to determine the flow direction of the traffic from VPC
- Each route in a route table specify the range of IP addresses where the traffic is directed to and the gateway, network interface etc
- Each AWS VPC has a router and its primary function is to take all the routing tables defined within that VPC and direct the traffic flow within that VPC, as well as to subnets outside of the VPC, based on the rules defined within those tables
- Routing table consists of list of destination subnets, as well as the final destination

#### NAT Gateway (NGW)

- It is equivalent of forward proxy
- When created inside VPC subnet, an elastic IP has to be assigned to it
- Resources inside private subnet are assigned with private IP address and they cannot directly connect to internet
- NAT gateway helps these resources to communicate with the internet
- Resources such as EC2 inside private subnet route traffic to NAT gateway and NAT gateway re-routes it to the internet gateway. The reponse then is sent back to the EC2 through internet gateway and NAT gateway

#### Routing Configuration

- A VPC consists of a main routing table that enables communication between the resources within a VPC
- Assuming VPC was created with CIDR `10.10.0.0/16`, below is the main routing table with default configuraion (local - cannot be deleted)
|Destination|Target|
|-|-|
|10.10.0.0/16|Local|
- A subnet created under VPC would have its own CIDR derived from VPC and assuming it as `10.10.0.0/24`
- If only main routing table to be used for the routing purpose then all the subnets use same routing table to communicate to internet gateway
|Destination|Target|
|-|-|
|10.10.0.0/16|Local|
|0.0.0.0/0|IGW (Internet Gateway)|
- Best practice is to create a routing table for each subnet, where there is 1-to-1 relationship between route tables and subnets within the VPC
- In case of public subnets
|Destination|Target|
|-|-|
|10.10.0.0/24|Local|
|0.0.0.0/0|IGW (Internet Gateway)|
- In case of private subnets
|Destination|Target|
|-|-|
|10.10.0.0/16|Local|
|0.0.0.0/0|NGW (NAT Gateway)|
- It also possible to assign one each routing table per AZ for all the public subnets and all private subnets in that AZ.

#### VPC Peering

- VPC peering connection is a networking connection between two VPCs that enables routing of traffic between them usingorivate IPv4 or IPv6 addresses. Through peering, a connection can be established with VPC from another AWS account or VPC in a different region.

- VPC Peering allows resources in one VPC access resources in other VPC. Resources including EC2 instances, RDS databases and Lambda functions.
