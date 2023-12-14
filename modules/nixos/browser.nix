{ config, lib, ... }:

let
  # To add new extensions in Firefox:
  # 1. Add the extension to Firefox.
  # 2. To to `about:memory` -> `Measure` -> search for Extensions
  # 3. Locate Extension(id={...}, name="...", baseURL=moz-extension://.../)
  # 4. Yoink the extension ID to use as key.
  # 5. Go to the Firefox extension page and derive the value from the
  # DL link.
  # 6. Or go to about:debugging#/runtime/this-firefox
  extensions = {
    # subscribe rss
    "i@diygod.me" = "rsshub-radar";
    # black list
    "@ublacklist" = "ublacklist";
    # scripts
    "firefox@tampermonkey.net" = "tampermonkey";
    # Content blocker.
    "uBlock0@raymondhill.net" = "ublock-origin";
    # Mark (skip) sponsored & other video segments on YouTube.
    "sponsorBlocker@ajay.app" = "sponsorblock";
    # subscribe rss
    "treestyletab@piro.sakura.ne.jp" = "tree-style-tab";
    # 划词翻译
    "{0982b844-4f35-48b7-9811-6832d916f21c}" = "hcfy";
    # CAPTCHA Solver
    "{2f67aecb-5dac-4f76-9378-0ac4f2bedc9c}" = "noptcha";
    # bitwarden password manager
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
    # mouse gestures
    "{506e023c-7f2b-40a3-8066-bc5deb40aebe}" = "gesturefy";
    # base64 decoder
    "{b20e4f00-ab03-4a88-90e7-4f6b6232c5a9}" = "base64-decoder";
  };
in
{
  programs.firefox.enable = true;

  programs.firefox.policies = {
    # List of webextensions to install.
    ExtensionSettings =
      lib.mapAttrs
        (_: name: {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
        })
        extensions;#  // {
        #   installation_mode = "normal_installed";
        #   install_url = "https://github.com/pt-plugins/PT-Plugin-Plus/releases/download/v1.6.1.2353/PT-Plugin-Plus-1.6.1.2353.xpi";
        # };

    # TODO Webextension configuration.
    # "3rdparty".Extensions = {};
  };

  programs.firefox.preferences = {
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
}
