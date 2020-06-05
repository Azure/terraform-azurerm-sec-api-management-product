provider "azurerm" {
  version = "~>2.0"
  features {}
}

resource "azurerm_api_management_product" "apim" {
  product_id            = var.apim_product_id
  api_management_name   = data.azurerm_api_management.apim.name
  resource_group_name   = data.azurerm_resource_group.base.name
  display_name          = var.apim_product_display_name
  subscription_required = var.apim_product_subscription_required
  subscriptions_limit   = var.apim_product_subscriptions_limit
  approval_required     = var.apim_product_approval_required
  published             = var.apim_product_published
}

resource "azurerm_api_management_api" "apim" {
  for_each = { for api in var.apim_product_apis : api.name => api }

  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.base.name
  api_management_name = data.azurerm_api_management.apim.name
  revision            = each.value.revision
  display_name        = each.value.display_name
  path                = each.value.path
  protocols           = each.value.protocols
  service_url         = each.value.service_url
}

resource "azurerm_api_management_product_api" "apim" {
  depends_on = [
    azurerm_api_management_api.apim,
    azurerm_api_management_product.apim,
  ]
  for_each = { for k, o in azurerm_api_management_api.apim : k => o }

  api_name            = each.value.name
  product_id          = var.apim_product_id
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.base.name
}

resource "azurerm_api_management_backend" "apim" {
  for_each = { for backend in var.apim_backends : backend.name => backend }

  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.base.name
  api_management_name = data.azurerm_api_management.apim.name
  protocol            = each.value.protocol
  url                 = each.value.url
}

resource "azurerm_api_management_api_operation" "apim" {
  depends_on = [azurerm_api_management_product_api.apim]
  for_each   = { for operation in var.apim_operations : operation.operation_id => operation }

  operation_id        = each.value.operation_id
  api_name            = each.value.api_name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.base.name
  display_name        = each.value.display_name
  method              = each.value.method
  url_template        = each.value.url_template
  description         = each.value.description

  dynamic "request" {
    for_each = each.value.request

    content {
      description = request.value["description"]
      dynamic "header" {
        for_each = request.value["header"]

        content {
          name          = header.value["name"]
          required      = header.value["required"]
          type          = header.value["type"]
          description   = header.value["description"]
          default_value = header.value["default_value"]
          values        = header.value["values"]
        }
      }
      dynamic "query_parameter" {
        for_each = request.value["query_parameter"]

        content {
          name          = query_parameter.value["name"]
          required      = query_parameter.value["required"]
          type          = query_parameter.value["type"]
          description   = query_parameter.value["description"]
          default_value = query_parameter.value["default_value"]
          values        = query_parameter.value["values"]
        }
      }
      dynamic "representation" {
        for_each = request.value["representation"]

        content {
          content_type = representation.value["content_type"]

          dynamic "form_parameter" {
            for_each = representation.value["form_parameter"]

            content {
              name          = form_parameter.value["name"]
              required      = form_parameter.value["required"]
              type          = form_parameter.value["type"]
              description   = form_parameter.value["description"]
              default_value = form_parameter.value["default_value"]
              values        = form_parameter.value["values"]
            }
          }
        }
      }
    }
  }
  dynamic "response" {
    for_each = each.value.response

    content {
      status_code = response.value["status_code"]
      description = response.value["description"]
      dynamic "header" {
        for_each = response.value["header"]

        content {
          name          = header.value["name"]
          required      = header.value["required"]
          type          = header.value["type"]
          description   = header.value["description"]
          default_value = header.value["default_value"]
          values        = header.value["values"]
        }
      }
      dynamic "representation" {
        for_each = response.value["representation"]

        content {
          content_type = representation.value["content_type"]

          dynamic "form_parameter" {
            for_each = representation.value["form_parameter"]

            content {
              name          = form_parameter.value["name"]
              required      = form_parameter.value["required"]
              type          = form_parameter.value["type"]
              description   = form_parameter.value["description"]
              default_value = form_parameter.value["default_value"]
              values        = form_parameter.value["values"]
            }
          }
        }
      }
    }
  }
  dynamic "template_parameter" {
    for_each = each.value.template_parameter

    content {
      name          = template_parameter.value["name"]
      required      = template_parameter.value["required"]
      type          = template_parameter.value["type"]
      description   = template_parameter.value["description"]
      default_value = template_parameter.value["default_value"]
      values        = template_parameter.value["values"]
    }
  }
}

resource "azurerm_api_management_api_operation_policy" "apim" {
  depends_on = [azurerm_api_management_api_operation.apim]
  for_each   = { for policies in var.apim_operation_policies : policies.operation_id => policies }

  api_name            = each.value.api_name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.base.name
  operation_id        = each.value.operation_id

  xml_content = file(each.value.policy_file_path)
}
