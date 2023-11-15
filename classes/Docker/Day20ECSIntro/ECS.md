# ECS  
Amazon Elastic Container Service (Amazon ECS) is a fully managed container orchestration service that helps you easily deploy, manage, and scale containerized applications.   
Options to run your applications on Amazon EC2 instances, a serverless environment, or on-premises VMs.  

## ECS Cluster Overview  
1. ECS Clusters are logical grouping of EC2 instances.  
2. EC2 instances run the ECS agent(Docker Container).  
3. The ECS agents resiters the instances to the ECS Cluster.  
4. The EC2 instances runs on a special AMI, that specifically designed for ECS.  

## Summary of the ECS Terms  
1. **Task Definition** — This a blueprint that describes how a docker container should launch. If you are already familiar with AWS, it is like a LaunchConfig except instead it is for a docker container instead of a instance. It contains settings like exposed port, docker image, cpu shares, memory requirement, command to run and environmental variables.  
2. **Task** — This is a running container with the settings defined in the Task Definition. It can be thought of as an “instance” of a Task Definition.  
3. **Service** — Defines long running tasks of the same Task Definition. This can be 1 running container or multiple running containers all using the same Task Definition.  
4. **Cluster** — A logic group of EC2 instances. When an instance launches the ecs-agent software on the server registers the instance to an ECS Cluster. This is easily configurable by setting the ECS_CLUSTER variable in /etc/ecs/ecs.config described here.
5. **Container Instance** — This is just an EC2 instance that is part of an ECS Cluster and has docker and the ecs-agent running on it.  

## Common use cases in Amazon ECS  
Fargate is suitable for the following workloads:  
1. Large workloads that need to be optimized for low overhead  
2. Small workloads that have occasional burst  
3. Tiny workloads  
4. Batch workloads  

## EC2 is suitable for the following workloads:
1. Workloads that require consistently high CPU core and memory usage  
2. Large workloads that need to be optimized for price  
3. Your applications need to access persistent storage  
4. You must directly manage your infrastructure  

## Reference:  
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html#  
https://aws.amazon.com/ecs/pricing/  



## ECR Elastic Container Registry

ECR Hands On steps to execute

## fetch an existing image

```bash
docker pull gkoenig/simplehttp
```

## Create repository

```bash
aws ecr create-repository \
--repository-name ecr-simplehttp \
--region us-west-2 \
--image-scanning-configuration scanOnPush=true
```

## Tag docker image


```bash
docker images
docker tag gkoenig/simplehttp 258889785048.dkr.ecr.eu-central-1.amazonaws.com/ecr-simplehttp:1.0
docker tag gkoenig/simplehttp 258889785048.dkr.ecr.eu-central-1.amazonaws.com/ecr-simplehttp:latest 
```

## Get authentication token

Retrieve the authentication token:

```bash
aws ecr get-login-password --region eu-central-1
```

Do the docker login in 1 step:

```bash
aws ecr get-login-password --region eu-central-1 | docker login \
--username AWS \
--password-stdin \
258889785048.dkr.ecr.eu-central-1.amazonaws.com 
```

## Push docker image to ECR repository

```bash
docker push 258889785048.dkr.ecr.eu-central-1.amazonaws.com/ecr-simplehttp:1.0
docker push 258889785048.dkr.ecr.eu-central-1.amazonaws.com/ecr-simplehttp:latest
```

## Using the image within a service

* update _simplehttp_ task definition, replacing the container image by the one you used e.g. in pushing it to ECR
* create a service
    * EC2 launchtype
    * using the updated task definition
    * use the existing loadbalancer
* call URL to ALB to test the availability of the service