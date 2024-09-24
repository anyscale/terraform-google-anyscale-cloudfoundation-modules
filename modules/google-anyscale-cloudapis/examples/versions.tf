terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.google_project_id
  region  = var.google_region
}
provider "google-beta" {
  project = var.google_project_id
  region  = var.google_region
}
