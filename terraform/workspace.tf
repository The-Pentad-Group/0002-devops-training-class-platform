
/*
US East (N. Virginia) us-east-1	: use1-az2, use1-az4, use1-az6
https://docs.aws.amazon.com/workspaces/latest/adminguide/azs-workspaces.html
*/

/*

//Creating VPC for workstations to use

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Workspace-VPC"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  one_nat_gateway_per_az = false
  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Name = "Workspace"
    Environment = "Trunk"
  }
}

//Directory for pulling and storing user/compute info

resource "aws_directory_service_directory" "aws-managed-ad" {
  name = "kopicloud.local"
  description = "KopiCloud Managed Directory Service"
  password = "JoshDidThis"
  edition = "Standard"
  type = "SimpleAD"
  size = "Small"
  vpc_settings {
    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
  }
  tags = {
    Name = "Workspace"
    Environment = "Trunk"
  }
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = aws_directory_service_directory.aws-managed-ad.dns_ip_addresses
  domain_name = "workspacetest.local"
  tags = {
    Name = "kopicloud-dev-dhcp-option"
    Environment = "Development"
  }
}
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id = module.vpc.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}

*/