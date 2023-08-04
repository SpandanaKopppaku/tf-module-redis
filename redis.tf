resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "roboshop-${var.ENV}-redis"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.redis_pg.name
  engine_version       = "6.2"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.allows_redis.id]
}

# Creates parameter group needed for elastic cache

resource "aws_elasticache_parameter_group" "redis_pg" {
  name   = "roboshop-${var.ENV}-redis-pg"
  family = "redis6.x"
}


# # Creates subnet group
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "roboshop-redis-${var.ENV}-subnetgroup"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

  tags = {
    Name = "roboshop-docdb-${var.ENV}-subnetgroup"
    }
}




# resource "aws_docdb_subnet_group" "aws_docdb_subnet_group" {
#   name       = "roboshop-docdb-${var.ENV}-subnetgroup"
#   subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

#   tags = {
#     Name = "roboshop-docdb-${var.ENV}-subnetgroup"
#   }
# }

# # Creates compute machines needed for Documnet DB and these has to be attached to the cluster
# resource "aws_docdb_cluster_instance" "cluster_instances" {
#   count              = 1
#   identifier         = "roboshop-docdb-${var.ENV}-instance"
#   cluster_identifier = aws_docdb_cluster.docdb.id       # This argumnet attaches the nodes created here to the docdb cluster
#   instance_class     = "db.t3.medium"

#   depends_on         = [aws_docdb_cluster.docdb]
# }