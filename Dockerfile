FROM fedora:26

MAINTAINER Krishna Kumar <kks32@cam.ac.uk>

# Libraries
RUN dnf update -y && dnf install -y bzip2 git curl npm nodejs wget golang mongodb mongodb-server
RUN  npm install -g yarn && yarn global add n && n stable

WORKDIR /root/

# Expose port
EXPOSE 4000 8080

# Start Mongodb
RUN mkdir /db

# Get Go dep
RUN go get -u github.com/golang/dep/cmd/dep

# Get API
RUN cd /root/go/src/ && \
    git clone https://github.com/kings-cam/ticketing-api.git tickets && \
    cd /root/go/src/tickets && \
    /root/go/bin/dep ensure && \
    go build cmd/api.go

# Get UI
RUN cd /root && \
    git clone https://github.com/kings-cam/ticketing-ui.git ui && \
    cd /root/ui && yarn install