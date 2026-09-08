cask "dotviewer" do
  version "1.5.3"
  sha256 "b76733f665bddfbaec68a27753534bf39ef61dc2dc735de4321dac9f6e17f5b0"

  url "https://github.com/stianlars1/dotViewer/releases/download/v#{version}/dotViewer-#{version}.dmg"
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

  uninstall launchctl: "com.stianlars1.dotViewer",
            quit:      "com.stianlars1.dotViewer"

  zap trash: [
    "~/Library/Application Support/dotViewer",
    "~/Library/Caches/com.stianlars1.dotViewer",
    "~/Library/Group Containers/group.stianlars1.dotViewer.shared",
    "~/Library/Preferences/com.stianlars1.dotViewer.plist",
    "~/Library/Saved Application State/com.stianlars1.dotViewer.savedState",
  ]
end
