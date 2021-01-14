terraform {  
    backend "s3" {
        bucket         = "dhruv-toptal-terrastate"
        key            = "terraform.tfstate"    
        region         = "us-east-1"
        dynamodb_table = "toptal-terrastate-db"
    }
}
