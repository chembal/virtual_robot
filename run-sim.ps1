# Rebuilds and launches virtual_robot (no IntelliJ needed). Needs a JDK 17 with JavaFX, e.g. Liberica 17 Full;
# it uses JAVA_HOME if that qualifies, else a Liberica Full install, else javac on PATH.
# Usage: .\run-sim.ps1            -> on-screen virtual gamepad
#        .\run-sim.ps1 -RealGamepad -> physical USB gamepad (press Start+A to assign it as gamepad1)
param([switch]$RealGamepad)
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

# Find a JDK that has javac, javaw and JavaFX (Liberica "Full" bundles JavaFX; plain JDKs do not).
$candidates = @()
if ($env:JAVA_HOME) { $candidates += $env:JAVA_HOME }
$candidates += @(Get-ChildItem 'C:\Program Files\BellSoft' -Directory -Filter 'LibericaJDK-*-Full' -ErrorAction SilentlyContinue |
    Sort-Object Name -Descending | ForEach-Object FullName)
$javac = Get-Command javac.exe -ErrorAction SilentlyContinue
if ($javac) { $candidates += (Split-Path (Split-Path $javac.Source -Parent) -Parent) }
$jdkHome = $candidates | Where-Object {
    $_ -and (Test-Path "$_\bin\javac.exe") -and (Test-Path "$_\bin\javaw.exe") -and (Test-Path "$_\lib\javafx.properties")
} | Select-Object -First 1
if (-not $jdkHome) {
    throw "No JDK with JavaFX found. Install 'Liberica JDK 17 Full' (https://bell-sw.com/pages/downloads/, choose Full) or set JAVA_HOME to a JDK that includes JavaFX."
}
Write-Host "Using JDK: $jdkHome"
$jdk = "$jdkHome\bin"
$out = 'out\cli'
$cp = ((Get-ChildItem lib\*.jar | Where-Object Name -notmatch 'sources' | ForEach-Object FullName) -join ';')

if (Test-Path $out) { Remove-Item $out -Recurse -Force }
New-Item -ItemType Directory $out | Out-Null
# Also compile the BioBuzz example's OpModes straight from that repo, so edits there show up here
$extra = '..\BioBuzzExample\TeamCode\src\main\java'
# Like the FTC Driver Station, list only your OpModes: when the BioBuzz repo is present, the stock
# samples in TeamCode\src are not compiled at all. Delete that folder check to bring them back.
if (Test-Path $extra) { $srcDirs = @('Controller\src', $extra) } else { $srcDirs = @('Controller\src', 'TeamCode\src') }
Get-ChildItem $srcDirs -Recurse -Filter *.java | ForEach-Object { '"' + ($_.FullName -replace '\\', '/') + '"' } | Set-Content out\srcs.txt -Encoding ascii
& "$jdk\javac.exe" -nowarn -encoding UTF-8 -d $out -cp $cp '@out\srcs.txt'
if ($LASTEXITCODE -ne 0) { throw 'Compile failed' }

# Copy FXML, images and other resources next to the classes
foreach ($src in 'Controller\src', 'TeamCode\src') {
    $root = (Resolve-Path $src).Path
    Get-ChildItem $src -Recurse -File | Where-Object Extension -ne '.java' | ForEach-Object {
        $dest = Join-Path $out $_.FullName.Substring($root.Length + 1)
        New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
        Copy-Item $_.FullName $dest
    }
}

$gp = if ($RealGamepad) { '-Dvirtual_robot.realGamepad=true ' } else { '' }
Start-Process "$jdk\javaw.exe" -ArgumentList "$gp-cp `"$out;$cp`" virtual_robot.controller.VirtualRobotApplication"
