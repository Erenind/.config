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
    match = {class = "terraria"},
    immediate = true
})

hl.window_rule({
    match = {
        class = "waypaper"
    },
    float = true
})


local obsidianWidth = 1920 * 0.7
local obsidianHeight = obsidianWidth * 0.618


hl.window_rule({
    match = {
        class = "obsidian"
    },
    float = true,
    size = {tostring(obsidianWidth),tostring(obsidianHeight)}
})
