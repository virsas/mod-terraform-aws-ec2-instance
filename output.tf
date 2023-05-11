output "arn" {
  value = try(aws_instance.vss.arn, "")
}
output "instance_state" {
  value = try(aws_instance.vss.instance_state, "")
}
output "primary_network_interface_id" {
  value = try(aws_instance.vss.primary_network_interface_id, "")
}
output "private_dns" {
  value = try(aws_instance.vss.private_dns, "")
}
output "public_dns" {
  value = try(aws_instance.vss.public_dns, "")
}
output "private_ip" {
  value = try(aws_instance.vss.private_ip, "")
}
