resource "aws_db_instance" "main" {
  identifier          = "sri-rajeswari-db"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  engine              = "postgres"
  engine_version      = "15.4"
  username            = var.database_username
  password            = var.database_password
  db_name             = "srirajeswariprovisions"
  skip_final_snapshot = true
}
