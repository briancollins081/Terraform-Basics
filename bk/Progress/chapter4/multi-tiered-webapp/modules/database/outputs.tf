output db_config {
  value       = {
      user        = aws_db_instance.database.username
      password    = aws_db_instance.database.password
      database    = aws_db_instance.database.name
      hostname    = aws_db_instance.database.address
      port        = aws_db_instance.database.port
  }
}

# output db_password {
#   value       = module.database.db_config.password
# }

# output lb_dns_name {
#   value       = "tbd"
# }

