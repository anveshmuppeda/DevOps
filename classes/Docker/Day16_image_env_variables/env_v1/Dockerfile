FROM ubuntu
ARG environment=prod
RUN echo "The ARG name is environment, and the values is ${environment}" 
RUN echo ${environment} > /tmp/test
ENV testname1=testvalue1
RUN echo "The ARG variable value is $environment, the ENV variable value is $testname1"