hl.bind("SUPER + W", hl.dsp.window.close())
hl.bind("SUPER + Q", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + space", hl.dsp.exec_cmd(menu))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("~/.config/waybar/launch.sh"))
hl.bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("loginctl reboot"))
hl.bind("SUPER + SHIFT + ALT + E", hl.dsp.exec_cmd("loginctl suspend"))
hl.bind("SUPER + SHIFT + ALT + P", hl.dsp.exec_cmd("loginctl poweroff"))
hl.bind("SUPER + SHIFT + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd("~/.config/rofi/launchers/wallpicker.sh"))
hl.bind("SUPER + ALT + M", hl.dsp.exec_cmd("~/.config/rofi/launchers/respicker.sh"))
hl.bind("SUPER + ALT + K", hl.dsp.exec_cmd("~/.config/rofi/launchers/keyboards.sh"))
hl.bind("SUPER + ALT + space", hl.dsp.exec_cmd("~/.config/rofi/launchers/main_launcher.sh"))
hl.bind("SUPER + I", hl.dsp.exec_cmd("~/.config/rofi/launchers/internet_search.sh"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("gnome-calendar"))

hl.bind("SUPER + B", hl.dsp.exec_cmd(browser))
hl.bind("SUPER + ALT + B", hl.dsp.exec_cmd(browser_incognito))
hl.bind("SUPER + ALT + CTRL + B", hl.dsp.exec_cmd(browser_tor))
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + F", hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER + E", hl.dsp.exec_cmd("thunderbird"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("Telegram"))
hl.bind("SUPER + ALT + N", hl.dsp.exec_cmd("~/.config/waybar/toggle_netpala.sh"))
hl.bind("SUPER + ALT + C", hl.dsp.exec_cmd("~/.config/waybar/toggle_bluetui.sh"))
hl.bind("SUPER + ALT + D", hl.dsp.exec_cmd("~/.config/waybar/toggle_wiremix.sh"))
hl.bind("SUPER + Y", hl.dsp.exec_cmd("GTK_IM_MODULE=simple ghostty -e yazi"))

hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
	hl.bind("SUPER + " .. (i % 10), hl.dsp.focus({ workspace = i }))
end

for i = 1, 10 do
	hl.bind("SUPER + SHIFT + " .. (i % 10), hl.dsp.window.move({ workspace = i }))
end

hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))

hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ repeating = true, locked = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { repeating = true, locked = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
