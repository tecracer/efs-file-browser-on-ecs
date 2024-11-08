# The following are the version I used during testing.
# Probably works with lower versions as well.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
  required_version = ">= 1.5.6" # last tf version before opentofu switch, so it is backward compatible
}
