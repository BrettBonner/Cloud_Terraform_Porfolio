variable "fn_name"            { type = string }
variable "handler"            { type = string }
variable "runtime"            { type = string }
variable "source_path"        { type = string }   # directory containing handler.py
variable "env_vars"           { 
    type = map(string) 
    default = {} 
    }
variable "policy_json"        { type = string }   # inline IAM policy JSON for the function
variable "log_retention_days" { 
    type = number 
    default = 3 
    }
