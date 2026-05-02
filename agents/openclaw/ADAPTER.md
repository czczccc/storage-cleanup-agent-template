# OpenClaw Adapter

Use this adapter when wiring the workflow into OpenClaw or another local agent runner.

Suggested instruction block:

```text
For disk analysis and cleanup tasks, use storage-cleanup-agent-template/prompts/shared-playbook.md and storage-cleanup-agent-template/policies/cleanup-buckets.md.

Platform entrypoints:
- macOS: scripts/macos/storage_report.sh and scripts/macos/candidate_scan.sh
- Windows: scripts/windows/storage_report.ps1 and scripts/windows/candidate_scan.ps1

Never delete files before showing a confirmation list.
Do not remove user documents, media libraries, chat history, mail, browser profiles, credentials, or ambiguous app data unless explicitly approved.
After approval, prefer the platform delete helper with a manifest file instead of ad hoc delete commands.
```

Suggested run pattern:

1. run the storage report
2. run the candidate scan for deep cleanup
3. summarize by risk
4. wait for approval
5. clean only approved targets
6. rerun the report
