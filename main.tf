provider "aws" {
  region = "ap-souteast-1"
}

module "module1" {
  source = "./modules/module1"
}

module "module2" {
  source = "./modules/module2"
}
