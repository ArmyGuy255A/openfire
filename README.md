# Getting Started
This docker image is designed to demonstrate the ability to containerize applications within a larger infrastructure. We don't need to deploy out fully-fledged servers to support a single microservice in our environments. 

## How to Build the default Image without any modifications
Simply build this image by running:
```bash
git pull "https://github.com/ArmyGuy255A/openfire"
cd openfire
docker build .
```

### Advanced Build Options
A build.ps1 script is included in the repository to allow for more advanced build options, including automated builds and pushing to a registry. The script is designed to be integrated with Git and a Container Registry. You can call the PowerShell script with the following parameters:
```powershell
.\build.ps1 -RemoteRegistry "armyguy255a/openfire" -PushToRegistry $true
```

## Running the Docker Image
To run the docker image, you can use the following command:
```powershell
.\run.ps1
```

Alternatively, you can run the command to start the container manually:
```bash
docker run `
 -d `
 -p 5222:5222 `
 -p 5223:5223 `
 -p 5262:5262 `
 -p 5269:5269 `
 -p 5270:5270 `
 -p 5275:5275 `
 -p 5276:5276 `
 -p 7070:7070 `
 -p 7443:7443 `
 -p 7777:7777 `
 -p 9090:9090 `
 -p 9001:9001 `
 --name openfire `
 -v 'openfire-data:/usr/share/openfire' `
 armyguy255a/openfire:4.9.0
```
