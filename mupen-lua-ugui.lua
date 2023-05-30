BreitbandGraphics = {
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
        wgui.setpen(BreitbandGraphics.color_to_hex(color))
        wgui.rect(rectangle.x, rectangle.y, rectangle.x + rectangle.width, rectangle.y + rectangle.height)
    end,
    gdi_fill_rectangle = function(rectangle, color)
        wgui.setbrush(BreitbandGraphics.color_to_hex(color))
        wgui.setpen(BreitbandGraphics.color_to_hex(color))
        wgui.rect(rectangle.x, rectangle.y, rectangle.x + rectangle.width, rectangle.y + rectangle.height)
    end,
    gdi_draw_ellipse = function(rectangle, color)
        wgui.setbrush("null")
        wgui.setpen(BreitbandGraphics.color_to_hex(color))
        wgui.ellipse(rectangle.x, rectangle.y, rectangle.x + rectangle.width, rectangle.y + rectangle.height)
    end,
    gdi_fill_ellipse = function(rectangle, color)
        wgui.setbrush(BreitbandGraphics.color_to_hex(color))
        wgui.setpen(BreitbandGraphics.color_to_hex(color))
        wgui.ellipse(rectangle.x, rectangle.y, rectangle.x + rectangle.width, rectangle.y + rectangle.height)
    end,
    gdi_draw_text = function(rectangle, alignment, respect_bounds, color, font_size, font_name, text)
        wgui.setcolor(BreitbandGraphics.color_to_hex(color))
        wgui.setfont(font_size,
            font_name, "")
        local flags = ""
        if alignment == "center-center" then
            flags = "cv"
        end
        if alignment == "left-center" then
            flags = "lv"
        end
        if alignment == "right-center" then
            flags = "rv"
        end
        wgui.drawtext(text, {
            l = rectangle.x,
            t = rectangle.y,
            w = respect_bounds and rectangle.width or 99999,
            h = respect_bounds and rectangle.height or 99999,
        }, flags)
    end,
    gdi_draw_line = function(from, to, color, thickness)
        wgui.setbrush("null")
        wgui.setpen(BreitbandGraphics.color_to_hex(color), thickness)
        wgui.line(from.x, from.y, to.x, to.y)
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

local function clamp(value, min, max)
    if value < min then
        return min
    end
    if value > max then
        return max
    end
    return value
end

local function is_pointer_inside(rectangle)
    return Mupen_lua_ugui.input_state.pointer.position.x > rectangle.x and
        Mupen_lua_ugui.input_state.pointer.position.y > rectangle.y and
        Mupen_lua_ugui.input_state.pointer.position.x < rectangle.x + rectangle.width and
        Mupen_lua_ugui.input_state.pointer.position.y < rectangle.y + rectangle.height;
end
local function is_previous_primary_down_pointer_inside(rectangle)
    return Mupen_lua_ugui.previous_pointer_primary_down_position.x > rectangle.x and
        Mupen_lua_ugui.previous_pointer_primary_down_position.y > rectangle.y and
        Mupen_lua_ugui.previous_pointer_primary_down_position.x < rectangle.x + rectangle.width and
        Mupen_lua_ugui.previous_pointer_primary_down_position.y < rectangle.y + rectangle.height;
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

local function get_just_pressed_keys()
    local keys = {}
    for key, value in pairs(Mupen_lua_ugui.input_state.keyboard.held_keys) do
        if not Mupen_lua_ugui.previous_input_state.keyboard.held_keys[key] then
            keys[key] = 1
        end
    end
    return keys
end

local function remove_at(string, index)
    if index == 0 then
        return string
    end
    return string:sub(1, index - 1) .. string:sub(index + 1, string:len())
end
local function insert_at(string, string2, index)
    return string:sub(1, index) .. string2 .. string:sub(index + string2:len(), string:len())
end

local function remap(value, from1, to1, from2, to2)
    return (value - from1) / (to1 - from1) * (to2 - from2) + from2
end

local NORMAL = 0
local HOVER = 1
local ACTIVE = 2

local function get_basic_visual_state(control)
    if is_pointer_inside(control.rectangle) then
        if is_previous_primary_down_pointer_inside(control.rectangle) and is_pointer_down() then
            return ACTIVE
        end

        return HOVER
    end
    return NORMAL
end

Mupen_lua_ugui = {
    -- TODO: find better way of protecting these
    -- Dictionary of additional control data by id
    -- Library-side state, don't mutate
    control_data = {},
    -- Library-side state, don't mutate
    input_state = {},
    -- Library-side state, don't mutate
    previous_input_state = {},
    -- Library-side state, don't mutate
    active_control_uid = nil,
    -- Library-side state, don't mutate
    previous_pointer_primary_down_position = { x = 0, y = 0 },
    -- Library-side state, don't mutate
    modal_hittest_ignore_rectangle = { x = 0, y = 0, width = 0, height = 0 },

    stylers = {
        windows_10 = {
            draw_raised_frame = function(control, visual_state)
                local back_color = {
                    r = 225,
                    g = 225,
                    b = 225
                }
                local border_color = {
                    r = 173,
                    g = 173,
                    b = 173
                }

                if visual_state == ACTIVE then
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
                end
                BreitbandGraphics.gdi_fill_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, 1),
                    border_color)
                BreitbandGraphics.gdi_fill_rectangle(control.rectangle, back_color)
            end,
            draw_button = function(control, override_active)
                local visual_state = get_basic_visual_state(control)
                if override_active then
                    visual_state = ACTIVE
                end

                Mupen_lua_ugui.stylers.windows_10.draw_raised_frame(control, visual_state)

                BreitbandGraphics.gdi_draw_text(control.rectangle, 'center-center', true, {
                    r = 0,
                    g = 0,
                    b = 0
                }, 11, "Microsoft Sans Serif", control.text)
            end,
            draw_togglebutton = function(control)
                Mupen_lua_ugui.stylers.windows_10.draw_button(control, control.is_checked)
            end,
            draw_textbox = function(control)
                local visual_state = get_basic_visual_state(control)

                local back_color = {
                    r = 255,
                    g = 255,
                    b = 255
                }
                local border_color = {
                    r = 122,
                    g = 122,
                    b = 122
                }

                if Mupen_lua_ugui.active_control_uid == control.uid then
                    visual_state = ACTIVE
                end

                if visual_state == HOVER then
                    border_color = {
                        r = 23,
                        g = 23,
                        b = 23,
                    }
                elseif visual_state == ACTIVE then
                    border_color = {
                        r = 0,
                        g = 84,
                        b = 153
                    }
                end

                BreitbandGraphics.gdi_fill_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, 1),
                    border_color)
                BreitbandGraphics.gdi_fill_rectangle(control.rectangle, back_color)
                BreitbandGraphics.gdi_draw_text(control.rectangle, 'left-top', false, {
                    r = 0,
                    g = 0,
                    b = 0
                }, 11, "Microsoft Sans Serif", control.text)

                local string_to_caret = control.text:sub(1, Mupen_lua_ugui.control_data[control.uid].caret_index - 1)
                local caret_x = wgui.gettextextent(string_to_caret).width

                if visual_state == ACTIVE then
                    BreitbandGraphics.gdi_draw_line({
                        x = control.rectangle.x + caret_x,
                        y = control.rectangle.y + 2
                    }, {
                        x = control.rectangle.x + caret_x,
                        y = control.rectangle.y + math.max(15, wgui.gettextextent(control.text).height)
                    }, {
                        r = 0,
                        g = 0,
                        b = 0
                    }, 1)
                end
            end,
            draw_joystick = function(control)
                Mupen_lua_ugui.stylers.windows_10.draw_raised_frame(control, NORMAL)

                local stick_position = {}

                stick_position.x = remap(control.position.x, -128, 127, control.rectangle.x,
                    control.rectangle.x + control.rectangle.width)
                stick_position.y = remap(control.position.y, -127, 128, control.rectangle.y,
                    control.rectangle.y + control.rectangle.height)

                BreitbandGraphics.gdi_fill_ellipse(control.rectangle, {
                    r = 0,
                    g = 0,
                    b = 0
                })
                BreitbandGraphics.gdi_fill_ellipse(BreitbandGraphics.inflate_rectangle(control.rectangle, -1), {
                    r = 255,
                    g = 255,
                    b = 255
                })
                BreitbandGraphics.gdi_draw_line({
                    x = control.rectangle.x + control.rectangle.width / 2,
                    y = control.rectangle.y,
                }, {
                    x = control.rectangle.x + control.rectangle.width / 2,
                    y = control.rectangle.y + control.rectangle.height
                }, {
                    r = 0,
                    g = 0,
                    b = 0
                }, 1)
                BreitbandGraphics.gdi_draw_line({
                    x = control.rectangle.x,
                    y = control.rectangle.y + control.rectangle.height / 2,
                }, {
                    x = control.rectangle.x + control.rectangle.width,
                    y = control.rectangle.y + control.rectangle.height / 2,
                }, {
                    r = 0,
                    g = 0,
                    b = 0
                }, 1)

                BreitbandGraphics.gdi_draw_line({
                    x = control.rectangle.x + control.rectangle.width / 2,
                    y = control.rectangle.y + control.rectangle.height / 2,
                }, {
                    x = stick_position.x,
                    y = stick_position.y,
                }, {
                    r = 0,
                    g = 0,
                    b = 255
                }, 3)
                local tip_size = 5
                BreitbandGraphics.gdi_fill_ellipse({
                    x = stick_position.x - tip_size / 2,
                    y = stick_position.y - tip_size / 2,
                    width = tip_size + 2,
                    height = tip_size + 2,
                }, {
                    r = 255,
                    g = 0,
                    b = 0
                })
            end,
            draw_trackbar = function(control)
                local visual_state = get_basic_visual_state(control)

                local track_color = {
                    r = 231,
                    g = 234,
                    b = 234
                }
                local track_border_color = {
                    r = 214,
                    g = 214,
                    b = 214
                }
                local head_color = {
                    r = 0,
                    g = 122,
                    b = 217
                }

                if Mupen_lua_ugui.active_control_uid == control.uid then
                    visual_state = ACTIVE
                end

                if visual_state == HOVER then
                    head_color = {
                        r = 23,
                        g = 23,
                        b = 23,
                    }
                elseif visual_state == ACTIVE then
                    head_color = {
                        r = 204,
                        g = 204,
                        b = 204,
                    }
                end



                local is_horizontal = control.rectangle.width > control.rectangle.height
                local HEAD_WIDTH = 6
                local TRACK_THICKNESS = 2
                local HEAD_HEIGHT = (TRACK_THICKNESS + 2 * 2) * 3
                local track_rectangle = {}
                local head_rectangle = {}

                if not is_horizontal then
                    track_rectangle = {
                        x = control.rectangle.x + control.rectangle.width / 2 - TRACK_THICKNESS / 2,
                        y = control.rectangle.y,
                        width = TRACK_THICKNESS,
                        height = control.rectangle.height
                    }
                    head_rectangle = {
                        x = control.rectangle.x + control.rectangle.width / 2 - HEAD_HEIGHT / 2,
                        y = control.rectangle.y + (control.value * control.rectangle.height) - HEAD_WIDTH / 2,
                        width = HEAD_HEIGHT,
                        height = HEAD_WIDTH
                    }
                else
                    track_rectangle = {
                        x = control.rectangle.x,
                        y = control.rectangle.y + control.rectangle.height / 2 - TRACK_THICKNESS / 2,
                        width = control.rectangle.width,
                        height = TRACK_THICKNESS
                    }
                    head_rectangle = {
                        x = control.rectangle.x + (control.value * control.rectangle.width) - HEAD_WIDTH / 2,
                        y = control.rectangle.y + control.rectangle.height / 2 - HEAD_HEIGHT / 2,
                        width = HEAD_WIDTH,
                        height = HEAD_HEIGHT
                    }
                end

                BreitbandGraphics.gdi_fill_rectangle(BreitbandGraphics.inflate_rectangle(track_rectangle, 1),
                    track_border_color)
                BreitbandGraphics.gdi_fill_rectangle(track_rectangle, track_color)
                BreitbandGraphics.gdi_fill_rectangle(head_rectangle, head_color)
            end,
            draw_combobox = function(control)
                local visual_state = get_basic_visual_state(control)

                if Mupen_lua_ugui.control_data[control.uid].is_open then
                    visual_state = ACTIVE
                end

                Mupen_lua_ugui.stylers.windows_10.draw_raised_frame(control, visual_state)

                BreitbandGraphics.gdi_draw_text({
                        x = control.rectangle.x + 2,
                        y = control.rectangle.y,
                        width = control.rectangle.width,
                        height = control.rectangle.height,
                    }, "left-center", true, {
                        r = 0,
                        g = 0,
                        b = 0
                    }, 11, "Microsoft Sans Serif",
                    control.items[control.selected_index])

                BreitbandGraphics.gdi_draw_text({
                        x = control.rectangle.x,
                        y = control.rectangle.y,
                        width = control.rectangle.width - 8,
                        height = control.rectangle.height,
                    }, "right-center", true, {
                        r = 0,
                        g = 0,
                        b = 0
                    }, 11, "Segoe UI Mono",
                    Mupen_lua_ugui.control_data[control.uid].is_open and "^" or "v")

                if Mupen_lua_ugui.control_data[control.uid].is_open then
                    BreitbandGraphics.gdi_fill_rectangle(BreitbandGraphics.inflate_rectangle({
                        x = control.rectangle.x,
                        y = control.rectangle.y + control.rectangle.height,
                        width = control.rectangle.width,
                        height = #control.items * 20
                    }, 1), {
                        r = 0,
                        g = 120,
                        b = 215
                    })

                    for i = 1, #control.items, 1 do
                        local rect = {
                            x = control.rectangle.x,
                            y = control.rectangle.y + control.rectangle.height + (20 * (i - 1)),
                            width = control.rectangle.width,
                            height = 20
                        }

                        local back_color = {
                            r = 255,
                            g = 255,
                            b = 255
                        }
                        local text_color = {
                            r = 0,
                            g = 0,
                            b = 0
                        }

                        if Mupen_lua_ugui.control_data[control.uid].hovered_index == i then
                            back_color = {
                                r = 0,
                                g = 120,
                                b = 215
                            }
                            text_color = {
                                r = 255,
                                g = 255,
                                b = 255
                            }
                        end

                        BreitbandGraphics.gdi_fill_rectangle(rect, back_color)
                        rect.x = rect.x + 2
                        BreitbandGraphics.gdi_draw_text(rect, "left-center", true, text_color, 11, "Microsoft Sans Serif",
                            control.items[i])
                    end
                end
            end
        },
    },

    begin_frame = function(input_state)
        Mupen_lua_ugui.previous_input_state = clone(Mupen_lua_ugui.input_state)
        Mupen_lua_ugui.input_state = clone(input_state)

        if is_pointer_just_down() then
            Mupen_lua_ugui.previous_pointer_primary_down_position = Mupen_lua_ugui.input_state.pointer.position
        end
    end,

    button = function(control)
        local pushed = is_pointer_just_down() and is_pointer_inside(control.rectangle) and
            not is_pointer_inside(Mupen_lua_ugui.modal_hittest_ignore_rectangle)

        if pushed then
            Mupen_lua_ugui.active_control_uid = control.uid
        end

        Mupen_lua_ugui.stylers.windows_10.draw_button(control, false)

        return pushed
    end,

    toggle_button = function(control)
        local pushed = is_pointer_just_down() and is_previous_primary_down_pointer_inside(control.rectangle) and
            not is_pointer_inside(Mupen_lua_ugui.modal_hittest_ignore_rectangle)
        local is_checked = control.is_checked
        if pushed then
            Mupen_lua_ugui.active_control_uid = control.uid
            is_checked = not is_checked
        end

        Mupen_lua_ugui.stylers.windows_10.draw_togglebutton(control)

        return is_checked
    end,

    textbox = function(control)
        if not Mupen_lua_ugui.control_data[control.uid] then
            Mupen_lua_ugui.control_data[control.uid] = {
                caret_index = 1
            }
        end

        if is_pointer_just_down() and is_previous_primary_down_pointer_inside(control.rectangle) and
            not is_pointer_inside(Mupen_lua_ugui.modal_hittest_ignore_rectangle) then
            Mupen_lua_ugui.active_control_uid = control.uid
        end

        local function get_caret_index_at_relative_position(position)
            -- TODO: optimize
            local x = position.x - control.rectangle.x
            local lowest_distance = 9999999999
            local lowest_distance_index = -1
            for i = 1, #control.text + 2, 1 do
                local dist = math.abs(wgui.gettextextent(control.text:sub(1, i - 1)).width - x)
                if dist < lowest_distance then
                    lowest_distance = dist
                    lowest_distance_index = i
                end
            end
            return lowest_distance_index
        end

        local text = control.text

        if Mupen_lua_ugui.active_control_uid == control.uid then
            if is_pointer_down() and is_previous_primary_down_pointer_inside(control.rectangle) then
                Mupen_lua_ugui.control_data[control.uid].caret_index = get_caret_index_at_relative_position(
                    Mupen_lua_ugui.input_state.pointer.position)
            end

            local just_pressed_keys = get_just_pressed_keys();

            if just_pressed_keys.left then
                Mupen_lua_ugui.control_data[control.uid].caret_index = Mupen_lua_ugui.control_data[control.uid]
                    .caret_index - 1
            elseif just_pressed_keys.right then
                Mupen_lua_ugui.control_data[control.uid].caret_index = Mupen_lua_ugui.control_data[control.uid]
                    .caret_index + 1
            elseif just_pressed_keys.space then
                text = insert_at(text, " ", Mupen_lua_ugui.control_data[control.uid].caret_index - 1)
                Mupen_lua_ugui.control_data[control.uid].caret_index = Mupen_lua_ugui.control_data[control.uid]
                    .caret_index + 1
            elseif just_pressed_keys.backspace then
                text = remove_at(text, Mupen_lua_ugui.control_data[control.uid].caret_index - 1)
                Mupen_lua_ugui.control_data[control.uid].caret_index = Mupen_lua_ugui.control_data[control.uid]
                    .caret_index - 1
            else
                for key, _ in pairs(just_pressed_keys) do
                    if not (#key == 1) then
                        goto continue
                    end
                    text = insert_at(text, key, Mupen_lua_ugui.control_data[control.uid].caret_index - 1)
                    Mupen_lua_ugui.control_data[control.uid].caret_index = Mupen_lua_ugui.control_data[control.uid]
                        .caret_index + 1
                    ::continue::
                end
            end

            Mupen_lua_ugui.control_data[control.uid].caret_index = clamp(
                Mupen_lua_ugui.control_data[control.uid].caret_index, 1, #text + 1)
        end


        Mupen_lua_ugui.stylers.windows_10.draw_textbox(control)

        return text
    end,

    joystick = function(control)
        Mupen_lua_ugui.stylers.windows_10.draw_joystick(control)

        return control.position
    end,

    trackbar = function(control)
        local value = control.value

        if is_pointer_just_down() and is_previous_primary_down_pointer_inside(control.rectangle) and
            not is_pointer_inside(Mupen_lua_ugui.modal_hittest_ignore_rectangle) then
            Mupen_lua_ugui.active_control_uid = control.uid
        end

        -- we instantly deactivate this control after releasing our mouse to emulate windows behaviour
        if Mupen_lua_ugui.active_control_uid == control.uid and not is_pointer_down() then
            Mupen_lua_ugui.active_control_uid = nil
        end

        if Mupen_lua_ugui.active_control_uid == control.uid and is_previous_primary_down_pointer_inside(control.rectangle) and is_pointer_down() then
            if control.rectangle.width > control.rectangle.height then
                value = clamp(
                    (Mupen_lua_ugui.input_state.pointer.position.x - control.rectangle.x) /
                    control.rectangle.width,
                    0, 1)
            else
                value = clamp(
                    (Mupen_lua_ugui.input_state.pointer.position.y - control.rectangle.y) /
                    control.rectangle.height,
                    0, 1)
            end
        end

        Mupen_lua_ugui.stylers.windows_10.draw_trackbar(control)

        return value
    end,

    combobox = function(control)
        if not Mupen_lua_ugui.control_data[control.uid] then
            Mupen_lua_ugui.control_data[control.uid] = {
                is_open = false,
                hovered_index = 0,
            }
        end

        if is_pointer_just_down() then
            if is_pointer_inside(control.rectangle) then
                Mupen_lua_ugui.control_data[control.uid].is_open = not Mupen_lua_ugui.control_data[control.uid].is_open
            else
                if not is_pointer_inside({
                        x = control.rectangle.x,
                        y = control.rectangle.y + control.rectangle.height,
                        width = control.rectangle.width,
                        height = 20 * #control.items
                    }) then
                    Mupen_lua_ugui.control_data[control.uid].is_open = false
                end
            end
        end

        local selected_index = control.selected_index
        Mupen_lua_ugui.modal_hittest_ignore_rectangle = { x = 0, y = 0, width = 0, height = 0 }



        if Mupen_lua_ugui.control_data[control.uid].is_open then
            for i = 1, #control.items, 1 do
                if is_pointer_inside({
                        x = control.rectangle.x,
                        y = control.rectangle.y + control.rectangle.height + (20 * (i - 1)),
                        width = control.rectangle.width,
                        height = 20
                    }) then
                    if is_pointer_just_down() then
                        selected_index = i
                        Mupen_lua_ugui.control_data[control.uid].is_open = false
                    end
                    Mupen_lua_ugui.control_data[control.uid].hovered_index = i
                    break
                end
            end

            Mupen_lua_ugui.modal_hittest_ignore_rectangle = {
                x = control.rectangle.x,
                y = control.rectangle.y + control.rectangle.height,
                width = control.rectangle.width,
                height = 20 * #control.items
            }
        end

        selected_index = clamp(selected_index, 1, #control.items)

        Mupen_lua_ugui.stylers.windows_10.draw_combobox(control)

        return selected_index
    end
}
