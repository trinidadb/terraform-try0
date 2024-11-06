#!/bin/bash
read -p "Enter the namespace:"  NAMESPACE
read -p "Enter the AWS environment: " AWS_ENV
read -p "Enter the AWS region: " AWS_REGION

declare -A repo_dirs=(
  ["namespace1"]="docker1"
  ["namespace2"]="docker2"
)
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REPOSITORY_NAME="$NAMESPACE-$AWS_ENV"
LAMBDA_NAME="$NAMESPACE-$AWS_ENV"
ECR_URL="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME"

echo "Logging into Amazon ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL

echo "Building Docker image..."
docker build --platform linux/amd64 -f "./${repo_dirs[$NAMESPACE]}/dockerfile" -t $REPOSITORY_NAME .

echo "Tagging Docker image with ECR repository..."
docker tag $REPOSITORY_NAME $ECR_URL:latest

echo "Pushing Docker image to ECR..."
docker push $ECR_URL:latest

echo "Docker image successfully pushed to ECR: $ECR_URL"

echo "Updating lambda function..."
aws lambda update-function-code --function-name $LAMBDA_NAME --image-uri=$ECR_URL:latest --publish

