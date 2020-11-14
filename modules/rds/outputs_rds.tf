output "host" {
  value = aws_db_instance.mysqldb.address
}

output "username" {
  value = aws_db_instance.mysqldb.username
}