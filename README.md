Here's an improved version of your README that adds more detailed usage instructions, explains how to extend this image as a base for custom containers, and enhances formatting.

---

# Openfire Docker Image

This Docker image provides a containerized version of [Openfire](https://www.igniterealtime.org/projects/openfire/), a real-time collaboration (RTC) server. It demonstrates how to containerize applications, making it easy to deploy a microservice without requiring a fully-fledged server environment.

## Getting Started

This image can be used out-of-the-box or as a base for further customization. By containerizing Openfire, you can quickly spin up instances as part of a larger infrastructure.

### Prerequisites
- Docker installed on your local machine.
- Optional: Docker Compose or a container orchestration platform like Kubernetes.

---

## Building the Image

### Default Build
To build the default image without modifications:

```bash
git clone https://github.com/ArmyGuy255A/openfire
cd openfire
docker build -t armyguy255a/openfire .
```

### Advanced Build Options
An advanced `build.ps1` PowerShell script is included for automating builds and pushing images to a registry. This script integrates with Git and supports parameterized builds.

To use `build.ps1`:

```powershell
.\build.ps1 -RemoteRegistry "armyguy255a/openfire" -PushToRegistry $true
```

This command builds the Docker image and pushes it to the specified remote registry.

---

## Running the Docker Container

### Quick Start
To start the container with default settings:

```bash
docker run -d \
 -p 5222:5222 \
 -p 5223:5223 \
 -p 5262:5262 \
 -p 5269:5269 \
 -p 5270:5270 \
 -p 5275:5275 \
 -p 5276:5276 \
 -p 7070:7070 \
 -p 7443:7443 \
 -p 7777:7777 \
 -p 9090:9090 \
 -p 9001:9001 \
 --name openfire \
 -v openfire-data:/usr/share/openfire \
 armyguy255a/openfire:4.9.0
```

### Running with PowerShell
Alternatively, you can use the provided `run.ps1` script to start the container with predefined settings:

```powershell
.\run.ps1
```

---

## Using as a Base Image for Custom Containers

You can use this Openfire image as a base for building customized containers. This is particularly useful if you want to add plugins, configurations, or other dependencies.

### Extending the Base Image

To use this image as a base, create a `Dockerfile` in your project and specify `armyguy255a/openfire` as the base image. Here’s an example:

```dockerfile
FROM armyguy255a/openfire:4.9.0

# Install additional plugins or dependencies
COPY custom-plugin.jar /usr/share/openfire/plugins/

# Add custom configuration
COPY openfire.xml /usr/share/openfire/conf/openfire.xml

# Define any additional environment variables or volumes as needed
ENV MY_CUSTOM_SETTING=value

# Switch to the openfire user
USER openfire

# Expose ports
EXPOSE 9090 9091 5222 5223 5269 5270 5262 7070 7443 80 443 5275 5276 7777

# Set entrypoint
ENTRYPOINT ["/usr/share/openfire/entrypoint.sh"]

```

Build your custom image:

```bash
docker build -t my-custom-openfire .
```

### Custom Startup Script
If you need to add startup logic or manage additional services, consider creating an `entrypoint.sh` script:

```bash
#!/bin/bash
# Custom startup script for additional configuration

# Start Openfire
exec /usr/share/openfire/entrypoint.sh
```

Make sure to set the script as executable and copy it into the container.

---

## Persistent Data and Configuration

To retain data and configurations across container restarts, the container mounts `openfire-data` at `/usr/share/openfire`. This allows Openfire to store persistent data such as:

- User data and settings
- Installed plugins
- Server configurations

### Example: Using a Named Volume

```bash
docker run -d \
 -v openfire-data:/usr/share/openfire \
 armyguy255a/openfire:4.9.0
```

---

## Health Checks

This container is designed to respond to Docker health checks. To check the health status, add the following in Docker Compose or as part of your deployment configuration:

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:9090"]
  interval: 1m
  timeout: 10s
  retries: 3
```

---

## Contributing

Feel free to fork the repository and contribute by submitting pull requests. Contributions that improve functionality, usability, or stability are welcome.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

This README provides a clear explanation of how to build, run, and extend the Openfire Docker image. You can further customize this template based on specific requirements or use cases.