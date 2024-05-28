#!/bin/bash

env=$1

##### All of the echos commented out below are for debugging only #####

echo "Obtaining current AWS Status - Frankfurt"
curl -s https://status.aws.amazon.com/ | sed '/Status History/,$d' | sed -e 's/<[^>]*>//g' | sed 's/  */ /g' | sed -e '/Frankfurt/N;y/\n/\t/' | grep "Frankfurt" > /tmp/awsStatus.txt

services=(
    ElasticSearch \
    Kibana \
    Kibana-SM \
    Grafana \
    Grafana-SM \
    Logstash-SM-Logging \
    Sensu \
    Graphite-SM-Metric-Store \
    Consul \
    Nomad \
    AP-Database \
    Client-Database \
    AP-Database-Repmgr \
    Client-Database-Repmgr \
    APIM-API-Manager-Gateway-HTTP \
    APIM-API-Manager-Gateway-HTTPS \
    APIM-API-Manager-Gateway-Manager \
    APIM-API-Manager-Analytics \
    APIM-API-Manager-Key-Manager \
    APIM-API-Manager-Publisher \
    APIM-API-Manager-Store \
    APIM-API-Manager-Traffic-Manager \
    APIM-API-Manager-User-Store \
    Jenkins \
    Jenkins-Slave \
    Nexus \
    Rundeck \
    AP-iPaaS-Private-Load-Balancer \
    AP-iPaaS-Public-Load-Balancer \
    OpenVPN \
    Container-Server \
    # Container-Docker \
    SM-RabbitMQ \
    INT-RabbitMQ \
    )

bitbucketservices=(
    BitBucket-SSH \
    BitBucket-HTTPS \
)

awsServices=(
    RDS \
    EC2 \
    VPN \
    DirectConnect \
    NAT \
    Peering \
    Elasticache \
)

awsServiceStatus=(
    AWS-EC2 \
    # AWS-EBS \
    AWS-EFS \
    # AWS-S3 \
    AWS-RDS \
    AWS-ElastiCache \
    AWS-ELB \
    AWS-Route-53 \
    AWS-VPC \
    AWS-Direct-Connect \
    AWS-VPN \
    AWS-Transit-Gateway \
    AWS-CloudTrail \
    AWS-Config \
    AWS-KMS \
    AWS-Lambda \
    AWS-CloudWatch \
)

declare -A command=(
    [ElasticSearch]=`curl -s 'elasticsearch.service.core.local:9200/_cat/health?format=json&pretty' | jq --raw-output '.[].status | select(. == "yellow" or "green")' | wc -l` \
    [Kibana]=`curl -s 'localhost:8500/v1/health/service/kibana?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "kibana")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [Kibana-SM]=`curl -s 'localhost:8500/v1/health/service/kibana-sm?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "kibana-sm")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [Grafana]=`curl -s 'localhost:8500/v1/health/service/grafana?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "grafana")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [Grafana-SM]=`curl -s 'localhost:8500/v1/health/service/grafana-sm?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "grafana")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [Logstash-SM-Logging]=`curl -s 'localhost:8500/v1/health/service/logstash-service?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.Node | contains ("sm-logging-server"))) | map(select(.CheckID == "logstash-service")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 3 ]]; then echo "1"; else echo "0"; fi` \
    [Sensu]=`curl -s 'localhost:8500/v1/health/service/sensu-api?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "sensu-api")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [Graphite-SM-Metric-Store]=`curl -s 'localhost:8500/v1/health/service/graphite?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "graphite")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [Consul]=`curl -s 'localhost:8500/v1/health/service/consul?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "consul")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 3 ]]; then echo "1"; else echo "0"; fi` \
    [Nomad]=`curl -s 'localhost:8500/v1/health/service/nomad?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.Name == "Nomad Server Serf Check")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 3 ]]; then echo "1"; else echo "0"; fi` \
    [AP-Database]=`curl -s 'localhost:8500/v1/health/service/ap_database?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "ap_database")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [Client-Database]=`curl -s 'localhost:8500/v1/health/service/client_database_'$env'?format=json&pretty' | jq --arg env "$env" --raw-output '.[].Checks | map(select(.CheckID == "client_database_'$env'")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [AP-Database-Repmgr]=`curl -s 'localhost:8500/v1/health/service/repmgr?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.Node | contains ("ap-database"))) | map(select(.CheckID == "repmgr-service")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [Client-Database-Repmgr]=`curl -s 'localhost:8500/v1/health/service/repmgr?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.Node | contains ("client-database"))) | map(select(.CheckID == "repmgr-service")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [APIM-API-Manager-Gateway-HTTP]=`curl -s 'localhost:8500/v1/health/service/api_manager_gateway_http_api_access?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "api_manager_gateway_http_api_access")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [APIM-API-Manager-Gateway-HTTPS]=`curl -s 'localhost:8500/v1/health/service/api_manager_gateway_https_api_access?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "api_manager_gateway_https_api_access")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [APIM-API-Manager-Gateway-Manager]=`curl -s 'localhost:8500/v1/health/service/wso2-gateway-manager?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "wso2-gateway-manager")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [APIM-API-Manager-Analytics]=`curl -s 'localhost:8500/v1/health/service/wso2-analytics?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "wso2-analytics")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [APIM-API-Manager-Key-Manager]=`curl -s 'localhost:8500/v1/health/service/wso2-key-manager?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "wso2-key-manager")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [APIM-API-Manager-Publisher]=`curl -s 'localhost:8500/v1/health/service/wso2-publisher?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "wso2-publisher")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [APIM-API-Manager-Store]=`curl -s 'localhost:8500/v1/health/service/wso2-store?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "wso2-store")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [APIM-API-Manager-Traffic-Manager]=`curl -s 'localhost:8500/v1/health/service/wso2-traffic-manager?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "wso2-traffic-manager")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [APIM-API-Manager-User-Store]=`curl -s 'localhost:8500/v1/health/service/wso2_user_store?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID == "wso2_user_store")) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [Jenkins]=`curl -s -o /dev/null -w "%{http_code}"  https://jenkins.cloud.aioinissaydowa.eu/login | grep 200 | wc -l` \
    [Jenkins-Slave]=`curl -s 'localhost:8500/v1/health/checks/jenkins-slave?format=json&pretty' | jq '.[] | select(.Node == "alm-continuous-integration-agent-0")' | grep passing | wc -l` \
    [Nexus]=`curl -s -o /dev/null -w "%{http_code}"  https://nexus.cloud.aioinissaydowa.eu/ | grep 200 | wc -l` \
    [Rundeck]=`curl -s -o /dev/null -w "%{http_code}" https://rundeck.cloud.aioinissaydowa.eu/user/login | grep 200 | wc -l` \
    [AP-iPaaS-Private-Load-Balancer]=`curl -s 'localhost:8500/v1/health/checks/haproxy-service?format=json&pretty' | jq '.[] | select(.Node == "ap-ipaas-private-load-balancer-0")' | grep passing | wc -l > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [AP-iPaaS-Public-Load-Balancer]=`curl -s 'localhost:8500/v1/health/checks/haproxy-service?format=json&pretty' | jq '.[] | select(.Node == "ap-ipaas-public-load-balancer-0")' | grep passing | wc -l > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [OpenVPN]=`curl -s -o /dev/null -w "%{http_code}"  https://openvpn.cloud.aioinissaydowa.eu/?src=connect | grep 302 | wc -l` \
    [Container-Server]=`curl -s 'localhost:8500/v1/health/service/nomad-client?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.Node | contains ("container-host"))) | map(select(.Name == "Nomad Client HTTP Check"))| length ' > container.txt; container_count=$(head -n -1 container.txt | wc -l); container_threshold=$(( container_count*33/100 )); curl -s 'localhost:8500/v1/health/service/nomad-client?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.Node | contains ("container-host"))) | map(select(.Name == "Nomad Client HTTP Check")) | map(select(.Status == "passing")) | length'  > container_success.txt; container_success_count=$(head -n -1 container_success.txt | wc -l);  if [[ $container_success_count -ge $container_threshold ]]; then echo "1"; else echo "0"; fi` \
    [SM-RabbitMQ]=`curl -s 'localhost:8500/v1/health/service/rabbitmq?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.Node | contains ("sm-messaging"))) | map(select(.CheckID | contains ("rabbitmq"))) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [INT-RabbitMQ]=`curl -s 'localhost:8500/v1/health/service/rabbitmq-server-service-'$env'?format=json&pretty' | jq --raw-output '.[].Checks | map(select(.CheckID | contains ("rabbitmq"))) | map(select(.Status == "passing")) | length' | grep "1" > /tmp/count.txt; if [[ $(wc -l </tmp/count.txt) -ge 1 ]]; then echo "1"; else echo "0"; fi` \
    [AWS-EC2]=`grep "Amazon Elastic Compute Cloud" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    # ???????????[AWS-EBS]=`grep "Amazon Elastic Compute Cloud" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-EFS]=`grep "Amazon Elastic File System " /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    # ????????????[AWS-S3]=`grep "Amazon Elastic Compute Cloud" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-RDS]=`grep "Amazon Relational Database Service " /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-ElastiCache]=`grep "Amazon ElastiCache" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-ELB]=`grep "Amazon Elastic Load Balancing" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-Route-53]=`grep "Amazon Route 53 Private DNS" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-VPC]=`grep "AWS VPCE PrivateLink" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-Direct-Connect]=`grep "AWS Direct Connect " /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-VPN]=`grep "AWS Client VPN" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-Transit-Gateway]=`grep "AWS Transit Gateway" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-CloudTrail]=`grep "AWS CloudTrail" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-Config]=`grep "AWS Config" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-KMS]=`grep "AWS Key Management Service" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-Lambda]=`grep "AWS Lambda" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [AWS-CloudWatch]=`grep "Amazon CloudWatch" /tmp/awsStatus.txt | grep "Service is operating normally" | wc -l` \
    [RDS]=`totalinstances=$(aws rds describe-db-instances --region=eu-central-1 | jq --raw-output '.DBInstances[].DBInstanceIdentifier' | wc -l); availableinstances=$(aws rds describe-db-instances --region=eu-central-1 | jq --raw-output '.DBInstances[].DBInstanceStatus' | grep -v "failed" | wc -l); awk -v a="$availableinstances" -v b="$totalinstances" 'BEGIN { printf (a/b)*100 }'`\
    [EC2]=`totalinstances=$(($(aws ec2 describe-instance-status --region=eu-central-1 | jq --raw-output '.InstanceStatuses[].SystemStatus.Status' | wc -l)+$(aws ec2 describe-instance-status --region=eu-central-1 | jq --raw-output '.InstanceStatuses[].InstanceStatus.Status' | wc -l))); availableinstances=$(($(aws ec2 describe-instance-status --region=eu-central-1 | jq --raw-output '.InstanceStatuses[].SystemStatus.Status' | grep "ok" | wc -l)+$(aws ec2 describe-instance-status --region=eu-central-1 | jq --raw-output '.InstanceStatuses[].InstanceStatus.Status' | grep "ok" | wc -l))); awk -v a="$availableinstances" -v b="$totalinstances" 'BEGIN { printf (a/b)*100 }'` \
    [VPN]=`totalinstances=$(aws ec2 describe-vpn-connections --region=eu-central-1 | jq --raw-output '.VpnConnections[].State' | wc -l); availableinstances=$(aws ec2 describe-vpn-connections --region=eu-central-1 | jq --raw-output '.VpnConnections[].State'| grep "available" | wc -l); awk -v a="$availableinstances" -v b="$totalinstances" 'BEGIN { printf (a/b)*100 }'` \
    [DirectConnect]=`totalinstances=$(aws directconnect describe-connections --region=eu-central-1 | jq --raw-output '.connections[].connectionState' | wc -l); availableinstances=$(aws directconnect describe-connections --region=eu-central-1 | jq --raw-output '.connections[].connectionState' | grep "available" | wc -l); awk -v a="$availableinstances" -v b="$totalinstances" 'BEGIN { printf (a/b)*100 }'` \
    [NAT]=`totalinstances=$(aws ec2 describe-nat-gateways --region=eu-central-1 | jq --raw-output '.NatGateways[].State' | wc -l); availableinstances=$(aws ec2 describe-nat-gateways --region=eu-central-1 | jq --raw-output '.NatGateways[].State' | grep "available" | wc -l); awk -v a="$availableinstances" -v b="$totalinstances" 'BEGIN { printf (a/b)*100 }'` \
    [Peering]=`totalinstances=$(aws ec2 describe-vpc-peering-connections --region=eu-central-1 | jq --raw-output '.VpcPeeringConnections[].Status.Code' | wc -l); availableinstances=$(aws ec2 describe-vpc-peering-connections --region=eu-central-1 | jq --raw-output '.VpcPeeringConnections[].Status.Code' | grep -v "failed" | wc -l); awk -v a="$availableinstances" -v b="$totalinstances" 'BEGIN { printf (a/b)*100 }'` \
    [Elasticache]=`totalinstances=$(aws elasticache describe-cache-clusters --region=eu-central-1 | jq --raw-output '.CacheClusters[].CacheClusterStatus' | wc -l); availableinstances=$(aws elasticache describe-cache-clusters --region=eu-central-1 | jq --raw-output '.CacheClusters[].CacheClusterStatus' | grep "available" | wc -l); awk -v a="$availableinstances" -v b="$totalinstances" 'BEGIN { printf (a/b)*100 }'` \
    [BitBucket-SSH]=`curl -s https://bqlf8qjztdtr.statuspage.io/api/v2/components.json | jq --raw-output '.components | map(select(.name| contains ("SSH"))) | map(select(.status == "operational")) | length' | wc -l` \
    [BitBucket-HTTPS]=`curl -s https://bqlf8qjztdtr.statuspage.io/api/v2/components.json | jq --raw-output '.components | map(select(.name| contains ("HTTPS"))) | map(select(.status == "operational")) | length' | wc -l` \
)

maintenenceCheck(){

curl -g --silent --location --request GET 'https://api.pagerduty.com/maintenance_windows?service_ids[]=P3C618H,PLU67DA&filter=ongoing' --header 'Authorization: Token token=xiCQd9PDZt27BkbURx-x' --header 'Accept: application/vnd.pagerduty+json;version=2' | jq --raw-output 'if .maintenance_windows == [] then "No maintenence windows" else "Maintenence in progress" end' | grep "Maintenence in progress" | wc -l > /tmp/maintenence.txt


if [[ $(grep "0" /tmp/maintenence.txt) ]]
then
echo "Currenty there is no ongoing maintenence."
export maintenenceWindow=0
elif [[ $(grep "1" /tmp/maintenence.txt) ]]
then
echo "Maintenence ongoing"
export maintenenceWindow=1
fi

echo $env
}

awsMaintenenceCheck(){

curl -g --silent --location --request GET 'https://api.pagerduty.com/maintenance_windows?service_ids[]=PK5MJJC&filter=ongoing' --header 'Authorization: Token token=xiCQd9PDZt27BkbURx-x' --header 'Accept: application/vnd.pagerduty+json;version=2' | jq --raw-output 'if .maintenance_windows == [] then "No maintenence windows" else "Maintenence in progress" end' | grep "Maintenence in progress" | wc -l > /tmp/awsMaintenence.txt


if [[ $(grep "0" /tmp/awsMaintenence.txt) ]]
then
echo "Currenty there is no ongoing AWS maintenence."
export awsMaintenenceWindow=0
elif [[ $(grep "1" /tmp/awsMaintenence.txt) ]]
then
echo "AWS Maintenence ongoing"
export awsMaintenenceWindow=1
fi

}

serviceAvailability(){

for service in "${services[@]}"
do
    # echo "Completing Status Check Command for $service"
    # echo ""
    echo "${command[$service]}" > /tmp/"$service"_output.txt



    if [[ $(grep "1" /tmp/"$service"_output.txt) ]]
    then
    # echo "The service is currently available registering to Graphite"
    # echo ""
    echo "serviceAvailability.$service.success 1 `date +%s`" | nc localhost 2103
    elif [[ $(grep "0" /tmp/"$service"_output.txt) ]]
    then
    # echo "The service is currently down registering to Graphite"
    # echo ""
    echo "serviceAvailability.$service.failure 1 `date +%s`" | nc localhost 2103
    else
    # echo "The status was not recognised writing as an error"
    echo "serviceAvailability.$service.failure 1 `date +%s`" | nc localhost 2103
    fi


# echo "######################################################"
done
}

bitbucketServiceAvailability(){

for bitbucketservices in "${bitbucketservices[@]}"
do
    # echo "Completing Status Check Command for $service"
    # echo ""
    echo "${command[$bitbucketservices]}" > /tmp/"$bitbucketservices"_output.txt



    if [[ $(grep "1" /tmp/"$bitbucketservices"_output.txt) ]]
    then
    # echo "The service is currently available registering to Graphite"
    # echo ""
    echo "serviceAvailability.$bitbucketservices.success 1 `date +%s`" | nc localhost 2103
    elif [[ $(grep "0" /tmp/"$bitbucketservices"_output.txt) ]]
    then
    # echo "The service is currently down registering to Graphite"
    # echo ""
    echo "serviceAvailability.$bitbucketservices.failure 1 `date +%s`" | nc localhost 2103
    else
    # echo "The status was not recognised writing as an error"
    echo "serviceAvailability.$bitbucketservices.failure 1 `date +%s`" | nc localhost 2103
    fi


# echo "######################################################"
done
}

awsServiceAvailability(){

for service in "${awsServices[@]}"
do
    echo "Completing Status Check Command for $service"
    echo ""
    echo "${command[$service]}" > /tmp/"$service"_output.txt
    echo "serviceAvailability.$service.status $(cat /tmp/"$service"_output.txt) `date +%s`" | nc localhost 2103
done
}

awsServiceStatus(){

for awsservice in "${awsServiceStatus[@]}"
do
    # echo "Completing Status Check Command for $awsservice"
    # echo ""
    echo "${command[$awsservice]}" > /tmp/"$awsservice"_output.txt



    if [[ $(grep "1" /tmp/"$awsservice"_output.txt) ]]
    then
    # echo "The service is currently available registering to Graphite"
    # echo ""
    echo "serviceAvailability.$awsservice.success 1 `date +%s`" | nc localhost 2103
    elif [[ $(grep "0" /tmp/"$awsservice"_output.txt) ]]
    then
    # echo "The service is currently down registering to Graphite"
    # echo ""
    echo "serviceAvailability.$awsservice.failure 1 `date +%s`" | nc localhost 2103
    else
    # echo "The status was not recognised writing as an error"
    echo "serviceAvailability.$awsservice.failure 1 `date +%s`" | nc localhost 2103
    fi


# echo "######################################################"
done
}

maintenenceCheck
awsMaintenenceCheck

if [[ $maintenenceWindow = 1 ]]
then
    for service in "${services[@]}"
    do
        # echo "Maintenance Window in progress registering to Graphite"
        echo "serviceAvailability.$service.maintenence 1 `date +%s`" | nc localhost 2103
    done
else
    # echo "There are currently no scheduled maintenence windows"
    # echo "######################################################"
    # echo ""
    serviceAvailability
fi

if [[ $awsMaintenenceWindow = 1 ]]
then
    for awsservice in "${awsServices[@]}"
    do
        # echo "Maintenance Window in progress registering to Graphite"
        echo "serviceAvailability.$awsservice.status 100.00 `date +%s`" | nc localhost 2103
    done
else
    # echo "There are currently no scheduled maintenence windows"
    # echo "######################################################"
    # echo ""
    awsServiceAvailability
fi

# AWS availability to always run as this is AWS's services
awsServiceStatus
bitbucketServiceAvailability
