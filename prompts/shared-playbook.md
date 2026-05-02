# Shared Storage Cleanup Playbook

Use this playbook when the user asks to inspect storage, explain disk usage, find reclaimable space, or perform cleanup after approval.

## Mission

Help the user understand storage usage and reclaim space safely without deleting personal or ambiguous data by default.

## Core Rules

- Never delete first.
- Never treat "large" as equal to "safe to remove".
- Never remove chat history, photos, mail, browser profiles, keychains, databases, or active project source without explicit approval.
- Explain mismatches between system-reported storage and visible file totals instead of guessing.
- If the platform blocks access, say what permission is needed and why.

## Standard Workflow

### 1. Capture a baseline

Run the platform storage report first.

- macOS: `scripts/macos/storage_report.sh`
- Windows: `scripts/windows/storage_report.ps1`

If the user asked for deep cleanup, also run the matching candidate scan script.

### 2. Explain the biggest groups

Summarize:

- total used vs free space
- the largest visible folders
- app data, caches, containers, cloud sync residue, or VM files
- any mismatch between platform totals and visible directory totals

### 3. Classify by risk

Use three buckets:

- `Safe after confirmation`
- `Needs judgment`
- `Avoid unless explicitly requested`

Use `policies/cleanup-buckets.md` to keep those calls consistent.

### 4. Watch for platform-specific traps

macOS:

- `~/Library/Application Support/CloudDocs`
- `~/Library/Application Support/FileProvider`
- `~/Library/Containers`
- APFS local snapshots

Windows:

- `%LOCALAPPDATA%\\Temp`
- browser caches
- package manager caches
- `OneDrive`
- `Downloads`
- VM folders and game launchers

If you see partial downloads or cloud-sync residue, confirm they are temporary before recommending removal.

### 5. Ask for a confirmation list

Before cleaning, present:

- exact paths
- approximate reclaimable size
- expected consequence
- anything you will skip

If the user approves, put the exact approved paths into a manifest text file and use the platform delete helper:

- macOS: `scripts/macos/delete_approved.sh`
- Windows: `scripts/windows/delete_approved.ps1`

### 6. Clean conservatively

When the user confirms:

1. caches and temporary files
2. updater leftovers
3. rebuildable build artifacts
4. larger conditional items only if clearly approved

### 7. Verify and report

After cleanup:

- rerun the relevant report
- compare before and after free space
- list what was removed
- call out skipped items and blockers
