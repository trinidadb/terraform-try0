# Lambda con Docker desde ECR
resource "aws_lambda_function" "my_lambda" {

  depends_on    = [null_resource.docker_push] #Wait to make sure that the image was correctly pushed
  function_name = "${var.namespace}-${var.env}"
  image_uri     = "${aws_ecr_repository.app-repo.repository_url}:latest"
  role          = aws_iam_role.lambda_exec_role.arn
  package_type  = "Image"
  timeout       = var.lambdaTimeout
  memory_size   = var.lambdaMemory
}

# IAM role para la Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name               = "lambda-exec-${var.namespace}-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  for_each   = toset(["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
                      "arn:aws:iam::aws:policy/AmazonS3FullAccess"])
  policy_arn = each.key
}