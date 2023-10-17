local function folder(file)
    local s = debug.getinfo(2, 'S').source:sub(2)
    local p = file:gsub('[%(%)%%%.%+%-%*%?%^%$]', '%%%0'):gsub('[\\/]', '[\\/]') .. '$'
    return s:gsub(p, '')
end

dofile(folder('demos\\control_gallery.lua') .. 'mupen-lua-ugui.lua')

local mouse_wheel = 0
local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

emu.atupdatescreen(function()
    BreitbandGraphics.fill_rectangle({
        x = initial_size.width,
        y = 0,
        width = 200,
        height = initial_size.height,
    }, {
        r = 0,
        g = 0,
        b = 0,
    })

    local keys = input.get()
    Mupen_lua_ugui.begin_frame(BreitbandGraphics, Mupen_lua_ugui.stylers.windows_10, {
        mouse_position = {
            x = keys.xmouse,
            y = keys.ymouse,
        },
        wheel = mouse_wheel,
        is_primary_down = keys.leftclick,
        held_keys = keys,
    })
    mouse_wheel = 0

    Mupen_lua_ugui.button({
        uid = 0,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 10,
            width = 90,
            height = 30,
        },
        text = 'Test',
    })

    if (Mupen_lua_ugui.button({
            uid = 1,
            is_enabled = false,
            rectangle = {
                x = initial_size.width + 100,
                y = 10,
                width = 90,
                height = 30,
            },
            text = 'Test',
        })) then
        print('a')
    end

    Mupen_lua_ugui.textbox({
        uid = 2,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 50,
            width = 90,
            height = 30,
        },
        text = 'Test',
    })

    Mupen_lua_ugui.textbox({
        uid = 3,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 100,
            y = 50,
            width = 90,
            height = 30,
        },
        text = 'Test',
    })

    Mupen_lua_ugui.combobox({
        uid = 4,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 90,
            width = 90,
            height = 30,
        },
        items = {
            'Test',
        },
        selected_index = 1,
    })

    Mupen_lua_ugui.combobox({
        uid = 5,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 100,
            y = 90,
            width = 90,
            height = 30,
        },
        items = {
            'Test',
        },
        selected_index = 1,
    })

    Mupen_lua_ugui.trackbar({
        uid = 6,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 130,
            width = 90,
            height = 30,
        },
        value = 0,
    })

    Mupen_lua_ugui.trackbar({
        uid = 7,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 100,
            y = 130,
            width = 90,
            height = 30,
        },
        value = 0,
    })


    Mupen_lua_ugui.listbox({
        uid = 8,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 170,
            width = 90,
            height = 30,
        },
        selected_index = 1,
        items = {
            'Test',
            'Item',
        },
    })

    Mupen_lua_ugui.listbox({
        uid = 9,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 100,
            y = 170,
            width = 90,
            height = 30,
        },
        selected_index = 1,
        items = {
            'Test',
            'Item',
        },
    })

    Mupen_lua_ugui.joystick({
        uid = 10,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 210,
            width = 90,
            height = 90,
        },
        position = {
            x = 0,
            y = 0.5,
        },
    })

    Mupen_lua_ugui.joystick({
        uid = 11,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 100,
            y = 210,
            width = 90,
            height = 90,
        },
        position = {
            x = 1,
            y = 0.5,
        },
    })


    Mupen_lua_ugui.end_frame()
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
