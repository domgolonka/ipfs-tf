module "rds_db" {
  source            = "./rds"
  project           = local.vars.project
  env               = local.environment
  name              = "blockparty"
  engine            = local.vars.rds.engine
  engine_version    = local.vars.rds.engine_version
  instance_class    = local.vars.rds.instance_class
  port              = local.vars.rds.port
  username          = local.secrets.db_username
  password          = local.secrets.db_password
  allocated_storage = local.vars.rds.allocated_storage
  subnet_ids        = module.vpc.private_subnet_ids
  sg_ids            = [module.rds_sg.id]
}