import boto3
ec2_client = boto3.client('ec2')
global status_output
global report_output
status_output = []
report_output = []
def getEC2InstanceStatus():
    status = ec2_client.describe_instance_status()
    for i in status["InstanceStatuses"]:
        status_output.append([i["InstanceId"], i["InstanceStatus"]['Status'], i["SystemStatus"]['Status']])
    return status_output
def statusHealthCheck(status_output):
    for status_health in status_output:
        if ("ok" not in status_health[1]) or ("ok" not in status_health[2]):
            hostname = ec2_client.describe_tags(
                Filters=[
                {
                    'Name': 'resource-id',
                    'Values': [status_health[0]]
                }
            ]
            )
            if name := [tag['Value'] for tag in hostname['Tags'] if tag['Key'] == 'Name']:
                string = status_health
                report_output.append(name + string)
    return report_output
def printReport(report_output):
    if report_output:
        print("The following hosts have health checks that are not in a 'ok' state")
        print ("{:<50} {:<20} {:<20} {:<20}".format( 'Instance', 'Instance_ID', 'Instance_Status', 'System_Status'))
        for data in report_output:
            instance, instance_id, instance_status, system_status = data
            print ("{:<50} {:<20} {:<20} {:<20}".format( instance, instance_id, instance_status, system_status))
    else:
        print("No EC2 issues")
getEC2InstanceStatus()
statusHealthCheck(status_output)
printReport(report_output)