# Docker Commands  
---  
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
 
## Container  

### Run start a container  
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
```
docker run -d <container-id>
docker run <container-id>  
```  

---  

## Container Login  

### Exec - execute command  
```
docker exec <container-id>  cat /etc/hosts  
```  




