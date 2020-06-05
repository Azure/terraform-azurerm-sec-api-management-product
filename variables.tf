#Required Variables
variable "apim_name" {
  type        = string
  description = "The name of the Azure API Management resource"
}

variable "apim_resource_group_name" {
  type        = string
  description = "The name of the resource group containing the Azure API management resource"
}

variable "apim_product_id" {
  type        = string
  description = "The name of the resource group containing the Azure API management resource"
}

variable "apim_product_display_name" {
  type        = string
  description = "The name of the resource group containing the Azure API management resource"
}

#Optional Variables
variable "apim_product_subscription_required" {
  type        = string
  description = "The name of the resource group containing the Azure API management resource"
  default     = true
}

variable "apim_product_subscriptions_limit" {
  type        = string
  description = "The number of subscriptions a user can have to this product at the same time"
  default     = 1
}


variable "apim_product_approval_required" {
  type        = string
  description = "The name of the resource group containing the Azure API management resource"
  default     = true
}

variable "apim_product_published" {
  type        = string
  description = "The name of the resource group containing the Azure API management resource"
  default     = true
}

variable "apim_product_apis" {
  type = set(object({
    name         = string
    revision     = string
    display_name = string
    path         = string
    protocols    = set(string)
    service_url  = string
  }))
  description = "The product API definitions"
  default     = []
}

variable "apim_backends" {
  type = set(object({
    name     = string
    protocol = string
    url      = string
  }))
  description = "The Backend API definitions"
  default     = []
}

variable "apim_operations" {
  type = set(object({
    operation_id = string
    api_name     = string
    display_name = string
    method       = string
    url_template = string
    description  = string
    request = set(object({
      description = string
      header = set(object({
        name          = string
        required      = bool
        type          = string
        description   = string
        default_value = string
        values        = set(string)
      }))
      query_parameter = set(object({
        name          = string
        required      = bool
        type          = string
        description   = string
        default_value = string
        values        = set(string)
      }))
      representation = set(object({
        content_type = string
        form_parameter = set(object({
          name          = string
          required      = bool
          type          = string
          description   = string
          default_value = string
          values        = set(string)
        }))
      }))
    }))
    response = set(object({
      status_code = number
      description = string
      header = set(object({
        name          = string
        required      = bool
        type          = string
        description   = string
        default_value = string
        values        = set(string)
      }))
      representation = set(object({
        content_type = string
        form_parameter = set(object({
          name          = string
          required      = bool
          type          = string
          description   = string
          default_value = string
          values        = set(string)
        }))
      }))
    }))
    template_parameter = set(object({
      name          = string
      required      = bool
      type          = string
      description   = string
      default_value = string
      values        = set(string)
    }))
  }))
  description = "The API operations"
  default     = []
}

variable "apim_operation_policies" {
  type = set(object({
    api_name         = string
    operation_id     = string
    policy_file_path = string
  }))
  description = "The API operation policies"
  default     = []
}


