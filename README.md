# BLAZOR PWA Sample

Sample PWA app written in [BLAZOR](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor) wasm with description what to do to test the PWA features.

## Deployment

- JAM stack style deployment to Neflity: https://pwa-blazor.netlify.app/
- Docker image on Docker HUB: https://hub.docker.com/repository/docker/piotrzan/blazorindocker

![.NET Core](https://github.com/Piotr1215/pwa-sample/workflows/.NET%20Core/badge.svg?branch=master)

## How to run container

### Create a simple Makefile

``` makefile
IMAGE?=piotrzan/blazorindocker
.PHONY: run

default: run

run:
	docker run --rm -it -p 5010:80 -e ASPNETCORE_ENVIRONMENT=Development --name blazor-pwa $(IMAGE)
```
of run docker command directly `docker run --rm -it -p 5010:80 -e ASPNETCORE_ENVIRONMENT=Development --name blazor-pwa piotrzan/blazorindocker`

Access the URL on [localhost:5010](http://localhost:5010/)