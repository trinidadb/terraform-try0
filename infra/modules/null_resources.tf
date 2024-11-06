resource "null_resource" "aws_ecr_login" {
  triggers = {
    "run_at" = timestamp()
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current_user.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  }
}

resource "null_resource" "docker_push" {
  triggers = {
    force_rerun = "${timestamp()}"
  }

  depends_on = [aws_ecr_repository.app-repo] #Make sure the repository was created before

  # One provisioner for each command, because everything together was working badly
  provisioner "local-exec" {
    working_dir = var.dockersLoc
    command     = "docker build --platform linux/amd64 -f ${var.dockerDir}/dockerfile -t ${aws_ecr_repository.app-repo.name} ."
  }

  provisioner "local-exec" {
    working_dir = var.dockersLoc
    command     = "docker tag ${aws_ecr_repository.app-repo.name} ${aws_ecr_repository.app-repo.repository_url}:latest"
  }

  provisioner "local-exec" {
    working_dir = var.dockersLoc
    command     = "docker push ${aws_ecr_repository.app-repo.repository_url}:latest"
  }
}