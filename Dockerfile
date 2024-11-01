FROM openjdk:24-jdk-slim

RUN apt-get update && \
    apt-get install -y wget openssl vim nano && \
    apt-get clean

ARG OPENFIRE_VERSION=4_9_0
ENV OF_VERSION=${OPENFIRE_VERSION}

WORKDIR /usr/share

RUN wget https://igniterealtime.org/downloadServlet?filename=openfire/openfire_${OF_VERSION}.tar.gz

RUN mv download* openfire.tar.gz
RUN tar -xf openfire.tar.gz
RUN chmod 755 ./openfire
RUN rm openfire.tar.gz

# Add Plugins
ADD Plugins /usr/share/openfire/plugins

#Admin Console
EXPOSE 9090
EXPOSE 9091

#Client to Server
EXPOSE 5222
EXPOSE 5223

#Server to Server
EXPOSE 5269
EXPOSE 5270

#Connection Manager
EXPOSE 5262

#HTTP Binding
EXPOSE 7070
EXPOSE 7443
EXPOSE 80
EXPOSE 443

#External Components
EXPOSE 5275
EXPOSE 5276 

#File Transfer
EXPOSE 7777

#TODO


# CMD [ "chown -R daemon:daemon ." ]

ENTRYPOINT [ "bash", "/usr/share/openfire/bin/openfire", "run" ]