#!/bin/bash


# Parse input parameters
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'

#global variables
servers_count=0
failing_servers_count=0
failed_rds_nodes_count=0
failed_consul_services_count=0
faileddns=0

while [[ "$#" -gt 0 ]]
do
  case $1 in
    --environment_region)
      RD_OPTION_ENVIRONMENT_REGION="$2"
      ;;
    --option)
      RD_OPTION_CHECK="$2"
      ;;
    --override_caas_branch)
      RD_OPTION_OVERRIDE_CAAS_BRANCH="$2"
      ;;
  esac
  shift
done

source /tmp/common.sh
#AWS Console morning checks

#EC2 Health Function Definition
ec2health()
{
#environments
aws ec2 describe-instances --region "$RD_OPTION_ENVIRONMENT_REGION" --query 'Reservations[*].Instances[*].[Tags[?Key==`Environment`]| [0].Value]' --filters "Name=tag:Client_Prefix,Values="anv"" --output text | sort -u > /tmp/environments
for environment in `cat /tmp/environments`
    do
        echo -e "\n${BOLD}EC2 servers status from AWS Console on $environment"
        #removing the status health file
        rm -rf /tmp/ec2statushealth.out
        aws ec2 describe-instances --region "$RD_OPTION_ENVIRONMENT_REGION"  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,Tags[?Key==`Name`]| [0].Value]' --filters "Name=tag:Client_Prefix,Values="anv"" "Name=tag:Environment,Values="$environment"" --output text > /tmp/serverstatus.out
        cat /tmp/serverstatus.out | grep -v running > /tmp/failed_servers.out
        failing_servers_count=$((failing_servers_count+`cat /tmp/failed_servers.out | wc -l`))
        cat /tmp/serverstatus.out | grep running | awk '{print $1}' > /tmp/running_servers_ids.out
        cat /tmp/serverstatus.out | grep running > /tmp/running_servers_all.out

        echo -e "${RED}Failed Servers List:"
        if [ -s /tmp/failed_servers.out ]
        then
                echo -e "${RED}Below servers are failing:";
                sed -i  '1i Instance_ID Status Server_Name' /tmp/failed_servers.out
                #echo -e "`cat /tmp/failed_servers.out`"
                cat /tmp/failed_servers.out | column -t
                echo -e "========================================="
        else
                echo -e "${GREEN}All serverers are running\n";
                echo -e "========================================="
        fi

        for ec2nodeid in `cat /tmp/running_servers_ids.out`
        {
          aws ec2 describe-instance-status --region us-east-1 --query 'InstanceStatuses[*].[SystemStatus.Details[?Name==`reachability`]| [0].Status,InstanceStatus.Details[?Name==`reachability`]| [0].Status]' --instance-ids $ec2nodeid --output text >> /tmp/ec2statushealth.out
        }

        paste /tmp/running_servers_all.out /tmp/ec2statushealth.out > /tmp/ec2overal.out
        servers_count=$((servers_count+`cat /tmp/serverstatus.out | wc -l`))
        failing_servers_count=$((failing_servers_count+`cat /tmp/ec2overal.out | grep failed | wc -l`))
        sed -i  '1i Instance_ID STatus Server_Name First_Status_Check Second_Status_Check' /tmp/ec2overal.out
        echo "Status of the Status checks on running nodes"
        cat /tmp/ec2overal.out | column -t
        #cat /tmp/ec2overal.out | awk 'BEGIN {printf("%-20s %-8s %-40s %-20s %-10s \n" ,"Instance ID", "Status", "Server NAME", "First_Status_check", "Second_Status_check")} {printf("%-20s %-8s %-40s %-20s %-10s\n", $1, $2, $3, $4, $5, $6)}'
echo -e "========================================="
done
}

#RDS Health Function Definition
rdshealth()
{
#Checking RDS Instacne status
echo -e "\nRDS Instances status"
aws rds describe-db-instances --region "$RD_OPTION_ENVIRONMENT_REGION" --query 'DBInstances[].{RDS_NAME:DBInstanceIdentifier,STATUS:DBInstanceStatus,RETENTION:BackupRetentionPeriod}' --output table

#Checking RDS Snapshots
for rds_node in `aws rds describe-db-instances --region "$RD_OPTION_ENVIRONMENT_REGION" --query 'DBInstances[].[DBInstanceIdentifier]' --output text`
    do
        echo -e "\n${BOLD}Last two days snapshots of $rds_node\n"
        #Assigning yesterdays date to the formattedDate vaeiable 
        formattedDate=$(date --date="-1 days" +'%Y-%m-%d')
        aws rds describe-db-snapshots --region "$RD_OPTION_ENVIRONMENT_REGION" --query 'DBSnapshots[?SnapshotCreateTime>=`'${formattedDate}'`].{RDS_NAME:DBInstanceIdentifier,SNAPSHOT_NAME:DBSnapshotIdentifier,CREATION_TIME:SnapshotCreateTime,STATUS:Status,STORAGE:AllocatedStorage}' --db-instance-identifier $rds_node --output table
done
echo -e "========================================="
}

#Consul health function Definition
consulhealth()
{
  echo ""
  for service in `consul catalog services`
  {
        echo " "
        #echo -e "\n${BOLD}Checking $service status"
        curl -s "localhost:8500/v1/health/service/${service}?format=json&pretty" | jq --raw-output '.[].Checks | map(select(.CheckID == "'${service}'")) | map(select(.Status != "passing")) | .[] | .Node' > /tmp/nodes.out
        if [ -s /tmp/nodes.out ]
        then
                echo -e "${RED}$service is failing on below nodes";
                cat /tmp/nodes.out
                echo -e "========================================="
        else
                echo -e "${GREEN}$service Service is running fine\n";
                echo -e "========================================="
        fi
  }
  echo -e "========================================="
}

#UI Health function definition
uihealth()
{
  echo -e "\n${BOLD}Checking UI Health status"
  aws route53 list-resource-record-sets --hosted-zone-id Z0177451ZQ17AJVZ0JDB --query 'ResourceRecordSets[*].[Name]' --output text | sort -u | grep -v blue | grep -v private | grep -v ing > /tmp/route53entries.out
  for entry in `cat /tmp/route53entries.out`
  {
        echo -e "\nStatus of ${entry::-1}"
        #echo "$entry"
        timeout 3s curl -s -o /dev/null -w "%{http_code}" https://${entry::-1}/user/login > /tmp/uistatus.out
        #some 
        if [ -s /tmp/uistatus.out ]
        then
                cat /tmp/uistatus.out
                echo -e "========================================="
        else
                echo -e "${RED}$entry unrecognized\n";
                echo -e "========================================="
        fi
  }
  echo -e "========================================="
}

#final report function definition
finalreport()
{
if [ $RD_OPTION_CHECK == "all" ]; then
    echo -e "\nFinal report for all checks\n"
    echo "$failing_servers_count"

elif [ "$RD_OPTION_CHECK" == "awsec2" ]; then
    echo -e "\nFinal report for AWS EC2 server health checks"
    echo -e "Total number of servers in aws: $servers_count"
    if(( $failing_servers_count > 0 ))
    then
        echo -e "${RED}Number of server failures in aws: $failing_servers_count"
    else
        echo -e "${GREEN}===All servers are running==="
    fi
elif [ "$RD_OPTION_CHECK" == "awsrds" ]; then
    echo -e "\nFinal report for AWS RDS health checks"

elif [ "$RD_OPTION_CHECK" == "consulchecks" ]; then
    echo -e "\nFinal report for Consul Health checks"

elif [ "$RD_OPTION_CHECK" == "uistatus" ]; then
    echo -e "\nFinal report for UI Health status"

fi
echo -e "========================================="
}

#main function call definitions
if [ $RD_OPTION_CHECK == "all" ]; then
    echo -e "\nVerifing the all checks\n"
    #calling all functions
    ec2health
    rdshealth
    consulhealth
    uihealth

elif [ "$RD_OPTION_CHECK" == "awsec2" ]; then
    echo -e "\nVerifying the AWS EC2 server health checks"
    #calling ec2 health checks function
    ec2health
    finalreport

elif [ "$RD_OPTION_CHECK" == "awsrds" ]; then
    echo -e "\nVerifying the AWS RDS health checks"
    #calling rds health checks functions
    rdshealth

elif [ "$RD_OPTION_CHECK" == "consulchecks" ]; then
    echo -e "\nVerifying the Consul Health checks"
    #calling Consul health checks functions
    consulhealth

elif [ "$RD_OPTION_CHECK" == "uistatus" ]; then
    echo -e "\nVerifying the UI Health status"
    #calling UI status functions
    uihealth
fi 
