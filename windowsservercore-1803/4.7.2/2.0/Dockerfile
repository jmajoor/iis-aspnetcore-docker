# escape=`
FROM microsoft/aspnet:4.7.2-windowsservercore-1803

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# tags: 4.7.1-2.0.7-windowsservercore-ltsc2016
# Install .NET Core
ENV DOTNET_VERSION 2.0.8
# ENV DOTNET_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Runtime/$DOTNET_VERSION/DotNetCore.$DOTNET_VERSION-WindowsHosting.exe
# It should be stored here, where all the other dotnet core version are stored.
# However the gives a BlobNotFound, even though it is listed in the checksums for this URL.
# The hosting bundle can also be downloaded with the url shown below.
# This url is obtained from: https://github.com/dotnet/core/blob/master/release-notes/download-archives/2.0.7-download.md
# Checksum obtained from: https://dotnetcli.blob.core.windows.net/dotnet/checksums/2.0.7-runtime-sha.txt
ENV DOTNET_DOWNLOAD_URL https://download.microsoft.com/download/E/F/7/EF7302FE-4F84-4529-9E3A-893450F76501/DotNetCore.2.0.8-WindowsHosting.exe
ENV DOTNET_DOWNLOAD_SHA 393346d9668b4cfb4d520bc198fdff43d3137ef35a512b5ca4c8c7607c99e08c0ea173bb478ec5a8b75c7e719425abc224c2dd88ddf46b92bafec4a9e3f0bd6a

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