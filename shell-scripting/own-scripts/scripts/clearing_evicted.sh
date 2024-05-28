#! /bin/bash

## Capgemini UK PLC Proprietary and Confidential ##
## Copyright Capgemini 2020 - All Rights Reserved ##

# Parse input parameters
while [[ "$#" -gt 0 ]]
do
  case $1 in
    --environment_name)
      RD_OPTION_ENVIRONMENT_NAME="$2"
      ;;
    --name)
      RD_OPTION_NAME="$2"
      ;;
    --ucp_password)
      RD_OPTION_UCP_PASSWORD="$2"
      ;;
    --enable_quota)
      RD_OPTION_ENABLE_QUOTA="$2"
      ;;
    --limit_cpu)
      RD_OPTION_LIMIT_CPU="$2"
      ;;
    --limit_memory)
      RD_OPTION_LIMIT_MEMORY="$2"
      ;;
    --limit_storage)
      RD_OPTION_LIMIT_STORAGE="$2"
      ;;
    --cluster_type)
      RD_OPTION_CLUSTER_TYPE="$2"
      ;;
    --ldap_username)
      RD_OPTION_LDAP_USERNAME="$2"
      ;;
    --ldap_password)
      RD_OPTION_LDAP_PASSWORD="$2"
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
    REGISTRY_URL="${URL_PREFIX}dtr.${BASE_DOMAIN}/xpaas-system"
    if [ -f ./bundle/${RD_OPTION_ENVIRONMENT_NAME}/env.sh ]; then
        cd bundle/${RD_OPTION_ENVIRONMENT_NAME}
        eval "$(<env.sh)"
        cd ..
    else
        echo "No client bundle, please use the job to generate one and then try again."
        exit 2
    fi
fi

echo "Creating namespace and binding client admins to it"

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: $RD_OPTION_NAME
  labels:
    xpaas.io/namespace-type: unmanaged
EOF

if [ $RD_OPTION_ENABLE_QUOTA == "true" ]; then
cat <<EOF | kubectl apply  -n $RD_OPTION_NAME -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: main
spec:
  hard:
    limits.cpu: "$RD_OPTION_LIMIT_CPU"
    limits.memory: ${RD_OPTION_LIMIT_MEMORY}Gi
    requests.storage: ${RD_OPTION_LIMIT_STORAGE}Gi
EOF
fi


if [ $RD_OPTION_TASK == "List" ]; then
echo "Listing the Evicted Pods from cluster in all namespaces"
cat <<EOF | kubectl get pods -A | grep Evicted
EOF
fi

if [ $RD_OPTION_TASK == "Clear" ]; then
echo "Clearing the Evicted Pods from cluster in all namespaces"
cat <<EOF | kubectl get pod -n RD_OPTION_NAME | grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n RD_OPTION_NAME
EOF
fi

