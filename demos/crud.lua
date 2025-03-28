local path_root = debug.getinfo(1).source:sub(2):gsub("\\[^\\]+\\[^\\]+$", "\\")

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "mupen-lua-ugui"
ugui = dofile(path_root .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

local mouse_wheel = -1
local text = ''
local items = {}
local selected_list_index = 1
local priorities = {
    'Low',
    'Medium',
    'High',
}
local is_editing = false

local function is_selection_valid()
    return (selected_list_index and selected_list_index > 0 and selected_list_index <= #items)
end

local function get_safe_selected_list_index()
    local i = selected_list_index
    i = math.min(selected_list_index, #items)
    i = math.max(selected_list_index, 1)
    return i
end

emu.atdrawd2d(function()
    BreitbandGraphics.fill_rectangle({
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
    ugui.begin_frame({
        mouse_position = {
            x = keys.xmouse,
            y = keys.ymouse,
        },
        wheel = mouse_wheel,
        is_primary_down = keys.leftclick,
        held_keys = keys,
    })
    mouse_wheel = 0

    text = ugui.textbox({
        uid = 1,
        rectangle = {
            x = initial_size.width + 10,
            y = 10,
            width = 150,
            height = 20,
        },
        text = text,
    })

    if (ugui.button({
            uid = 2,
            is_enabled = text:len() > 0,
            rectangle = {
                x = initial_size.width + 170,
                y = 10,
                width = 20,
                height = 20,
            },
            text = '+',
        })) then
        items[#items + 1] = {
            text = text,
            priority = 1,
        }

        text = ''
    end


    local list_items = {}
    for i = 1, #items, 1 do
        list_items[i] = priorities[items[i].priority] .. ' - ' .. items[i].text
    end

    selected_list_index = ugui.listbox({
        uid = 5,
        rectangle = {
            x = initial_size.width + 10,
            y = 40,
            width = 180,
            height = 200,
        },
        selected_index = selected_list_index,
        items = list_items,
    })

    if (ugui.button({
            uid = 10,
            is_enabled = is_selection_valid(),
            rectangle = {
                x = initial_size.width + 10,
                y = 250,
                width = 85,
                height = 20,
            },
            text = 'Delete',
        })) then
        table.remove(items, selected_list_index)
    end

    is_editing = ugui.toggle_button({
        uid = 15,
        is_enabled = is_selection_valid(),
        rectangle = {
            x = initial_size.width + 105,
            y = 250,
            width = 85,
            height = 20,
        },
        text = 'Edit',
        is_checked = is_editing,
    })


    local priority_selection_index = ugui.combobox({
        uid = 20,
        is_enabled = is_selection_valid() and is_editing,
        rectangle = {
            x = initial_size.width + 10,
            y = 280,
            width = 180,
            height = 20,
        },
        selected_index = is_selection_valid() and items[get_safe_selected_list_index()].priority or 1,
        items = priorities,
    })

    if is_selection_valid() then
        items[selected_list_index].priority = priority_selection_index
    end

    local text = ugui.textbox({
        uid = 25,
        is_enabled = is_selection_valid() and is_editing,
        rectangle = {
            x = initial_size.width + 10,
            y = 310,
            width = 180,
            height = 20,
        },
        text = is_selection_valid() and items[selected_list_index].text or '',
    })
    
    if is_selection_valid() then
        items[selected_list_index].text = text
    end

    ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)

emu.atwindowmessage(function(_, msg_id, wparam, _)
    if msg_id == 522 then
        local scroll = math.floor(wparam / 65536)
        if scroll == 120 then
            mouse_wheel = 1
        elseif scroll == 65416 then
            mouse_wheel = -1
        end
    end
end)
