cask "rudbman" do
  version "0.3.9"
  sha256 "d36cba9916da946f570739313ecd178b0396bc8d8af65b902248e2f03e4f19b6"

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
