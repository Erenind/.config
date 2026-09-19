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
        class = "md.obsidian.Obsidian"
    },
    float = true,
    size = {tostring(obsidianWidth),tostring(obsidianHeight)}
})

hl.window_rule({
    match = {
        class = "code"
    },
    float = true,
    size = {tostring(obsidianWidth),tostring(obsidianHeight)}
})

hl.window_rule({
    match = {
        class = "kitty"
    },
    opaque = true

})

hl.window_rule({
    match = {
        title = "quickshell"
    },
    float = true;
})

hl.window_rule({
    match = {
        class = "org.keepassxc.KeePassXC"
    },
    float = true,
    size = {"10","10"}
})

hl.layer_rule({
    match = {
        namespace = "quickshell"
    },
    no_anim = true;
})
hl.window_rule({
    match = {
        class="wechat"
    },
    float=true,
    no_blur=true,
    border_size=0,
    no_shadow=true,
    rounding=0,
    opacity="1.0"
})
hl.window_rule({
    match = {
        title="微信"
    },
    float=true,
    no_blur=true,
    border_size=0,
    no_shadow=true,
    rounding=0,
    opacity="1.0"
})