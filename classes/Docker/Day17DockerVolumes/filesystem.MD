# Docker File System  

-> /var/lib/docker  
   -> containers  
   -> image  
   -> volumes  

## mysql  

to run a container:  
```
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -v data_volume:/var/lib/mysql -d mysql
```
to connect to sql  
```
mysql -u root -p
```  
