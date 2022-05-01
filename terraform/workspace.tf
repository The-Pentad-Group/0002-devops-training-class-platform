// Create newtowrk for workspaces
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "JoshSpaces"
  cidr = "10.10.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets  = ["10.10.3.0/24", "10.10.4.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "JoshSpaces"
    Environment = "Trunk"
  }
}

//Create directory managment services
  resource "aws_directory_service_directory" "aws-managed-ad" {
  name = "JoshSpaces.local"
  description = "Workspace Deployment"
  password = "Notmypassword"
  edition = "Standard"
  type = "MicrosoftAD"
  vpc_settings {
    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
  }
  tags = {
    Name = "JoshSpaces"
    Environment = "Trunk"
  }
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = aws_directory_service_directory.aws-managed-ad.dns_ip_addresses
  domain_name = "JoshSpaces.local"
  tags = {
    Name = "JoshSpaces"
    Environment = "Trunk"
  }
}
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id = module.vpc.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}

//Created required IAM role
data "aws_iam_policy_document" "workspaces" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["workspaces.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "workspaces-default" {
  name = "workspaces_DefaultRole"
  assume_role_policy = data.aws_iam_policy_document.workspaces.json
}
resource "aws_iam_role_policy_attachment" "workspaces-default-service-access" {
  role = aws_iam_role.workspaces-default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesServiceAccess"
}
resource "aws_iam_role_policy_attachment" "workspaces-default-self-service-access" {
  role = aws_iam_role.workspaces-default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesSelfServiceAccess"
}



//Worspaces Directory
resource "aws_workspaces_directory" "workspaces-directory" {
  directory_id = aws_directory_service_directory.aws-managed-ad.id
  subnet_ids   = module.vpc.private_subnets
  depends_on = [aws_iam_role.workspaces-default]
}

# Windows Standard Bundle powered by Windows Server 2019
data "aws_workspaces_bundle" "standard_windows" {
  bundle_id = "wsb-gk1wpk43z"
}

resource "aws_workspaces_workspace" "workspaces" {
  directory_id = aws_workspaces_directory.workspaces-directory.id
  bundle_id = data.aws_workspaces_bundle.standard_windows.id
  # Admin is the Administrator of the AWS Directory Service
  user_name = "Admin"
  root_volume_encryption_enabled = true
  user_volume_encryption_enabled = true
  volume_encryption_key = aws_kms_key.workspaces-kms.arn
  workspace_properties {
    compute_type_name = "VALUE"
    user_volume_size_gib = 50
    root_volume_size_gib = 80
    running_mode = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60
  }
  tags = {
    Name = "JoshSpaces"
    Environment = "Trunk"
  }
  depends_on = [
    aws_iam_role.workspaces-default,
    aws_workspaces_directory.workspaces-directory
  ]
}