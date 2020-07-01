#!/bin/bash

NAMESPACE=weblate
SERVICE_NAME=weblate

IMAGE=weblate/weblate:4.1.1-1

BLUE="blue"
GREEN="green"

#================================================#
get_replicas() {
  get_deployment_jsonpath '{.status.replicas}'
}

get_specified_replicas() {
  get_deployment_jsonpath '{.spec.replicas}'
}

get_updated_replicas() {
  get_deployment_jsonpath '{.status.updatedReplicas}'
}

get_available_replicas() {
  get_deployment_jsonpath '{.status.availableReplicas}'
}

get_deployment_jsonpath() {
  local -r jsonpath="$1"

  kubectl --namespace ${NAMESPACE} get deployment "${SERVICE_NAME}-$NEW_VERSION" -o "jsonpath=${jsonpath}"
}

scaleBackAndExit() {

    kubectl -n $NAMESPACE scale deployment/$SERVICE_NAME-$NEW_VERSION --replicas=0
    exit 1
}

# reference https://github.com/JasonJhuboo/kubernetes-scripts/blob/master/wait-for-deployment
healthCheck() {
    specified_replicas="$(get_specified_replicas)";
    current_replicas=$(get_replicas)
    updated_replicas=$(get_updated_replicas)
    available_replicas=$(get_available_replicas)

    secs=10
    SECONDS=0

    while [[ ${updated_replicas} -lt ${specified_replicas} || ${current_replicas} -gt ${updated_replicas} || ${available_replicas} -lt ${updated_replicas} ]]; do
    if [ $SECONDS -gt "$secs" ]; then
        scaleBackAndExit
        break 
    fi
    sleep .5
    
    echo "current/updated/available replicas: ${current_replicas}/${updated_replicas}/${available_replicas}, waiting"
    current_replicas=$(get_replicas)
    updated_replicas=$(get_updated_replicas)
    available_replicas=$(get_available_replicas)
    done

}

#get currently deployed color
CURRENT_VERSION=$(kubectl get service $SERVICE_NAME -o=jsonpath='{.spec.selector.version}' --namespace=${NAMESPACE}) 

NEW_VERSION=""

if [ "$CURRENT_VERSION" == "$BLUE" ]; then
    NEW_VERSION=$GREEN
else
    NEW_VERSION=$BLUE
fi

echo New Version is $NEW_VERSION

kubectl -n $NAMESPACE set image deployment/$SERVICE_NAME-$NEW_VERSION $SERVICE_NAME=$IMAGE 
kubectl -n $NAMESPACE scale deployment/$SERVICE_NAME-$NEW_VERSION --replicas=1

kubectl -n $NAMESPACE rollout status deployment/$SERVICE_NAME-$NEW_VERSION 

healthCheck

kubectl -n $NAMESPACE patch service $SERVICE_NAME -p '{"spec":{"selector":{"version": "'$NEW_VERSION'"}}}'

kubectl -n $NAMESPACE scale deployment/$SERVICE_NAME-$CURRENT_VERSION --replicas=0