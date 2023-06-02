function folder(thisFileName)
    if not thisFileName then
        thisFileName = "Main.lua"
    end

    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder('demos\\todo_app.lua') .. 'mupen-lua-ugui.lua')
local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)



local text = ""
local items = {}
local selected_index = nil

emu.atupdatescreen(function()
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


    text = Mupen_lua_ugui.textbox({
        uid = 1,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 10,
            width = 150,
            height = 20,
        },
        text = text,
    })

    if (Mupen_lua_ugui.button({
            uid = 2,
            is_enabled = text:len() > 0,
            rectangle = {
                x = initial_size.width + 170,
                y = 10,
                width = 20,
                height = 20,
            },
            text = "+",
        })) then
        items[#items + 1] = text
        text = ""
    end

    selected_index = Mupen_lua_ugui.listbox({
        uid = 3,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 40,
            width = 180,
            height = 200,
        },
        selected_index = selected_index,
        items = items,
    })
    local has_selection = (selected_index and selected_index > 0 and selected_index <= #items)
    if (Mupen_lua_ugui.button({
            uid = 3,
            is_enabled = has_selection,
            rectangle = {
                x = initial_size.width + 10,
                y = 250,
                width = 180,
                height = 20,
            },
            text = has_selection and
                ("Delete \"" .. items[selected_index] .. "\"") or "No selection",
        })) then
        if selected_index and selected_index > 0 and selected_index <= #items then
            table.remove(items, selected_index)
        end
    end
end)


emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
