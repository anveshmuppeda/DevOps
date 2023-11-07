FROM ubuntu:18.04
LABEL maintainer="anvesh35"
RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*
# Copy the script to the container
COPY ./script.sh /
ENV a=10
ENV b=20
RUN chmod +x /script.sh
# Set the entrypoint to the script with CMD arguments
ENTRYPOINT ["/script.sh"]