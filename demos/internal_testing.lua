local function folder(file)
    local s = debug.getinfo(2, 'S').source:sub(2)
    local p = file:gsub('[%(%)%%%.%+%-%*%?%^%$]', '%%%0'):gsub('[\\/]', '[\\/]') .. '$'
    return s:gsub(p, '')
end

local items = {}
for i = 1, 1000, 1 do
    items[#items + 1] = 'Item ' .. i
end
local mouse_wheel = 0
dofile(folder('demos\\internal_testing.lua') .. 'mupen-lua-ugui.lua')
local initial_size = wgui.info()
local selected_index = 1
local selected_index_2 = 1
local text = 'a'

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

    selected_index = ugui.combobox({
        uid = 0,
        rectangle = {
            x = initial_size.width + 5,
            y = 5,
            width = 90,
            height = 20,
        },
        items = items,
        selected_index = selected_index,
    })

    if ugui.button({
            uid = 123,
            rectangle = {
                x = initial_size.width + 100,
                y = 5,
                width = 90,
                height = 20,
            },
            text = 'a',
        }) then
        print(math.random())
    end

    selected_index_2 = ugui.listbox({
        uid = 555,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 5,
            y = 80,
            width = 150,
            height = 83,
        },
        items = items,
        selected_index = selected_index_2,
        horizontal_scroll = false
    })

    text = ugui.textbox({
        uid = 5255,
        rectangle = {
            x = initial_size.width + 5,
            y = 30,
            width = 140,
            height = 20,
        },
        text = text,
    })

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
