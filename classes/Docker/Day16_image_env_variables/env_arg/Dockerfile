FROM ubuntu:latest
LABEL maintainer="anvesh35"
RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*
# Copy the script to the container
COPY ./script.sh /
ARG arg1=30
ARG arg2=40
ENV env1=10
ENV env2=20
RUN chmod +x /script.sh
# Set the entrypoint to the script with CMD arguments
ENTRYPOINT ["/script.sh"]