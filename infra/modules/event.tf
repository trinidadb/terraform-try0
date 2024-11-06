resource "aws_scheduler_schedule" "every_day_rule" {
  name       = "run-lambda-${var.namespace}-${var.env}"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = var.cronExpression
  schedule_expression_timezone = var.timezone

  target {
    arn      = aws_lambda_function.my_lambda.arn
    role_arn = aws_iam_role.scheduler.arn
  }
}

resource "aws_iam_role" "scheduler" {
  name = "cron-scheduler-role-${var.namespace}-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_scheduler.json
}

resource "aws_iam_role_policy_attachment" "scheduler_policy" {
  role       = aws_iam_role.scheduler.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole" # Policy that allows invocation of Lambda
}

# Without this permission, even though AWS Scheduler can assume the role and has permissions via the attached policy, the Lambda would still reject the invocation because Lambda requires explicit permissions for any external service that calls it.
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromScheduler"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "scheduler.amazonaws.com"
  source_arn    = aws_scheduler_schedule.every_day_rule.arn
}