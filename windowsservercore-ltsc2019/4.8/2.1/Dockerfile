# escape=`
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Install .NET Core
ENV DOTNET_VERSION 2.1.17
ENV DOTNET_DOWNLOAD_URL https://download.visualstudio.microsoft.com/download/pr/a431ea89-07d9-4533-9d72-fd246bd2efc7/5bbc08f02800c08b69bce56d03723f18/dotnet-hosting-$DOTNET_VERSION-win.exe

ENV DOTNET_DOWNLOAD_SHA f9b205f24f9264b1b65e7d32706320a07be87ac4fc8c4d41ea861dea5c95dbd676b3bfb245dd904c6650ebee907884914e871644692dee761e830d80595ee9ec

RUN Invoke-WebRequest $Env:DOTNET_DOWNLOAD_URL -OutFile WindowsHosting.exe; `
    if ((Get-FileHash WindowsHosting.exe -Algorithm sha512).Hash -ne $Env:DOTNET_DOWNLOAD_SHA) { `
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
        exit 1; `
    }; `
    `
    Start-Process "./WindowsHosting.exe" '/install /quiet /norestart' -Wait; `
    Remove-Item -Force -Recurse 'C:\ProgramData\Package Cache\*'; `
    Remove-Item -Force -Recurse C:\Windows\Installer\*; `
    Remove-Item -Force WindowsHosting.exe

RUN setx /M PATH $($Env:PATH + ';' + $Env:ProgramFiles + '\dotnet')

# Enable detection of running in a container
ENV DOTNET_RUNNING_IN_CONTAINER=true