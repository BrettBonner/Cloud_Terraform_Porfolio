resource "aws_dynamodb_table" "this" {
    name = var.table_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key = var.pk_name

    attribute { 
        name = var.pk_name 
        type = "S" 
    }
}