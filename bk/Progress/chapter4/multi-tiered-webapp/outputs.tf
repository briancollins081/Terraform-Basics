output dp_password {
  value       = module.database.db_config.password
  sensitive   = true
}

output ld_dns_name {
  value       = module.autoscaling.lb_dns_name
}

