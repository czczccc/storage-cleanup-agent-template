#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  delete_approved.sh MANIFEST_FILE [--apply]

Behavior:
  - default mode is dry-run
  - reads one path per line from the manifest file
  - ignores blank lines and lines starting with #
  - deletes only the listed paths when --apply is provided
EOF
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

manifest="$1"
apply_mode="${2:-}"

if [[ ! -f "$manifest" ]]; then
  echo "Manifest not found: $manifest" >&2
  exit 1
fi

if [[ -n "$apply_mode" && "$apply_mode" != "--apply" ]]; then
  usage
  exit 1
fi

echo "== Approved Paths =="
while IFS= read -r raw || [[ -n "$raw" ]]; do
  path="${raw#"${raw%%[![:space:]]*}"}"
  path="${path%"${path##*[![:space:]]}"}"
  [[ -z "$path" || "${path:0:1}" == "#" ]] && continue

  if [[ -e "$path" ]]; then
    du -sh "$path" 2>/dev/null || echo "$path"
  else
    echo "Missing: $path"
  fi
done < "$manifest"

if [[ "$apply_mode" != "--apply" ]]; then
  echo
  echo "Dry run only. Re-run with --apply to delete the listed paths."
  exit 0
fi

echo
echo "== Deleting =="
while IFS= read -r raw || [[ -n "$raw" ]]; do
  path="${raw#"${raw%%[![:space:]]*}"}"
  path="${path%"${path##*[![:space:]]}"}"
  [[ -z "$path" || "${path:0:1}" == "#" ]] && continue

  if [[ -e "$path" ]]; then
    rm -rf "$path"
    echo "Deleted: $path"
  else
    echo "Skipped missing: $path"
  fi
done < "$manifest"
