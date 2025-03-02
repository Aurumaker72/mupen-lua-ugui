local path_root = debug.getinfo(1).short_src:gsub("\\[^\\]+\\[^\\]+$", "\\")

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "mupen-lua-ugui"
ugui = dofile(path_root .. 'mupen-lua-ugui.lua')

local mouse_wheel = 0
local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

emu.atdrawd2d(function()
    BreitbandGraphics.fill_rectangle({
        x = initial_size.width,
        y = 0,
        width = 200,
        height = initial_size.height,
    }, {
        r = 253,
        g = 253,
        b = 253,
    })

    local keys = input.get()
    ugui.begin_frame( {
        mouse_position = {
            x = keys.xmouse,
            y = keys.ymouse,
        },
        wheel = mouse_wheel,
        is_primary_down = keys.leftclick,
        held_keys = keys,
    })
    mouse_wheel = 0

    local i = 0
    for x = 1, 10, 1 do
        for y = 1, 30, 1 do
            ugui.button({
                uid = i,
                rectangle = {
                    x = initial_size.width + (x - 1) * 20,
                    y = (y - 1) * 20,
                    width = 20,
                    height = 20,
                },
                text = ':)',
            })
            i = i + 1
        end
    end



    ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
emu.atwindowmessage(function(_, msg_id, wparam, _)
    if msg_id == 522 then
        local scroll = math.floor(wparam / 65536)
        if scroll == 120 then
            mouse_wheel = 1
        elseif scroll == 65416 then
            mouse_wheel = -1
        end
    end
end)
