terraform {  
    backend "s3" {
        bucket         = "dhruv-toptal-terraformstate"
        key            = "terraform.tfstate"    
        region         = "us-east-1"
        dynamodb_table = "dhruv-toptal-terraformstate-db"
    }
}
