# escape=`
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-1803

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Install .NET Core
ENV DOTNET_VERSION 2.1.22
ENV DOTNET_DOWNLOAD_URL https://download.visualstudio.microsoft.com/download/pr/2fe0ef0c-a6b6-4cda-b6b8-874068bb131f/709d1c7817fa19524089dda74933ddce/dotnet-hosting-2.1.22-win.exe

ENV DOTNET_DOWNLOAD_SHA 7ef01c139e60ddb2658e71bba1e4d07f340be512300d2ed87ffd63acba9415fa52eb51c2ca6fcb20f4e67f1b746a222ee35ba60a77c5c44ca3966d09b22b2b80

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