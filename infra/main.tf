
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "predict" {
  source = "./modules"

  region         = var.region
  env            = var.env
  namespace      = "predictor"
  cronExpression = "cron(0 7 * * ? *)"
  timezone       = "Europe/Madrid"
  lambdaTimeout  = 360
  dockersLoc     = "../my-dockers"
  dockerDir      = "docker1"
}

module "recommend" {
  source = "./modules"

  region         = var.region
  env            = var.env
  namespace      = "recommender"
  cronExpression = "cron(15 7 * * ? *)"
  timezone       = "Europe/Madrid"
  lambdaTimeout  = 720
  dockersLoc     = "../my-dockers"
  dockerDir      = "docker2"
}
