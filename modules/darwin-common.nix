{
  pkgs,
  lib,
  config,
  ...
}:{
  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadRightClick = true;
  system.defaults.trackpad.Dragging = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;

  system.defaults.NSGlobalDomain.AppleShowAllFiles = true;
  system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain."com.apple.sound.beep.volume" = 0.4723665;
  system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true;

  system.defaults.dock.minimize-to-application = true;
  system.defaults.dock.autohide = true;

  system.defaults.screencapture.location = "~/Pictures";
  system.defaults.screencapture.show-thumbnail = true;
  system.defaults.screencapture.target = "clipboard" ;

  system.defaults.finder.AppleShowAllFiles = true;
  system.defaults.finder.ShowStatusBar = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.FXDefaultSearchScope = "SCcf";
  system.defaults.finder.FXPreferredViewStyle = "Nlsv";
  system.defaults.finder.QuitMenuItem = true;
}
