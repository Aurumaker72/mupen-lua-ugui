function folder(thisFileName)
    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder("demos\\control_extensions_iconbutton.lua") .. "mupen-lua-ugui.lua")


Mupen_lua_ugui.iconbutton = function(control)
    local pushed = Mupen_lua_ugui.button(control)

    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x,
        y = control.rectangle.y,
        width = control.rectangle.width,
        height = control.rectangle.height,
    }, {
        x = 0,
        y = 0,
        width = 99999,
        height = 99999,
    }, control.icon, BreitbandGraphics.colors.white)

    return pushed
end

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

emu.atupdatescreen(function()
    BreitbandGraphics.renderers.d2d.fill_rectangle({
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

    Mupen_lua_ugui.begin_frame(BreitbandGraphics.renderers.d2d, Mupen_lua_ugui.stylers.windows_10, {
        pointer = {
            position = {
                x = keys.xmouse,
                y = keys.ymouse,
            },
            is_primary_down = keys.leftclick,
        },
        keyboard = {
            held_keys = keys,
        },
    })

    if Mupen_lua_ugui.iconbutton({
            uid = 0,
            is_enabled = true,
            rectangle = {
                x = initial_size.width + 10,
                y = 10,
                width = 80,
                height = 80,
            },
            icon = folder("control_extensions_iconbutton.lua") .. "res/image.png",
        }) then
        print("hi")
    end

    Mupen_lua_ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
