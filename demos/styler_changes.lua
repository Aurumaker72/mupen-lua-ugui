function folder(thisFileName)
    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder('demos\\styler_changes.lua') .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
wgui.resize(initial_size.width + 250, initial_size.height)



Mupen_lua_ugui.stylers.windows_10.draw_raised_frame = function(control, visual_state)
    local back_color = {
        r = 253,
        g = 253,
        b = 253
    }
    local border_color = {
        r = 208,
        g = 208,
        b = 208
    }
    if visual_state == Mupen_lua_ugui.visual_states.active then
        back_color = {
            r = 204,
            g = 228,
            b = 247
        }
        border_color = {
            r = 0,
            g = 84,
            b = 153
        }
    elseif visual_state == Mupen_lua_ugui.visual_states.hovered then
        back_color = {
            r = 229,
            g = 241,
            b = 251
        }
        border_color = {
            r = 0,
            g = 84,
            b = 153
        }
    elseif visual_state == Mupen_lua_ugui.visual_states.disabled then
        back_color = {
            r = 249,
            g = 249,
            b = 249
        }
        border_color = {
            r = 233,
            g = 233,
            b = 233
        }
    end

    Mupen_lua_ugui.renderer.draw_rounded_rectangle(control.rectangle,
        border_color, {
            x = 4,
            y = 4
        }, 2)
    Mupen_lua_ugui.renderer.fill_rounded_rectangle(control.rectangle,
        back_color, {
            x = 4,
            y = 4
        })
    Mupen_lua_ugui.renderer.fill_rectangle({
            x = control.rectangle.x,
            y = control.rectangle.y + control.rectangle.height - 0.5,
            width = control.rectangle.width,
            height = 0.5,
        },
        {
            r = 186,
            g = 186,
            b = 186
        })
end

emu.atupdatescreen(function()
    BreitbandGraphics.renderers.d2d.fill_rectangle({
        x = initial_size.width,
        y = 0,
        width = 250,
        height = initial_size.height
    }, {
        r = 253,
        g = 253,
        b = 253
    })

    local keys = input.get()

    Mupen_lua_ugui.begin_frame(BreitbandGraphics.renderers.d2d, Mupen_lua_ugui.stylers.windows_10, {
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
            x = initial_size.width + 10,
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
                x = initial_size.width + 10 + 100,
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
            x = initial_size.width + 10,
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
            x = initial_size.width + 10 + 100,
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
            x = initial_size.width + 10,
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
            x = initial_size.width + 10 + 100,
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
            x = initial_size.width + 10,
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
            x = initial_size.width + 10 + 100,
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
            x = initial_size.width + 10,
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
            x = initial_size.width + 10 + 100,
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
            x = initial_size.width + 10,
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
            x = initial_size.width + 10 + 100,
            y = 210,
            width = 90,
            height = 90,
        },
        position = {
            x = 1,
            y = 0.5,
        }
    })


    Mupen_lua_ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
