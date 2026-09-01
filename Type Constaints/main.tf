resource "aws_iam_user" "developers" {
count = var.create_users ? length(var.IAM_User_Names) : 0
  
  # Accessing the list using an index (e.g., iam_user_names[0])
  name = "${var.project_name}-${var.IAM_User_Names[count.index]}"
  
  # Passing the entire map of tags directly
  tags = var.project_tags
}