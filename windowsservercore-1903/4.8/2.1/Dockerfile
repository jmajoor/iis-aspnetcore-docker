# escape=`
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-1903

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Install .NET Core
ENV DOTNET_VERSION 2.1.19
ENV DOTNET_DOWNLOAD_URL https://download.visualstudio.microsoft.com/download/pr/988d236a-30bf-4e96-8063-665d27c922c9/b793025960eaf182d8f32e723ad9b47a/dotnet-hosting-2.1.19-win.exe

ENV DOTNET_DOWNLOAD_SHA 6bbba7eb796ad88a4c66568e45b9e2eb6873f0d591093d0b3c574a9c9dddc4af03eacbfb6d8495653aa59eb8a03f804972a52759d07b5e456a93ee87e4619d4b

RUN Invoke-WebRequest $Env:DOTNET_DOWNLOAD_URL -OutFile WindowsHosting.exe; `
    if ((Get-FileHash WindowsHosting.exe -Algorithm sha512).Hash -ne $Env:DOTNET_DOWNLOAD_SHA) { `
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
        exit 1; `
    }; `
    `
    dir c:\Windows\Installer; `
    Start-Process "./WindowsHosting.exe" '/install /quiet /norestart' -Wait; `
    Remove-Item -Force -Recurse 'C:\ProgramData\Package Cache\*'; `
    Remove-Item -Force -Recurse C:\Windows\Installer\*; `
    Remove-Item -Force WindowsHosting.exe

RUN setx /M PATH $($Env:PATH + ';' + $Env:ProgramFiles + '\dotnet')

# Enable detection of running in a container
ENV DOTNET_RUNNING_IN_CONTAINER=true