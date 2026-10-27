cask "dotviewer" do
  version "1.5.8"
  sha256 "1e3dbc6314036a1eaff4cebfd659335251b6041f55efca96e9147837352bdaa3"

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
