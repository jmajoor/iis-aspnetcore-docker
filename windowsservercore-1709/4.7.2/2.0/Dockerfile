# escape=`
FROM microsoft/aspnet:4.7.2-windowsservercore-1709

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# tags: 4.7.1-2.0.7-windowsservercore-ltsc2016
# Install .NET Core
ENV DOTNET_VERSION 2.0.9
# ENV DOTNET_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Runtime/$DOTNET_VERSION/DotNetCore.$DOTNET_VERSION-WindowsHosting.exe
# It should be stored here, where all the other dotnet core version are stored.
# However the gives a BlobNotFound, even though it is listed in the checksums for this URL.
# The hosting bundle can also be downloaded with the url shown below.
# This url is obtained from: https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.0.7-download.md
# Checksum obtained from: https://dotnetcli.blob.core.windows.net/dotnet/checksums/2.0.7-runtime-sha.txt
ENV DOTNET_DOWNLOAD_URL https://download.microsoft.com/download/3/a/3/3a3bda26-560d-4d8e-922e-6f6bc4553a84/DotNetCore.2.0.9-WindowsHosting.exe
ENV DOTNET_DOWNLOAD_SHA bea34b32752c1a9ab589b43df68fbb90fc63c34564603619a4ac516d8732f37d4867f07602c4ce0c276ebe133a64bbcabe4586cb89459bb2b8929ef848e3b450

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