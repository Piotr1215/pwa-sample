# BLAZOR PWA Sample

Sample PWA app written in [BLAZOR](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor) wasm with description what to do to test the [PWA](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps) features.

## Deployment Options

### [Neflify](https://www.netlify.com/) JAM Stack

Deployed with [Github actions](https://docs.github.com/en/free-pro-team@latest/actions)

``` yaml
name: .NET Core

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master # Checkout the master branch
    - name: Setup .NET Core
      uses: actions/setup-dotnet@v1 # Setup .NET Core
      with:
        dotnet-version: 3.1.300 # Change to your version of .NET Core
    - name: Build with dotnet
      run: dotnet build --configuration Release
    - name: Publish Blazor webassembly using dotnet
      #create Blazor WebAssembly dist output folder in the project directory
      run: dotnet publish -c Release --no-build -o publishoutput # Don't build again, just publish
    - name: Publish generated Blazor webassembly to Netlify
      uses: netlify/actions/cli@master #uses Netlify Cli actions
      env: # These are the environment variables added in GitHub Secrets for this repo
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
      with:
          args: deploy --dir=publishoutput/wwwroot --prod #push this folder to Netlify
          secrets: '["NETLIFY_AUTH_TOKEN", "NETLIFY_SITE_ID"]'
```

This deployment is live under: https://pwa-blazor.netlify.app/

![.NET Core](https://github.com/Piotr1215/pwa-sample/workflows/.NET%20Core/badge.svg?branch=master)

### Docker HUB

This deployment is live under: https://hub.docker.com/repository/docker/piotrzan/blazorindocker

![Docker Build](https://img.shields.io/docker/cloud/build/piotrzan/blazorindocker.svg)

Deployment is done using Docker HUB build feature based on below simplistic Dockerfile

``` Dockerfile
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app
COPY . ./
RUN pwa-
FROM nginx:alpine
WORKDIR /var/www/web
COPY --from=build-env /app/output/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
```

#### How to run container

Create a simple Makefile to simplify docker command.

``` makefile
IMAGE?=piotrzan/blazorindocker
.PHONY: run

default: run

run:
	docker run --rm -it -p 5010:80 -e ASPNETCORE_ENVIRONMENT=Development --name blazor-pwa $(IMAGE)
```

Alternatively you can run docker command directly

`docker run --rm -it -p 5010:80 -e ASPNETCORE_ENVIRONMENT=Development --name blazor-pwa piotrzan/blazorindocker`

Access the URL on [localhost:5010](http://localhost:5010/)

### Azure

You can also deploy to Azure using Azure Pipelines as Code:

``` yaml
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
  branches:
    include:
      - master

  paths:
    exclude:
    # Exclude README.md from triggering content deployments
    - README.md

pool:
  vmImage: "windows-latest"

steps:
- task: DotNetCoreCLI@2
  displayName: 'Build Blazor Project'
  inputs:
    command: build
    projects: '**/*.csproj'

- task: DotNetCoreCLI@2
  displayName: 'Publish'
  inputs:
    command: publish
    arguments: '--configuration Release --output $(Build.ArtifactStagingDirectory)'
    zipAfterPublish: false

- task: PublishBuildArtifacts@1
  displayName: "Upload Artifacts"
  inputs:
    pathtoPublish: '$(Build.ArtifactStagingDirectory)'
    artifactName: 'drop'

- task: AzureFileCopy@3
  displayName: "Copy the bundle to pwa Storage Account"
  inputs:
      SourcePath: "$(Build.ArtifactStagingDirectory)/s/wwwroot"
      azureSubscription: "your-service-connection"
      Destination: "AzureBlob"
      storage: "yourblobstorage"
      ContainerName: "$web"
```