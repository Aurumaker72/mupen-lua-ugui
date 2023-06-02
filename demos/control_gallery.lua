function folder(thisFileName)
    if not thisFileName then
        thisFileName = "Main.lua"
    end

    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder('demos\\control_gallery.lua') .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

emu.atupdatescreen(function()
    BreitbandGraphics.renderers.gdi.fill_rectangle({
        x = initial_size.width,
        y = 0,
        width = 200,
        height = initial_size.height
    }, {
        r = 0,
        g = 0,
        b = 0
    })

    local keys = input.get()

    Mupen_lua_ugui.begin_frame(BreitbandGraphics.renderers.gdi, Mupen_lua_ugui.stylers.windows_10, {
        pointer = {
            position = {
                x = keys.xmouse,
                y = keys.ymouse,
            },
            is_primary_down = keys.leftclick
        },
        keyboard = {
            held_keys = keys
        }
    })

    Mupen_lua_ugui.button({
        uid = 0,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 10,
            width = 90,
            height = 30,
        },
        text = "Test"
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
            text = "Test"
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
        text = "Test"
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
        text = "Test"
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
            "Test"
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
            "Test"
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
        value = 0
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
        value = 0
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
            "Test",
            "Item"
        }
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
            "Test",
            "Item"
        }
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
        }
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
        }
    })
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
