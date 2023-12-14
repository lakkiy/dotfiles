{ config, lib, ... }:

{
  home.file."firefox-gnome-theme" = {
    target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
    source = (fetchTarball {
      url = "https://github.com/rafaelmardojai/firefox-gnome-theme/archive/master.tar.gz";
      sha256 = "080d4v3mlc9a4w5pdkyjmi06kcf5n4dpd0sv617gs93g86r9fx2a";
    });
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "Default";
      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "gnomeTheme.normalWidthTabs" = true;
        "gnomeTheme.tabsAsHeaderbar" = true;
        "browser.download.useDownloadDir" = true;
        "permissions.memory_only" = true;
        "signon.rememberSignons" = false;
        "browser.tabs.insertAfterCurrent" = true;
        "extensions.pocket.enabled" = false;
        "ui.systemUsesDarkTheme" = "1";
        "general.autoScroll" = true;
        "browser.tabs.inTitlebar" = "1";
        "browser.tabs.firefox-view" = false;
        "browser.bookmarks.addedImportButton" = true;
        "pref.general.disable_button.default_browser" = true;
      };
      userChrome = ''
          @import "firefox-gnome-theme/userChrome.css";
          @import "firefox-gnome-theme/theme/colors/dark.css";
        '';
    };
  };

}
