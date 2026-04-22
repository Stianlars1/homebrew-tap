cask "dotviewer" do
  version "1.3.0"
  sha256 "89a2a6c0859b1bfd82dfc83e11d820b30e53416cb8d1e4db2883ee94e94946de"

  url "https://github.com/stianlars1/dotViewer/releases/download/v#{version}/dotViewer-#{version}.dmg",
      verified: "github.com/stianlars1/dotViewer/"
  name "dotViewer"
  desc "Quick Look extension for syntax-highlighted source code previews"
  homepage "https://github.com/stianlars1/dotViewer"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates false
  depends_on macos: ">= :sequoia"

  app "dotViewer.app"

  postflight do
    # Register the Quick Look extensions with macOS so Finder picks them up
    # immediately, without requiring the user to launch dotViewer first.
    system_command "/usr/bin/pluginkit",
                   args: ["-e", "use", "-i", "com.stianlars1.dotViewer.QuickLookPreview"],
                   sudo: false
    system_command "/usr/bin/pluginkit",
                   args: ["-e", "use", "-i", "com.stianlars1.dotViewer.QuickLookThumbnail"],
                   sudo: false
    # Rebuild the Quick Look server cache so previews work right away.
    system_command "/usr/bin/qlmanage", args: ["-r"], sudo: false
  end

  uninstall quit:      "com.stianlars1.dotViewer",
            launchctl: "com.stianlars1.dotViewer"

  zap trash: [
    "~/Library/Group Containers/group.stianlars1.dotViewer.shared",
    "~/Library/Preferences/com.stianlars1.dotViewer.plist",
    "~/Library/Caches/com.stianlars1.dotViewer",
    "~/Library/Application Support/dotViewer",
    "~/Library/Saved Application State/com.stianlars1.dotViewer.savedState",
  ]
end
