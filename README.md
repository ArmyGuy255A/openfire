# Getting Started
This docker image is designed to demonstrate the ability to containerize applications within a larger infrastructure. We don't need to deploy out fully-fledged servers to support a single microservice in our environments. 

## How to Build this Image
Simply build this image by running:
```bash
git pull "https://github.com/ArmyGuy255A/openfirelivedemo"
cd openfirelivedemo
docker build .
```

## How to use the pre-build Docker Image
You can deploy the docker image using any platform you wish. Just ensure that you use the following image:tag from Docker hub
```
armyguy255a/openfire:latest
```
