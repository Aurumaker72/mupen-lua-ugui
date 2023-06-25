function folder(thisFileName)
    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder("demos\\memory_watch.lua") .. "mupen-lua-ugui.lua")

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

-- https://www.programmerall.com/article/6862983111/
local function clone(obj)
    local InTable = {}
    local function Func(obj)
        if type(obj) ~= "table" then
            return obj
        end
        local NewTable = {}
        InTable[obj] = NewTable
        for k, v in pairs(obj) do
            NewTable[Func(k)] = Func(v);
        end
        return setmetatable(NewTable, getmetatable(obj))
    end
    return Func(obj)
end

local tab = {
    ["0"] = "0000",
    ["1"] = "0001",
    ["2"] = "0010",
    ["3"] = "0011",
    ["4"] = "0100",
    ["5"] = "0101",
    ["6"] = "0110",
    ["7"] = "0111",
    ["8"] = "1000",
    ["9"] = "1001",
    ["a"] = "1010",
    ["b"] = "1011",
    ["c"] = "1100",
    ["d"] = "1101",
    ["e"] = "1110",
    ["f"] = "1111",
    ["A"] = "1010",
    ["B"] = "1011",
    ["C"] = "1100",
    ["D"] = "1101",
    ["E"] = "1110",
    ["F"] = "1111",
}
local function fp_to_float(input)
    if not input then
        print(debug.traceback())
    end
    local str = string.format("%x", input)
    local str1 = ""
    local a, z
    for z = 1, string.len(str) do
        a = string.sub(str, z, z)
        str1 = str1 .. tab[a]
    end
    local pm = string.sub(str1, 1, 1)
    local exp = string.sub(str1, 2, 9)
    local c = tonumber(exp, 2) - 127
    local p = 2 ^ c
    local man = "1" .. string.sub(str1, 10, 32)
    local x = 0
    for z = 1, string.len(man) do
        if string.sub(man, z, z) == "1" then
            x = x + p
        end
        p = p / 2
    end
    if pm == "1" then
        x = -x
    end
    return (x)
end

local type_index = 1
local address = "0x00000000"
local types = {
    "int8",
    "int32",
    "uint32",
    "fpuint32",
    "single",
}

local selected_watch_index = nil
local watches = {}
local items = {}

local function update_values()
    items = {}

    for i = 1, #watches, 1 do
        local hex = watches[i].address:sub(3, watches[i].address:len())
        local address = tonumber(hex, 16)

        local value = nil
        local text = address .. " = "


        if watches[i].type == "int8" then
            value = memory.readbyte(address)
        elseif watches[i].type == "uint32" then
            value = memory.readdword(address)
        elseif watches[i].type == "int32" then
            value = memory.readword(address)
        elseif watches[i].type == "single" then
            value = memory.readfloat(address)
        elseif watches[i].type == "fpuint32" then
            value = fp_to_float(memory.readdword(address))
        end

        text = text .. tostring(value)

        items[#items + 1] = text
    end
end

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

    address = Mupen_lua_ugui.textbox({
        uid = 0,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 5,
            y = 10,
            width = 90,
            height = 20,
        },
        text = address,
    })

    type_index = Mupen_lua_ugui.combobox({
        uid = 1,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 105,
            y = 10,
            width = 90,
            height = 20,
        },
        items = types,
        selected_index = type_index,
    })

    if (Mupen_lua_ugui.button({
            uid = 2,
            is_enabled = true,
            rectangle = {
                x = initial_size.width + 5,
                y = 35,
                width = 190,
                height = 30,
            },
            text = "Add to watch",
        })) then
        local can_add = true
        for i = 1, #watches, 1 do
            if watches[i].address == address and watches[i].type == types[type_index] then
                print("A watch for " .. address .. " as " .. types[type_index] .. " already exists!")
                can_add = false
            end
        end

        if can_add then
            watches[#watches + 1] = {
                address = address,
                type = types[type_index],
            }
            update_values()
        end
    end

    selected_watch_index = Mupen_lua_ugui.listbox({
        uid = 3,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 5,
            y = 70,
            width = 190,
            height = 300,
        },
        items = items,
        selected_index = selected_watch_index,
    })

    Mupen_lua_ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)

emu.atinput(update_values)
