FROM openjdk:23-jdk-slim

# Install required packages
RUN apt update && \
    apt install -y --no-install-recommends wget openssl vim nano && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Set the Openfire version
ARG OPENFIRE_VERSION
ENV OF_VERSION=${OPENFIRE_VERSION}

# Set the working directory
WORKDIR /usr/share

# Download Openfire
RUN wget -O openfire.tar.gz "https://igniterealtime.org/downloadServlet?filename=openfire/openfire_${OF_VERSION}.tar.gz"

# Extract, set permissions, and clean up
RUN tar -xf openfire.tar.gz && \
    chmod 755 ./openfire && \
    rm openfire.tar.gz

# Add plugins
ADD Plugins /usr/share/openfire/plugins

# Copy the entrypoint script and make it executable
COPY entrypoint.sh /usr/share/openfire/entrypoint.sh
RUN chmod +x /usr/share/openfire/entrypoint.sh

# Allow the openfire user to run the entrypoint script
RUN chown openfire:openfire /usr/share/openfire/entrypoint.sh

# Create an openfire user
RUN useradd -r -s /bin/false openfire

# Set permissions
RUN chown -R openfire:openfire /usr/share/openfire

# Switch to the openfire user
USER openfire



# Expose ports
EXPOSE 9090 9091 5222 5223 5269 5270 5262 7070 7443 80 443 5275 5276 7777

# Set entrypoint
ENTRYPOINT ["/usr/share/openfire/entrypoint.sh"]