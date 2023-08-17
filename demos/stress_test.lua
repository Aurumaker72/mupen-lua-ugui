local function folder(file)
    local s = debug.getinfo(2, "S").source:sub(2)
    local p = file:gsub("[%(%)%%%.%+%-%*%?%^%$]", "%%%0"):gsub("[\\/]", "[\\/]") .. "$"
    return s:gsub(p, "")
end

dofile(folder('demos\\stress_test.lua') .. 'mupen-lua-ugui.lua')

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

    for x = 1, 10, 1 do
        for y = 1, 30, 1 do
            Mupen_lua_ugui.button({
                uid = x * y,
                is_enabled = true,
                rectangle = {
                    x = initial_size.width + (x - 1) * 20,
                    y = (y - 1) * 20,
                    width = 20,
                    height = 20,
                },
                text = ':)',
            })
        end
    end



    Mupen_lua_ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
