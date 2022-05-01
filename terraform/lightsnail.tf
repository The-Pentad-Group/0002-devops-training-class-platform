resource "aws_lightsail_instance" "lightsnail_test" {
    for_each = {
    for key, value in var.lightsnail_config :
    key => value
  }
  availability_zone = each.value.availability_zone
  blueprint_id      = each.value.blueprint_id
  bundle_id         = each.value.bundle_id
 
}

    # "blueprints": [
    #     {
    #         "blueprintId": "windows_server_2019",
    #         "name": "Windows Server 2019",
    #         "group": "windows_2019",
    #         "type": "os",
    #         "description": "Amazon Lightsail helps you build, deploy, scale, and manage Microsoft applications quickly, easily, and cost effectively with Windows Server 2019. For business IT applications, Lightsail runs Windows-based solutions in a secure, easily managed, and performant cloud environment. Common Windows use cases include Enterprise Windows-based application hosting, website and web-service hosting, data processing, distributed testing, ASP.NET application hosting, and running any other application requiring Windows software.",
    #         "isActive": true,
    #         "minPower": 0,
    #         "version": "2022.04.13",
    #         "versionCode": "1",
    #         "productUrl": "https://aws.amazon.com/marketplace/pp/B07QZ4XZ8F",
    #         "licenseUrl": "https://d7umqicpi7263.cloudfront.net/eula/product/ef297a90-3ad0-4674-83b4-7f0ec07c39bb/8dcaef51-8e20-41b3-a622-57864d247f86.txt",
    #         "platform": "WINDOWS"
    #     },