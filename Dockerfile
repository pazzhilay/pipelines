FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
COPY *.sln .
COPY server/PipelinesWebApi/*.csproj ./server/PipelinesWebApi/
COPY server/PipelinesWebApi.Tests/*.csproj ./server/PipelinesWebApi.Tests/
RUN dotnet restore

COPY server/PipelinesWebApi/. ./server/PipelinesWebApi/
COPY server/PipelinesWebApi.Tests/. ./server/PipelinesWebApi.Tests/

FROM build AS publish
RUN dotnet publish ./server/PipelinesWebApi/PipelinesWebApi.csproj -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
CMD ASPNETCORE_URLS=http://*:$PORT dotnet PipelinesWebApi.dll