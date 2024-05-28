#!/bin/bash

# Parse input parameters
while [[ "$#" -gt 0 ]]
do
  case $1 in
    --environment)
      RD_OPTION_ENVIRONMENT="$2"
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
echo "Restarting ${RD_OPTION_NODE}"
#instanceid="$(aws ec2 describe-instances --region ${RD_GLOBALS_AWS_REGION} --filters "Name=private-dns-name,Values=${RD_OPTION_NODE}" | jq -r .Reservations[0].Instances[0].InstanceId)"
#aws ec2 terminate-instances --region ${RD_GLOBALS_AWS_REGION} --instance-ids $instanceid
#echo $instanceid

runningnodes=$(aws ec2 describe-instances --region ${RD_GLOBALS_AWS_REGION} --query 'Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key==`Name`]| [0].Value]' --filters "Name=tag:Name,Values="${RD_OPTION_NODE}"" "Name=tag:Client_Prefix,Values="anv"" "Name=instance-state-name,Values=running" --output text  | awk '{print $1}' )
echo "Printing the current ec2 instanace ID"
echo $runningnodes

#echo "Checking the current status of the ${RD_OPTION_NODE}"
#servercurrentstatus=$(aws ec2 describe-instances --region ${RD_GLOBALS_AWS_REGION}  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key==`Name`]| [0].Value]' --filters "Name=tag:Name,Values="${RD_OPTION_NODE}"" "Name=tag:Client_Prefix,Values="anv"" --output text | awk '{print $2}')
#echo $servercurrentstatus

#echo "Stopping ${RD_OPTION_NODE}"
#aws ec2 stop-instances --region ${RD_GLOBALS_AWS_REGION} --instance-ids $runningnodes

if [ "$RD_OPTION_TYPE" == "status" ]; then
    servercurrentstatus=$(aws ec2 describe-instances --region ${RD_GLOBALS_AWS_REGION}  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key==`Name`]| [0].Value]' --filters "Name=tag:Name,Values="${RD_OPTION_NODE}"" "Name=tag:Client_Prefix,Values="anv"" --output text | awk '{print $2}')
    echo "Cheking the server status of ${RD_OPTION_NODE}";
    echo $servercurrentstatus
# Check if need to drain node
elif [ "$RD_OPTION_TYPE" == "start" ]; then
    echo "Starting the server";
    echo "Cheking the ${RD_OPTION_NODE} status";
    servercurrentstatus=$(aws ec2 describe-instances --region ${RD_GLOBALS_AWS_REGION}  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key==`Name`]| [0].Value]' --filters "Name=tag:Name,Values="${RD_OPTION_NODE}"" "Name=tag:Client_Prefix,Values="anv"" --output text | awk '{print $2}')
    echo $servercurrentstatus
    if [ "$servercurrentstatus" == "stopped" ]; then
    aws ec2 start-instances --region ${RD_GLOBALS_AWS_REGION} --instance-ids $runningnodes
    else
    echo "Current status is incorrect, wait for the status become "STOPPED" then proceed with start"
    exit 2
    fi
elif [ "$RD_OPTION_TYPE" == "stop" ]; then
    echo "Stopping the ${RD_OPTION_NODE}";
    echo "Cheking the ${RD_OPTION_NODE} status before Stop";
    echo $servercurrentstatus
    if [ "$servercurrentstatus" == "running" ]; then
    aws ec2 stop-instances --region ${RD_GLOBALS_AWS_REGION} --instance-ids $runningnodes
    elif [ "$servercurrentstatus" == "shutting-down" ]; then
    echo "Instance is already stopping"
    exit 2
    elif [ "$servercurrentstatus" == "terminated" ]; then
    echo "Instance is terminated, it won't stop"
    fi
fi
