# Submitting dotViewer to the Official Homebrew Cask

Once the project grows enough to clear Homebrew's notability bar, submit the cask to the [official homebrew-cask repository](https://github.com/Homebrew/homebrew-cask). After it merges, users can install without the `brew tap` step:

```bash
brew install --cask dotviewer
```

This document captures the full submission workflow, audit expectations, and the one real blocker you need to clear first.

---

## Prerequisite: Clear the notability threshold

Homebrew auto-runs `brew audit --new` on every new cask PR. It **rejects** repositories that don't meet all three of:

- **≥ 30 GitHub forks**, OR
- **≥ 30 watchers**, OR
- **≥ 75 stars**

Any one of these is enough. Current status (check before submitting):

```bash
gh repo view stianlars1/dotViewer --json stargazerCount,forkCount,watchers
```

At repo-creation time this returned `0 / 0 / 0`, so submission is blocked until growth catches up. Interim strategy: ship via this tap (`stianlars1/tap`), link it prominently from the README, and revisit once the project gets traction from the App Store listing, Product Hunt launch, or community shares.

The rule exists because homebrew-cask maintainers are volunteers — they won't absorb maintenance burden for software with no user base. It's not personal; every cask gets the same gate.

---

## When you're ready to submit

### 1. Fork and clone homebrew-cask

```bash
gh repo fork Homebrew/homebrew-cask --clone
cd homebrew-cask
```

### 2. Create a branch and copy the cask in

```bash
git checkout -b dotviewer
cp ~/Developer/macOS\ Apps/homebrew-tap/Casks/dotviewer.rb Casks/d/dotviewer.rb
```

Note the `d/` subdirectory — homebrew-cask shards casks by first letter.

### 3. Run the full audit

This is the exact check the CI bot runs on your PR:

```bash
brew audit --cask --new --online --strict Casks/d/dotviewer.rb
brew style --cask Casks/d/dotviewer.rb
```

Both must pass with zero errors. Known warnings to watch for:

| Warning | Meaning | Action |
|---------|---------|--------|
| "GitHub repository not notable enough" | You haven't cleared 30 forks / 30 watchers / 75 stars | Wait for growth before submitting |
| "Cask token does not match..." | Filename must match `token` value (both `dotviewer`) | Already correct |
| "URL should not use `verified:` when domains match" | Already fixed in the tap cask | No action |
| "auto_updates should be true" | Only if dotViewer adopts Sparkle for in-app updates | Set `auto_updates true` if/when you add Sparkle |

### 4. Test install locally

```bash
brew install --cask --no-quarantine ./Casks/d/dotviewer.rb
# Verify dotViewer.app exists in /Applications and Quick Look works
brew uninstall --cask dotviewer
```

### 5. Commit and open PR

```bash
git add Casks/d/dotviewer.rb
git commit -m "Add dotviewer"
git push -u origin dotviewer
gh pr create \
  --repo Homebrew/homebrew-cask \
  --title "Add dotviewer" \
  --body "$(cat <<'EOF'
dotViewer is a macOS Quick Look extension for syntax-highlighted source code previews.

- Homepage: https://github.com/stianlars1/dotViewer
- License: (fill in — homebrew-cask requires a license in the repo)
- Free and open source: yes
- Notarized: yes (Developer ID: 7F5ZSQFCQ4)
- Stable release: v1.3.0+
- `brew audit --cask --new --online --strict`: passes
- `brew style --cask`: passes

Installation tested locally with `brew install --cask ./Casks/d/dotviewer.rb`.
EOF
)"
```

### 6. Respond to CI + reviewer feedback

- A GitHub Action bot comments within a few minutes with audit results.
- A human maintainer usually reviews within 2–14 days.
- Common feedback: tweak `desc:`, reorder stanzas, remove unnecessary lines.
- Push follow-up commits to the same branch; they'll amend into the PR automatically.

### 7. After merge

- `livecheck` (`strategy: :github_latest`) takes over. Homebrew's autobump bot watches your GitHub releases page and opens PRs to bump the version + SHA256 on every new release.
- **Your `publish.sh` still updates `stianlars1/tap`** — keep that running as a fallback and for users who tapped before the official cask existed. Both will work in parallel.
- Remove the `brew tap stianlars1/tap` step from the dotViewer README install instructions (or keep it as an alternate).

---

## Licensing note

Check that [github.com/stianlars1/dotViewer](https://github.com/stianlars1/dotViewer) has a `LICENSE` file at repo root. homebrew-cask's audit doesn't hard-fail on this, but maintainers will ask. Any OSI-approved license is fine (MIT, Apache 2.0, BSD, etc.).

---

## Maintaining parity between the two casks

Once the official cask is merged, the two cask definitions should stay roughly identical. Differences that are **OK**:

- Official cask will have its version/sha256 bumped by Homebrew's bot faster than your tap (the bot runs hourly)
- Official cask might get maintainer-suggested style tweaks that drift from yours

Differences that will **confuse users** — avoid these:

- Different `depends_on macos:` floors
- Different `zap` trash paths (uninstall behavior diverges)
- Different `postflight` actions

When in doubt, mirror the official cask into this tap after each upstream change. A quarterly `diff` is sufficient.
