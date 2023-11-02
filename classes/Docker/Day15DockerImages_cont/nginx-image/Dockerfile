FROM ubuntu:18.04  

#maintainer
LABEL maintainer="anvesh.m35" 

#install nginx
RUN  apt-get -y update && apt-get -y install nginx

#copying files
COPY default /etc/nginx/sites-available/default
COPY index.html /usr/share/nginx/html/index.html

#exposing the port
EXPOSE 80

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]