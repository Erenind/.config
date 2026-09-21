local terminal = "kitty"
local fileManager = "dolphin"
local menu = "rofi -show drun -show-icons"
-- local menu = "hyprlauncher"
local mainMod = "SUPER"
local floatWindowWidth = 1920 * 0.6
local floatWindowHeight = floatWindowWidth * 0.618

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.resize({ x=floatWindowWidth, y=floatWindowHeight }))
    hl.dispatch(hl.dsp.window.center())
end)
-- hl.bind(mainMod .. "+ SHIFT + Return", function()
--     hl.dispatch(hl.dsp.exec_cmd(terminal))
--     hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
--     hl.dispatch(hl.dsp.window.resize({ x=1920 * 0.5, y=1080 * 0.6 }))
--     hl.dispatch(hl.dsp.window.center())
-- end)
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + M", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("qs ipc call volume volume up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("qs ipc call volume volume down"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("qs ipc call volume volume mute"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("qs ipc call brightness brightness up"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("qs ipc call brightness brightness down"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 20 0"),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -20 0"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -20"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 20"),  { repeating = true })

hl.bind(mainMod .. " + Y",         hl.dsp.exec_cmd("waypaper --random"))
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.exec_cmd("waypaper"))

hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("hyprshot -m window -m region --clipboard-only"))

hl.bind(mainMod .. " + F",         hl.dsp.exec_cmd("hyprctl dispatch fullscreenstate 1"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 0"))

hl.bind(mainMod .. " + U", hl.dsp.exec_cmd("qs ipc call volume volume up"), { repeating = true })
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("qs ipc call volume volume down"),      { repeating = true })
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.exec_cmd("qs ipc call volume volume mute"))

hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("qs ipc call brightness brightness up"),   { repeating = true })
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("qs ipc call brightness brightness down"), { repeating = true })

-- lock
hl.bind(mainMod .. " + L",hl.dsp.exec_cmd("hyprlock"))
