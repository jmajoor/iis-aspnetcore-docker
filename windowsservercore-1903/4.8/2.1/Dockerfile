# escape=`
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-1903

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Install .NET Core
ENV DOTNET_VERSION 2.1.14
ENV DOTNET_DOWNLOAD_URL  https://download.visualstudio.microsoft.com/download/pr/d08902cf-87b0-4bfe-b25c-627ff77b8802/8293c56094f50ba8c4ed703aff95c325/dotnet-hosting-$DOTNET_VERSION-win.exe

ENV DOTNET_DOWNLOAD_SHA 95bc0148f7569aff80515f0877cc0509343a9b754d07c8efb0925f1f21ee2ce530988afc2b2b5214b5cba346dbfb302a98d5ada79110f003707314da70f08f2e

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