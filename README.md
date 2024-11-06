# Playing with Terraform

This project aimed to gain practical experience with Terraform by deploying a set of AWS infrastructure components. This deployment included two Docker containers, which were built, tagged locally, and then pushed to distinct ECR repositories. Two Lambda functions were subsequently created, each based on one of the ECR images, and two EventBridge schedulers were configured to trigger these Lambda functions.

Initially, local provisioners were used to handle the build, tag, and push operations for the Docker images. However, after reviewing Terraform’s documentation, it was noted that using local provisioners for these tasks is discouraged due to potential stability issues and dependency challenges. Therefore, in later iterations, specifically in the [fastApi-terraform](https://github.com/trinidadb/fastApi-terraform) repository, this approach was replaced with a Makefile-based strategy.

![image](https://github.com/user-attachments/assets/69f0c703-0c6f-4af0-a5d3-f3a056f1665f)


## Warning
- Always ensure to destroy your infrastructure after usage. Forgetting to do so could incur high AWS fees.
- Never commit your AWS Account ID to git. Store it in a `.env` file and ensure `.env` is added to your `.gitignore`.


### Deploy and Destroy Infrastructure/App
 
1. Navigate to the terraform directory.

   ```bash
   cd infra

2. Run the following commands to initialize and apply the Terraform configuration:

   ```bash
   terraform init
   terraform apply

3. To tear down and destroy the infrastructure created by Terraform, run the following command in the Terraform directory:
   
   ```bash
   terraform destroy
