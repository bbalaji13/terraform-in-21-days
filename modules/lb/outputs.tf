output "target_group_arn" {
    value = aws_lb_target_group.test.arn
}

output "lb_security_group_id" {
    value = aws_security_group.load_balancer.id
  
}
