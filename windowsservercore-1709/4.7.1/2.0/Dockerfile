# escape=`
FROM microsoft/aspnet:4.7.1-windowsservercore-1709

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# tags: 4.7.1-2.0.7-windowsservercore-ltsc2016
# Install .NET Core
ENV DOTNET_VERSION 2.0.7
# ENV DOTNET_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Runtime/$DOTNET_VERSION/DotNetCore.$DOTNET_VERSION-WindowsHosting.exe
# It should be stored here, where all the other dotnet core version are stored.
# However the gives a BlobNotFound, even though it is listed in the checksums for this URL.
# The hosting bundle can also be downloaded with the url shown below.
# This url is obtained from: https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.0.7-download.md
# Checksum obtained from: https://dotnetcli.blob.core.windows.net/dotnet/checksums/2.0.7-runtime-sha.txt
ENV DOTNET_DOWNLOAD_URL https://download.microsoft.com/download/A/9/F/A9F8872C-48B2-41DB-8AAD-D5908D988592/DotNetCore.2.0.7-WindowsHosting.exe
ENV DOTNET_DOWNLOAD_SHA 83f7c2607a0ad97800d2302cd6b9462b623cc66960974bdb1c404eff89eedb0d1f876a957a671b885f7ac81584bc9fd97a34231c342fa19affa38fa603c4974e

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