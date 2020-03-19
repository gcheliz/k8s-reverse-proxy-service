#!/usr/bin/env bash

set -e

deploy_component() {
  environment=$1
  namespace=$2
  component=$3
  tag=$4

  envsubst < namespace.yaml | kubectl apply -f -

  for service in $(find services/common services/${environment} -name "${component}-service.yaml"); do
    envsubst '''${NAMESPACE} ${DOCKER_REGISTRY} ${TAG}''' < ${service} | kubectl apply -f -
  done

  for secret in $(find secret/common secret/${environment} -name "${component}-secret.yaml"); do
    envsubst '''${NAMESPACE} ${DOCKER_REGISTRY} ${TAG}''' < ${secret} | kubectl apply -f -
  done

  for config in $(find configmap/common configmap/${environment} -name "${component}-configmap.yaml"); do
    envsubst '''${NAMESPACE} ${DOCKER_REGISTRY} ${TAG}''' < ${config} | kubectl apply -f -
  done

  for deployment in $(find deployment/common deployment/${environment} -name "${component}-deployment.yaml"); do
    envsubst '''${NAMESPACE} ${DOCKER_REGISTRY} ${TAG}''' < ${deployment} | kubectl apply -f -
  done

}

export ENVIRONMENT=$1
export NAMESPACE=$2
export DOCKER_REGISTRY=$3
export TAG=$4
shift
components_tags=$@

pushd k8s/demo
for component_tag in ${components_tags}; do
  component=$(echo ${component_tag} | cut -d":" -f1)
  tag=$(echo ${component_tag} | cut -d":" -f2)

  deploy_component ${ENVIRONMENT} ${NAMESPACE} ${component} ${tag}
done

echo "Creating integration ingress..."
envsubst '''${NAMESPACE}''' < services/${environment}/api-ingress.yaml | kubectl apply -f -

popd

