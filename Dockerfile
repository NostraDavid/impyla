# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Disable interactive install prompts
ARG DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt-get update -y && \
    apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    g++ \
    gcc \
    git \
    libtool \
    lsb-release \
    sudo

# Clone the Impala repository for tag 4.3.0
RUN git clone --branch 4.3.0 https://github.com/apache/impala.git ~/Impala

# Set the IMPALA_HOME environment variable
ENV IMPALA_HOME /root/Impala

# Run the bootstrap scripts
WORKDIR $IMPALA_HOME
RUN ./bin/bootstrap_development.sh

# Expose Impala ports
# 21000: Impala Shell for user interactions
# 21050: Impala JDBC for Java-based applications
# 25000: Impala Web UI for monitoring and managing queries
# 25010: StateStore Web UI for cluster state management
# 25020: Catalog Web UI for metadata and schema management
EXPOSE 21000 21050 25000 25010 25020

# Format the test cluster and start Impala and dependent services
CMD ["./buildall.sh", "-noclean", "-notests", "-format", "-start_minicluster", "-start_impala_cluster"]
