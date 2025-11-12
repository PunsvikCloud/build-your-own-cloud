FROM mcr.microsoft.com/dotnet/sdk:10.0-alpine AS build
WORKDIR /src
COPY build-your-own-cloud.sln .
COPY build-your-own-cloud.csproj .
RUN dotnet restore build-your-own-cloud.sln
COPY . .
RUN dotnet build -c Release build-your-own-cloud.sln
RUN dotnet test -c Release build-your-own-cloud.sln
RUN dotnet publish -c Release -o /dist build-your-own-cloud.sln

FROM mcr.microsoft.com/dotnet/aspnet:10.0-alpine
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production
EXPOSE 8080
WORKDIR /app
COPY --from=build /dist .
CMD ["dotnet", "build-your-own-cloud.dll"]