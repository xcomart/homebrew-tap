# xcomart/homebrew-tap

Homebrew casks for the desktop applications published by
[xcomart](https://github.com/xcomart):

| Cask | Application |
|---|---|
| `rulogman` | [rulogman](https://github.com/xcomart/rulogman): GUI SSH terminal with a files panel, a built-in editor and split panes |
| `rudbman` | [rudbman](https://github.com/xcomart/rudbman): GUI database workbench for any database with a JDBC driver |
| `rudbgen` | [rudbgen](https://github.com/xcomart/rudbgen): source code generator that renders JDBC database metadata through templates |

## Installing

```bash
brew install --cask xcomart/tap/rulogman
brew install --cask xcomart/tap/rudbman
brew install --cask xcomart/tap/rudbgen
```

The qualified name taps this repository on first use. Since Homebrew 6 a
third-party tap is ignored until it is trusted, and installing by the
qualified name trusts that one cask and nothing else in the tap. To install
by the short name instead, trust the cask first:

```bash
brew tap xcomart/tap
brew trust --cask xcomart/tap/rulogman
brew install --cask rulogman
```

`brew trust xcomart/tap` trusts every current and future cask here at once.

## What the casks do differently

**Apple Silicon only.** Each release ships one macOS build,
`aarch64-apple-darwin`, so every cask declares `depends_on arch: :arm64`. An
Intel Mac has no build to install; build from source there, as each
application's README describes.

**The quarantine flag is cleared on install.** The bundles are ad-hoc signed
rather than notarized; there is no Apple Developer account behind them. So
Gatekeeper refuses the quarantined copy Homebrew downloads, and Homebrew 5 no
longer offers `--no-quarantine`. Each cask's `postflight_steps` runs
`xattr -d -r com.apple.quarantine` on the installed bundle. That is the same
command each README walks a manual install through. Installing from this tap
therefore means trusting the GitHub release it points at, whose SHA256 the
cask pins.

**The applications update themselves.** Each one has a built-in updater that
replaces its bundle in place, so the casks say `auto_updates true`:
`brew upgrade` leaves them alone unless it is run with `--greedy`, and
`brew outdated` does not list them. The two never fight over the bundle.

**Uninstalling keeps your settings.** `brew uninstall --cask <name>` removes
only the application. `--zap` also removes its settings directory under
`~/Library/Application Support`. Saved passwords live in the login keychain
and stay there either way.

## How the casks are updated

Nobody edits the versions here by hand. Each application's release workflow
(`.github/workflows/release.yml`, the `homebrew` job) runs once the GitHub
release is published. It reads the macOS archive's SHA256 from the release's
`SHA256SUMS`, writes the new `version` and `sha256` into the cask, and commits
the result to `main`. It never moves a cask to an older version than the one
already here.

That job pushes with the `HOMEBREW_TAP_TOKEN` secret of the application's
repository. The token is a fine-grained personal access token with
**Contents: Read and write** on this repository alone. Without the secret the
job leaves a warning on the release run and changes nothing. Because the push
comes from a personal token rather than `GITHUB_TOKEN`, it runs this
repository's [Tests](.github/workflows/tests.yml) workflow: style, audit and a
real install, check and uninstall of every cask on a macOS runner.

To update a cask by hand anyway, change `version` and `sha256` together. The
checksum is the `aarch64-apple-darwin.tar.gz` line of the release's
`SHA256SUMS`.

## Why not homebrew/cask

The official cask repository no longer accepts applications that fail
Gatekeeper, which un-notarized bundles do, and it also has notability
thresholds these projects do not meet yet. A tap has neither requirement. If
the bundles are ever signed with a Developer ID and notarized, the casks here
can be submitted there nearly unchanged, apart from the `postflight_steps`.
