#!/usr/bin/env bash
set -euo pipefail

target_home="${1:-$HOME}"

if [[ ! -d "$target_home" ]]; then
  echo "Home directory not found: $target_home" >&2
  exit 1
fi

echo "== Safe After Confirmation =="

for dir in \
  "$target_home/.cache" \
  "$target_home/.npm" \
  "$target_home/.pnpm-store" \
  "$target_home/Library/Caches"; do
  if [[ -d "$dir" ]]; then
    du -sh "$dir" 2>/dev/null
  fi
done

clouddocs_session="$target_home/Library/Application Support/CloudDocs/session"
if [[ -d "$clouddocs_session" ]]; then
  echo
  echo "-- Partial CloudDocs downloads --"
  find "$clouddocs_session" -type f -name '*.qkdownloading' -print0 2>/dev/null | \
    xargs -0 du -sh 2>/dev/null | sort -h | tail -40 || true
fi

echo
echo "-- Build artifacts --"
find "$target_home" -xdev \
  \( -name node_modules -o -name .next -o -name dist -o -name build \) \
  -prune -exec du -sh {} + 2>/dev/null | sort -h | tail -60 || true

echo
echo "== Needs Judgment =="
for dir in \
  "$target_home/Downloads" \
  "$target_home/Movies" \
  "$target_home/Pictures" \
  "$target_home/Library/Application Support" \
  "$target_home/Library/Containers"; do
  if [[ -d "$dir" ]]; then
    du -sh "$dir" 2>/dev/null
  fi
done

echo
echo "== Avoid Unless Explicitly Requested =="
for dir in \
  "$target_home/Library/Mail" \
  "$target_home/Library/Messages" \
  "$target_home/Library/Safari" \
  "$target_home/Library/Keychains" \
  "$target_home/Pictures/Photos Library.photoslibrary"; do
  if [[ -e "$dir" ]]; then
    du -sh "$dir" 2>/dev/null || true
  fi
done
