local function load_json(filepath)
    local file = io.open(filepath,"r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()

    return content
end

local function hex_to_rgba(hex, alpha)
    alpha = alpha or "ee"
    return string.format("rgba(%s%s)", hex, alpha)
end

local wal = {}
local wal_content = load_json(os.getenv("HOME") .. "/.cache/wal/colors.json")
if wal_content then
    for color, hex in wal_content:gmatch('"(color%d+)":%s*"#([%x]+)"') do
        wal[color] = hex
    end
end

local border_c4 = wal.color4 and hex_to_rgba(wal.color4) or "rgba(33ccffee)"
local border_c3 = wal.color3 and hex_to_rgba(wal.color3) or "rgba(7BC0E7ee)"
local border_c5 = wal.color5 and hex_to_rgba(wal.color5) or "rgba(00ff99ee)"
local border_inactive = wal.color8 and hex_to_rgba(wal.color8, "aa") or "rgba(595959aa)"

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = { colors = {border_c4, border_c3, border_c5}, angle = 45 },
            inactive_border = border_inactive,
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        rounding_power = 5,
        active_opacity = 1,
        inactive_opacity = 0.8,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },
        blur = {
            enabled = true,
            size = 10,
            passes = 3,
            vibrancy = 0.1696,
            ignore_opacity = true,
        },
    },
    animations = {
        enabled = true,
    },
dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
        },
    },

})