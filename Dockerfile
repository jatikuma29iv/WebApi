# Stage 1
FROM microsoft/aspnetcore-build AS builder
WORKDIR /source

# caches restore result by copying csproj file separately
COPY src/aspdocker/aspdocker.csproj ./src/aspdocker/
RUN dotnet restore ./src/aspdocker/aspdocker.csproj

COPY src/aspdocker.tests/aspdocker.tests.csproj ./src/aspdocker.tests/
RUN dotnet restore ./src/aspdocker.tests/aspdocker.tests.csproj

# copies the rest of your code
COPY . .

RUN dotnet test ./src/aspdocker.tests/aspdocker.tests.csproj

RUN dotnet publish ./src/aspdocker/aspdocker.csproj --output /app/ --configuration Release

# Stage 2
FROM microsoft/aspnetcore
WORKDIR /app
COPY --from=builder /app .
ENTRYPOINT ["dotnet", "aspdocker.dll"]