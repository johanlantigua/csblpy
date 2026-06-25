$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root

$iscc = Get-Command iscc.exe -ErrorAction SilentlyContinue
if (-not $iscc) {
  $possible = @(
    "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
    "C:\Program Files\Inno Setup 6\ISCC.exe"
  )
  foreach ($path in $possible) {
    if (Test-Path $path) {
      $iscc = Get-Item $path
      break
    }
  }
}

if (-not $iscc) {
  throw "Inno Setup compiler not found. Install Inno Setup 6, then run this script again."
}

if (-not (Test-Path "laneagilitypy\dist\CSBL Agility.exe")) {
  Push-Location laneagilitypy
  powershell -ExecutionPolicy Bypass -File .\build_exe.ps1
  Pop-Location
}

if (-not (Test-Path "jumpplatepy\dist\CSBL Jump Plate.exe")) {
  Push-Location jumpplatepy
  powershell -ExecutionPolicy Bypass -File .\build_exe.ps1
  Pop-Location
}

Push-Location laneagilitypy
& $iscc.FullName .\CSBL-Agility-Installer.iss
Pop-Location

Push-Location jumpplatepy
& $iscc.FullName .\CSBL-Jump-Plate-Installer.iss
Pop-Location

Write-Host ""
Write-Host "Built Store installer packages:"
Write-Host "$Root\docs\downloads\CSBL-Agility-Setup-1.0.0.exe"
Write-Host "$Root\docs\downloads\CSBL-Jump-Plate-Setup-1.0.0.exe"
