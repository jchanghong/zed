# Build Zed Release Installer
# This script builds a release version of Zed for Windows (x86_64)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$env:ZED_WORKSPACE = $ScriptDir

# Check and update RELEASE_CHANNEL file to stable
$releaseChannelPath = "$env:ZED_WORKSPACE\crates\zed\RELEASE_CHANNEL"
if (-not (Test-Path $releaseChannelPath)) {
    Write-Host "Error: RELEASE_CHANNEL file not found at $releaseChannelPath" -ForegroundColor Red
    exit 1
}

$releaseChannel = (Get-Content $releaseChannelPath -Raw).Trim()
if ($releaseChannel -ne "stable") {
    Write-Host "Current RELEASE_CHANNEL is '$releaseChannel', switching to 'stable' for release build" -ForegroundColor Yellow
    Set-Content -Path $releaseChannelPath -Value "stable" -NoNewline
    Write-Host "RELEASE_CHANNEL updated to: stable" -ForegroundColor Green
} else {
    Write-Host "RELEASE_CHANNEL verified: stable" -ForegroundColor Green
}

# Clean the entire target directory
$targetDir = "$env:ZED_WORKSPACE\target"
if (Test-Path $targetDir) {
    Write-Host "Removing target directory: $targetDir" -ForegroundColor Yellow
    cmd /c "rd /s /q `"$targetDir`""
    Write-Host "Target directory removed." -ForegroundColor Green
} else {
    Write-Host "Target directory does not exist, skipping clean." -ForegroundColor Yellow
}

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
