## Intro
K8s manifests for [Weblate](https://weblate.org/en/)

Terraform manifests for starting gke cluster.

Blue/Green deloyment script.

## GKE
Download service-account json and place it in terraform directory.

Replace `credentials` paramter with service-account json file name in `main.tf` file. 

Set up gcloud cli

Login using `gcloud auth login`

## Infrastructure
cd to `terraform` directory

first run `terraform init`

and then run `terraform apply -var="project_id=<gcp project_id>"`

in order to destroy infrastructure
`terraform destroy -var="project_id=<gcp project_id>"`

## Kubeconfig 
After cluster is started, download kubeconfig by running `get-credentials.sh`

## Deploy
- run `deploy-services.sh` to deploy the application (change KUBECONFIG variable if needed)

## Update
Update image tag in bg-auto.sh

Then run `./bg-auto.sh` to start deployment process.

To revert back to previous version run `./bg-revert.sh`