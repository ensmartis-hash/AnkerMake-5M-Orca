# Copy Grok-v1 JSON presets into the active OrcaSlicer user folder.
# Does not copy .info files (those are Orca cloud-sync metadata).
# Run with OrcaSlicer fully quit.

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$PresetRoot = Join-Path $RepoRoot 'presets\v1'
$OrcaUserRoot = Join-Path $env:APPDATA 'OrcaSlicer\user'

if (-not (Test-Path $OrcaUserRoot)) {
    throw "OrcaSlicer user folder not found: $OrcaUserRoot"
}

$conf = Join-Path $env:APPDATA 'OrcaSlicer\OrcaSlicer.conf'
$folder = $null
if (Test-Path $conf) {
    $raw = Get-Content -Raw -LiteralPath $conf
    if ($raw -match '"preset_folder"\s*:\s*"([^"]+)"') {
        $folder = $Matches[1]
    }
}

if ($folder) {
    $destBase = Join-Path $OrcaUserRoot $folder
} else {
    $destBase = Join-Path $OrcaUserRoot 'default'
}

if (-not (Test-Path $destBase)) {
    throw "Preset destination not found: $destBase"
}

foreach ($kind in @('machine', 'filament', 'process')) {
    $srcDir = Join-Path $PresetRoot $kind
    $dstDir = Join-Path $destBase $kind
    New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
    Get-ChildItem -LiteralPath $srcDir -Filter '*.json' | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $dstDir $_.Name) -Force
        Write-Host "Installed $($kind)/$($_.Name)"
    }
}

Write-Host ""
Write-Host "Done. Destination: $destBase"
Write-Host "If presets vanish after restart, Orca cloud sync is on."
Write-Host "Preferences -> uncheck Sync user presets, or set sync_user_preset false in OrcaSlicer.conf."
Write-Host "Then fully quit Orca and reopen."
