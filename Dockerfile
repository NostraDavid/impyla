FROM ubuntu:20.04
# source: https://medium.com/@deepak7093/apache-impala-installation-4d6ed1862dfa
# Note that if you update Debian, you'll also need to figure out which openjdk
# you need for your new version

#  Environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    IMPALA_HOME=/etc/Impala

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    autoconf \
    automake \
    bison \
    build-essential \
    cmake \
    git \
    libkrb5-dev \
    libncurses-dev \
    libpython3-dev \
    libsasl2-dev \
    libsasl2-dev \
    libssl-dev \
    libtool \
    libz-dev \
    maven \
    ntp \
    openjdk-17-jdk \
    openssh-server \
    postgresql \
    wget

# Setup PostgreSQL and SSH
RUN service postgresql start && \
    service ssh start && \
    ssh-keygen -t dsa -f ~/.ssh/id_dsa -N "" && \
    cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys

# Clone and build the native toolchain and Impala
# RUN git clone --depth=1 https://github.com/cloudera/native-toolchain.git && \
#     cd /native-toolchain && \
#     ./buildall.sh
RUN cd /etc && \
    git clone --depth=1 https://github.com/apache/impala.git Impala && \
    cd /etc/Impala && \
    ./buildall.sh -noclean -notests -skiptests

# Expose Impala ports
EXPOSE 21000 21050 22000 25000 25010 25020

# Add start script
WORKDIR /app
COPY start-impala.sh /start-impala.sh
RUN chmod +x /start-impala.sh

# Start Impala
CMD ["./start-impala.sh"]
