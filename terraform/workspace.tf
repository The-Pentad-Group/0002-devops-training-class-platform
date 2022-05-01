
data "aws_workspaces_bundle" "value_windows_10" {
  bundle_id = "wsb-bh8rsxt14" # Value with Windows 10 (English)
}

resource "aws_workspaces_workspace" "example" {
     for_each = {
    for key, value in var.workspace_config :
    key => value
  }
 directory_id = aws_workspaces_directory.example.id
  bundle_id    = data.aws_workspaces_bundle.value_windows_10.id
  user_name    = each.value.user_name

  root_volume_encryption_enabled = true
  user_volume_encryption_enabled = true
  volume_encryption_key          = "alias/aws/workspaces"

  workspace_properties {
    compute_type_name                         = "VALUE"
    user_volume_size_gib                      = 10
    root_volume_size_gib                      = 80
    running_mode                              = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60
  }
  tags = {
    Department = "DepartmentofJosh"
  }
}