cask "rudbgen" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.9"
  sha256 arm:   "e01e0472f22df73a292e1ff6973b9b3d1ca2954143b6e0b66c90885d1dd3f93a",
         intel: "5e8bb6f0508fbca897da00b57f1f502dbdbc6fde158f52b9fdbd696f1939bddb"

  url "https://github.com/xcomart/rudbgen/releases/download/v#{version}/rudbgen-v#{version}-#{arch}-apple-darwin.tar.gz"
  name "rudbgen"
  desc "Source code generator that renders JDBC database metadata through templates"
  homepage "https://github.com/xcomart/rudbgen"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :big_sur

  app "rudbgen-v#{version}-#{arch}-apple-darwin/rudbgen.app"

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
