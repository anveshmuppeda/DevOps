# Docker Commands  
1. [ Image ](#image)
2. [ Container ](#container)
3. [ Running Container ](#run)
4. [ Container Exec ](#exec)
5. [ Nginx Container ](#nginx)

---  
<a name="image"></a>
## Image  

### Pull – download an image  
```
docker run nginx:<version>   
docker pull nginx:<version>   
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
docker run nginx:<version>
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

<a name="run"></a>
## Run Container
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

### Naming container
```
docker run -d --name <container-name> <image-name>  
```

### Running container on specific port  
```
docker run -d -p <host_port>:<container_port> --name <container-name> <image-name>  
```

---  

<a name="exec"></a>
## Container Login  

### Exec - execute command on running container  
```
docker exec <container-id>  cat /etc/hosts  
```  

### Login to running container  
```
docker exec -it <container-id> bash  
```  

### Login to container  by running  
```
docker run -it <image> bash  
```

---  

<a name="nginx"></a>
## Nginx  container

### Source conf  
Paths::  
source configuration  
```
/etc/nginx/conf.d  
```
webpage path  
```
/usr/share/nginx/html  
```


#nginx conf  
```
/etc/nginx/nginx.conf  
```

---
