#!/usr/bin/env bash

# see https://randthoughts.github.io/random-wallpaper-with-just-bash-and-systemd/

# goto https://unsplash.com/developers to get your ak, and add to env
ACCESS_KEY="${UNSPLASHACCESSKEY}"
TOPIC="bo8jQKTaE0Y" # "Wallpapers"
WALLPAPER_DIR="${HOME}/.local/share/backgrounds" # TODO mkdir if not exist

if ! photo_path="$(mktemp -p "${WALLPAPER_DIR}" "unsplash.com.XXXXXXXXXX.jpg")"
then
  >&2 echo "Error: failed to create temporary file."
  exit 1
fi

if ! photo_url="$(curl --silent --show-error --header "Authorization: Client-ID ${ACCESS_KEY}" \
  "https://api.unsplash.com/photos/random?orientation=landscape&topic=${TOPIC}" \
  | grep --ignore-case --only-matching --perl-regexp '(?<=download":").*?(?=")')"
then
  >&2 echo "Error: failed to retrieve download URL."
  exit 1
fi

if ! curl --silent --show-error --location --header "Authorization: Client-ID ${ACCESS_KEY}" \
  --output "${photo_path}" "${photo_url}"
then
  >&2 echo "Error: failed to download photo."
  exit 1
fi

case $XDG_CURRENT_DESKTOP in
    "i3")
        feh --bg-fill "${photo_path}"
        ;;
    "MATE")
        dconf write /org/mate/desktop/background/picture-filename "'${photo_path}'"
        ;;
    "GNOME")
        for setting_name in "background" "screensaver"; do
            if ! gsettings set "org.gnome.desktop.${setting_name}" "picture-uri" "file:///${photo_path}"
            then
                >&2 echo "Error: failed to set photo as ${setting_name}."
                exit 1
            fi
        done
        ;;
    "KDE")
        qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
    var allDesktops = desktops();
    print (allDesktops);
    for (i=0;i<allDesktops.length;i++) {{
        d = allDesktops[i];
        d.wallpaperPlugin = "org.kde.image";
        d.currentConfigGroup = Array("Wallpaper",
                                     "org.kde.image",
                                     "General");
        d.writeConfig("Image", "file:///${photo_path}")
    }}
'
        ;;
esac
