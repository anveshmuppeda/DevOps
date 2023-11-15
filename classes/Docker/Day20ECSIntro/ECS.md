# # ECR Elastic Container Registry

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