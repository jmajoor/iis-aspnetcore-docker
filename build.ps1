#!/usr/bin/env pwsh
[cmdletbinding()]
param(
    [switch]$UseImageCache,
    [string]$VersionFilter,
    [string]$ArchitectureFilter,
    [string]$OSFilter,
    [switch]$CleanupDocker,
    [switch]$Keep,
    [switch]$Push,
    $RepositoryName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-CleanupDocker($ActiveOS)
{
    if ($CleanupDocker) {
        if ("$ActiveOS" -eq "windows") {
            docker ps -a -q | ForEach-Object { docker rm -f $_ }

            # Windows base images are large, preserve them to avoid the overhead of pulling each time.
            docker images |
                Where-Object {
                    -Not ($_.StartsWith("mcr.microsoft.com/windows/nanoserver ")`
                    -Or $_.StartsWith("mcr.microsoft.com/dotnet/framework/aspnet ")`
                    -Or $_.StartsWith("mcr.microsoft.com/windows/servercore ")`
                    -Or $_.StartsWith("REPOSITORY ")) } |
                ForEach-Object { $_.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)[2] } |
                Select-Object -Unique |
                ForEach-Object { docker rmi -f $_ }
        }
        else {
            docker system prune -a -f
        }
    }
}

$(docker version) | % { Write-Host "$_" }
$activeOS = docker version -f "{{ .Server.Os }}"
Invoke-CleanupDocker $activeOS
$osBuild = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\').BuildLabEx
$buildOSVersion = "1903"
switch -regex ($osbuild) {
	"^14393.*" {
        $buildOSVersion = "ltsc2016"
	}
	"^16299.*" {
        $buildOSVersion = "1709"
	}
	"^17134." {
        $buildOSVersion = "1803"
	}
	"^17763." {
        $buildOSVersion = "ltsc2019"
	}
	"^18362." {
        $buildOSVersion = "1903"
	}
	
	default {
        $buildOSVersion = "1903"
	}
}

if ($UseImageCache) {
    $optionalDockerBuildArgs = ""
}
else {
    $optionalDockerBuildArgs = "--no-cache"
}

$manifest = Get-Content "manifest.json" | ConvertFrom-Json
$manifestRepo = $manifest.Repos[0]
$builtTags = @()

$buildFilter = ".*"
if (-not [string]::IsNullOrEmpty($OsFilter))
{
    $buildFilter = "$OsFilter"
}
if (-not [string]::IsNullOrEmpty($versionFilter))
{
    $buildFilter = "$buildFilter/$versionFilter"
}

if ($RepositoryName -ne $null) {
    $manifestRepo.Name = "$RepositoryName"
}

if ($Push) {
    $manifestRepo.Images |
    ForEach-Object {
        $_.Platforms |
            Where-Object { $_.os -eq "$activeOS" } |
            Where-Object { [string]::IsNullOrEmpty($buildFilter) -or $_.dockerfile -match "$buildFilter" } |
            Where-Object { ( [string]::IsNullOrEmpty($ArchitectureFilter) -and -not [bool]($_.PSobject.Properties.name -match "architecture"))`
                -or ( [bool]($_.PSobject.Properties.name -match "architecture") -and $_.architecture -eq "$ArchitectureFilter" ) } |
            ForEach-Object {
                $tags = [array]($_.Tags | ForEach-Object { $_.PSobject.Properties })
                # No shared tags
                # if ([bool]($images.PSobject.Properties.name -match "sharedtags")) {
                #     $tags += [array]($images.sharedtags | ForEach-Object { $_.PSobject.Properties })
                # }
                $qualifiedTags = $tags | ForEach-Object { $manifestRepo.Name + ':' + $_.Name}
                $qualifiedTags | ForEach-Object {
                    Write-Host "--- Push $_ ---"
                    Invoke-Expression "docker push $_"
                }
            }
    }
    return
}

try {
    $manifestRepo.Images |
    ForEach-Object {
        $images = $_
        $_.Platforms |
            Where-Object { $_.os -eq "$activeOS" } |
            Where-Object { [string]::IsNullOrEmpty($buildFilter) -or $_.dockerfile -match "$buildFilter" } |
            Where-Object { ( [string]::IsNullOrEmpty($ArchitectureFilter) -and -not [bool]($_.PSobject.Properties.name -match "architecture"))`
                -or ( [bool]($_.PSobject.Properties.name -match "architecture") -and $_.architecture -eq "$ArchitectureFilter" ) } |
            ForEach-Object {
                $dockerfilePath = $_.dockerfile
                $tags = [array]($_.Tags | ForEach-Object { $_.PSobject.Properties })
                if ([bool]($images.PSobject.Properties.name -match "sharedtags")) {
                    $tags += [array]($images.sharedtags | ForEach-Object { $_.PSobject.Properties })
                }
                $qualifiedTags = $tags | ForEach-Object { $manifestRepo.Name + ':' + $_.Name}
                $formattedTags = $qualifiedTags -join ', '
				$buildArgs = $optionalDockerBuildArgs
                if ($_.osVersion -ne $buildOSVersion) {
                    $buildArgs += " --isolation=hyperv"
                    Write-Host "--- Building with hyperv isolation"
                }
                Write-Host "--- Building $formattedTags from $dockerfilePath ---"
                Invoke-Expression "docker build $buildArgs --pull -t $($qualifiedTags -join ' -t ') $dockerfilePath"
                if ($LastExitCode -ne 0) {
                    throw "Failed building $formattedTags"
                }
                if ($Push) {
                    
                }

                $builtTags += $formattedTags
            }
    }
    Write-Host "Tags built:`n$($builtTags | Out-String)"
}
finally {
    if (!$Keep -or $Push) {
        Invoke-CleanupDocker $activeOS
    }
}