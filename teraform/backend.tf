terraform {

  required_providers {

    aws = {

      source = "hashicorp/aws"

      version = "~> 4.18.0"

    }

  }



  backend "s3" {

    bucket = "3tier-appl"

    key = "state/terraform.tfstate"

    region = ""

    encrypt = true

    dynamodb_table = "Terraform_lock"

  }

}