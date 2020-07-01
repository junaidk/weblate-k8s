## Intro
K8s manifests for [Weblate](https://weblate.org/en/)
Terraform manifests for starting gke cluster.
Blue/Green deloyment script.

## Infrastructure
cd to `terraform` directory
and run `terraform apply -var="project_id=<gcp project_id>"`

## GKE
- download service-account json and place it in terraform directory.
- replace `credentials` paramter with service-account json file name. 
- set up gcloud cli
- login using `gcloud auth login`
- after cluster is started, download kubeconfig by running `get=credentials.sh`

## Deploy
- run `deploy-services.sh` to deploy the application (change KUBECONFIG variable if needed)

## Update
Update image tag in bg-auto.sh
Then run ./bg-auto.sh to start deployment process.