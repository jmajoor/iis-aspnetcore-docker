# escape=`
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-1803

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# Install .NET Core
ENV DOTNET_VERSION 2.1.12
ENV DOTNET_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/aspnetcore/Runtime/$DOTNET_VERSION/dotnet-hosting-$DOTNET_VERSION-win.exe

ENV DOTNET_DOWNLOAD_SHA B80AD724CC0EAB7C63E1D0FBF62BDAA573BA2626F331AE92A7669E77308589ABF06A86E268640DCCCE39AB03446133075CD69188A5E3D701B4E51B187DEA22AC

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