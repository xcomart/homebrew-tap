cask "rudbman" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.3.11"
  sha256 arm:   "01eedfedadd1eca12e67db59eb56a1e1654023b9af90787b5f1989880e00e425",
         intel: "8cfa51e9b901a80a6e05672f8356b2f314fbae26c69ab32f34a5e092f64872bf"

  url "https://github.com/xcomart/rudbman/releases/download/v#{version}/rudbman-v#{version}-#{arch}-apple-darwin.tar.gz"
  name "rudbman"
  desc "GUI database workbench for any database with a JDBC driver"
  homepage "https://github.com/xcomart/rudbman"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :big_sur

  app "rudbman-v#{version}-#{arch}-apple-darwin/rudbman.app"

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
