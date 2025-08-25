variable "region"      {
    type = string  
    default = "us-east-1" 
    }
variable "env"         {
    type = string  
    default = "dev" 
    }
variable "owner"       { 
    type = string  
    default = "brett" 
    }
variable "alert_email" { 
    type = string  
    description = "Email for budget alarms" 
    }
