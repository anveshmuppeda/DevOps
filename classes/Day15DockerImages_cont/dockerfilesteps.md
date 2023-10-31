# Docker File Inastructions  

***
| Instruction | Argument |  
|:-----|:------:|  
|FROM       |    Start from a base OS or another Image  |
|LABEL      |    Adding labels to the container    |
|RUN        |    Install All dependecies      |
|WORKDIR    |    Changing the source directory    |
|COPY       |    Sopy Source Code    |
|CMD        |    Commands to execute    |
*** 

---
> [!NOTE] 
>  **RUN**. Mainly used to build images and install applications and packages. Builds a new layer over an existing image by committing the results.  
>
>  **CMD**. Sets default parameters that can be overridden from the Docker Command Line Interface (CLI) when a container is running. 
>
>  **_NOTE:_**  **ENTRYPOINT**. Default parameters that cannot be overridden when Docker Containers run with CLI parameters.   

---

Reference:  
https://docs.docker.com/engine/reference/builder/  