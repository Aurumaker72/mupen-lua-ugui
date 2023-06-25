-- mupen-lua-ugui 1.0.0

if not wgui.fill_rectangle then
    print("BreitbandGraphics requires a Mupen64-rr-lua version newer than 1.1.2\r\n")
end

---@alias color {r: integer, g: integer, b: integer, a: integer?} RGBA color 0-255
---@alias color_hex string "#RRGGBBB"
---@alias color_float {r: number, g: number, b: number, a: number} Color passed into d2d function 0-1

---@alias point {x: integer, y: integer}
---@alias rectangle {x: integer, y: integer, width: integer, height: integer}
---@alias radii {x: integer, y: integer}

---@alias text_style {is_bold: boolean, is_italic: boolean}

BreitbandGraphics = {
    ---Converts `color` to `color_hex`.
    ---@param color color
    ---@return color_hex
    color_to_hex = function(color)
        return string.format("#%06X",
            (color.r * 0x10000) + (color.g * 0x100) + color.b)
    end,
    ---Converts `color_hex` to `color`.
    ---@param hex color_hex
    ---@return color
    hex_to_color = function(hex)
        return
        {
            r = tonumber(hex:sub(2, 3), 16),
            g = tonumber(hex:sub(4, 5), 16),
            b = tonumber(hex:sub(6, 7), 16),
        }
    end,
    colors = {
        white = {
            r = 255,
            g = 255,
            b = 255,
        },
        black = {
            r = 0,
            g = 0,
            b = 0,
        },
        red = {
            r = 255,
            g = 0,
            b = 0,
        },
        green = {
            r = 0,
            g = 255,
            b = 0,
        },
        blue = {
            r = 0,
            g = 0,
            b = 255,
        },
        yellow = {
            r = 255,
            g = 255,
            b = 0,
        },
        orange = {
            r = 255,
            g = 128,
            b = 0,
        },
        magenta = {
            r = 255,
            g = 0,
            b = 255,
        },
    },

    ---Inflates a rectangle by `amount` and returns a new rectangle.
    ---@param rectangle rectangle
    ---@param amount integer
    ---@return rectangle
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
            bitmap_cache = {},
            ---Converts `color` to `color_float`.
            ---@param color color
            ---@return color_float
            color_to_float = function(color)
                return {
                    r = color.r / 255.0,
                    g = color.g / 255.0,
                    b = color.b / 255.0,
                    a = (color.a and (color.a / 255.0) or 1.0),
                }
            end,
            ---Returns the size of the given text.
            ---@param text string
            ---@param font_size number
            ---@param font_name string
            ---@return { width: integer, height: integer }
            get_text_size = function(text, font_size, font_name)
                return wgui.get_text_size(text, font_name, font_size, 99999999, 99999999)
            end,
            ---Draws the the border of a rectangle.
            ---@param rectangle rectangle
            ---@param color color
            ---@param thickness number
            draw_rectangle = function(rectangle, color, thickness)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.draw_rectangle(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
                    rectangle.y + rectangle.height, float_color.r, float_color.g, float_color.b, 1.0, thickness)
            end,
            ---Draws a filled in rectangle.
            ---@param rectangle rectangle
            ---@param color color
            fill_rectangle = function(rectangle, color)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.fill_rectangle(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
                    rectangle.y + rectangle.height, float_color.r, float_color.g, float_color.b, 1.0)
            end,
            ---Draws the border of a rounded rectangle.
            ---@param rectangle rectangle
            ---@param color color
            ---@param radii radii
            ---@param thickness number
            draw_rounded_rectangle = function(rectangle, color, radii, thickness)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.draw_rounded_rectangle(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
                    rectangle.y + rectangle.height, radii.x, radii.y, float_color.r, float_color.g, float_color.b, 1.0,
                    thickness)
            end,
            ---Draws a filled in rounded rectangle.
            ---@param rectangle rectangle
            ---@param color color
            ---@param radii radii
            fill_rounded_rectangle = function(rectangle, color, radii)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.fill_rounded_rectangle(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
                    rectangle.y + rectangle.height, radii.x, radii.y, float_color.r, float_color.g, float_color.b, 1.0)
            end,
            ---Draws the border of an ellipse.
            ---@param rectangle rectangle
            ---@param color color
            ---@param thickness number
            draw_ellipse = function(rectangle, color, thickness)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.draw_ellipse(rectangle.x + rectangle.width / 2, rectangle.y + rectangle.height / 2,
                    rectangle.width / 2, rectangle.height / 2, float_color.r, float_color.g, float_color.b, 1.0,
                    thickness)
            end,
            ---Draws a filled in ellipse.
            ---@param rectangle rectangle
            ---@param color color
            fill_ellipse = function(rectangle, color)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.fill_ellipse(rectangle.x + rectangle.width / 2, rectangle.y + rectangle.height / 2,
                    rectangle.width / 2, rectangle.height / 2, float_color.r, float_color.g, float_color.b, 1.0)
            end,
            ---Draws text.
            ---@param rectangle rectangle
            ---@param horizontal_alignment "center"|"start"|"end"|"stretch"
            ---@param vertical_alignment "center"|"start"|"end"
            ---@param style text_style
            ---@param color color
            ---@param font_size number
            ---@param font_name string
            ---@param text string
            draw_text = function(rectangle, horizontal_alignment, vertical_alignment, style, color, font_size, font_name,
                text)
                if text == nil then
                    text = ""
                end

                local d_horizontal_alignment = 0
                local d_vertical_alignment = 0
                local d_style = 0

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

                if style.is_bold then
                    d_style = d_style | (1 << 0);
                end
                if style.is_italic then
                    d_style = d_style | (2 << 0);
                end

                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.draw_text(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
                    rectangle.y + rectangle.height, float_color.r, float_color.g, float_color.b, 1.0, text, font_name,
                    font_size, d_style, d_horizontal_alignment, d_vertical_alignment)
            end,
            ---Draws a line.
            ---@param from point
            ---@param to point
            ---@param color color
            ---@param thickness number
            draw_line = function(from, to, color, thickness)
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.draw_line(from.x, from.y, to.x, to.y, float_color.r, float_color.g, float_color.b, 1.0,
                    thickness)
            end,
            ---Pushes a clip
            ---@param rectangle rectangle
            push_clip = function(rectangle)
                wgui.push_clip(rectangle.x, rectangle.y, rectangle.x + rectangle.width,
                    rectangle.y + rectangle.height)
            end,
            ---Pops a clip
            pop_clip = function()
                wgui.pop_clip()
            end,
            ---Draws an image
            ---@param destination_rectangle rectangle
            ---@param source_rectangle rectangle
            ---@param path string
            ---@param color color
            draw_image = function(destination_rectangle, source_rectangle, path, color)
                if not BreitbandGraphics.renderers.d2d.bitmap_cache[path] then
                    print("Loaded image from " .. path)
                    wgui.load_image(path, path)
                end
                BreitbandGraphics.renderers.d2d.bitmap_cache[path] = path
                local float_color = BreitbandGraphics.renderers.d2d.color_to_float(color)
                wgui.draw_image(destination_rectangle.x, destination_rectangle.y,
                    destination_rectangle.x + destination_rectangle.width,
                    destination_rectangle.y + destination_rectangle.height,
                    source_rectangle.x, source_rectangle.y, source_rectangle.x + source_rectangle.width,
                    source_rectangle.y + source_rectangle.height, path, float_color.a, 1)
            end,
        },
        compat = {
            brush = "#FF0000",
            pen = "#FF0000",
            pen_thickness = 1,
            font_size = 0,
            font_name = "Fixedsys",
            text_color = "#FF0000",
            text_options = "",
            any_to_color = function(any)
                if any:find("#") then
                    return BreitbandGraphics.hex_to_color(any)
                else
                    if BreitbandGraphics.colors[any] then
                        return BreitbandGraphics.colors[any]
                    else
                        print("Can't resolve color " .. any .. " to anything")
                    end
                end
            end,
            setbrush = function(color)
                BreitbandGraphics.renderers.compat.brush = color
            end,
            setpen = function(color, thickness)
                BreitbandGraphics.renderers.compat.pen = color
                BreitbandGraphics.renderers.compat.pen_thickness = thickness and thickness or 1
            end,
            setcolor = function(color)
                BreitbandGraphics.renderers.compat.text_color = color
            end,
            setfont = function(size, name, text_options)
                BreitbandGraphics.renderers.compat.font_size = size + 2
                BreitbandGraphics.renderers.compat.font_name = name
                BreitbandGraphics.renderers.compat.text_options = text_options
            end,
            rect = function(x, y, right, bottom)
                local rectangle = {
                    x = x,
                    y = y,
                    width = right - x,
                    height = bottom - y,
                }
                BreitbandGraphics.renderers.d2d.fill_rectangle(
                    BreitbandGraphics.inflate_rectangle(rectangle, BreitbandGraphics.renderers.compat.pen_thickness),
                    BreitbandGraphics.renderers.compat.any_to_color(BreitbandGraphics.renderers.compat.pen))
                BreitbandGraphics.renderers.d2d.fill_rectangle(rectangle,
                    BreitbandGraphics.renderers.compat.any_to_color(BreitbandGraphics.renderers.compat.brush))
            end,
            text = function(x, y, text)
                local size = BreitbandGraphics.renderers.d2d.get_text_size(text,
                    BreitbandGraphics.renderers.compat.font_size, BreitbandGraphics.renderers.compat.font_name)
                BreitbandGraphics.renderers.d2d.draw_text({
                        x = x,
                        y = y,
                        width = 9999999999,
                        height = size.height,
                    }, "start", "start", {
                        is_bold = BreitbandGraphics.renderers.compat.text_options:find("b") and true,
                        is_italic = BreitbandGraphics.renderers.compat.text_options:find("i") and true,
                    },
                    BreitbandGraphics.renderers.compat.any_to_color(BreitbandGraphics.renderers.compat.text_color),
                    BreitbandGraphics.renderers.compat.font_size, BreitbandGraphics.renderers.compat.font_name, text)
            end,
            line = function(x, y, x2, y2)
                BreitbandGraphics.renderers.d2d.draw_line({
                        x = x,
                        y = y,
                    }, {
                        x = x2,
                        y = y2,
                    }, BreitbandGraphics.renderers.compat.any_to_color(BreitbandGraphics.renderers.compat.pen),
                    BreitbandGraphics.renderers.compat.pen_thickness)
            end,
            ellipse = function(x, y, right, bottom)
                local rectangle = {
                    x = x,
                    y = y,
                    width = right - x,
                    height = bottom - y,
                }
                BreitbandGraphics.renderers.d2d.fill_ellipse(
                    BreitbandGraphics.inflate_rectangle(rectangle, BreitbandGraphics.renderers.compat.pen_thickness),
                    BreitbandGraphics.renderers.compat.any_to_color(BreitbandGraphics.renderers.compat.pen))
                BreitbandGraphics.renderers.d2d.fill_ellipse(rectangle,
                    BreitbandGraphics.renderers.compat.any_to_color(BreitbandGraphics.renderers.compat.brush))
            end,
            loadimage = function(path)
                return path
            end,
            drawimage = function(identifier, x, y, width, height)
                BreitbandGraphics.renderers.d2d.draw_image({
                    x = x,
                    y = y,
                    width = width,
                    height = height,
                }, {
                    x = 0,
                    y = 0,
                    width = 999999,
                    height = 999999,
                }, identifier, BreitbandGraphics.colors.white)
            end,
        }
    }
}

-- reverse polyfill old gdi functions
wgui.setbrush = BreitbandGraphics.renderers.compat.setbrush
wgui.setpen = BreitbandGraphics.renderers.compat.setpen
wgui.rect = BreitbandGraphics.renderers.compat.rect
wgui.setcolor = BreitbandGraphics.renderers.compat.setcolor
wgui.setfont = BreitbandGraphics.renderers.compat.setfont
wgui.text = BreitbandGraphics.renderers.compat.text
wgui.line = BreitbandGraphics.renderers.compat.line
wgui.ellipse = BreitbandGraphics.renderers.compat.ellipse
wgui.loadimage = BreitbandGraphics.renderers.compat.loadimage
wgui.drawimage = BreitbandGraphics.renderers.compat.drawimage

-- https://stackoverflow.com/a/26367080/14472122
local function deep_clone(obj, seen)
    if type(obj) ~= "table" then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[deep_clone(k, s)] = deep_clone(v, s) end
    return res
end

---Clamps `value` between `min` and `max`
---@param value number
---@param min number
---@param max number
---@return number
local function clamp(value, min, max)
    return math.max(math.min(value, max), min)
end

---Whether the pointer is inside a given rectangle
---@param rectangle rectangle
---@return boolean
local function is_pointer_inside(rectangle)
    return Mupen_lua_ugui.input_state.pointer.position.x > rectangle.x and
        Mupen_lua_ugui.input_state.pointer.position.y > rectangle.y and
        Mupen_lua_ugui.input_state.pointer.position.x < rectangle.x + rectangle.width and
        Mupen_lua_ugui.input_state.pointer.position.y < rectangle.y + rectangle.height;
end

local function is_pointer_inside_ignored_rectangle()
    for i = 1, #Mupen_lua_ugui.hittest_ignore_rectangles, 1 do
        if (Mupen_lua_ugui.input_state.pointer.position.x > Mupen_lua_ugui.hittest_ignore_rectangles[i].x and
                Mupen_lua_ugui.input_state.pointer.position.y > Mupen_lua_ugui.hittest_ignore_rectangles[i].y and
                Mupen_lua_ugui.input_state.pointer.position.x < Mupen_lua_ugui.hittest_ignore_rectangles[i].x + Mupen_lua_ugui.hittest_ignore_rectangles[i].width and
                Mupen_lua_ugui.input_state.pointer.position.y < Mupen_lua_ugui.hittest_ignore_rectangles[i].y + Mupen_lua_ugui.hittest_ignore_rectangles[i].height)
        then
            return true
        end
    end
    return false
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

local function remove_range(string, start_index, end_index)
    if start_index > end_index then
        start_index, end_index = end_index, start_index
    end
    return string.sub(string, 1, start_index - 1) .. string.sub(string, end_index)
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





Mupen_lua_ugui = {
    -- TODO: find better way of protecting these
    -- Dictionary of additional control data by id
    -- Library-side state, don't mutate
    control_data = {},
    input_state = {},
    previous_input_state = {},
    active_control_uid = nil,
    previous_pointer_primary_down_position = {x = 0, y = 0},
    hittest_ignore_rectangles = {},
    -- we can only interact with one control per frame
    has_primary_input_been_handled = false,
    end_frame_callbacks = {},
    renderer = nil,
    styler = nil,
    visual_states = {
        disabled = 0,
        normal = 1,
        hovered = 2,
        active = 3,
    },
    get_visual_state = function(control)
        if not control.is_enabled then
            return Mupen_lua_ugui.visual_states.disabled
        end

        if is_pointer_inside(control.rectangle) and not is_pointer_inside_ignored_rectangle() then
            if is_previous_primary_down_pointer_inside(control.rectangle) and is_pointer_down() then
                return Mupen_lua_ugui.visual_states.active
            end

            return Mupen_lua_ugui.visual_states.hovered
        end
        return Mupen_lua_ugui.visual_states.normal
    end,

    stylers = {
        windows_10 = {
            textbox_padding = 2,
            draw_raised_frame = function(control, visual_state)
                local back_color = {
                    r = 225,
                    g = 225,
                    b = 225,
                }
                local border_color = {
                    r = 173,
                    g = 173,
                    b = 173,
                }

                if visual_state == Mupen_lua_ugui.visual_states.active then
                    back_color = {
                        r = 204,
                        g = 228,
                        b = 247,
                    }
                    border_color = {
                        r = 0,
                        g = 84,
                        b = 153,
                    }
                elseif visual_state == Mupen_lua_ugui.visual_states.hovered then
                    back_color = {
                        r = 229,
                        g = 241,
                        b = 251,
                    }
                    border_color = {
                        r = 0,
                        g = 120,
                        b = 215,
                    }
                elseif visual_state == Mupen_lua_ugui.visual_states.disabled then
                    back_color = {
                        r = 204,
                        g = 204,
                        b = 204,
                    }
                    border_color = {
                        r = 191,
                        g = 191,
                        b = 191,
                    }
                end

                Mupen_lua_ugui.renderer.fill_rectangle(control.rectangle,
                    border_color)
                Mupen_lua_ugui.renderer.fill_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, -1),
                    back_color)
            end,
            draw_button = function(control)
                local visual_state = Mupen_lua_ugui.get_visual_state(control)

                -- override for toggle_button
                if control.is_checked and control.is_enabled then
                    visual_state = Mupen_lua_ugui.visual_states.active
                end

                Mupen_lua_ugui.stylers.windows_10.draw_raised_frame(control, visual_state)

                local text_color = {
                    r = 0,
                    g = 0,
                    b = 0,
                }

                if visual_state == Mupen_lua_ugui.visual_states.disabled then
                    text_color = {
                        r = 160,
                        g = 160,
                        b = 160,
                    }
                end

                Mupen_lua_ugui.renderer.draw_text(control.rectangle, "center", "center",
                    {}, text_color,
                    12,
                    "MS Sans Serif", control.text)
            end,
            draw_togglebutton = function(control)
                Mupen_lua_ugui.stylers.windows_10.draw_button(control)
            end,
            draw_textbox = function(control)
                local visual_state = Mupen_lua_ugui.get_visual_state(control)

                local back_color = {
                    r = 255,
                    g = 255,
                    b = 255,
                }
                local border_color = {
                    r = 122,
                    g = 122,
                    b = 122,
                }
                local text_color = {
                    r = 0,
                    g = 0,
                    b = 0,
                }

                if Mupen_lua_ugui.active_control_uid == control.uid and control.is_enabled then
                    visual_state = Mupen_lua_ugui.visual_states.active
                end

                if visual_state == Mupen_lua_ugui.visual_states.hovered then
                    border_color = {
                        r = 23,
                        g = 23,
                        b = 23,
                    }
                elseif visual_state == Mupen_lua_ugui.visual_states.active then
                    border_color = {
                        r = 0,
                        g = 84,
                        b = 153,
                    }
                elseif visual_state == Mupen_lua_ugui.visual_states.disabled then
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
                local should_visualize_selection = not (Mupen_lua_ugui.control_data[control.uid].selection_start == nil) and
                    not (Mupen_lua_ugui.control_data[control.uid].selection_end == nil) and control.is_enabled and
                    not (Mupen_lua_ugui.control_data[control.uid].selection_start == Mupen_lua_ugui.control_data[control.uid].selection_end)

                if should_visualize_selection then
                    local string_to_selection_start = control.text:sub(1,
                        Mupen_lua_ugui.control_data[control.uid].selection_start - 1)
                    local string_to_selection_end = control.text:sub(1,
                        Mupen_lua_ugui.control_data[control.uid].selection_end - 1)

                    Mupen_lua_ugui.renderer.fill_rectangle({
                            x = control.rectangle.x +
                                Mupen_lua_ugui.renderer.get_text_size(string_to_selection_start, 12,
                                    "MS Sans Serif")
                                .width + Mupen_lua_ugui.stylers.windows_10.textbox_padding,
                            y = control.rectangle.y,
                            width = Mupen_lua_ugui.renderer.get_text_size(string_to_selection_end, 12,
                                    "MS Sans Serif")
                                .width -
                                Mupen_lua_ugui.renderer.get_text_size(string_to_selection_start, 12,
                                    "MS Sans Serif")
                                .width,
                            height = control.rectangle.height,
                        },
                        BreitbandGraphics.hex_to_color("#0078D7"))
                end

                Mupen_lua_ugui.renderer.draw_text({
                        x = control.rectangle.x + Mupen_lua_ugui.stylers.windows_10.textbox_padding,
                        y = control.rectangle.y,
                        width = control.rectangle.width - Mupen_lua_ugui.stylers.windows_10.textbox_padding * 2,
                        height = control.rectangle.height,
                    }, "start", "start", {}, text_color, 12,
                    "MS Sans Serif", control.text)

                if should_visualize_selection then
                    local lower = Mupen_lua_ugui.control_data[control.uid].selection_start
                    local higher = Mupen_lua_ugui.control_data[control.uid].selection_end
                    if Mupen_lua_ugui.control_data[control.uid].selection_start > Mupen_lua_ugui.control_data[control.uid].selection_end then
                        lower = Mupen_lua_ugui.control_data[control.uid].selection_end
                        higher = Mupen_lua_ugui.control_data[control.uid].selection_start
                    end

                    local string_to_selection_start = control.text:sub(1,
                        lower - 1)
                    local string_to_selection_end = control.text:sub(1,
                        higher - 1)

                    local selection_start_x = control.rectangle.x +
                        Mupen_lua_ugui.renderer.get_text_size(string_to_selection_start, 12,
                            "MS Sans Serif").width + Mupen_lua_ugui.stylers.windows_10.textbox_padding

                    local selection_end_x = control.rectangle.x +
                        Mupen_lua_ugui.renderer.get_text_size(string_to_selection_end, 12,
                            "MS Sans Serif").width + Mupen_lua_ugui.stylers.windows_10.textbox_padding

                    Mupen_lua_ugui.renderer.push_clip({
                        x = selection_start_x,
                        y = control.rectangle.y,
                        width = selection_end_x - selection_start_x,
                        height = control.rectangle.height
                    })
                    Mupen_lua_ugui.renderer.draw_text({
                            x = control.rectangle.x + Mupen_lua_ugui.stylers.windows_10.textbox_padding,
                            y = control.rectangle.y,
                            width = control.rectangle.width - Mupen_lua_ugui.stylers.windows_10.textbox_padding * 2,
                            height = control.rectangle.height,
                        }, 'start', 'start', {}, BreitbandGraphics.colors.white, 12,
                        "MS Sans Serif", control.text)
                    Mupen_lua_ugui.renderer.pop_clip()
                end


                local string_to_caret = control.text:sub(1, Mupen_lua_ugui.control_data[control.uid].caret_index - 1)
                local caret_x = Mupen_lua_ugui.renderer.get_text_size(string_to_caret, 12, "MS Sans Serif").width +
                    Mupen_lua_ugui.stylers.windows_10.textbox_padding

                if visual_state == Mupen_lua_ugui.visual_states.active and math.floor(os.clock() * 2) % 2 == 0 and not should_visualize_selection then
                    Mupen_lua_ugui.renderer.draw_line({
                        x = control.rectangle.x + caret_x,
                        y = control.rectangle.y + 2,
                    }, {
                        x = control.rectangle.x + caret_x,
                        y = control.rectangle.y +
                            math.max(15,
                                Mupen_lua_ugui.renderer.get_text_size(string_to_caret, 12, "MS Sans Serif")
                                .height), -- TODO: move text measurement into BreitbandGraphics
                    }, {
                        r = 0,
                        g = 0,
                        b = 0,
                    }, 1)
                end
            end,
            draw_joystick = function(control)
                local visual_state = Mupen_lua_ugui.get_visual_state(control)

                local back_color = {
                    r = 255,
                    g = 255,
                    b = 255,
                }
                local outline_color = {
                    r = 0,
                    g = 0,
                    b = 0,
                }
                local tip_color = {
                    r = 255,
                    g = 0,
                    b = 0,
                }
                local line_color = {
                    r = 0,
                    g = 0,
                    b = 255,
                }

                if visual_state == Mupen_lua_ugui.visual_states.disabled then
                    outline_color = {
                        r = 191,
                        g = 191,
                        b = 191,
                    }
                    tip_color = {
                        r = 255,
                        g = 128,
                        b = 128,
                    }
                    line_color = {
                        r = 128,
                        g = 128,
                        b = 255,
                    }
                end

                local stick_position = {
                    x = remap(control.position.x, 0, 1, control.rectangle.x,
                        control.rectangle.x + control.rectangle.width),
                    y = remap(control.position.y, 0, 1, control.rectangle.y,
                        control.rectangle.y + control.rectangle.height),
                }
                Mupen_lua_ugui.stylers.windows_10.draw_raised_frame(control, visual_state)
                Mupen_lua_ugui.renderer.fill_ellipse(BreitbandGraphics.inflate_rectangle(control.rectangle, -1),
                    back_color)
                Mupen_lua_ugui.renderer.draw_ellipse(BreitbandGraphics.inflate_rectangle(control.rectangle, -1),
                    outline_color, 1)
                Mupen_lua_ugui.renderer.draw_line({
                    x = control.rectangle.x + control.rectangle.width / 2,
                    y = control.rectangle.y,
                }, {
                    x = control.rectangle.x + control.rectangle.width / 2,
                    y = control.rectangle.y + control.rectangle.height,
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
                local visual_state = Mupen_lua_ugui.get_visual_state(control)

                local track_color = {
                    r = 231,
                    g = 234,
                    b = 234,
                }
                local track_border_color = {
                    r = 214,
                    g = 214,
                    b = 214,
                }
                local head_color = {
                    r = 0,
                    g = 122,
                    b = 217,
                }

                if Mupen_lua_ugui.active_control_uid == control.uid and control.is_enabled then
                    visual_state = Mupen_lua_ugui.visual_states.active
                end

                if visual_state == Mupen_lua_ugui.visual_states.hovered then
                    head_color = {
                        r = 23,
                        g = 23,
                        b = 23,
                    }
                elseif visual_state == Mupen_lua_ugui.visual_states.active then
                    head_color = {
                        r = 204,
                        g = 204,
                        b = 204,
                    }
                elseif visual_state == Mupen_lua_ugui.visual_states.disabled then
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
                        height = control.rectangle.height,
                    }
                    head_rectangle = {
                        x = control.rectangle.x + control.rectangle.width / 2 - HEAD_HEIGHT / 2,
                        y = control.rectangle.y + (control.value * control.rectangle.height) - HEAD_WIDTH / 2,
                        width = HEAD_HEIGHT,
                        height = HEAD_WIDTH,
                    }
                else
                    track_rectangle = {
                        x = control.rectangle.x,
                        y = control.rectangle.y + control.rectangle.height / 2 - TRACK_THICKNESS / 2,
                        width = control.rectangle.width,
                        height = TRACK_THICKNESS,
                    }
                    head_rectangle = {
                        x = control.rectangle.x + (control.value * control.rectangle.width) - HEAD_WIDTH / 2,
                        y = control.rectangle.y + control.rectangle.height / 2 - HEAD_HEIGHT / 2,
                        width = HEAD_WIDTH,
                        height = HEAD_HEIGHT,
                    }
                end

                Mupen_lua_ugui.renderer.fill_rectangle(BreitbandGraphics.inflate_rectangle(track_rectangle, 1),
                    track_border_color)
                Mupen_lua_ugui.renderer.fill_rectangle(track_rectangle, track_color)
                Mupen_lua_ugui.renderer.fill_rectangle(head_rectangle, head_color)
            end,
            draw_combobox = function(control)
                local visual_state = Mupen_lua_ugui.get_visual_state(control)

                local text_color = {
                    r = 0,
                    g = 0,
                    b = 0,
                }

                if Mupen_lua_ugui.control_data[control.uid].is_open and control.is_enabled then
                    visual_state = Mupen_lua_ugui.visual_states.active
                end

                Mupen_lua_ugui.stylers.windows_10.draw_raised_frame(control, visual_state)

                if visual_state == Mupen_lua_ugui.visual_states.disabled then
                    text_color = {
                        r = 109,
                        g = 109,
                        b = 109,
                    }
                end
                Mupen_lua_ugui.renderer.draw_text({
                        x = control.rectangle.x + Mupen_lua_ugui.stylers.windows_10.textbox_padding * 2,
                        y = control.rectangle.y,
                        width = control.rectangle.width,
                        height = control.rectangle.height,
                    }, "start", "center", {}, text_color, 12, "MS Sans Serif",
                    control.items[control.selected_index])

                Mupen_lua_ugui.renderer.draw_text({
                        x = control.rectangle.x,
                        y = control.rectangle.y,
                        width = control.rectangle.width - Mupen_lua_ugui.stylers.windows_10.textbox_padding * 4,
                        height = control.rectangle.height,
                    }, "end", "center", {}, text_color, 12, "Segoe UI Mono",
                    Mupen_lua_ugui.control_data[control.uid].is_open and "^" or "v")

                if Mupen_lua_ugui.control_data[control.uid].is_open then
                    Mupen_lua_ugui.renderer.fill_rectangle(BreitbandGraphics.inflate_rectangle({
                        x = control.rectangle.x,
                        y = control.rectangle.y + control.rectangle.height,
                        width = control.rectangle.width,
                        height = #control.items * 20,
                    }, 1), {
                        r = 0,
                        g = 120,
                        b = 215,
                    })

                    for i = 1, #control.items, 1 do
                        local rect = {
                            x = control.rectangle.x,
                            y = control.rectangle.y + control.rectangle.height + (20 * (i - 1)),
                            width = control.rectangle.width,
                            height = 20,
                        }

                        local back_color = {
                            r = 255,
                            g = 255,
                            b = 255,
                        }
                        local text_color = {
                            r = 0,
                            g = 0,
                            b = 0,
                        }

                        if Mupen_lua_ugui.control_data[control.uid].hovered_index == i then
                            back_color = {
                                r = 0,
                                g = 120,
                                b = 215,
                            }
                            text_color = {
                                r = 255,
                                g = 255,
                                b = 255,
                            }
                        end

                        Mupen_lua_ugui.renderer.fill_rectangle(rect, back_color)
                        rect.x = rect.x + 2
                        Mupen_lua_ugui.renderer.draw_text(rect, "start", "center", {}, text_color, 12,
                            "MS Sans Serif",
                            control.items[i])
                    end
                end
            end,

            draw_listbox = function(control)
                Mupen_lua_ugui.renderer.fill_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, 1), {
                    r = 130,
                    g = 135,
                    b = 144,
                })
                Mupen_lua_ugui.renderer.fill_rectangle(control.rectangle, {
                    r = 255,
                    g = 255,
                    b = 255,
                })

                local visual_state = Mupen_lua_ugui.get_visual_state(control)

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
                            b = 215,
                        }

                        if visual_state == Mupen_lua_ugui.visual_states.disabled then
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
                            height = 20,
                        }, accent_color)

                        text_color = {
                            r = 255,
                            g = 255,
                            b = 255,
                        }
                    end

                    if visual_state == Mupen_lua_ugui.visual_states.disabled then
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
                            height = 20,
                        }, "start", "center", {}, text_color, 12, "MS Sans Serif",
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
                        height = control.rectangle.height,
                    }, {
                        r = 240,
                        g = 240,
                        b = 240,
                    })

                    Mupen_lua_ugui.renderer.fill_rectangle({
                        x = control.rectangle.x + control.rectangle.width - 10,
                        y = control.rectangle.y + scrollbar_y,
                        width = 10,
                        height = scrollbar_height,
                    }, {
                        r = 204,
                        g = 204,
                        b = 204,
                    })
                end

                Mupen_lua_ugui.renderer.pop_clip()
            end,
        },
    },

    begin_frame = function(renderer, styler, input_state)
        Mupen_lua_ugui.previous_input_state = deep_clone(Mupen_lua_ugui.input_state)
        Mupen_lua_ugui.input_state = deep_clone(input_state)
        Mupen_lua_ugui.renderer = renderer
        Mupen_lua_ugui.styler = styler
        Mupen_lua_ugui.has_primary_input_been_handled = false

        if is_pointer_just_down() then
            Mupen_lua_ugui.previous_pointer_primary_down_position = Mupen_lua_ugui.input_state.pointer.position
        end
    end,

    end_frame = function()
        for i = 1, #Mupen_lua_ugui.end_frame_callbacks, 1 do
            Mupen_lua_ugui.end_frame_callbacks[i]()
        end

        Mupen_lua_ugui.end_frame_callbacks = {}
        Mupen_lua_ugui.hittest_ignore_rectangles = {}
    end,

    button = function(control)
        local pushed = is_pointer_just_down() and is_pointer_inside(control.rectangle) and
            not is_pointer_inside_ignored_rectangle() and control.is_enabled and
            not Mupen_lua_ugui.has_primary_input_been_handled

        if pushed then
            Mupen_lua_ugui.active_control_uid = control.uid
        end

        Mupen_lua_ugui.styler.draw_button(control)

        return pushed
    end,

    toggle_button = function(control)
        local pushed = is_pointer_just_down() and is_previous_primary_down_pointer_inside(control.rectangle) and
            not is_pointer_inside_ignored_rectangle() and
            not Mupen_lua_ugui.has_primary_input_been_handled

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
                caret_index = 1,
                selection_start = nil,
                selection_end = nil,
            }
        end

        local pushed = is_pointer_just_down() and is_previous_primary_down_pointer_inside(control.rectangle) and
            not is_pointer_inside_ignored_rectangle() and
            not Mupen_lua_ugui.has_primary_input_been_handled
        local text = control.text

        if pushed and control.is_enabled then
            Mupen_lua_ugui.active_control_uid = control.uid
        end

        if not (Mupen_lua_ugui.active_control_uid == control.uid) then
            Mupen_lua_ugui.control_data[control.uid].selection_start = nil
            Mupen_lua_ugui.control_data[control.uid].selection_end = nil
        end

        local function get_caret_index_at_relative_position(position)
            -- TODO: optimize
            local x = (position.x - control.rectangle.x) + Mupen_lua_ugui.styler.textbox_padding
            local lowest_distance = 9999999999
            local lowest_distance_index = -1
            for i = 1, #control.text + 2, 1 do
                local dist = math.abs(Mupen_lua_ugui.renderer.get_text_size(control.text:sub(1, i - 1), 12,
                    "MS Sans Serif").width - x)
                if dist < lowest_distance then
                    lowest_distance = dist
                    lowest_distance_index = i
                end
            end

            return lowest_distance_index
        end

        local function get_higher_selection()
            if Mupen_lua_ugui.control_data[control.uid].selection_start > Mupen_lua_ugui.control_data[control.uid].selection_end then
                return Mupen_lua_ugui.control_data[control.uid].selection_start
            end
            return Mupen_lua_ugui.control_data[control.uid].selection_end
        end

        local function get_lower_selection()
            if Mupen_lua_ugui.control_data[control.uid].selection_start > Mupen_lua_ugui.control_data[control.uid].selection_end then
                return Mupen_lua_ugui.control_data[control.uid].selection_end
            end
            return Mupen_lua_ugui.control_data[control.uid].selection_start
        end

        local function handle_special_keys(keys)
            local has_selection = not (Mupen_lua_ugui.control_data[control.uid].selection_start == Mupen_lua_ugui.control_data[control.uid].selection_end)


            if keys.left then
                if has_selection then
                    -- nuke the selection and set it to the caret index
                    local lower_selection = get_lower_selection()
                    Mupen_lua_ugui.control_data[control.uid].selection_start = lower_selection
                    Mupen_lua_ugui.control_data[control.uid].selection_end = lower_selection
                    Mupen_lua_ugui.control_data[control.uid].caret_index = lower_selection
                else
                    Mupen_lua_ugui.control_data[control.uid].caret_index = Mupen_lua_ugui.control_data[control.uid]
                        .caret_index - 1
                end
            elseif keys.right then
                if has_selection then
                    -- move the caret to the selection end index and nuke the selection
                    local higher_selection = get_higher_selection()
                    Mupen_lua_ugui.control_data[control.uid].caret_index = higher_selection
                    Mupen_lua_ugui.control_data[control.uid].selection_start = higher_selection
                    Mupen_lua_ugui.control_data[control.uid].selection_end = higher_selection
                else
                    Mupen_lua_ugui.control_data[control.uid].caret_index = Mupen_lua_ugui.control_data[control.uid]
                        .caret_index + 1
                end
            elseif keys.space then
                if has_selection then
                    local lower_selection = get_lower_selection()
                    text = remove_range(text, get_lower_selection(), get_higher_selection())
                    Mupen_lua_ugui.control_data[control.uid].caret_index = lower_selection
                    Mupen_lua_ugui.control_data[control.uid].selection_start = lower_selection
                    Mupen_lua_ugui.control_data[control.uid].selection_end = lower_selection
                    text = insert_at(text, " ", Mupen_lua_ugui.control_data[control.uid].caret_index - 1)
                    Mupen_lua_ugui.control_data[control.uid].caret_index = Mupen_lua_ugui.control_data[control.uid]
                        .caret_index + 1
                else
                    text = insert_at(text, " ", Mupen_lua_ugui.control_data[control.uid].caret_index - 1)
                    Mupen_lua_ugui.control_data[control.uid].caret_index = Mupen_lua_ugui.control_data[control.uid]
                        .caret_index + 1
                end
            elseif keys.backspace then
                if has_selection then
                    local lower_selection = get_lower_selection()
                    text = remove_range(text, lower_selection, get_higher_selection())
                    Mupen_lua_ugui.control_data[control.uid].caret_index = lower_selection
                    Mupen_lua_ugui.control_data[control.uid].selection_start = lower_selection
                    Mupen_lua_ugui.control_data[control.uid].selection_end = lower_selection
                else
                    text = remove_at(text, Mupen_lua_ugui.control_data[control.uid].caret_index - 1)
                    Mupen_lua_ugui.control_data[control.uid].caret_index = Mupen_lua_ugui.control_data[control.uid]
                        .caret_index - 1
                end
            else
                return false
            end
            return true
        end


        if Mupen_lua_ugui.active_control_uid == control.uid and control.is_enabled then
            -- start the new selection
            if is_pointer_just_down() and is_pointer_inside(control.rectangle) then
                Mupen_lua_ugui.control_data[control.uid].caret_index = get_caret_index_at_relative_position(
                    Mupen_lua_ugui.input_state.pointer.position)
                Mupen_lua_ugui.control_data[control.uid].selection_start = get_caret_index_at_relative_position(
                    Mupen_lua_ugui.input_state.pointer.position)
            end

            if is_pointer_down() and is_previous_primary_down_pointer_inside(control.rectangle) then
                Mupen_lua_ugui.control_data[control.uid].selection_end = get_caret_index_at_relative_position(
                    Mupen_lua_ugui.input_state.pointer.position)
            end

            local just_pressed_keys = get_just_pressed_keys();
            local has_selection = not (Mupen_lua_ugui.control_data[control.uid].selection_start == Mupen_lua_ugui.control_data[control.uid].selection_end)

            if not handle_special_keys(just_pressed_keys) then
                for key, _ in pairs(just_pressed_keys) do
                    if not (#key == 1) then
                        goto continue
                    end

                    if has_selection then
                        local lower_selection = get_lower_selection()
                        text = remove_range(text, get_lower_selection(), get_higher_selection())
                        Mupen_lua_ugui.control_data[control.uid].caret_index = lower_selection
                        Mupen_lua_ugui.control_data[control.uid].selection_start = lower_selection
                        Mupen_lua_ugui.control_data[control.uid].selection_end = lower_selection
                        text = insert_at(text, key, Mupen_lua_ugui.control_data[control.uid].caret_index - 1)
                        Mupen_lua_ugui.control_data[control.uid].caret_index = Mupen_lua_ugui.control_data[control.uid]
                            .caret_index + 1
                    else
                        text = insert_at(text, key, Mupen_lua_ugui.control_data[control.uid].caret_index - 1)
                        Mupen_lua_ugui.control_data[control.uid].caret_index = Mupen_lua_ugui.control_data[control.uid]
                            .caret_index + 1
                    end



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
            not is_pointer_inside_ignored_rectangle() and
            not Mupen_lua_ugui.has_primary_input_been_handled
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
        end

        if is_pointer_just_down() and control.is_enabled then
            if is_pointer_inside(control.rectangle) and (not Mupen_lua_ugui.has_primary_input_been_handled) then
                Mupen_lua_ugui.control_data[control.uid].is_open = not Mupen_lua_ugui.control_data[control.uid].is_open
            else
                if not is_pointer_inside({
                        x = control.rectangle.x,
                        y = control.rectangle.y + control.rectangle.height,
                        width = control.rectangle.width,
                        height = 20 * #control.items,
                    }) then
                    Mupen_lua_ugui.control_data[control.uid].is_open = false
                end
            end
        end

        local selected_index = control.selected_index

        if Mupen_lua_ugui.control_data[control.uid].is_open and control.is_enabled then
            for i = 1, #control.items, 1 do
                if is_pointer_inside({
                        x = control.rectangle.x,
                        y = control.rectangle.y + control.rectangle.height + (20 * (i - 1)),
                        width = control.rectangle.width,
                        height = 20,
                    }) then
                    if is_pointer_just_down() then
                        selected_index = i
                        Mupen_lua_ugui.control_data[control.uid].is_open = false
                        Mupen_lua_ugui.has_primary_input_been_handled = true
                    end
                    Mupen_lua_ugui.control_data[control.uid].hovered_index = i
                    break
                end
            end
        end



        if Mupen_lua_ugui.control_data[control.uid].is_open then
            Mupen_lua_ugui.hittest_ignore_rectangles[#Mupen_lua_ugui.hittest_ignore_rectangles + 1] = {
                x = control.rectangle.x,
                y = control.rectangle.y + control.rectangle.height,
                width = control.rectangle.width,
                height = 20 * #control.items,
            }
        end
        selected_index = clamp(selected_index, 1, #control.items)

        -- we draw the modal over all other controls
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

        if control.is_enabled and is_pointer_inside(control.rectangle) and not is_pointer_inside_ignored_rectangle() then
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
    end,
}
