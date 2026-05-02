param(
  [string]$HomePath = $HOME
)

$ErrorActionPreference = "SilentlyContinue"

function Get-DirSizeBytes {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) { return 0 }
  $measure = Get-ChildItem -LiteralPath $Path -Force -Recurse -File |
    Measure-Object -Property Length -Sum
  return [int64]($measure.Sum)
}

function Write-DirSummary {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) { return }
  $items = Get-ChildItem -LiteralPath $Path -Force
  $rows = foreach ($item in $items) {
    $size = if ($item.PSIsContainer) { Get-DirSizeBytes -Path $item.FullName } else { $item.Length }
    [pscustomobject]@{
      SizeGB = [math]::Round($size / 1GB, 2)
      Path = $item.FullName
    }
  }
  $rows | Sort-Object SizeGB | Select-Object -Last 30 | Format-Table -AutoSize
}

$systemDrive = $env:SystemDrive
$volume = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $systemDrive }

Write-Output "== Volume =="
if ($volume) {
  [pscustomobject]@{
    Drive = $volume.DeviceID
    SizeGB = [math]::Round($volume.Size / 1GB, 2)
    FreeGB = [math]::Round($volume.FreeSpace / 1GB, 2)
    UsedGB = [math]::Round(($volume.Size - $volume.FreeSpace) / 1GB, 2)
  } | Format-Table -AutoSize
}

Write-Output ""
Write-Output "== Home Top Level =="
Write-DirSummary -Path $HomePath

$localAppData = $env:LOCALAPPDATA
$roamingAppData = $env:APPDATA
$downloads = Join-Path $HomePath "Downloads"
$pictures = Join-Path $HomePath "Pictures"

foreach ($dir in @($localAppData, $roamingAppData, $downloads, $pictures)) {
  if (Test-Path -LiteralPath $dir) {
    Write-Output ""
    Write-Output "== $dir =="
    Write-DirSummary -Path $dir
  }
}

Write-Output ""
Write-Output "== Large Files In Home (>500MB) =="
Get-ChildItem -LiteralPath $HomePath -Force -Recurse -File |
  Where-Object { $_.Length -gt 500MB } |
  Sort-Object Length |
  Select-Object -Last 40 @{Name="SizeGB";Expression={[math]::Round($_.Length / 1GB, 2)}}, FullName |
  Format-Table -AutoSize
