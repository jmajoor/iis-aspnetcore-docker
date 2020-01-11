# escape=`
FROM microsoft/aspnet:4.7.2-windowsservercore-ltsc2016

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Install .NET Core
ENV DOTNET_VERSION 2.2.8
ENV DOTNET_DOWNLOAD_URL  https://download.visualstudio.microsoft.com/download/pr/ba001109-03c6-45ef-832c-c4dbfdb36e00/e3413f9e47e13f1e4b1b9cf2998bc613/dotnet-hosting-$DOTNET_VERSION-win.exe

ENV DOTNET_DOWNLOAD_SHA 1b3177fc65ec343f641b8ffdc2a0e925e322e90ed44dcb5c6d3982a370dd7b56f7fcc362dad3a4b7e2db4f0fe6878b7e7448fc7f41dfe01302c7484434691f6b
RUN Invoke-WebRequest $Env:DOTNET_DOWNLOAD_URL -OutFile WindowsHosting.exe; `
    if ((Get-FileHash WindowsHosting.exe -Algorithm sha512).Hash -ne $Env:DOTNET_DOWNLOAD_SHA) { `
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
        exit 1; `
    }; `
    `
    Start-Process "./WindowsHosting.exe" '/install /quiet /norestart' -Wait; `
    Remove-Item -Force WindowsHosting.exe

RUN setx /M PATH $($Env:PATH + ';' + $Env:ProgramFiles + '\dotnet')

# Enable detection of running in a container
ENV DOTNET_RUNNING_IN_CONTAINER=true