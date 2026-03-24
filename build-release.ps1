# Build Zed Release Installer
# This script builds a release version of Zed for Windows (x86_64)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$env:ZED_WORKSPACE = $ScriptDir

# Check RELEASE_CHANNEL file
$releaseChannelPath = "$env:ZED_WORKSPACE\crates\zed\RELEASE_CHANNEL"
if (-not (Test-Path $releaseChannelPath)) {
    Write-Host "Error: RELEASE_CHANNEL file not found at $releaseChannelPath" -ForegroundColor Red
    exit 1
}

$releaseChannel = (Get-Content $releaseChannelPath -Raw).Trim()
if ($releaseChannel -ne "stable") {
    Write-Host "Error: RELEASE_CHANNEL is '$releaseChannel', but 'stable' is required" -ForegroundColor Red
    Write-Host "Please update $releaseChannelPath to 'stable' before building" -ForegroundColor Yellow
    exit 1
}

Write-Host "RELEASE_CHANNEL verified: stable" -ForegroundColor Green

# Navigate to workspace
Set-Location $env:ZED_WORKSPACE

# Run the bundle script for x86_64 release
Write-Host "=================================================="
Write-Host "Building Zed x86_64 stable release installer"
Write-Host "=================================================="
Write-Host ""

& "$env:ZED_WORKSPACE\script\bundle-windows.ps1" -Architecture x86_64

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host "Build completed successfully!" -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Red
    Write-Host "Build failed with exit code: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "==================================================" -ForegroundColor Red
    exit $LASTEXITCODE
}
