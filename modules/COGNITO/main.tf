#------Resources for COGNITO Module------

resource "aws_cognito_user_pool" "example" {
  name = var.user-pool-name 
  email_configuration {
    email_sending_account = var.email-sending-account #"COGNITO_DEFAULT" 
  }

  username_attributes      = [var.attribute]
  auto_verified_attributes = [var.attribute]

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

resource "aws_cognito_user_pool_domain" "example" {
  domain       = var.domain #"nagarjunabhai"
  user_pool_id = aws_cognito_user_pool.example.id
}

resource "aws_cognito_user_pool_client" "userpool_client" {
  name                                 = var.client-name #"client"
  user_pool_id                         = aws_cognito_user_pool.example.id
  callback_urls                        = [var.callback-url]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
  explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH"]
}

resource "aws_cognito_user_pool_ui_customization" "example" {
  client_id    = aws_cognito_user_pool_client.userpool_client.id
  css          = ".label-customizable {font-weight: 400;}"
  user_pool_id = aws_cognito_user_pool_domain.example.user_pool_id
}
