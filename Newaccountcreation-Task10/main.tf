
provider "aws" {
  region = "ap-south-1"
}


resource "aws_organizations_account" "new_account" {
  name                       = "Ajay-terraform"
  email                      = "ajaynitco1998+03@gmail.com"
  role_name                  = "OrganizationAccountAccessRole"
  iam_user_access_to_billing = "ALLOW"
}


data "template_file" "iam_role_template" {
  template = file("template.yaml")
}


resource "aws_cloudformation_stack_set" "iam_role_stackset" {
  name             = "IAMRoleStackSet"
  template_body    = data.template_file.iam_role_template.rendered
  capabilities     = ["CAPABILITY_NAMED_IAM"]
  permission_model = "SERVICE_MANAGED"
  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }
}


resource "aws_cloudformation_stack_set_instance" "iam_role_stackset_instance" {
  stack_set_name = aws_cloudformation_stack_set.iam_role_stackset.name
  deployment_targets { organizational_unit_ids = ["ou-it6y-qp4kkyad"] }
  region = "ap-south-1"

  depends_on = [aws_organizations_account.new_account]
}

data "external" "delete_vpc" {
  program = ["python3", "${path.module}/delete_vpc.py"]
  query = {
    new_account_id = aws_organizations_account.new_account.id
  }
}


output "new_account_id" {
  value = aws_organizations_account.new_account.id
}
