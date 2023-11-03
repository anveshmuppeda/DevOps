FROM ubuntu
ARG myfirstarg=1000
RUN echo "The ARG name is myfirstarg, and the values is ${myfirstarg}" 
RUN echo ${myfirstarg} > /tmp/test
ENV myfirstenvvar=5000
RUN echo "The ARG variable value is $myfirstarg, the ENV variable value is $myfirstenvvar"