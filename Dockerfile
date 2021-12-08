FROM openjdk:11

RUN ["/bin/sh", "-c", "apt-get install wget"]

ARG OPENFIRE_VERSION=4_6_4
ENV OF_VERSION=${OPENFIRE_VERSION}

WORKDIR /usr/share

RUN wget https://igniterealtime.org/downloadServlet?filename=openfire/openfire_${OF_VERSION}.tar.gz

RUN mv download* openfire.tar.gz
RUN tar -xf openfire.tar.gz
RUN chmod 755 ./openfire
RUN rm openfire.tar.gz

EXPOSE 9090

ENTRYPOINT [ "bash", "/usr/share/openfire/bin/openfire", "run" ]