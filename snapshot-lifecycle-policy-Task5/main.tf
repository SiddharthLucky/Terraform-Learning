resource "aws_ebs_volume" "example" {
  availability_zone = "ap-south-1a"
  size              = 8
  tags = {
    Name = "example-volume"
  }
}

resource "aws_dlm_lifecycle_policy" "ebs_snapshot_policy" {
  description        = "Daily snapshot policy for EBS volumes"
  execution_role_arn = aws_iam_role.dlm_role.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]
    target_tags = {
      Key = "backup"
      Value = "true"
    }

    schedule {
      name = "daily-snapshot"
      tags_to_add = {
        SnapshotType = "Daily"
      }

      create_rule {
        interval      = 1
        interval_unit = "HOURS"
      }

      retain_rule {
        count = 2
      }
    }
  }
}

resource "aws_iam_role" "dlm_role" {
  name = "dlm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "dlm.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "dlm_role_policy" {
  role = aws_iam_role.dlm_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateSnapshot",
          "ec2:CreateSnapshots",
          "ec2:DeleteSnapshot",
          "ec2:DescribeVolumes",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags"
        ],
        Resource = "*"
      }
    ]
  })
}
