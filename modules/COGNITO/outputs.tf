output "user-pool-id" {
    value = aws_cognito_user_pool.example.id
}
output "client-id" {
    value = aws_cognito_user_pool_client.userpool_client.id
}
