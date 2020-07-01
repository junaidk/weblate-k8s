#!/bin/bash
export KUBECONFIG=`pwd`/my-gke-cluster.kubeconfig

# applying the manifests
kubectl apply -f k8s/