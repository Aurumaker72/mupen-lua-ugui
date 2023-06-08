function folder(thisFileName)
    if not thisFileName then
        thisFileName = "Main.lua"
    end

    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder('demos\\navigation.lua') .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)


local pages = {}
local selected_page_index = 0

local is_joystick_enabled = true

pages[1] = function()
    Mupen_lua_ugui.button({
        uid = 0,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 5,
            y = 100,
            width = 120,
            height = 30,
        },
        text = "Do something"
    })
end

pages[2] = function()
    Mupen_lua_ugui.joystick({
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
            y = (math.cos(os.clock() * 2) + 1) / 2
        }
    })

    is_joystick_enabled = Mupen_lua_ugui.toggle_button({
        uid = 2,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 5,
            y = 230,
            width = 100,
            height = 30,
        },
        text = "Joystick",
        is_checked = is_joystick_enabled
    })
end

emu.atupdatescreen(function()
    BreitbandGraphics.renderers.d2d.fill_rectangle({
        x = initial_size.width,
        y = 0,
        width = 200,
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





    local items = {}

    for i = 1, #pages, 1 do
        items[i] = "Page Nr. " .. i
    end

    selected_page_index = Mupen_lua_ugui.combobox({
        uid = 6000,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 5,
            y = 10,
            width = 190,
            height = 30,
        },
        items = items,
        selected_index = selected_page_index
    })

    pages[selected_page_index]()

    Mupen_lua_ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
