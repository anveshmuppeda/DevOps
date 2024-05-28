#! /bin/bash

# Parse input parameters
while [[ "$#" -gt 0 ]]
do
  case $1 in
    --environment)
      RD_OPTION_ENVIRONMENT="$2"
      ;;
    --name)
      RD_OPTION_NAME="$2"
      ;;
    --ucp_password)
      RD_OPTION_UCP_PASSWORD="$2"
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

export DATACENTER=${RD_GLOBALS_TF_VAR_CLIENT_PREFIX}-${RD_OPTION_ENVIRONMENT}
export CLUSTER_URL_PREFIX=$(consul kv get aws/${RD_GLOBALS_AWS_REGION}/${RD_GLOBALS_TF_VAR_CLIENT_PREFIX}/environments/${RD_OPTION_ENVIRONMENT}/common/TF_VAR/cluster_url_prefix)
export BASE_DOMAIN=$(consul kv get aws/${RD_GLOBALS_AWS_REGION}/${RD_GLOBALS_TF_VAR_CLIENT_PREFIX}/global/TF_VAR/base_domain)
UCP_DOMAIN="${CLUSTER_URL_PREFIX}ucp.${BASE_DOMAIN}"
USERNAME="admin"
PASSWORD=$RD_OPTION_UCP_PASSWORD

if [ $RD_OPTION_CLUSTER_TYPE == "kubernetes" ]; then
    . /opt/eipaas/utils/vault_login.sh
    mkdir -p ./bundle/${RD_OPTION_ENVIRONMENT}/
    vault kv get -field admin "internal/management/alm_operations_server/${RD_OPTION_ENVIRONMENT}/k8sconf" > ./bundle/${RD_OPTION_ENVIRONMENT}/admin.conf
    export KUBECONFIG=$PWD/bundle/${RD_OPTION_ENVIRONMENT}/admin.conf
    # TODO: Replace with in environment registry
    REGISTRY_URL=$DOCKER_REGISTRY/docker-releases
    #REGISTRY_URL="${CLUSTER_URL_PREFIX}registry.${BASE_DOMAIN}"
else
    REGISTRY_URL="${CLUSTER_URL_PREFIX}dtr.${BASE_DOMAIN}/xpaas-system"
    if [ -f ./bundle/${RD_OPTION_ENVIRONMENT}/env.sh ]; then
        cd bundle/${RD_OPTION_ENVIRONMENT}
        eval "$(<env.sh)"
        cd ..
    else
        echo "No client bundle, please use the job to generate one and then try again."
        exit 2
    fi
fi

echo ""
echo "Deleting namespace"

kubectl delete namespace "$RD_OPTION_NAME"

echo ""
echo "Listing namespaces in cluster"
kubectl get ns

all {
    #delete all evicted pods in cluster
    kubectl get pods -A | grep Evicted | awk '{print $1,$2,$4}' | xargs kubectl delete pod $2 -n $1
    #List evicted pods in cluster
    kubectl get pods -A | grep Evicted
}

specific_namespace {
    #delete eveicted pods in specific namespace
    kubectl get pods -A | grep Evicted | awk '{print $1,$2,$4}' | xargs kubectl delete pod $2 -n $1
    #List evicted pods in specific namespace
    kubectl get pods -n $namespace | grep Evicted
}

#main function call definitions
if [ $RD_OPTION_OPTION == "all" ]; then
    echo -e "\nRunninf in all namespaces\n"
    #calling all functions
    all
else
    echo -e "\nRuning againat specific namespace"
    #calling specific_namespace function function
    specific_namespace
fi

echo ""
echo "=========END========"

