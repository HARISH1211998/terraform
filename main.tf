provider "aws" {
  region = "ap-southseast-1"
}

module "module1" {
  source = "./modules/module1"
}

module "module2" {
  source = "./modules/module2"
}
