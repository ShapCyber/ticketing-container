FROM fedora:latest

MAINTAINER Krishna Kumar <kks32@cam.ac.uk>

# Libraries
RUN dnf update -y && dnf install -y git curl npm nodejs wget golang mongodb mongodb-server
RUN  npm install -g yarn && yarn global add n && n stable

WORKDIR /root/

# Expose port
EXPOSE 4000 8080

# Start Mongodb
RUN mkdir /root/db && mongod --dbpath /root/db &

# Get Go dep
RUN go get -u github.com/golang/dep/cmd/dep

# Get API
RUN git clone https://github.com/kings-cam/ticketing-ui.git /root/go/src/tickets && cd /root/go/src/tickets
RUN /root/go/bin/dep init && /root/go/bin/dep ensure && go build cmd/api.go
RUN ./api &

# Get UI
RUN git clone https://github.com/kings-cam/ticketing-ui.git /root/ui && cd /root/ui
RUN yarn install && npm run dev &


RUN /bin/bash