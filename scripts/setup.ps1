# One-shot setup for a fresh Windows PC: checks tools, runs the test suite.
# Run from the repo root:  powershell -ExecutionPolicy Bypass -File scripts\setup.ps1 [-Install] [-Serve]
param([switch]$Install, [switch]$Serve)
$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

$tools = @(
  @{ Cmd = "git";  Id = "Git.Git" },
  @{ Cmd = "node"; Id = "OpenJS.NodeJS.LTS" }
)
foreach ($t in $tools) {
  if (Get-Command $t.Cmd -ErrorAction SilentlyContinue) { continue }
  if ($Install) {
    winget install --id $t.Id -e --accept-source-agreements --accept-package-agreements
    Write-Output "Installed $($t.Cmd). Open a new terminal and re-run this script."
    exit 0
  }
  throw "$($t.Cmd) not found. Re-run with -Install, or: winget install --id $($t.Id) -e"
}

node --check dist/app.js
foreach ($test in "gameplay", "frontiers", "exploration", "offline") {
  node "tests/$test.mjs"
  if ($LASTEXITCODE -ne 0) { throw "tests/$test.mjs failed" }
}

if (-not (Test-Path "$env:ProgramFiles\Android\Android Studio")) {
  Write-Output "Android Studio not found (only needed for the native APK): winget install --id Google.AndroidStudio -e"
}

Write-Output ""
Write-Output "Ready. Play locally with: powershell -File scripts\dev-server.ps1  ->  http://127.0.0.1:8080"
if ($Serve) { & (Join-Path $PSScriptRoot "dev-server.ps1") }
