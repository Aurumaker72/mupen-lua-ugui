Bandbreitegfx = {
    color_to_hex = function(color)
        return string.format("#%06X", (color.r * 0x10000) + (color.g * 0x100) + color.b)
    end,
    inflate_rectangle = function(rectangle, amount)
        return {
            x = rectangle.x - amount,
            y = rectangle.y - amount,
            width = rectangle.width + amount * 2,
            height = rectangle.height + amount * 2,
        }
    end,
    gdi_draw_rectangle = function(rectangle, color)
        wgui.setbrush("null") -- https://github.com/mkdasher/mupen64-rr-lua-/blob/master/lua/LuaConsole.cpp#L2004
        wgui.setpen(Bandbreitegfx.color_to_hex(color))
        wgui.rect(rectangle.x, rectangle.y, rectangle.x + rectangle.width, rectangle.y + rectangle.height)
    end,
    gdi_fill_rectangle = function(rectangle, color)
        wgui.setbrush(Bandbreitegfx.color_to_hex(color))
        wgui.setpen(Bandbreitegfx.color_to_hex(color))
        wgui.rect(rectangle.x, rectangle.y, rectangle.x + rectangle.width, rectangle.y + rectangle.height)
    end,
    gdi_draw_ellipse = function(rectangle, color)
        wgui.setbrush("null")
        wgui.setpen(Bandbreitegfx.color_to_hex(color))
        wgui.ellipse(rectangle.x, rectangle.y, rectangle.x + rectangle.width, rectangle.y + rectangle.height)
    end,
    gdi_fill_ellipse = function(rectangle, color)
        wgui.setbrush(Bandbreitegfx.color_to_hex(color))
        wgui.setpen(bandbreitegfx.color_to_hex(color))
        wgui.ellipse(Bandbreitegfx.x, rectangle.y, rectangle.x + rectangle.width, rectangle.y + rectangle.height)
    end,
    gdi_draw_text = function(rectangle, alignment, color, font_size, font_name, text)
        wgui.setcolor(Bandbreitegfx.color_to_hex(color))
        wgui.setfont(font_size,
            font_name, "")
        local flags = ""
        if alignment == "center-center" then
            flags = "cv"
        end
        wgui.drawtext(text, {
            l = rectangle.x,
            t = rectangle.y,
            w = rectangle.width,
            h = rectangle.height,
        }, flags)
    end
}

-- https://www.programmerall.com/article/6862983111/
local function clone(obj)
    local InTable = {};
    local function Func(obj)
        if type(obj) ~= "table" then --Determine whether there is a table in the table
            return obj;
        end
        local NewTable = {};      --Define a new table
        InTable[obj] = NewTable;  --If there is a table in the table, first give the table to InTable, and then use NewTable to receive the embedded table
        for k, v in pairs(obj) do --Assign the key and value of the old table to the new table
            NewTable[Func(k)] = Func(v);
        end
        return setmetatable(NewTable, getmetatable(obj)) --Assignment metatable
    end
    return Func(obj)                                     --If there is a table in the table, the embedded table is also copied
end

local function is_pointer_inside(rectangle)
    return Mupen_lua_ugui.input_state.pointer.position.x > rectangle.x and
        Mupen_lua_ugui.input_state.pointer.position.y > rectangle.y and
        Mupen_lua_ugui.input_state.pointer.position.x < rectangle.x + rectangle.width and
        Mupen_lua_ugui.input_state.pointer.position.y < rectangle.y + rectangle.height;
end
local function is_pointer_just_inside(rectangle)
    return (Mupen_lua_ugui.input_state.pointer.position.x > rectangle.x and
            Mupen_lua_ugui.input_state.pointer.position.y > rectangle.y and
            Mupen_lua_ugui.input_state.pointer.position.x < rectangle.x + rectangle.width and
            Mupen_lua_ugui.input_state.pointer.position.y < rectangle.y + rectangle.height)
        and
        not (Mupen_lua_ugui.previous_input_state.pointer.position.x > rectangle.x and
            Mupen_lua_ugui.previous_input_state.pointer.position.y > rectangle.y and
            Mupen_lua_ugui.previous_input_state.pointer.position.x < rectangle.x + rectangle.width and
            Mupen_lua_ugui.previous_input_state.pointer.position.y < rectangle.y + rectangle.height);
end
local function is_pointer_down()
    return Mupen_lua_ugui.input_state.pointer.is_primary_down;
end
local function is_pointer_just_down()
    return Mupen_lua_ugui.input_state.pointer.is_primary_down and
        not Mupen_lua_ugui.previous_input_state.pointer.is_primary_down;
end

local NORMAL = 0
local HOVER = 1
local ACTIVE = 2

local function get_basic_visual_state(control)
    if is_pointer_inside(control.rectangle) then
        if is_pointer_down() then
            return ACTIVE
        else
            return HOVER
        end
    end
    return NORMAL
end

Mupen_lua_ugui = {
    input_state = {},
    previous_input_state = {},

    stylers = {
        windows_10 = {
            draw_button = function(control)
                local visual_state = get_basic_visual_state(control)
                local back_color = nil
                local border_color = nil

                if visual_state == NORMAL then
                    back_color = {
                        r = 225,
                        g = 225,
                        b = 225
                    }
                    border_color = {
                        r = 173,
                        g = 173,
                        b = 173
                    }
                elseif visual_state == HOVER then
                    back_color = {
                        r = 229,
                        g = 241,
                        b = 251
                    }
                    border_color = {
                        r = 0,
                        g = 120,
                        b = 215
                    }
                elseif visual_state == ACTIVE then
                    back_color = {
                        r = 204,
                        g = 228,
                        b = 247
                    }
                    border_color = {
                        r = 0,
                        g = 84,
                        b = 153
                    }
                end

                Bandbreitegfx.gdi_fill_rectangle(Bandbreitegfx.inflate_rectangle(control.rectangle, 1), border_color)
                Bandbreitegfx.gdi_fill_rectangle(control.rectangle, back_color)
                Bandbreitegfx.gdi_draw_text(control.rectangle, 'center-center', {
                    r = 0,
                    g = 0,
                    b = 0
                }, 11, "Microsoft Sans Serif", control.text)
            end
        },
    },

    prepare_frame = function(input_state)
        Mupen_lua_ugui.previous_input_state = clone(Mupen_lua_ugui.input_state)
        Mupen_lua_ugui.input_state = clone(input_state)
    end,

    button = function(control)
        Mupen_lua_ugui.stylers.windows_10.draw_button(control)

        return is_pointer_inside(control.rectangle) and is_pointer_just_down()
    end
}

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
