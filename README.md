# Storage Cleanup Agent Template

This template turns a storage-analysis and cleanup workflow into a portable playbook that can be used by different coding agents on macOS and Windows.

It is designed for:

- Claude Code
- Hermes
- OpenClaw
- any other shell-capable agent that can read prompt files and run local scripts

The workflow is intentionally conservative:

1. inspect storage first
2. explain where space is going
3. classify candidates by risk
4. ask for confirmation
5. clean only approved targets
6. verify before and after

## What Is Shared vs Agent-Specific

Shared:

- analysis procedure
- cleanup safety policy
- candidate buckets
- platform scripts

Agent-specific:

- how the instructions are phrased
- where you paste the prompt
- whether the agent prefers terse steps or a more guided response style

## Layout

- `prompts/shared-playbook.md`
  - the core workflow every agent should follow
- `policies/cleanup-buckets.md`
  - what is usually safe, what needs judgment, and what should be avoided
- `scripts/macos/`
  - shell scripts for macOS inspection and approved cleanup
- `scripts/windows/`
  - PowerShell scripts for Windows inspection and approved cleanup
- `agents/`
  - adapter prompts for Claude Code, Hermes, and OpenClaw

## Recommended Usage

1. Give your agent the adapter prompt for its environment.
2. Keep `prompts/shared-playbook.md` and `policies/cleanup-buckets.md` alongside it.
3. Let the agent run the matching platform scripts first.
4. Require an explicit user confirmation before deletion.
5. If the user approves, write the approved paths into a plain text manifest and use the platform delete helper in dry-run mode before applying.

## Example User Requests

- "Analyze my disk usage and show me what is safe to clean first."
- "Deep clean my Mac, but show me a confirmation list before deleting anything."
- "Check why Windows says storage is full and separate safe cleanup from risky cleanup."

## Notes

- These scripts focus on discovery, not automatic deletion.
- The delete helpers only remove paths explicitly listed in a manifest file.
- They are built to surface reclaimable space safely.
- Some directories may require Full Disk Access on macOS or elevated permissions on Windows for a complete picture.
