## Intro
K8s manifests for [Weblate](https://weblate.org/en/)


## GKE
- download service-account json and place it in terraform directory.
- replace `credentials` paramter with service-account json file name. 
- set up gcloud cli
- login using `gcloud auth login`
- after cluster is started, download kubeconfig by running `get=credentials.sh`

## deploy
- run `deploy-services.sh` to deploy the application (chane KUBECONFIG variable if needed)

## infrastructure
cd to `terraform` director
and run `terraform apply -var="project_id=<gcp project_id>"`