# Define the permission boundary policy
resource "aws_iam_policy" "permission_boundary" {
  name        = "PermissionBoundaryPolicy"
  path        = "/"
  description = "Permission boundary policy to restrict delete and modify actions"

  policy = file("permission_boundary_policy.json")
}

# Define the administrator policy document
data "aws_iam_policy_document" "admin_policy" {
  statement {
    actions   = ["*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

# Create the permission set with administrator access
resource "aws_iam_policy" "admin_policy" {
  name        = "AdministratorPolicy"
  path        = "/"
  description = "Administrator policy"

  policy = data.aws_iam_policy_document.admin_policy.json
}

# Create the IAM role and attach the permission boundary
resource "aws_iam_role" "admin_role" {
  name = "AdminRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  permissions_boundary = aws_iam_policy.permission_boundary.arn
}

# Attach the administrator policy to the role
resource "aws_iam_role_policy_attachment" "admin_role_policy_attachment" {
  role       = aws_iam_role.admin_role.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

# Create the permission set
resource "aws_ssoadmin_permission_set" "admin_permission_set" {
  instance_arn = var.sso_instance_arn
  name         = "AdminPermissionSet"
  description  = "Administrator access with permission boundary"
  session_duration = "PT1H"
}

# Attach the administrator policy to the permission set
resource "aws_ssoadmin_managed_policy_attachment" "admin_policy_attachment" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.admin_permission_set.arn
  managed_policy_arn = aws_iam_policy.admin_policy.arn
}