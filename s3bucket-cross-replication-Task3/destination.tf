# ------------------------------------------------------------------------------
# S3 bucket to act as the replication target.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "destination" {
  provider = aws.dest
  bucket   = var.bucket_prefix
}

resource "aws_s3_bucket_versioning" "destination" {
  provider = aws.dest
  bucket   = aws_s3_bucket.destination.id

  versioning_configuration {
    status = "Enabled"
  }

  lifecycle {
    prevent_destroy = false
  }
}

# ------------------------------------------------------------------------------
# The destination bucket needs a policy that allows the source account to
# replicate into it.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "destination" {
  provider = aws.dest
  bucket   = aws_s3_bucket_versioning.destination.id

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "",
  "Statement": [
    {
      "Sid": "AllowReplication",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.source_account}:root"
      },
      "Action": [
        "s3:GetBucketVersioning",
        "s3:PutBucketVersioning",
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ObjectOwnerOverrideToBucketOwner"
      ],
      "Resource": [
        "${aws_s3_bucket.destination.arn}",
        "${aws_s3_bucket.destination.arn}/*"
      ]
    },
    {
      "Sid": "AllowRead",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "s3:List*",
        "s3:Get*"
      ],
      "Resource": [
        "${aws_s3_bucket.destination.arn}",
        "${aws_s3_bucket.destination.arn}/*"
      ]
    }
  ]
}
POLICY

}
