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

# Check system architecture before building using multiple methods
Write-Host "Detecting system architecture..." -ForegroundColor Cyan

# Method 1: RuntimeInformation (preferred)
$OSArchitecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
Write-Host "  Method 1 (RuntimeInformation): '$OSArchitecture'" -ForegroundColor Gray

# Method 2: Environment variable fallback
if ([string]::IsNullOrWhiteSpace($OSArchitecture)) {
    $procArch = $env:PROCESSOR_ARCHITECTURE
    Write-Host "  Method 2 (PROCESSOR_ARCHITECTURE): '$procArch'" -ForegroundColor Gray

    $OSArchitecture = switch ($procArch) {
        "AMD64" { "X64" }
        "ARM64" { "Arm64" }
        "x86" { "X86" }
        default { $procArch }
    }
}

# Method 3: WMI fallback
if ([string]::IsNullOrWhiteSpace($OSArchitecture)) {
    try {
        $wmiArch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
        Write-Host "  Method 3 (WMI): '$wmiArch'" -ForegroundColor Gray

        $OSArchitecture = switch -Regex ($wmiArch) {
            "64-bit" { "X64" }
            "ARM" { "Arm64" }
            default { $wmiArch }
        }
    } catch {
        Write-Host "  Method 3 (WMI): Failed" -ForegroundColor Gray
    }
}

Write-Host "Final detected architecture: '$OSArchitecture'" -ForegroundColor Cyan

if ([string]::IsNullOrWhiteSpace($OSArchitecture) -or $OSArchitecture -notin @("X64", "Arm64")) {
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Red
    Write-Host "ERROR: Unsupported system architecture: '$OSArchitecture'" -ForegroundColor Red
    Write-Host "==================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "This build script only supports:" -ForegroundColor Yellow
    Write-Host "  - X64 (x86_64) systems" -ForegroundColor Yellow
    Write-Host "  - Arm64 (aarch64) systems" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Debug information:" -ForegroundColor Cyan
    Write-Host "  PROCESSOR_ARCHITECTURE: $env:PROCESSOR_ARCHITECTURE" -ForegroundColor Gray
    Write-Host "  PROCESSOR_ARCHITEW6432: $env:PROCESSOR_ARCHITEW6432" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To fix this issue, you need to modify:" -ForegroundColor Cyan
    Write-Host "  script\bundle-windows.ps1 (lines 17-21)" -ForegroundColor Cyan
    Write-Host "  Add support for your architecture" -ForegroundColor Cyan
    exit 1
}

# Temporary fix for PowerShell 5.1 compatibility issues
$bundleScript = "$env:ZED_WORKSPACE\script\bundle-windows.ps1"
$bundleBackup = "$env:ZED_WORKSPACE\script\bundle-windows.ps1.backup"
$licensesScript = "$env:ZED_WORKSPACE\script\generate-licenses.ps1"
$licensesBackup = "$env:ZED_WORKSPACE\script\generate-licenses.ps1.backup"

Write-Host "Applying temporary fixes for PowerShell 5.1 compatibility..." -ForegroundColor Yellow

# Backup original files
Copy-Item -Path $bundleScript -Destination $bundleBackup -Force
Copy-Item -Path $licensesScript -Destination $licensesBackup -Force

try {
    # Fix 1: bundle-windows.ps1 architecture detection
    $content = Get-Content -Path $bundleScript -Raw
    $oldPattern = @'
\$OSArchitecture = switch \(\[System\.Runtime\.InteropServices\.RuntimeInformation\]::OSArchitecture\) \{
    "X64" \{ "x86_64" \}
    "Arm64" \{ "aarch64" \}
    default \{ throw "Unsupported architecture" \}
\}
'@
    $newCode = @'
$OSArchitecture = switch ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture) {
    "X64" { "x86_64" }
    "Arm64" { "aarch64" }
    default {
        $procArch = $env:PROCESSOR_ARCHITECTURE
        switch ($procArch) {
            "AMD64" { "x86_64" }
            "ARM64" { "aarch64" }
            default { throw "Unsupported architecture: RuntimeInfo='$([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture)', ProcArch='$procArch'" }
        }
    }
}
'@
    $content = $content -replace $oldPattern, $newCode
    Set-Content -Path $bundleScript -Value $content -NoNewline

    # Fix 2: generate-licenses.ps1 ternary operators (PowerShell 7+ syntax)
    $content = Get-Content -Path $licensesScript -Raw
    # Replace line 5: $outputFile=$args[0] ? $args[0] : "..."
    $content = $content -replace '\$outputFile=\$args\[0\] \? \$args\[0\] : "([^"]+)"', '$outputFile=if ($args[0]) { $args[0] } else { "$1" }'
    # Replace line 37: $failFlag = $env:ALLOW_MISSING_LICENSES ? "--fail" : ""
    $content = $content -replace '\$failFlag = \$env:ALLOW_MISSING_LICENSES \? "--fail" : ""', '$failFlag = if ($env:ALLOW_MISSING_LICENSES) { "--fail" } else { "" }'
    Set-Content -Path $licensesScript -Value $content -NoNewline

    Write-Host "Temporary fixes applied successfully." -ForegroundColor Green

    # Run the bundle script for x86_64 release
    Write-Host "=================================================="
    Write-Host "Building Zed x86_64 stable release installer"
    Write-Host "=================================================="
    Write-Host ""

    & "$bundleScript" -Architecture x86_64
    $buildExitCode = $LASTEXITCODE

} finally {
    # Always restore the original files
    Write-Host ""
    Write-Host "Restoring original files..." -ForegroundColor Yellow
    Move-Item -Path $bundleBackup -Destination $bundleScript -Force
    Move-Item -Path $licensesBackup -Destination $licensesScript -Force
    Write-Host "Original files restored." -ForegroundColor Green
}

if ($buildExitCode -eq 0) {
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host "Build completed successfully!" -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Red
    Write-Host "Build failed with exit code: $buildExitCode" -ForegroundColor Red
    Write-Host "==================================================" -ForegroundColor Red
    exit $buildExitCode
}
