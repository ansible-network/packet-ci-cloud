packet-ci-cloud
===============

CI/CD Deployment of Packet Nodepool Cloud

## Prerequisites

### Packet Project ID & API Key

This deployment requires a Packet account for the provisioned bare metal. You'll need your "Packet Project ID" and your "Packet API Key" to proceed. You can use an existing project or create a new project for the deployment.

We recommend setting the Packet API Token and Project ID as environment variables since this prevents tokens from being included in source code files. These values can also be stored within a variables file later if using environment variables isn't desired.
```bash
export TF_VAR_packet_project_id=YOUR_PROJECT_ID_HERE
export TF_VAR_packet_auth_token=YOUR_PACKET_TOKEN_HERE
```

#### Where is my Packet Project ID?

You can find your Project ID under the 'Manage' section in the Packet Portal. They are listed underneath each project in the listing. You can also find the project ID on the project 'Settings' tab, which also features a very handy "copy to clipboard" piece of functionality, for the clicky among us.

#### How can I create a Packet API Key? 

You will find your API Key on the left side of the portal. If you have existing keys you will find them listed on that page. If you haven't created one yet, you can click here:

https://app.packet.net/portal#/api-keys/new

### Terraform

These instructions use Terraform from Hashicorp to drive the deployment. If you don't have Terraform installed already, you can download and install Terraform using the instructions on the link below:
https://www.terraform.io/downloads.html

## Deployment Prep

Download this repo from GitHub into a local directory.

```bash
git clone <repo_url>
cd <repo>
cd terraform
```

Update with the keys to access the physical hosts. Terraform will configure the root user on the new hosts with this key
```
cp  ~/.ssh/id_rsa.pub .
```

Download the Terraform providers required:
```bash
cd terraform
terraform init
```

Run the Terraform 
```bash
terraform plan
terraform apply
```
## Ansible Configuration

Terraform will build a starting in terraform/openstack_user_config.yml using the host information (IP addressing) assigned for the new hosts. 

```bash
cp terraform/openstack_user_config.yml .
vi openstack_user_config.yml
```

### Run the Ansible Playbook

