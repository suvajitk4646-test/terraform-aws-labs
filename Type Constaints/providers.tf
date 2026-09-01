provider "aws" {
  region = "us-east-1"
}
provider "aws" {
  alias = "west_coast"
region = "us-west-2"  
}