$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

python -m pip install -r requirements.txt

python -m PyInstaller `
  --onefile `
  --windowed `
  --name "CSBL Jump Plate" `
  --icon ".\assets\lablogo.ico" `
  --add-data "..\pics;pics" `
  --add-data ".\assets;jumpplatepy\assets" `
  jump_plate_app.py

Write-Host ""
Write-Host "Built executable:"
Write-Host "$ScriptDir\dist\CSBL Jump Plate.exe"
