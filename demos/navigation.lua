local path_root = debug.getinfo(1).source:sub(2):gsub("\\[^\\]+\\[^\\]+$", "\\")

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "mupen-lua-ugui"
ugui = dofile(path_root .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)


local pages = {}
local selected_page_index = 1
local mouse_wheel = 0
local is_joystick_enabled = true

pages[1] = function()
    ugui.button({
        uid = 0,

        rectangle = {
            x = initial_size.width + 5,
            y = 100,
            width = 120,
            height = 30,
        },
        text = 'Do something',
    })
end

pages[2] = function()
    ugui.joystick({
        uid = 1,
        is_enabled = is_joystick_enabled,
        rectangle = {
            x = initial_size.width + 5,
            y = 100,
            width = 100,
            height = 100,
        },
        position = {
            x = (math.sin(os.clock() * 2) + 1) / 2,
            y = (math.cos(os.clock() * 2) + 1) / 2,
        },
        mag = 0,
    })

    is_joystick_enabled = ugui.toggle_button({
        uid = 2,

        rectangle = {
            x = initial_size.width + 5,
            y = 230,
            width = 100,
            height = 30,
        },
        text = 'Joystick',
        is_checked = is_joystick_enabled,
    })
end

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
    ugui.begin_frame({
        mouse_position = {
            x = keys.xmouse,
            y = keys.ymouse,
        },
        wheel = mouse_wheel,
        is_primary_down = keys.leftclick,
        held_keys = keys,
    })
    mouse_wheel = 0

    local items = {}

    for i = 1, #pages, 1 do
        items[i] = 'Page Nr. ' .. i
    end

    selected_page_index = ugui.combobox({
        uid = 6000,

        rectangle = {
            x = initial_size.width + 5,
            y = 10,
            width = 80,
            height = 20,
        },
        items = items,
        selected_index = selected_page_index,
    })

    selected_page_index = ugui.carrousel_button({
        uid = 60001,

        rectangle = {
            x = initial_size.width + 5,
            y = 40,
            width = 190,
            height = 20,
        },
        items = items,
        selected_index = selected_page_index,
    })

    pages[selected_page_index]()

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
