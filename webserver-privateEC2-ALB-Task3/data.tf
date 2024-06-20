# User Data script
data "template_file" "user_data" {
  template = file("user_data.sh")
}