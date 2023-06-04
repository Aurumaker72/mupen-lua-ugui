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
local selected_list_index = 1
local priorities = {
    "Low",
    "Medium",
    "High"
}

local function is_selection_valid()
    return (selected_list_index and selected_list_index > 0 and selected_list_index <= #items)
end

local function get_safe_selected_list_index()
    local i = selected_list_index
    i = math.min(selected_list_index, #items)
    i = math.max(selected_list_index, 1)
    return i
end

emu.atupdatescreen(function()
    BreitbandGraphics.renderers.gdi.fill_rectangle({
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
        items[#items + 1] = {
            text = text,
            priority = 1,
        }

        text = ""
    end


    local list_items = {}
    for i = 1, #items, 1 do
        list_items[i] = priorities[items[i].priority] .. " - " .. items[i].text
    end

    selected_list_index = Mupen_lua_ugui.listbox({
        uid = 3,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 40,
            width = 180,
            height = 200,
        },
        selected_index = selected_list_index,
        items = list_items,
    })

    if (Mupen_lua_ugui.button({
            uid = 3,
            is_enabled = is_selection_valid(),
            rectangle = {
                x = initial_size.width + 10,
                y = 250,
                width = 180,
                height = 20,
            },
            text = is_selection_valid() and
                "Delete" or "No selection",
        })) then
        table.remove(items, selected_list_index)
    end


    local priority_selection_index = Mupen_lua_ugui.combobox({
        uid = 4,
        is_enabled = is_selection_valid(),
        rectangle = {
            x = initial_size.width + 10,
            y = 280,
            width = 180,
            height = 20,
        },
        selected_index = is_selection_valid() and items[get_safe_selected_list_index()].priority or 1,
        items = priorities
    })

    if is_selection_valid() then
        items[selected_list_index].priority = priority_selection_index
    end


    Mupen_lua_ugui.end_frame()
end)


emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
