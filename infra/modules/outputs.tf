output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = aws_ecr_repository.app-repo.repository_url
}


output "lambda_arn" {
  description = "Lambda arn"
  value       = aws_lambda_function.my_lambda.arn
}
