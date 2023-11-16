# Self hosted agents in docker  

### to check arch of OS  
```bash
    dpkg --print-architecture
```
### Docker build for dind  
```bash
docker build --tag "azp-agent:dind" . .
```
 ### Docker run for dind  
 ```bash 
 docker run -e AZP_URL="https://dev.azure.com/muppedaanvesh" -e AZP_TOKEN="afbwykpaok3gu2ktophbxqf4wx7wqop5g55lahnfd2mltebiflsa" -e AZP_POOL="EKS-Agent-Pool" -e AZP_AGENT_NAME="Docker Agent - Linux" --name "azp-agent-linux" azp-agent:dind 
 ```

### dind on kubernetes  
```bash
kubectl create secret generic azdevops \
  --from-literal=AZP_URL=https://dev.azure.com/muppedaanvesh \
  --from-literal=AZP_TOKEN=afbwykpaok3gu2ktophbxqf4wx7wqop5g55lahnfd2mltebiflsa \
  --from-literal=AZP_POOL=EKS-Agent-Pool
```

 ```bash
 docker run --runtime=sysbox-runc -it --rm -P --name=syscont nestybox/ubuntu-bionic-systemd-docker
 ```

```bash
docker run -e AZP_URL="<Azure DevOps instance>" -e AZP_TOKEN="<Personal Access Token>" -e AZP_POOL="<Agent Pool Name>" -e AZP_AGENT_NAME="Docker Agent - Windows" --name "azp-agent-windows" azp-agent:windows
```

docker run -e AZP_URL="<Azure DevOps instance>" -e AZP_TOKEN="<Personal Access Token>" -e AZP_POOL="<Agent Pool Name>" -e AZP_AGENT_NAME="Docker Agent - Windows" --name "azp-agent-windows" azp-agent:windows

docker run -e AZP_URL="https://dev.azure.com/muppedaanvesh" -e AZP_TOKEN="afbwykpaok3gu2ktophbxqf4wx7wqop5g55lahnfd2mltebiflsa" -e AZP_POOL="EKS-Agent-Pool" -e AZP_AGENT_NAME="Docker Agent - Linux" --name "azp-agent-linux" anvesh35/azure-docker-agent:linux 


anvesh35/azure-docker-agent::linux



docker run -e AZP_URL="https://dev.azure.com/muppedaanvesh" -e AZP_TOKEN="afbwykpaok3gu2ktophbxqf4wx7wqop5g55lahnfd2mltebiflsa" -e AZP_POOL="EKS-Agent-Pool" -e AZP_AGENT_NAME="DockerAgent-Linux" --name "azp-agent-linux" anvesh35/azure-docker-agent:linux


docker pull nestybox/ubuntu-bionic-systemd-docker

