function folder(thisFileName)
    if not thisFileName then
        thisFileName = "Main.lua"
    end

    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder('demo.lua') .. 'mupen-lua-ugui.lua')

emu.atvi(function()
    local keys = input.get()
    Mupen_lua_ugui.prepare_frame({
        pointer = {
            position = {
                x = keys.xmouse,
                y = keys.ymouse,
            },
            is_primary_down = keys.leftclick
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

    if is_pressed then
        print(math.random())
    end
end)
