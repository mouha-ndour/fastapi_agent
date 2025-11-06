variable "region"        { 
    type = string  
    default = "eu-west-3" 
    }
variable "repo_name"     { 
    type = string  
    default = "fastapi-app" 
    }
variable "account_id"    {
     type = string 
     }
variable "instance_type" {
     type = string  
     default = "t3.micro" 
     }  # free-ish tier
variable "key_name"      {
     type = string  
     default = "eks-aws" 
     }        # set if you want SSH with a key pair
variable "container_port"{
     type = number  
     default = 8000 
     }
variable "host_port"     {
     type = number  
     default = 80 
     }
