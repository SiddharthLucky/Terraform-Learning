# Output the instance ID
output "instance_id" {
  value = aws_instance.example.id
}

# Output the snapshot ID
output "snapshot_id" {
  value = aws_ebs_snapshot.root_snapshot.id
}

# Output the shared snapshot ID
output "shared_snapshot_id" {
  value = aws_ebs_snapshot.root_snapshot.id
}
