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
    # only need these two extensions, others will sync after login.
    "treestyletab@piro.sakura.ne.jp" = "tree-style-tab";
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
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
        extensions;
  };
}
