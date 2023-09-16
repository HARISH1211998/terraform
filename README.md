# To use Terraform to create the resources defined in the configuration file (main.tf), you'll follow these steps using Terraform CLI commands:
# Initialize Terraform:
# This command initializes Terraform in the working directory and downloads the necessary provider plugins.
# bash Copy code

terraform init

# Plan:
# This command generates an execution plan, showing what actions will be taken to create the infrastructure.
# bash
# Copy code

terraform plan

# Apply:
# This command applies the changes and creates the specified AWS resources.
# bash
# Copy code

terraform apply

# You'll be prompted to confirm the execution plan. Type yes and press Enter to proceed.

# After running terraform apply, Terraform will create the EC2 instance, security group, and ALB in the specified AWS region and VPC.

# Remember to have the AWS CLI configured with appropriate credentials and permissions to create the resources. Adjust the AWS region and other configurations as needed in the Terraform file before running these commands.





