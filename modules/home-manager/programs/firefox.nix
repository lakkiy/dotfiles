{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.my.firefox;

in {
  options.my.firefox = {
    enable = mkEnableOption "firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.default = {
        name = "Default";
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "gnomeTheme.normalWidthTabs" = true;
          "gnomeTheme.tabsAsHeaderbar" = true;
          "browser.download.useDownloadDir" = true;
          "permissions.memory_only" = true;
          "signon.rememberSignons" = false;
          "extensions.pocket.enabled" = false;
          "general.autoScroll" = true;
          "browser.tabs.inTitlebar" = "1";
          "browser.tabs.firefox-view" = false;
          "browser.bookmarks.addedImportButton" = true;
          "pref.general.disable_button.default_browser" = true;
        };
        # grub from https://github.com/ranmaru22/firefox-vertical-tabs/blob/main/userChrome.css
        userChrome = builtins.readFile ../../../static/firefox/chrome/userChrome.css;
      };
    };
  };
}
