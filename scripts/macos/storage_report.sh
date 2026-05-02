#!/usr/bin/env bash
set -euo pipefail

target_home="${1:-$HOME}"

if [[ ! -d "$target_home" ]]; then
  echo "Home directory not found: $target_home" >&2
  exit 1
fi

echo "== Volume =="
df -h /System/Volumes/Data 2>/dev/null || df -h /
echo

echo "== APFS =="
diskutil info /System/Volumes/Data 2>/dev/null | \
  awk -F: '/Volume Name|Mount Point|Volume Used Space|Container Free Space/ {gsub(/^[ \t]+/, "", $2); print $1 ": " $2}'
echo

echo "== Home Top Level =="
du -xhd 1 "$target_home" 2>/dev/null | sort -h
echo

for dir in \
  "$target_home/Library" \
  "$target_home/Library/Application Support" \
  "$target_home/Library/Caches" \
  "$target_home/Library/Containers" \
  "$target_home/Documents" \
  "$target_home/Downloads" \
  "$target_home/Pictures"; do
  if [[ -d "$dir" ]]; then
    echo "== ${dir/#$target_home/\~} =="
    du -xhd 1 "$dir" 2>/dev/null | sort -h | tail -40
    echo
  fi
done

if [[ -d /Applications ]]; then
  echo "== /Applications =="
  du -xhd 1 /Applications 2>/dev/null | sort -h | tail -30
  echo
fi

echo "== Large Files In Home (>500MB) =="
find "$target_home" -xdev -type f -size +500M -print0 2>/dev/null | \
  xargs -0 du -h 2>/dev/null | sort -h | tail -40
