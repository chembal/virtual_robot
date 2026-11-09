# One-time setup: puts the BioBuzz robot code next to this folder (..\BioBuzzExample) if it isn't there yet.
# run-sim.ps1 and IntelliJ expect that layout:
#   <workspace>\virtual_robot      (this repo)
#   <workspace>\BioBuzzExample     (the robot code you edit and push in its own repo)
$ErrorActionPreference = 'Stop'
$target = Join-Path (Split-Path $PSScriptRoot -Parent) 'BioBuzzExample'
if (Test-Path $target) {
    Write-Host "BioBuzzExample already exists at $target - nothing to do."
} else {
    git clone https://github.com/WDM-Engineering-Robotics-Foundation/BioBuzzExample.git $target
    if ($LASTEXITCODE -ne 0) { throw 'Clone failed' }
    Write-Host "Cloned BioBuzzExample to $target"
}
Write-Host 'Next: open this folder in IntelliJ, or run .\run-sim.ps1 (virtual gamepad) / .\run-sim-gamepad.ps1 (USB gamepad).'
