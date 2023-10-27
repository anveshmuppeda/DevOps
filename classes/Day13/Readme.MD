# Docker Commands  
1. [ Image ](#image)
2. [ Container ](#container)
3. [ Container Exec ](#exec)
---  
<a name="image"></a>
## Image  

### Pull – download an image  
```
docker run nginx  
docker pull nginx  
```

### images - List images  
```
docker images
```  

### rmi - Remove Images  
```
docker rmi <imagename:tag>
```  

---  
<a name="container"></a>
## Container  

### Run - Start a container  
```
docker run nginx
```  

### ps – list containers  
```
#to list running containers  
docker ps  
#to list all containers including non running  
docker ps -a
```  

### STOP – stop a container docker  
```
docker stop <container-id> 
```  

### START – start a container docker  
```
docker start <container-id> 
```  

### Inspect container  
```
docker inspect <container-id>
```

### Rm – Remove a container  
```
docker rm <container-id>
```

### Append a command  
```
docker run ubuntu sleep 5
```  
### Run - Attache & Detach  

docker run will run the command in attach or foreground mode
```
docker run <image> 
```

docker run -d will run the container in dettach or background mode
```
docker run -d <image>
```

---  

<a name="exec"></a>
## Container Login  

### Exec - execute command  
```
docker exec <container-id>  cat /etc/hosts  
```  




