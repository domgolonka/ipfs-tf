output "id" {
  value = aws_lb.blockparty.id
}

output "arn" {
  value = aws_lb.blockparty.arn
}

output "dns_name" {
  value = aws_lb.blockparty.dns_name
}

output "zone_id" {
  value = aws_lb.blockparty.zone_id
}

output "target_group_arns" {
  value = { for k, v in aws_lb_target_group.blockparty : k => v.arn }
}