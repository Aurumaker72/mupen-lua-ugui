local function folder(file)
    local s = debug.getinfo(2, 'S').source:sub(2)
    local p = file:gsub('[%(%)%%%.%+%-%*%?%^%$]', '%%%0'):gsub('[\\/]', '[\\/]') .. '$'
    return s:gsub(p, '')
end

dofile(folder('demos\\ugui_ext.lua') .. 'mupen-lua-ugui.lua')
dofile(folder('demos\\ugui_ext.lua') .. 'mupen-lua-ugui-ext.lua')

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

local mouse_wheel = 0

local value = 5
local selected_index = 1

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

    value = ugui.spinner({
        uid = 1,
        rectangle = {
            x = initial_size.width + 5,
            y = 10,
            width = 190,
            height = 25,
        },
        value = value,
    })

    local result = ugui.tabcontrol({
        uid = 5,
        rectangle = {
            x = initial_size.width + 5,
            y = 40,
            width = 190,
            height = 200,
        },
        items = {
            'ABC',
            'DEFGHI',
            'JKL',
        },
        selected_index = selected_index,
    })

    selected_index = result.selected_index

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
