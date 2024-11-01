#!/bin/bash

# Download Plugins
.\Download-Files.ps1 -FileName Plugins.txt

# Download Windows Files
.\Download-Files.ps1 -FileName Windows.txt

# Loading the docker image
#docker image load -i nginx_1.25.3.tar.gz

# Read the current build version from buildver.txt
$build_version=Get-Content buildver.txt

# Increment the build version
$new_build_version=[int]$build_version + 1

# Update the buildver.txt file with the new build version
$new_build_version > buildver.txt

# Build and tag the Docker image
docker build `
-t armyguy255a/openfire:latest `
-t armyguy255a/openfire:4.9.0 `
-t armyguy255a/openfire:v$new_build_version .