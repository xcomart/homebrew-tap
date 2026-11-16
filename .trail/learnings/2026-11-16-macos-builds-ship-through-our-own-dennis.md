---
title: "macOS builds ship through our own Homebrew tap, not homebrew/cask"
author: Dennis
date: 2026-11-16
branch: main
cost: { minutes: 20, tokens: 234520 }
id: l-1378c819
scope: repo
status: active
src: agent
touches:
  - Casks/rulogman.rb
  - Casks/rudbman.rb
  - Casks/rudbgen.rb
  - ".github/workflows/tests.yml"
  - README.md
---

## Decided
- rulogman, rudbman and rudbgen are installed on Apple Silicon Macs with `brew install --cask xcomart/tap/<app>`, from the tap repository xcomart/homebrew-tap (one cask per app under Casks/).
- Nobody bumps the casks by hand. Each app's release workflow has a `homebrew` job after `publish`. It reads the aarch64-apple-darwin line of the release's SHA256SUMS, rewrites `version` and `sha256` in the tap's cask, and pushes to the tap's `main`. A rerun, or an older tag, leaves a cask at the same or a newer version alone.
- The casks say `auto_updates true`, because each app's built-in updater swaps the whole .app bundle in place. With that, `brew upgrade` does not fight the updater.
- The bundles are ad-hoc signed and not notarized, so each cask's `postflight_steps` runs `xattr -d -r com.apple.quarantine` on the installed app. It is the same manual fix the READMEs describe.

## Tried and ruled out
- Submitting to the official homebrew/cask repository. It rejects apps that fail Gatekeeper, which un-notarized bundles do, and it has notability thresholds (stars, forks, watchers) these repositories do not meet. That changes only with a Developer ID plus notarization.
- Legacy cask syntax. `brew style` (Homebrew 6) rejects `postflight do ... system_command` and asks for `postflight_steps` with `run`. An explicit `depends_on macos: ">= :big_sur"` is redundant, so use `depends_on :macos`.

## Watch out
- Since Homebrew 6.0, a third-party tap is ignored until it is trusted. Installing by the fully qualified name trusts only that cask. `brew style` and `brew audit` load the whole tap, so the tap's CI runs `brew trust xcomart/tap` before them and `brew untrust` before the install check.
- The release job needs the HOMEBREW_TAP_TOKEN secret in each app repository: a fine-grained PAT with Contents read/write on xcomart/homebrew-tap only. Without it the job warns and succeeds, like the winget job without WINGET_PAT. Because the push uses a PAT rather than GITHUB_TOKEN, it triggers the tap's Tests workflow, which installs every cask on a macOS runner.
- The job sets git user.name and user.email on its clone, not with `-c` on the commit. When three apps release minutes apart, the push-retry `git pull --rebase` replays the commit and needs a committer identity.
- macOS releases are aarch64 only, so the casks declare `depends_on arch: :arm64`. Intel support would need a new release-matrix target, the updater's TARGET table and an `arch` block in each cask.

In the code:
- each app's .github/workflows/release.yml, job `homebrew`
- xcomart/homebrew-tap: Casks/*.rb, .github/workflows/tests.yml, README.md
- rugpui/crates/rugpui-shell/src/update.rs: swap() and clear_quarantine(), the in-place bundle swap behind `auto_updates true`
