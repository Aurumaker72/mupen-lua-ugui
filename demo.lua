function folder(thisFileName)
    if not thisFileName then
        thisFileName = "Main.lua"
    end

    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder('demo.lua') .. 'mupen-lua-ugui.lua')

text = "Sample text"
is_checked = true
position = {
    x = 0,
    y = 0,
}

emu.atvi(function()
    local keys = input.get()

    Mupen_lua_ugui.begin_frame({
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

    local is_pressed = Mupen_lua_ugui.button({
        uid = 0,
        is_enabled = true,
        rectangle = {
            x = 40,
            y = 90,
            width = 120,
            height = 40,
        },
        text = "Hello World!"
    });

    text = Mupen_lua_ugui.textbox({
        uid = 1,
        is_enabled = true,
        rectangle = {
            x = 40,
            y = 180,
            width = 120,
            height = 40,
        },
        text = text,
    });

    is_checked = Mupen_lua_ugui.toggle_button({
        uid = 2,
        is_enabled = true,
        rectangle = {
            x = 40,
            y = 230,
            width = 120,
            height = 40,
        },
        text = "Test",
        is_checked = is_checked,
    });

    Mupen_lua_ugui.joystick({
        uid = 3,
        is_enabled = true,
        rectangle = {
            x = 40,
            y = 340,
            width = 118,
            height = 118,
        },
        position = {
            x = joypad.get().X,
            y = -joypad.get().Y,
        },
    });
end)
