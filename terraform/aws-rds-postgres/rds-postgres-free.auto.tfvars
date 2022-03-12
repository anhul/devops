identifier            = "rds-postgres-free"
name                  = "postgreSQL"
engine                = "postgres"
engine_version        = "12.9"
port                  = 5432
instance_class        = "db.t2.micro"
allocated_storage     = 20
max_allocated_storage = 0
storage_type          = "gp2"

username = "postgres"
password = "yourpass"

publicly_accessible     = true
backup_retention_period = 0
skip_final_snapshot     = true
