terraform {

  required_providers {

    aws = {

      source  = "hashicorp/aws"
      version = "5.47.0"

    }

  }



  backend "s3" {

    bucket = "3tier-appl"

    key = "state/terraform.tfstate"

    region = "ap-south-1"

    # encrypt = true

    # dynamodb_table = "Terraform_lock"

  }

}

