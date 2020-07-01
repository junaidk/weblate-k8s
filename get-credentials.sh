#!/bin/bash
export KUBECONFIG=`pwd`/my-gke-cluster.kubeconfig
gcloud container clusters get-credentials my-gke-cluster --zone=us-central1