# ------------------------------------------------------------------------------
# IAM role that S3 can use to read our bucket for replication
# ------------------------------------------------------------------------------
resource "aws_iam_role" "replication" {
  provider    = aws.source
  name_prefix = "replication"
  description = "Allow S3 to assume the role for replication"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "s3ReplicationAssume",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_policy" "replication" {
  provider    = aws.source
  name_prefix = "replication"
  description = "Allows reading for replication."

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.source.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.source.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.destination.arn}/*"
    }
  ]
}
POLICY

}

resource "aws_iam_policy_attachment" "replication" {
  provider   = aws.source
  name       = "replication"
  roles      = [aws_iam_role.replication.name]
  policy_arn = aws_iam_policy.replication.arn
}

# ------------------------------------------------------------------------------
# S3 bucket to act as the replication source, i.e. the primary copy of the data
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "source" {
  provider = aws.source
  bucket   = var.bucket_prefix
}

resource "aws_s3_bucket_versioning" "source" {
  provider = aws.source
  bucket   = aws_s3_bucket.destination.id

  versioning_configuration {
    status = "Enabled"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket   = var.bucket_prefix
  role = aws_iam_role.replication.arn

  rule {
    id     = "replicate-to-account2"
    status = "Enabled"

    filter {
      prefix = ""
    }

    destination {
      bucket        = aws_s3_bucket.source.arn
      storage_class = "STANDARD"
    }
  }
}
