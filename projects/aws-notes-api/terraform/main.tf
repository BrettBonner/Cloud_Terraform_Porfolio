module "notes_table" {
  source     = "./modules/table"
  table_name = "notes-${var.env}"
  pk_name    = "noteId"
}

module "create_note_fn" {
  source             = "./modules/lambda_fn"
  fn_name            = "create-note-${var.env}"
  handler            = "handler.lambda_handler"
  runtime            = "python3.12"
  source_path        = "${path.module}/../src/create_note"
  log_retention_days = 3
  env_vars = { TABLE_NAME = module.notes_table.name }
  policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["dynamodb:PutItem"],
      Resource = module.notes_table.arn
    }]
  })
}

module "get_note_fn" {
  source             = "./modules/lambda_fn"
  fn_name            = "get-note-${var.env}"
  handler            = "handler.lambda_handler"
  runtime            = "python3.12"
  source_path        = "${path.module}/../src/get_note"
  log_retention_days = 3
  env_vars = { TABLE_NAME = module.notes_table.name }
  policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["dynamodb:GetItem"],
      Resource = module.notes_table.arn
    }]
  })
}

module "http_api" {
  source            = "./modules/http_api"
  api_name          = "notes-api-${var.env}"
  cors_allow_origin = ["*"]
  routes = [
    {
      method      = "POST"
      path        = "/notes"
      lambda_arn  = module.create_note_fn.arn
      lambda_name = module.create_note_fn.name
    },
    {
      method      = "GET"
      path        = "/notes/{id}"
      lambda_arn  = module.get_note_fn.arn
      lambda_name = module.get_note_fn.name
    }
  ]
}
