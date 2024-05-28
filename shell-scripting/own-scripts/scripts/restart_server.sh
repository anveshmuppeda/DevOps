#!/bin/bash

# Parse input parameters
while [[ "$#" -gt 0 ]]
do
  case $1 in
    --datacentre)
      RD_OPTION_DATACENTRE="$2"
      ;;
    --environment)
      RD_OPTION_ENVIRONMENT="$2"
      ;;
    --node_name)
      RD_OPTION_NODE_NAME="$2"
      ;;
    --type)
      RD_OPTION_TYPE="$2"
      ;;
    --node)
      RD_OPTION_NODE="$2"
      ;;
    --override_caas_branch)
      RD_OPTION_OVERRIDE_CAAS_BRANCH="$2"
      ;;
  esac
  shift
done

source /tmp/common.sh

# Restarting Server
instanceid=$(aws ec2 describe-instances --region ${RD_GLOBALS_AWS_REGION} --query 'Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key==`Name`]| [0].Value]' --filters "Name=tag:Name,Values="${RD_OPTION_NODE_NAME}"" "Name=tag:Client_Prefix,Values="anv"" "Name=instance-state-name,Values=running" --output text  | awk '{print $1}' )
echo "${RD_OPTION_NODE_NAME} Instanace ID"
echo $instanceid


#echo "Checking the current status of the ${RD_OPTION_NODE}"
servercurrentstatus=$(aws ec2 describe-instances --region ${RD_GLOBALS_AWS_REGION}  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key==`Name`]| [0].Value]' --filters "Name=tag:Name,Values="${RD_OPTION_NODE_NAME}"" "Name=tag:Client_Prefix,Values="anv"" --output text | awk '{print $2}')

if [ "$RD_OPTION_TYPE" == "status" ]; then
    echo "${RD_OPTION_NODE_NAME} Current Status is:";
    echo $servercurrentstatus
# Check if need to drain node
elif [ "$RD_OPTION_TYPE" == "start" ]; then
    echo "Starting the server";
    echo "Cheking the ${RD_OPTION_NODE_NAME} current status";
    servercurrentstatus=$(aws ec2 describe-instances --region ${RD_GLOBALS_AWS_REGION}  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key==`Name`]| [0].Value]' --filters "Name=tag:Name,Values="${RD_OPTION_NODE_NAME}"" "Name=tag:Client_Prefix,Values="anv"" --output text | awk '{print $2}')
    echo $servercurrentstatus
    if [ "$servercurrentstatus" == "stopped" ]; then
    aws ec2 start-instances --region ${RD_GLOBALS_AWS_REGION} --instance-ids $instanceid
    else
    echo "Current status is incorrect, wait for the status become "STOPPED" then proceed with start"
    exit 2
    fi
elif [ "$RD_OPTION_TYPE" == "stop" ]; then
    echo "${RD_OPTION_NODE_NAME} Current status is:";
    echo $servercurrentstatus;
    if [ "$servercurrentstatus" == "running" ] || [ "$servercurrentstatus" == "pending" ]; then
        echo "Stopping the ${RD_OPTION_NODE_NAME}"
        aws ec2 stop-instances --region ${RD_GLOBALS_AWS_REGION} --instance-ids $instanceid
    elif [ "$servercurrentstatus" == "shutting-down" ] || [ "$servercurrentstatus" == "stopping" ]; then
    echo "Instance is already stopping"
    exit 2
    elif [ "$servercurrentstatus" == "terminated" ]; then
    echo "Instance is terminated"
    fi
fi
