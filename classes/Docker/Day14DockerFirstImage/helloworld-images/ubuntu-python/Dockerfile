#Source image
FROM ubuntu:18.04  

#maintainer
LABEL maintainer="anvesh.m35" 

#install pyhton
RUN  apt-get -y update && apt-get -y install python


# Any working directory can be chosen as per choice like '/' or '/home' etc
# i have chosen /usr/app/src
WORKDIR /usr/app/src

#to COPY the remote file at working directory in container
COPY test.py ./
# Now the structure looks like this '/usr/app/src/test.py'

#CMD instruction should be used to run the software
#contained by your image, along with any arguments.

CMD [ "python", "./test.py"]