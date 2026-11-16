cask "rudbgen" do
  version "0.2.8"
  sha256 "7bc34ca9905f4543654b4e8adaa141bdd06689142b95ad78c681a0d64c0b4dd9"

  url "https://github.com/xcomart/rudbgen/releases/download/v#{version}/rudbgen-v#{version}-aarch64-apple-darwin.tar.gz"
  name "rudbgen"
  desc "Source code generator that renders JDBC database metadata through templates"
  homepage "https://github.com/xcomart/rudbgen"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on :macos

  app "rudbgen-v#{version}-aarch64-apple-darwin/rudbgen.app"

  # The bundle is ad-hoc signed, not notarized, so Gatekeeper refuses the
  # quarantined copy Homebrew downloads. The README's manual fix, done here.
  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-d", "-r", "com.apple.quarantine", "{{appdir}}/rudbgen.app"],
        must_succeed: false,
        print_stderr: false
  end

  zap trash: [
    "~/Library/Application Support/rudbgen",
    "~/Library/Caches/rudbgen",
    "~/Library/Preferences/com.aihouse.rudbgen.plist",
    "~/Library/Saved Application State/com.aihouse.rudbgen.savedState",
  ]
end
