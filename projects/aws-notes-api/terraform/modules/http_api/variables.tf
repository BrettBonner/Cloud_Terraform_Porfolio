variable "api_name" {
    type = string
}
variable "cors_allow_origin" {
    description = "List of allowed origins for CORS"
    type = list(string)
    default = []
}
variable "routes" {
    type = list(object({
        method: string
        path: string
        lambda_arn: string
        lambda_name: string
    }))
}