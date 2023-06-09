function folder(thisFileName)
    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder('demos\\internal_testing.lua') .. 'mupen-lua-ugui.lua')

local text = "Sample text"
local is_checked = true
local value = 0
local selected_index = 0
local input_state = {}
local many_values = {}
local other_selected_index = nil

for i = 1, 1000, 1 do
    many_values[#many_values + 1] = "Item " .. i
end

emu.atupdatescreen(function()
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

    local is_pressed = Mupen_lua_ugui.button({
        uid = 0,
        is_enabled = true,
        rectangle = {
            x = 300,
            y = 60,
            width = 120,
            height = 40,
        },
        text = "This text is long and will overflow"
    })

    if is_pressed then
        many_values[#many_values + 1] = "new item"
    end

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
    })

    is_checked = Mupen_lua_ugui.toggle_button({
        uid = 2,
        is_enabled = true,
        rectangle = {
            x = 40,
            y = 230,
            width = 120,
            height = 40,
        },
        text = selected_index,
        is_checked = is_checked,
    })

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
            x = 0,
            y = 0,
        },
    })

    value = Mupen_lua_ugui.trackbar({
        uid = 4,
        is_enabled = true,
        rectangle = {
            x = 200,
            y = 100,
            width = 20,
            height = 200,
        },
        value = value
    })


    selected_index = Mupen_lua_ugui.combobox({
        uid = 5,
        is_enabled = true,
        rectangle = {
            x = 300,
            y = 20,
            width = 120,
            height = 30,
        },
        items = {
            "Item A",
            "Test",
            "Hey"
        },
        selected_index = selected_index,
    })


    other_selected_index = Mupen_lua_ugui.listbox({
        uid = 6,
        is_enabled = true,
        rectangle = {
            x = 500,
            y = 20,
            width = 120,
            height = 340,
        },
        items = many_values,
        selected_index = other_selected_index,
    })

    Mupen_lua_ugui.button({
        uid = 7,
        is_enabled = true,
        rectangle = {
            x = 500,
            y = 380,
            width = 120,
            height = 40,
        },
        text = other_selected_index
    })

    Mupen_lua_ugui.end_frame()
end)
