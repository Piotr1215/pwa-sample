IMAGE?=piotrzan/blazorindocker
.PHONY: run

default: run

run:
	docker run --rm -it -p 5010:80 -e ASPNETCORE_ENVIRONMENT=Development --name blazor-pwa $(IMAGE)