hl.config({
    ecosystem = {
        enforce_permissions = true,
    },
})

hl.permission("/usr/bin/hyprlock", "screencopy", "allow")
hl.permission("/usr/bin/grim", "screencopy", "allow")
hl.permission("/usr/lib/xdg-desktop-portal-hyprland", "screencopy", "allow")
hl.permission("/usr/bin/hyprpm", "plugin", "allow")
