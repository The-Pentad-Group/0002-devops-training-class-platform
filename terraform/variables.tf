variable "ec2_config" {
  type = map(any)
}

variable "lightsnail_config" {
  type = map(any)
}

variable "load_balancer_type" {
    description = "The type on load balancer."
    type = string
    default = "application"
  
}

variable "alb_resource_tags" {
    description = "Tags to be set for the load balancer."
    type = map(string)
    default = {
      Environment = "axk-old-test"
      Project = "axk-lb"

    }
  
}