# Claude Code Adapter

Use `prompts/shared-playbook.md` as the source of truth.

Add the following instruction to Claude Code's working instructions or repo guidance:

```text
When the user asks about disk usage or cleanup, follow the workflow in storage-cleanup-agent-template/prompts/shared-playbook.md and the policy in storage-cleanup-agent-template/policies/cleanup-buckets.md.

On macOS, start with scripts/macos/storage_report.sh.
On Windows, start with scripts/windows/storage_report.ps1.

Never delete first. Always provide a confirmation list with exact paths, estimated reclaimed space, and consequences before removing files.

Default "deep cleanup" to caches, updater leftovers, partial downloads, and rebuildable build artifacts.
If the user approves, prefer the platform delete helper with a manifest file instead of ad hoc delete commands.
```

Suggested user phrasing:

- "Analyze my storage and give me a confirmation list."
- "Deep clean, but do not delete anything until I confirm."
