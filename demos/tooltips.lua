local path_root = debug.getinfo(1).source:sub(2):gsub("\\[^\\]+\\[^\\]+$", "\\")

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "mupen-lua-ugui"
ugui = dofile(path_root .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
local mouse_wheel = 0

emu.atdrawd2d(function()
    BreitbandGraphics.fill_rectangle({
        x = 0,
        y = 0,
        width = wgui.info().width,
        height = wgui.info().height,
    }, {
        r = 253,
        g = 253,
        b = 253,
    })

    local keys = input.get()
    ugui.begin_frame({
        mouse_position = {
            x = keys.xmouse,
            y = keys.ymouse,
        },
        wheel = mouse_wheel,
        is_primary_down = keys.leftclick,
        held_keys = keys,
        window_size = {
            x = wgui.info().width,
            y = wgui.info().height,
        },
    })
    mouse_wheel = 0

    ugui.combobox({
        uid = 1,
        rectangle = {x = 10, y = 10, width = 90, height = 20},
        items = {
            "Hello",
            "Hello",
            "Hello",
            "Hello",
            "Hello",
        },
        selected_index = 1,
        tooltip = 'i have a tooltip too wow',
    })

    ugui.button({
        uid = 3,
        rectangle = {x = 0, y = 35, width = 800, height = 20},
        text = 'Hover Here',
        tooltip = 'Hello World!',
    })

    ugui.button({
        uid = 4,
        rectangle = {x = 10, y = 60, width = 90, height = 20},
        text = 'Hover Here',
        tooltip = 'Voluptas culpa officia consequatur eveniet. Sint fugiat culpa rerum debitis. Et ea cupiditate nulla eius saepe minima. Aspernatur omnis ut amet incidunt sequi doloremque corrupti. Corrupti vero quae rerum est recusandae perferendis.',
    })

    ugui.button({
        uid = 76,
        rectangle = {x = 10, y = 90, width = 90, height = 20},
        text = 'Im boring',
    })

    ugui.button({
        uid = 80,
        rectangle = {x = 10, y = 120, width = 90, height = 20},
        is_enabled = false,
        text = 'nope',
        tooltip = "!!!"
    })

    ugui.button({
        uid = 5,
        rectangle = {x = 700, y = 540, width = 90, height = 50},
        text = 'Hover Here',
        tooltip = 'Wow.',
    })

    ugui.end_frame()
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
