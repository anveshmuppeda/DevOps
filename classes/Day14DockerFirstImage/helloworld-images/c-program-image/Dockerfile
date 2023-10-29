FROM gcc:latest

#Labels as key value pair
LABEL Maintainer="anvesh"

COPY helloworld.c /tmp

WORKDIR /tmp

RUN gcc -o testing helloworld.c

CMD [ "./testing" ]