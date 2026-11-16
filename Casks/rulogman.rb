cask "rulogman" do
  version "0.6.6"
  sha256 "fe00eb5ed8d1c310584edf49b058f366a4a3d84e1c3f25208eb1aca0eb22b4fb"

  url "https://github.com/xcomart/rulogman/releases/download/v#{version}/rulogman-v#{version}-aarch64-apple-darwin.tar.gz"
  name "rulogman"
  desc "GUI SSH terminal with a files panel, built-in editor and split panes"
  homepage "https://github.com/xcomart/rulogman"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: ">= :big_sur"

  app "rulogman-v#{version}-aarch64-apple-darwin/rulogman.app"

  # The bundle is ad-hoc signed, not notarized, so Gatekeeper refuses the
  # quarantined copy Homebrew downloads. The README's manual fix, done here.
  postflight do
    system_command "/usr/bin/xattr",
                   args:         ["-d", "-r", "com.apple.quarantine", "#{appdir}/rulogman.app"],
                   print_stderr: false
  end

  zap trash: [
    "~/Library/Application Support/com.aihouse.rulogman",
    "~/Library/Caches/com.aihouse.rulogman",
    "~/Library/Preferences/com.aihouse.rulogman.plist",
    "~/Library/Saved Application State/com.aihouse.rulogman.savedState",
  ]
end
