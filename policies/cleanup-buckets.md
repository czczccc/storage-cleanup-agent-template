# Cleanup Buckets

Use these buckets when presenting cleanup candidates.

## Safe after confirmation

Usually rebuildable or disposable:

- user cache folders
- package manager caches
- browser and automation caches
- app updater leftovers
- orphaned installer archives
- temporary partial downloads
- rebuildable project outputs:
  - `node_modules`
  - `.next`
  - `dist`
  - `build`

macOS examples:

- `~/Library/Caches/*`
- `~/.cache/*`
- `~/.npm/_cacache`
- `~/Library/Application Support/CloudDocs/session/*/*.qkdownloading`

Windows examples:

- `%LOCALAPPDATA%\\Temp`
- `%LOCALAPPDATA%\\npm-cache`
- `%LOCALAPPDATA%\\pip\\Cache`
- Chrome and Edge disk caches
- `*.crdownload`

## Needs judgment

These may be removable, but only with a clear user choice:

- `Downloads`
- `Movies` or `Videos`
- duplicate project folders
- app data under `Application Support` or `AppData` that is not obviously a cache
- cloud sync leftovers that might still map to user documents
- local media in chat apps
- app bundles or installed software that would need uninstalling
- VM images

## Avoid unless explicitly requested

- photo libraries or originals
- mail stores
- message histories
- browser profiles and saved sessions
- keychains and credential stores
- system directories
- databases with unclear ownership
- active source trees other than rebuildable outputs
- anything ambiguous

## Good Summary Shape

When reporting candidates, keep the answer in this order:

1. current used and free space
2. biggest reclaimable groups
3. safe vs judgment calls
4. exact confirmation list before deletion
