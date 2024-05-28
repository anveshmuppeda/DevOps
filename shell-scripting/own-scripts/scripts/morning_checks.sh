#!/bin/bash

# Parse input parameters
BOLD='\033[1m'

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

# AWS Console morning checks
#AWS ec2 server checks
aws ec2 describe-instances --region ${RD_GLOBALS_AWS_REGION}  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,SystemStatus,Tags[?Key==`Name`]| [0].Value]' --filters "Name=tag:Client_Prefix,Values="anv"" "Name=tag:Environment,Values="${RD_OPTION_ENVIRONMENT}"" --output text


#RDS list with status
aws rds describe-db-instances --region us-east-1 --query 'DBInstances[].[DBInstanceIdentifier,DBInstanceStatus]' --output text

#RDS list with status retention period
aws rds describe-db-instances --region us-east-1 --query 'DBInstances[].[DBInstanceIdentifier,DBInstanceStatus,BackupRetentionPeriod]'

#RDS snaspshots to list the snapshots
aws rds describe-db-snapshots --region us-east-1 --query 'DBSnapshots[].[DBInstanceIdentifier,DBSnapshotIdentifier,SnapshotCreateTime,Status]' --output text

#RDS names
aws rds describe-db-instances --region us-east-1 --query 'DBInstances[].[DBInstanceIdentifier]' --output text

--db-instance-identifier anv-management-alm-database
#RDS snapshots last 7 days
aws rds describe-db-snapshots --region us-east-1 --query 'DBSnapshots[].[DBInstanceIdentifier,DBSnapshotIdentifier,SnapshotCreateTime,Status]' --db-instance-identifier anv-management-alm-database --output text | tail -n 5


#RDS snapshot with for loop
for rds_node in `aws rds describe-db-instances --region us-east-1 --query 'DBInstances[].[DBInstanceIdentifier]' --output text`
    do
        echo "Latest snapshots of $rds_node\n"
        aws rds describe-db-snapshots --region eu-west-1 --query 'DBSnapshots[].[DBInstanceIdentifier,DBSnapshotIdentifier,SnapshotCreateTime,Status]' --db-instance-identifier $rds_node --output text | tail -n 5
done

#formating
cat /tmp/rds.out | awk 'BEGIN {printf("%35s %35s %35s \n" ,"NAME", "FILE", "HI")} {printf("%35s %35s %35s\n", $1, $2, $3)}'

#environments
aws ec2 describe-instances --region us-east-1  --query 'Reservations[*].Instances[*].[Tags[?Key==`Environment`]| [0].Value]' --filters "Name=tag:Client_Prefix,Values="anv"" --output text | sort -u

#instance health
aws ec2 describe-instance-status --region us-east-1 --query 'InstanceStatuses[*].[InstanceId,SystemStatus.Details[?Name==`reachability`]| [0].Status,InstanceStatus.Details[?Name==`reachability`]| [0].Status]' --output text

aws ec2 describe-instance-status --region us-east-1 --query 'InstanceStatuses[*].[InstanceId,SystemStatus.Details[?Name==`reachability`]| [0].Status,InstanceStatus.Details[?Name==`reachability`]| [0].Status]' --output text

#instance health with instance ID
aws ec2 describe-instance-status --region us-east-1 --query 'InstanceStatuses[*].[InstanceId,SystemStatus.Details[?Name==`reachability`]| [0].Status,InstanceStatus.Details[?Name==`reachability`]| [0].Status]' --instance-ids i-0df3253e5d601732e --output text

#in table format
aws ec2 describe-instances --region us-east-1  --query 'Reservations[*].Instances[*].{Instance:InstanceId,Status:State.Name,Server_Name:Tags[?Key==`Name`]| [0].Value}' --filters "Name=tag:Client_Prefix,Values="anv"" "Name=tag:Environment,Values="management"" --output table

#curl username:pwd nexusurl
#playwrite

#formating
cat output.txt | awk 'BEGIN {printf("%-20s %-8s %-40s %-20s %-20s %-10s \n" ,"Instance ID", "Status", "NAME", "ID", "First_Status_check", "Second_Status_check")} {printf("%-20s %-8s %-40s %-20s %-20s %-10s\n", $1, $2, $3, $4, $5, $6)}'


#1. check the consul checks
#2. check UI status
#3. check UI login


#Servers failing consul template
curl -s 'localhost:8500/v1/health/service/consul-template-service?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "consul-template-service")) | map(select(.Status != "passing")) | .[] | .Node'

#list nodes by passing varibales in curl
curl -s "localhost:8500/v1/health/service/${node}?format=json&pretty" | jq --raw-output '.[].Checks | map(select(.CheckID == "'${node}'")) | map(select(.Status != "passing")) | .[] | .Node'

#UI status
curl -s -o /dev/null -w "%{http_code}" https://anv-rundeck.aws.capgemini-ips.com/user/login | grep 200 | wc -l

#Route53 entries:
aws route53 list-resource-record-sets --hosted-zone-id Z0177451ZQ17AJVZ0JDB --query 'ResourceRecordSets[*].[Name]' --output text | sort -u | grep -v blue

#adding headers using sed
sed -i  '1i COLUMN1,COLUMN2' FF_EMP.txt

#adding headers using awk
sed -i  '1i COLUMN1,COLUMN2' FF_EMP.txt

#formating the output 
file.sh | column -t
#a                           OK
#aa                          OK
#aaa                         OK
#aaaa                        OK
#aaaaaa                      OK
#aaaaaaaaaaaaaaaaa           OK
#aaaaaaaaaaaaaaaaaaaaaaaaaa  OK