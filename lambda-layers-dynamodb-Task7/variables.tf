variable "dynamodb_table_name" {
  default = "crud-table"
}

variable "lambda_function_name" {
  default = "CsvLambdaFunction"
}

variable "lambda_layer_name" {
  default = "CsvLayer"
}