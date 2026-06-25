$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

python -m pip install -r requirements.txt

python -m PyInstaller `
  --onefile `
  --windowed `
  --name "CSBL Agility" `
  --icon ".\assets\lablogo.ico" `
  --add-data "..\pics;pics" `
  --add-data ".\assets;pythoncode\assets" `
  agility_gui_la_camp.py

Write-Host ""
Write-Host "Built executable:"
Write-Host "$ScriptDir\dist\CSBL Agility.exe"
