# Study Paws installer for Windows. Downloads the official installer from the project's GitHub release and starts it.
# Source: https://github.com/miyagagne/Miya-s-Sandbox  (you can read exactly what this does below)
$ErrorActionPreference = 'Stop'
$url = 'https://github.com/miyagagne/Miya-s-Sandbox/releases/download/winston-latest/StudyPaws-Setup.exe'
$out = Join-Path $env:TEMP 'StudyPaws-Setup.exe'
try {
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $ProgressPreference = 'SilentlyContinue'
  Write-Host 'Downloading Study Paws (about 80 MB)...' -ForegroundColor Yellow
  Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing
  if ((Get-Item $out).Length -lt 10MB) { throw 'The download looks incomplete.' }
  Write-Host 'Starting the installer...' -ForegroundColor Green
  Start-Process -FilePath $out
  Write-Host 'Done! Follow the installer, then look for the Study Paws pet on your screen.' -ForegroundColor Green
} catch {
  Write-Host ('Sorry, that did not work: ' + $_.Exception.Message) -ForegroundColor Red
  Write-Host 'Try this direct link in your browser instead:' $url
}
