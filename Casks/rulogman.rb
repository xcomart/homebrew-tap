cask "rulogman" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.6.7"
  sha256 arm:   "2dd91c0cfd059458dbf8a11bd2372aaeb8b81295eb8afbe10f1039bb563b026b",
         intel: "7d35b205829512502edf810ce20302f0183767f2ce6b4b2142fee1fec052c6ae"

  url "https://github.com/xcomart/rulogman/releases/download/v#{version}/rulogman-v#{version}-#{arch}-apple-darwin.tar.gz"
  name "rulogman"
  desc "GUI SSH terminal with a files panel, built-in editor and split panes"
  homepage "https://github.com/xcomart/rulogman"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :big_sur

  app "rulogman-v#{version}-#{arch}-apple-darwin/rulogman.app"

  # The bundle is ad-hoc signed, not notarized, so Gatekeeper refuses the
  # quarantined copy Homebrew downloads. The README's manual fix, done here.
  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-d", "-r", "com.apple.quarantine", "{{appdir}}/rulogman.app"],
        must_succeed: false,
        print_stderr: false
  end

  zap trash: [
    "~/Library/Application Support/com.aihouse.rulogman",
    "~/Library/Caches/com.aihouse.rulogman",
    "~/Library/Preferences/com.aihouse.rulogman.plist",
    "~/Library/Saved Application State/com.aihouse.rulogman.savedState",
  ]
end
