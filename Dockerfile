FROM mcr.microsoft.com/dotnet/core/sdk:3.0-buster AS build
WORKDIR /src
COPY PWA-SampleApp.csproj .
RUN dotnet restore "PWA-SampleApp.csproj"
COPY . .
RUN dotnet build "PWA-SampleApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PWA-SampleApp.csproj" -c Release -o /app/publish

FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /app/publish/PWA-SampleApp/dist .
COPY nginx.conf /etc/nginx/nginx.conf