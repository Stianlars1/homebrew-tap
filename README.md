# stianlars1/homebrew-tap

Homebrew tap for [dotViewer](https://github.com/stianlars1/dotViewer) — a macOS Quick Look extension for syntax-highlighted source code previews.

## Install dotViewer

```bash
brew install --cask stianlars1/tap/dotviewer
```

Or, in two steps if you prefer:

```bash
brew tap stianlars1/tap
brew install --cask dotviewer
```

That's it. Homebrew will:

1. Download the notarized DMG from the latest GitHub release
2. Verify its SHA256 matches the cask definition
3. Copy `dotViewer.app` into `/Applications`
4. Register the Quick Look preview and thumbnail extensions
5. Rebuild the Quick Look server cache

Now select any source file in Finder and press **Space** — you should see a syntax-highlighted preview immediately.

## Upgrade

```bash
brew upgrade --cask dotviewer
```

## Uninstall

```bash
brew uninstall --cask dotviewer
```

To also remove user preferences, caches, and the App Group container:

```bash
brew uninstall --cask --zap dotviewer
```

## Requirements

- macOS 15.0 (Sequoia) or later
- Homebrew 4.0 or later

## How this tap stays up to date

New dotViewer releases are published through the project's `scripts/publish.sh` pipeline, which automatically updates [Casks/dotviewer.rb](Casks/dotviewer.rb) in this repo and pushes the bump — so `brew upgrade` always reflects the latest notarized DMG on GitHub.

## Official Homebrew Cask

A parallel submission to the [official Homebrew Cask](https://github.com/Homebrew/homebrew-cask) repository is planned so that once merged, users can skip the `brew tap` step and run:

```bash
brew install --cask dotviewer
```

See [OFFICIAL_SUBMISSION.md](OFFICIAL_SUBMISSION.md) for the submission process.

## Issues

For problems with the cask itself (install/upgrade/uninstall), open an issue here. For problems with dotViewer (highlighting, previews, crashes), use the main repo: https://github.com/stianlars1/dotViewer/issues
