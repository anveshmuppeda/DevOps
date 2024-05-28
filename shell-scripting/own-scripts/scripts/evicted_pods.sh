#! /bin/bash

# Parse input parameters
while [[ "$#" -gt 0 ]]
do
  case $1 in
    --environment_name)
      RD_OPTION_ENVIRONMENT_NAME="$2"
      ;;
    --namespace)
      RD_OPTION_NAMESPACE="$2"
      ;;
    --ucp_password)
      RD_OPTION_UCP_PASSWORD="$2"
      ;;
    --cluster_type)
      RD_OPTION_CLUSTER_TYPE="$2"
      ;;
    --task)
      RD_OPTION_TASK="$2"
      ;;
    --override_caas_branch)
      RD_OPTION_OVERRIDE_CAAS_BRANCH="$2"
      ;;
  esac
  shift
done

source /tmp/common.sh

export DATACENTER=${RD_GLOBALS_TF_VAR_CLIENT_PREFIX}-${RD_OPTION_ENVIRONMENT_NAME}
export AWS_REGION=${RD_GLOBALS_AWS_REGION}
export CLIENT_PREFIX=${RD_GLOBALS_TF_VAR_CLIENT_PREFIX}

UCP_DOMAIN="${URL_PREFIX}ucp.${BASE_DOMAIN}"
USERNAME="admin"
PASSWORD=$RD_OPTION_UCP_PASSWORD

gitCloneCoreRepo "caas" "$RD_OPTION_OVERRIDE_CAAS_BRANCH"
cd ${SCM_REPO_FOLDER}

source ./scripts/common.sh
. ./scripts/utils/setup_environment.sh

if [ $RD_OPTION_CLUSTER_TYPE != "kubernetes" ]; then
    echo "Curent Running Pods in cluster"
    kubectl get pods -A
fi