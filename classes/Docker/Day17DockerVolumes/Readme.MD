# Docker Commands  
1. [ Image ](#image)  
2. [ System ](#system)
2. [ Container ](#container)
3. [ Running Container ](#run)
4. [ Container Exec ](#exec)
5. [ Image Build & Tag ](#build)
6. [ Nginx Container ](#nginx)  
7. [ Args & Environment Variables ](#args)
8. [ Volumes ](#volumes)
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

### to remove all unused images  
```
docker image prune -a
```

### to delete all images  
```
docker rmi $(docker images -a)  
```

---
<a name="system"></a>  
## System  
Docker provides a single command that will clean up any resources — images, containers, volumes, and networks — that are dangling (not associated with a container):  
```
docker system prune
```

To additionally remove any stopped containers and all unused images (not just dangling images), add the -a flag to the command:
```
docker system prune -a
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

### To delete containers which are in exited state  
```
docker rm $(docker ps -a -f status=exited -q)
```  

### To delete containers which are in created state  
```
docker rm $(docker ps -a -f status=created -q)
```

---
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

### to pass environment variables to container  
```
docker run -p 3<host_port>:<container_port> --name <container-name> <image-name> -e <variable_name>=<value>
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

<a name="build"></a>
## Image Build & Tag  

### Use below command to build image  
```
docker build --tag "<image-name>:<image-tag>" --file "/path/to/Dockerfile" .
```

### to tag the current image with different tag  
```
docker tag <image-name>:<current-tag> <image-name>:<new=tag>
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

<a name="args"></a>  

## Args & Environement Variables   

> **_NOTE:_** The ARG arguments are only available when building the image, while ENV parameters are available to the application containers during build and when the container is running. 

### passing arguments  
```
docker build -t [image-name] --build-arg [arg-variable]=[value] .
``` 

### passing environment variables  
```
docker run --name [container-name] -e "[variable-name]=[new-value]" [image-name]
```  

### passing environment variables file  
```
docker run --name [container-name] --env-file [path-to-env-file] [image-name]
``` 

---

<a name="volumes"></a>  

## Volumes   
There are two types of volumes:  
1. Volume Mount  
    Which used to mount from the default location i.e. /var/lib/docker/volumes  
2. Bind Mount  
    Which is used to mount from the different locations other than default one  

### volume mounting   
```
docker run -v data_volume:/var/lib/mysql mysql  
``` 

### bind mounting  
```
docker run -v /data/mysql:/var/lib/mysql mysql  
```  

### new way of bind mounting  
```
docker run --mount type=bind,source=/data/mysql,target=/var/lib/mysql mysql
```

---  
