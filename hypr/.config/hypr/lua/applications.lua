terminal = "GTK_IM_MODULE=simple ghostty"
fileManager = "cosmic-files"
menu = "~/.config/rofi/launchers/app_drawer.sh || pkill rofi"
browser = "zen-browser"
browser_incognito = "zen-browser --private-window"
browser_tor = "brave --tor"
email = "thunderbird"

hl.on("hyprland.start", function()
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("dbus-update-activation-environment --all")
	hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
	hl.exec_cmd("waybar")
	hl.exec_cmd("swaync")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("pipewire")
	hl.exec_cmd("pipewire-pulse")
	hl.exec_cmd("wireplumber")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("flatpak run com.nextcloud.desktopclient.nextcloud --background")
end)
