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

function Write-SizedPath {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) { return }
  $size = Get-DirSizeBytes -Path $Path
  [pscustomobject]@{
    SizeGB = [math]::Round($size / 1GB, 2)
    Path = $Path
  } | Format-Table -AutoSize
}

Write-Output "== Safe After Confirmation =="
foreach ($dir in @(
  $env:TEMP,
  (Join-Path $env:LOCALAPPDATA "Temp"),
  (Join-Path $env:LOCALAPPDATA "npm-cache"),
  (Join-Path $env:LOCALAPPDATA "pip\Cache"),
  (Join-Path $env:LOCALAPPDATA "Google\Chrome\User Data\Default\Cache"),
  (Join-Path $env:LOCALAPPDATA "Microsoft\Edge\User Data\Default\Cache")
)) {
  Write-SizedPath -Path $dir
}

Write-Output ""
Write-Output "-- Partial downloads --"
Get-ChildItem -LiteralPath $HomePath -Force -Recurse -File |
  Where-Object { $_.Extension -in @(".crdownload", ".partial", ".part") } |
  Sort-Object Length |
  Select-Object -Last 40 @{Name="SizeGB";Expression={[math]::Round($_.Length / 1GB, 2)}}, FullName |
  Format-Table -AutoSize

Write-Output ""
Write-Output "-- Build artifacts --"
Get-ChildItem -LiteralPath $HomePath -Force -Recurse -Directory |
  Where-Object { $_.Name -in @("node_modules", ".next", "dist", "build") } |
  ForEach-Object {
    [pscustomobject]@{
      SizeGB = [math]::Round((Get-DirSizeBytes -Path $_.FullName) / 1GB, 2)
      Path = $_.FullName
    }
  } |
  Sort-Object SizeGB |
  Select-Object -Last 60 |
  Format-Table -AutoSize

Write-Output ""
Write-Output "== Needs Judgment =="
foreach ($dir in @(
  (Join-Path $HomePath "Downloads"),
  (Join-Path $HomePath "Videos"),
  (Join-Path $HomePath "Pictures"),
  (Join-Path $HomePath "OneDrive"),
  $env:APPDATA
)) {
  Write-SizedPath -Path $dir
}

Write-Output ""
Write-Output "== Avoid Unless Explicitly Requested =="
foreach ($dir in @(
  (Join-Path $HomePath "Pictures"),
  (Join-Path $HomePath "Documents\Outlook Files"),
  (Join-Path $env:APPDATA "Mozilla"),
  (Join-Path $env:LOCALAPPDATA "Microsoft\Outlook")
)) {
  Write-SizedPath -Path $dir
}
