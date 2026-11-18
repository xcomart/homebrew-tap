cask "rudbman" do
  version "0.3.10"
  sha256 "b8c08aa2819782f18406be87d54044662c778e9e88bd13f1c290e3ff43943374"

  url "https://github.com/xcomart/rudbman/releases/download/v#{version}/rudbman-v#{version}-aarch64-apple-darwin.tar.gz"
  name "rudbman"
  desc "GUI database workbench for any database with a JDBC driver"
  homepage "https://github.com/xcomart/rudbman"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on :macos

  app "rudbman-v#{version}-aarch64-apple-darwin/rudbman.app"

  # The bundle is ad-hoc signed, not notarized, so Gatekeeper refuses the
  # quarantined copy Homebrew downloads. The README's manual fix, done here.
  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-d", "-r", "com.apple.quarantine", "{{appdir}}/rudbman.app"],
        must_succeed: false,
        print_stderr: false
  end

  zap trash: [
    "~/Library/Application Support/rudbman",
    "~/Library/Caches/rudbman",
    "~/Library/Preferences/com.aihouse.rudbman.plist",
    "~/Library/Saved Application State/com.aihouse.rudbman.savedState",
  ]
end
