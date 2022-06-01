# VPC to VPC connectivity

## AWS Private Link

- A service provider has to create a network load balancer for allowing the service consumer to access the shared resouces from the service provider VPC
- A consumer has to create interface VPC endpoint that establishes connections between thier subnets and service provider's VPC

`Note`: Unable to create network load balancer to test this approach

## VPC Peering

- A VPC peering connection is a one to one relationship between two VPCs
- Multiple VPC peering connections can be created for a single VPC


### Limitations

VPC Peering not supported in following scenarios

- Matching CIDR blocks
- Transitive peering (VPC A -> VPC B -> VPC C)
 
