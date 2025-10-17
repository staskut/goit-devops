variable "ecr_name" {
  description = "Name of the ECR repository"
  type        = string
}


variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "force_delete" {
  description   = "Enable to delete repo with images"
  type          = bool
  default       = false
}

variable "image_tag_mutability" {
  description = "Whether image tags are IMMUTABLE or MUTABLE"
  type = string
  default = "MUTABLE"
  
}

variable "repository_policy" {
  description = "Custom JSON policy for the ECR repo (optional)"
  type        = string
  default     = null
}