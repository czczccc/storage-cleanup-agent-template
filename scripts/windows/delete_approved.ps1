param(
  [Parameter(Mandatory = $true)]
  [string]$ManifestPath,
  [switch]$Apply
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ManifestPath)) {
  throw "Manifest not found: $ManifestPath"
}

function Get-ItemSizeBytes {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) { return 0 }
  $item = Get-Item -LiteralPath $Path -Force
  if (-not $item.PSIsContainer) { return [int64]$item.Length }
  $measure = Get-ChildItem -LiteralPath $Path -Force -Recurse -File |
    Measure-Object -Property Length -Sum
  return [int64]($measure.Sum)
}

$paths = Get-Content -LiteralPath $ManifestPath |
  ForEach-Object { $_.Trim() } |
  Where-Object { $_ -and -not $_.StartsWith("#") }

Write-Output "== Approved Paths =="
foreach ($path in $paths) {
  if (Test-Path -LiteralPath $path) {
    [pscustomobject]@{
      SizeGB = [math]::Round((Get-ItemSizeBytes -Path $path) / 1GB, 2)
      Path = $path
    } | Format-Table -AutoSize
  } else {
    Write-Output "Missing: $path"
  }
}

if (-not $Apply) {
  Write-Output ""
  Write-Output "Dry run only. Re-run with -Apply to delete the listed paths."
  exit 0
}

Write-Output ""
Write-Output "== Deleting =="
foreach ($path in $paths) {
  if (Test-Path -LiteralPath $path) {
    Remove-Item -LiteralPath $path -Force -Recurse
    Write-Output "Deleted: $path"
  } else {
    Write-Output "Skipped missing: $path"
  }
}
