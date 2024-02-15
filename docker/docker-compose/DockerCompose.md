# Docker Compose  
Docker Compose is a tool that helps you define and share multi-container applications. With Compose, you can create a YAML file to define the services and with a single command, you can spin everything up or tear it all down.  

## docker compose commands  
```
docker-compose start  
docker-compose stop  
docker-compose pause  
docker-compose unpause  
docker-compose ps  
docker-compose up  
docker-compose down  
```

## Custom docker compose file name  
Use -f option to specify the file name.  
Example:
```
docker-compose -f docker-compose.test.yml up
```

## to run it in dettach mode  
```
docker-compose up -d
```

## Environment variables  

### environment vars  
```
  environment:
    RACK_ENV: development
  environment:
    - RACK_ENV=development
```

### environment vars from file  
```
  env_file: .env
  env_file: [.env, .development.env]
```

## Ports  
```
  ports:
    - "8000:80"  # host:container
```

## build from Dockerfile  
```
web:
  # build from Dockerfile
  build: .
  args:     # Add build arguments
    APP_HOME: app
```

## build from custom Dockerfile 
```
web:
  # build from custom Dockerfile
  build:
    context: ./dir
    dockerfile: Dockerfile.dev
```  

## Dependencies  

### makes the `db` service available as the hostname `database`  
 (implies depends_on)  
```
  links:
    - db:database
    - redis
```

 ### make sure `db` is alive before starting  
 ```
   depends_on:
    - db
 ```

