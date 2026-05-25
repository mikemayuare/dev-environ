hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name = "netpala-float",
    match = { title = "^(netpala)$" },
    float = true,
    size = { 1200, 1000 },
})

hl.window_rule({
    name = "blutui-float",
    match = { title = "^(bluetui)$" },
    float = true,
    size = { 900, 1000 },
})

hl.window_rule({
    name = "wiremix-float",
    match = { title = "^(wiremix)$" },
    float = true,
    size = { 1200, 800 },
})

hl.window_rule({
    name = "cosmic-float",
    match = { class = "^(com.system76.CosmicFilesDialog)$" },
    float = true,
    center = true,
})

hl.window_rule({
    name = "steam-float",
    match = { title = "^(Friend List)$" },
    float = true,
    center = true,
})
