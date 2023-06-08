BreitbandGraphics = {
    color_to_hex = function(color)
        return string.format("#%06X",
            (color.r * 0x10000) + (color.g * 0x100) + color.b)
    end,
    hex_to_color = function(hex)
        return
        {
            r = tonumber(hex:sub(2, 3), 16),
            g = tonumber(hex:sub(4, 5), 16),
            b = tonumber(hex:sub(6, 7), 16)
        }
    end,
    colors = {
        white = {
            r = 255,
            g = 255,
            b = 255
        },
        black = {
            r = 0,
            g = 0,
            b = 0
        },
        red = {
            r = 255,
            g = 0,
            b = 0
        },
        green = {
            r = 0,
            g = 255,
            b = 0
        },
        blue = {
            r = 0,
            g = 0,
            b = 255
        },
        yellow = {
            r = 255,
            g = 255,
            b = 0
        },
        orange = {
            r = 255,
            g = 128,
            b = 0
        },
        magenta = {
            r = 255,
            g = 0,
            b = 255
        },
    },

    inflate_rectangle = function(rectangle, amount)
        return {
            x = rectangle.x - amount,
            y = rectangle.y - amount,
            width = rectangle.width + amount * 2,
            height = rectangle.height + amount * 2,
        }
    end,

    renderers = {
        d2d = {
            color_to_float = function(color)
                return {
                    r = color.r / 255.0,
                    g = color.g / 255.0,
                    b = color.b / 255.0,
                }
            end,
            get_text_size = function(text, font_size, font_name)
                local a = wgui.d2d_get_text_size(text, font_name, font_size, 99999999, 99999999)

                return a;
            end,
            draw_rectangle = function(rectangle, color, thickness)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.d2d_draw_rectangle(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
                    rectangle.y + rectangle.height, float_color.r, float_color.g, float_color.b, 1.0, thickness)
            end,
            fill_rectangle = function(rectangle, color)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.d2d_fill_rectangle(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
                    rectangle.y + rectangle.height, float_color.r, float_color.g, float_color.b, 1.0)
            end,
            draw_rounded_rectangle = function(rectangle, color, radii, thickness)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.d2d_draw_rounded_rectangle(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
                    rectangle.y + rectangle.height, radii.x, radii.y, float_color.r, float_color.g, float_color.b, 1.0,
                    thickness)
            end,
            fill_rounded_rectangle = function(rectangle, color, radii)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.d2d_fill_rounded_rectangle(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
                    rectangle.y + rectangle.height, radii.x, radii.y, float_color.r, float_color.g, float_color.b, 1.0)
            end,
            draw_ellipse = function(rectangle, color, thickness)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.d2d_draw_ellipse(rectangle.x + rectangle.width / 2, rectangle.y + rectangle.height / 2,
                    rectangle.width / 2, rectangle.height / 2, float_color.r, float_color.g, float_color.b, 1.0,
                    thickness)
            end,
            fill_ellipse = function(rectangle, color)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.d2d_fill_ellipse(rectangle.x + rectangle.width / 2, rectangle.y + rectangle.height / 2,
                    rectangle.width / 2, rectangle.height / 2, float_color.r, float_color.g, float_color.b, 1.0)
            end,
            draw_text = function(rectangle, horizontal_alignment, vertical_alignment, color, font_size, font_name, text)
                if text == nil then
                    text = ""
                end

                local d_horizontal_alignment = 0
                local d_vertical_alignment = 0

                if horizontal_alignment == "center" then
                    d_horizontal_alignment = 2
                elseif horizontal_alignment == "start" then
                    d_horizontal_alignment = 0
                elseif horizontal_alignment == "end" then
                    d_horizontal_alignment = 1
                elseif horizontal_alignment == "stretch" then
                    d_horizontal_alignment = 3
                end

                if vertical_alignment == "center" then
                    d_vertical_alignment = 2
                elseif vertical_alignment == "start" then
                    d_vertical_alignment = 0
                elseif vertical_alignment == "end" then
                    d_vertical_alignment = 1
                end

                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.d2d_draw_text(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
                    rectangle.y + rectangle.height, float_color.r, float_color.g, float_color.b, 1.0, text, font_name,
                    font_size, d_horizontal_alignment, d_vertical_alignment)
            end,
            draw_line = function(from, to, color, thickness)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.d2d_draw_line(from.x, from.y, to.x, to.y, float_color.r, float_color.g, float_color.b, 1.0,
                    thickness)
            end,
            push_clip = function(rectangle)
                wgui.d2d_push_clip(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
                    rectangle.y + rectangle.height)
            end,
            pop_clip = function()
                wgui.d2d_pop_clip()
            end
        }
    }
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

local DISABLED = -1
local NORMAL = 0
local HOVER = 1
local ACTIVE = 2

local function get_basic_visual_state(control)
    if not control.is_enabled then
        return DISABLED
    end

    if is_pointer_inside(control.rectangle) and not is_pointer_inside(Mupen_lua_ugui.modal_hittest_ignore_rectangle) then
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
    -- Library-side state, don't mutate
    end_frame_callbacks = {},
    -- Library-side state, don't mutate
    renderer = nil,
    -- Library-side state, don't mutate
    styler = nil,

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
                elseif visual_state == DISABLED then
                    back_color = {
                        r = 204,
                        g = 204,
                        b = 204
                    }
                    border_color = {
                        r = 191,
                        g = 191,
                        b = 191
                    }
                end

                Mupen_lua_ugui.renderer.fill_rectangle(control.rectangle,
                    border_color)
                Mupen_lua_ugui.renderer.fill_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, -1),
                    back_color)
            end,
            draw_button = function(control)
                local visual_state = get_basic_visual_state(control)

                -- override for toggle_button
                if control.is_checked and control.is_enabled then
                    visual_state = ACTIVE
                end

                Mupen_lua_ugui.stylers.windows_10.draw_raised_frame(control, visual_state)

                local text_color = {
                    r = 0,
                    g = 0,
                    b = 0
                }

                if visual_state == DISABLED then
                    text_color = {
                        r = 160,
                        g = 160,
                        b = 160,
                    }
                end

                Mupen_lua_ugui.renderer.draw_text(control.rectangle, 'center', 'center', text_color, 14,
                    "Microsoft Sans Serif", control.text)
            end,
            draw_togglebutton = function(control)
                Mupen_lua_ugui.stylers.windows_10.draw_button(control)
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
                local text_color = {
                    r = 0,
                    g = 0,
                    b = 0,
                }

                if Mupen_lua_ugui.active_control_uid == control.uid and control.is_enabled then
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
                elseif visual_state == DISABLED then
                    back_color = {
                        r = 240,
                        g = 240,
                        b = 240,
                    }
                    border_color = {
                        r = 204,
                        g = 204,
                        b = 204,
                    }
                    text_color = {
                        r = 109,
                        g = 109,
                        b = 109,
                    }
                end

                Mupen_lua_ugui.renderer.fill_rectangle(control.rectangle,
                    border_color)
                Mupen_lua_ugui.renderer.fill_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, -1),
                    back_color)
                Mupen_lua_ugui.renderer.draw_text(control.rectangle, 'start', 'start', text_color, 14,
                    "Microsoft Sans Serif", control.text)

                local string_to_caret = control.text:sub(1, Mupen_lua_ugui.control_data[control.uid].caret_index - 1)
                local caret_x = Mupen_lua_ugui.renderer.get_text_size(string_to_caret, 14, "Microsoft Sans Serif").width

                if visual_state == ACTIVE then
                    Mupen_lua_ugui.renderer.draw_line({
                        x = control.rectangle.x + caret_x,
                        y = control.rectangle.y + 2
                    }, {
                        x = control.rectangle.x + caret_x,
                        y = control.rectangle.y +
                            math.max(15,
                                Mupen_lua_ugui.renderer.get_text_size(string_to_caret, 14, "Microsoft Sans Serif")
                                .height) -- TODO: move text measurement into BreitbandGraphics
                    }, {
                        r = 0,
                        g = 0,
                        b = 0
                    }, 1)
                end
            end,
            draw_joystick = function(control)
                -- TODO: utilize normalized coordinates, to logically decouple joystick from n64
                Mupen_lua_ugui.stylers.windows_10.draw_raised_frame(control, NORMAL)

                local visual_state = get_basic_visual_state(control)

                local back_color = {
                    r = 255,
                    g = 255,
                    b = 255
                }
                local outline_color = {
                    r = 0,
                    g = 0,
                    b = 0
                }
                local tip_color = {
                    r = 255,
                    g = 0,
                    b = 0
                }
                local line_color = {
                    r = 0,
                    g = 0,
                    b = 255
                }

                if visual_state == DISABLED then
                    outline_color = {
                        r = 191,
                        g = 191,
                        b = 191
                    }
                    tip_color = {
                        r = 255,
                        g = 128,
                        b = 128
                    }
                    line_color = {
                        r = 128,
                        g = 128,
                        b = 255
                    }
                end

                local stick_position = {
                    x = remap(control.position.x, 0, 1, control.rectangle.x,
                        control.rectangle.x + control.rectangle.width),
                    y = remap(control.position.y, 0, 1, control.rectangle.y,
                        control.rectangle.y + control.rectangle.height)
                }

                Mupen_lua_ugui.renderer.fill_ellipse(control.rectangle, back_color)
                Mupen_lua_ugui.renderer.draw_ellipse(control.rectangle, outline_color, 1)
                Mupen_lua_ugui.renderer.draw_line({
                    x = control.rectangle.x + control.rectangle.width / 2,
                    y = control.rectangle.y,
                }, {
                    x = control.rectangle.x + control.rectangle.width / 2,
                    y = control.rectangle.y + control.rectangle.height
                }, outline_color, 1)
                Mupen_lua_ugui.renderer.draw_line({
                    x = control.rectangle.x,
                    y = control.rectangle.y + control.rectangle.height / 2,
                }, {
                    x = control.rectangle.x + control.rectangle.width,
                    y = control.rectangle.y + control.rectangle.height / 2,
                }, outline_color, 1)

                Mupen_lua_ugui.renderer.draw_line({
                    x = control.rectangle.x + control.rectangle.width / 2,
                    y = control.rectangle.y + control.rectangle.height / 2,
                }, {
                    x = stick_position.x,
                    y = stick_position.y,
                }, line_color, 3)
                local tip_size = 8
                Mupen_lua_ugui.renderer.fill_ellipse({
                    x = stick_position.x - tip_size / 2,
                    y = stick_position.y - tip_size / 2,
                    width = tip_size,
                    height = tip_size,
                }, tip_color)
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

                if Mupen_lua_ugui.active_control_uid == control.uid and control.is_enabled then
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
                elseif visual_state == DISABLED then
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

                Mupen_lua_ugui.renderer.fill_rectangle(BreitbandGraphics.inflate_rectangle(track_rectangle, 1),
                    track_border_color)
                Mupen_lua_ugui.renderer.fill_rectangle(track_rectangle, track_color)
                Mupen_lua_ugui.renderer.fill_rectangle(head_rectangle, head_color)
            end,
            draw_combobox = function(control)
                local visual_state = get_basic_visual_state(control)

                local text_color = {
                    r = 0,
                    g = 0,
                    b = 0,
                }

                if Mupen_lua_ugui.control_data[control.uid].is_open and control.is_enabled then
                    visual_state = ACTIVE
                end

                Mupen_lua_ugui.stylers.windows_10.draw_raised_frame(control, visual_state)

                if visual_state == DISABLED then
                    text_color = {
                        r = 109,
                        g = 109,
                        b = 109,
                    }
                end
                Mupen_lua_ugui.renderer.draw_text({
                        x = control.rectangle.x + 2,
                        y = control.rectangle.y,
                        width = control.rectangle.width,
                        height = control.rectangle.height,
                    }, 'start', 'center', text_color, 14, "Microsoft Sans Serif",
                    control.items[control.selected_index])

                Mupen_lua_ugui.renderer.draw_text({
                        x = control.rectangle.x,
                        y = control.rectangle.y,
                        width = control.rectangle.width - 8,
                        height = control.rectangle.height,
                    }, 'end', 'center', text_color, 14, "Segoe UI Mono",
                    Mupen_lua_ugui.control_data[control.uid].is_open and "^" or "v")

                if Mupen_lua_ugui.control_data[control.uid].is_open then
                    Mupen_lua_ugui.renderer.fill_rectangle(BreitbandGraphics.inflate_rectangle({
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

                        Mupen_lua_ugui.renderer.fill_rectangle(rect, back_color)
                        rect.x = rect.x + 2
                        Mupen_lua_ugui.renderer.draw_text(rect, 'start', 'center', text_color, 14,
                            "Microsoft Sans Serif",
                            control.items[i])
                    end
                end
            end,

            draw_listbox = function(control)
                Mupen_lua_ugui.renderer.fill_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, 1), {
                    r = 130,
                    g = 135,
                    b = 144
                })
                Mupen_lua_ugui.renderer.fill_rectangle(control.rectangle, {
                    r = 255,
                    g = 255,
                    b = 255
                })

                local visual_state = get_basic_visual_state(control)

                -- item y position:
                -- y = (20 * (i - 1)) - (y_translation * ((20 * #control.items) - control.rectangle.height))

                local index_begin = (Mupen_lua_ugui.control_data[control.uid].y_translation *
                    ((20 * #control.items) - control.rectangle.height)) / 20

                local index_end = (control.rectangle.height + (Mupen_lua_ugui.control_data[control.uid].y_translation *
                    ((20 * #control.items) - control.rectangle.height))) / 20

                index_begin = math.max(index_begin, 0)
                index_end = math.min(index_end, #control.items)

                Mupen_lua_ugui.renderer.push_clip(control.rectangle)

                for i = math.floor(index_begin), math.ceil(index_end), 1 do
                    local y = (20 * (i - 1)) -
                        (Mupen_lua_ugui.control_data[control.uid].y_translation * ((20 * #control.items) - control.rectangle.height))

                    local text_color = {
                        r = 0,
                        g = 0,
                        b = 0,
                    }


                    -- TODO: add clipping support, as proper smooth scrolling is not achievable without clipping

                    if control.selected_index == i then
                        local accent_color = {
                            r = 0,
                            g = 120,
                            b = 215
                        }

                        if visual_state == DISABLED then
                            accent_color = {
                                r = 204,
                                g = 204,
                                b = 204,
                            }
                        end


                        Mupen_lua_ugui.renderer.fill_rectangle({
                            x = control.rectangle.x,
                            y = control.rectangle.y + y,
                            width = control.rectangle.width,
                            height = 20
                        }, accent_color)

                        text_color = {
                            r = 255,
                            g = 255,
                            b = 255
                        }
                    end

                    if visual_state == DISABLED then
                        text_color = {
                            r = 160,
                            g = 160,
                            b = 160,
                        }
                    end


                    Mupen_lua_ugui.renderer.draw_text({
                            x = control.rectangle.x + 2,
                            y = control.rectangle.y + y,
                            width = control.rectangle.width,
                            height = 20
                        }, 'start', 'center', text_color, 14, "Microsoft Sans Serif",
                        control.items[i])
                end


                if #control.items * 20 > control.rectangle.height then
                    local scrollbar_y = Mupen_lua_ugui.control_data[control.uid].y_translation * control.rectangle
                        .height
                    local scrollbar_height = 2 * 20 * (control.rectangle.height / (20 * #control.items))
                    -- we center the scrollbar around the translation value

                    scrollbar_y = scrollbar_y - scrollbar_height / 2
                    scrollbar_y = clamp(scrollbar_y, 0, control.rectangle.height - scrollbar_height)

                    Mupen_lua_ugui.renderer.fill_rectangle({
                        x = control.rectangle.x + control.rectangle.width - 10,
                        y = control.rectangle.y,
                        width = 10,
                        height = control.rectangle.height
                    }, {
                        r = 240,
                        g = 240,
                        b = 240
                    })

                    Mupen_lua_ugui.renderer.fill_rectangle({
                        x = control.rectangle.x + control.rectangle.width - 10,
                        y = control.rectangle.y + scrollbar_y,
                        width = 10,
                        height = scrollbar_height
                    }, {
                        r = 204,
                        g = 204,
                        b = 204
                    })
                end

                Mupen_lua_ugui.renderer.pop_clip()
            end
        },
    },

    begin_frame = function(renderer, styler, input_state)
        Mupen_lua_ugui.previous_input_state = clone(Mupen_lua_ugui.input_state)
        Mupen_lua_ugui.input_state = clone(input_state)
        Mupen_lua_ugui.renderer = renderer
        Mupen_lua_ugui.styler = styler

        if is_pointer_just_down() then
            Mupen_lua_ugui.previous_pointer_primary_down_position = Mupen_lua_ugui.input_state.pointer.position
        end
    end,

    end_frame = function()
        for i = 1, #Mupen_lua_ugui.end_frame_callbacks, 1 do
            Mupen_lua_ugui.end_frame_callbacks[i]()
        end

        Mupen_lua_ugui.end_frame_callbacks = {}
    end,

    button = function(control)
        local pushed = is_pointer_just_down() and is_pointer_inside(control.rectangle) and
            not is_pointer_inside(Mupen_lua_ugui.modal_hittest_ignore_rectangle) and control.is_enabled

        if pushed then
            Mupen_lua_ugui.active_control_uid = control.uid
        end

        Mupen_lua_ugui.styler.draw_button(control)

        return pushed
    end,

    toggle_button = function(control)
        local pushed = is_pointer_just_down() and is_previous_primary_down_pointer_inside(control.rectangle) and
            not is_pointer_inside(Mupen_lua_ugui.modal_hittest_ignore_rectangle)

        local is_checked = control.is_checked

        if pushed and control.is_enabled then
            Mupen_lua_ugui.active_control_uid = control.uid
            is_checked = not is_checked
        end

        Mupen_lua_ugui.styler.draw_togglebutton(control)

        return is_checked
    end,

    textbox = function(control)
        if not Mupen_lua_ugui.control_data[control.uid] then
            Mupen_lua_ugui.control_data[control.uid] = {
                caret_index = 1
            }
        end

        local pushed = is_pointer_just_down() and is_previous_primary_down_pointer_inside(control.rectangle) and
            not is_pointer_inside(Mupen_lua_ugui.modal_hittest_ignore_rectangle)

        if pushed and control.is_enabled then
            Mupen_lua_ugui.active_control_uid = control.uid
        end

        local function get_caret_index_at_relative_position(position)
            -- TODO: optimize
            local x = position.x - control.rectangle.x
            local lowest_distance = 9999999999
            local lowest_distance_index = -1
            for i = 1, #control.text + 2, 1 do
                local dist = math.abs(Mupen_lua_ugui.renderer.get_text_size(control.text:sub(1, i - 1), 14,
                    "Microsoft Sans Serif").width - x)
                if dist < lowest_distance then
                    lowest_distance = dist
                    lowest_distance_index = i
                end
            end

            return lowest_distance_index
        end

        local text = control.text

        if Mupen_lua_ugui.active_control_uid == control.uid and control.is_enabled then
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


        Mupen_lua_ugui.styler.draw_textbox(control)

        return text
    end,

    joystick = function(control)
        Mupen_lua_ugui.styler.draw_joystick(control)

        return control.position
    end,

    trackbar = function(control)
        local value = control.value

        local pushed = is_pointer_just_down() and is_previous_primary_down_pointer_inside(control.rectangle) and
            not is_pointer_inside(Mupen_lua_ugui.modal_hittest_ignore_rectangle)
        if pushed and control.is_enabled then
            Mupen_lua_ugui.active_control_uid = control.uid
        end

        -- we instantly deactivate this control after releasing our mouse to emulate windows behaviour
        if Mupen_lua_ugui.active_control_uid == control.uid and not is_pointer_down() and control.is_enabled then
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

        Mupen_lua_ugui.styler.draw_trackbar(control)

        return value
    end,

    combobox = function(control)
        if not Mupen_lua_ugui.control_data[control.uid] then
            Mupen_lua_ugui.control_data[control.uid] = {
                is_open = false,
                hovered_index = 0,
            }
        end

        if not control.is_enabled then
            Mupen_lua_ugui.control_data[control.uid].is_open = false
            Mupen_lua_ugui.modal_hittest_ignore_rectangle = { x = 0, y = 0, width = 0, height = 0 }
        end

        if is_pointer_just_down() and control.is_enabled then
            if is_pointer_inside(control.rectangle) then
                Mupen_lua_ugui.control_data[control.uid].is_open = not Mupen_lua_ugui.control_data[control.uid].is_open
                if not Mupen_lua_ugui.control_data[control.uid].is_open then
                    Mupen_lua_ugui.modal_hittest_ignore_rectangle = { x = 0, y = 0, width = 0, height = 0 }
                end
            else
                if not is_pointer_inside({
                        x = control.rectangle.x,
                        y = control.rectangle.y + control.rectangle.height,
                        width = control.rectangle.width,
                        height = 20 * #control.items
                    }) then
                    Mupen_lua_ugui.control_data[control.uid].is_open = false
                    Mupen_lua_ugui.modal_hittest_ignore_rectangle = { x = 0, y = 0, width = 0, height = 0 }
                end
            end
        end

        local selected_index = control.selected_index

        if Mupen_lua_ugui.control_data[control.uid].is_open and control.is_enabled then
            Mupen_lua_ugui.modal_hittest_ignore_rectangle = {
                x = control.rectangle.x,
                y = control.rectangle.y + control.rectangle.height,
                width = control.rectangle.width,
                height = 20 * #control.items
            }

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
                        Mupen_lua_ugui.modal_hittest_ignore_rectangle = { x = 0, y = 0, width = 0, height = 0 }
                    end
                    Mupen_lua_ugui.control_data[control.uid].hovered_index = i
                    break
                end
            end
        end



        selected_index = clamp(selected_index, 1, #control.items)

        Mupen_lua_ugui.end_frame_callbacks[#Mupen_lua_ugui.end_frame_callbacks + 1] = function()
            Mupen_lua_ugui.styler.draw_combobox(control)
        end


        return selected_index
    end,

    listbox = function(control)
        if not Mupen_lua_ugui.control_data[control.uid] then
            Mupen_lua_ugui.control_data[control.uid] = {
                y_translation = 0,
            }
        end

        local scrollbar_rect = {
            x = control.rectangle.x + control.rectangle.width - 10,
            y = control.rectangle.y,
            width = 10,
            height = control.rectangle.height,
        }

        -- we instantly deactivate this control after releasing our mouse to emulate windows behaviour
        if Mupen_lua_ugui.active_control_uid == control.uid and not is_pointer_down() then
            Mupen_lua_ugui.active_control_uid = nil
        end

        local selected_index = control.selected_index

        if control.is_enabled and is_pointer_inside(control.rectangle) and not is_pointer_inside(Mupen_lua_ugui.modal_hittest_ignore_rectangle) then
            if is_pointer_just_down() and is_pointer_inside(scrollbar_rect) then
                Mupen_lua_ugui.active_control_uid = control.uid
            end
            if is_pointer_down() and not is_pointer_inside(scrollbar_rect) and not is_previous_primary_down_pointer_inside(scrollbar_rect) then
                local relative_y = Mupen_lua_ugui.input_state.pointer.position.y - control.rectangle.y;
                local new_index = math.ceil((relative_y + (Mupen_lua_ugui.control_data[control.uid].y_translation *
                    ((20 * #control.items) - control.rectangle.height))) / 20)
                -- we only assign the new index if it's within bounds, as
                -- this emulates windows commctl behaviour
                if new_index <= #control.items then
                    selected_index = new_index
                end
            end
        end


        if Mupen_lua_ugui.active_control_uid == control.uid then
            -- only allow translation if content overflows

            if #control.items * 20 > control.rectangle.height then
                local v = (Mupen_lua_ugui.input_state.pointer.position.y - control.rectangle.y) /
                    control.rectangle.height
                Mupen_lua_ugui.control_data[control.uid].y_translation = v
            end
        end

        Mupen_lua_ugui.control_data[control.uid].y_translation = clamp(
            Mupen_lua_ugui.control_data[control.uid].y_translation, 0, 1)

        Mupen_lua_ugui.styler.draw_listbox(control)

        return selected_index
    end
}
