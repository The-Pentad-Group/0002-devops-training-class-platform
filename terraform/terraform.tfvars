ec2_config = {
  NONPROD_EC2 = {
    instance_type = "t2.small"
  }
  PROD_EC2 = {
    instance_type = "t2.medium"
  }
}
lightsnail_config = {
  JOSH_SNAIL = {
  name              = "JOSH_SNAIL"  
  availability_zone = "us-east-1b"
  blueprint_id      = "windows_server_2019"
  bundle_id         = "micro_2_0"
  }
}
