function folder(thisFileName)
    local str = debug.getinfo(2, 'S').source:sub(2)
    return (str:match('^.*/(.*).lua$') or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder('demos\\nineslice_styler.lua') .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

local styles = {
    'windows-11',
    'windows-10',
    'windows-aero',
}
local style_index = 1
local section_name_path = ''

local ustyles = {}
local control_transitions = {}

local function parse_ustyles(path)
    local file = io.open(path, 'rb')
    local lines = {}
    for line in io.lines(path) do
        local words = {}
        for word in line:gmatch('%w+') do
            table.insert(words, word)
        end
        table.insert(lines, words)
    end
    file:close()


    local function rectangle_from_line(line)
        return {
            x = tonumber(line[1]),
            y = tonumber(line[2]),
            width = tonumber(line[3]),
            height = tonumber(line[4]),
        }
    end

    local function number_from_line(line)
        return tonumber(line[1])
    end

    local function vector2_from_line(line)
        return {
            x = tonumber(line[1]),
            y = tonumber(line[2]),
        }
    end

    local function color_from_line(line)
        return {
            r = tonumber(line[1]),
            g = tonumber(line[2]),
            b = tonumber(line[3]),
        }
    end

    local function get_nineslice_rect_collection(index)
        local structure = {}
        local bounds = rectangle_from_line(lines[index])
        local center = rectangle_from_line(lines[index + 1])

        structure.center = center

        local corner_size = {
            x = math.abs(center.x - bounds.x),
            y = math.abs(center.y - bounds.y),
        }
        structure.top_left = {
            x = bounds.x,
            y = bounds.y,
            width = corner_size.x,
            height = corner_size.y,
        }
        structure.bottom_left = {
            x = bounds.x,
            y = center.y + center.height,
            width = corner_size.x,
            height = corner_size.y,
        }
        structure.left = {
            x = bounds.x,
            y = center.y,
            width = corner_size.x,
            height = bounds.height - corner_size.y * 2,
        }
        structure.top_right = {
            x = bounds.x + bounds.width - corner_size.x,
            y = bounds.y,
            width = corner_size.x,
            height = corner_size.y,
        }
        structure.bottom_right = {
            x = bounds.x + bounds.width - corner_size.x,
            y = center.y + center.height,
            width = corner_size.x,
            height = corner_size.y,
        }
        structure.top = {
            x = center.x,
            y = bounds.y,
            width = bounds.width - corner_size.x * 2,
            height = corner_size.y,
        }

        structure.right = {
            x = bounds.x + bounds.width - corner_size.x,
            y = center.y,
            width = corner_size.x,
            height = bounds.height - corner_size.y * 2,
        }
        structure.bottom = {
            x = center.x,
            y = bounds.y + bounds.height - corner_size.y,
            width = bounds.width - corner_size.x * 2,
            height = corner_size.y,
        }
        return structure
    end


    local data = {
        ['raised_frame'] = {
            [Mupen_lua_ugui.visual_states.normal] = {},
            [Mupen_lua_ugui.visual_states.hovered] = {},
            [Mupen_lua_ugui.visual_states.active] = {},
            [Mupen_lua_ugui.visual_states.disabled] = {},
        },
        ['edit_frame'] = {
            [Mupen_lua_ugui.visual_states.normal] = {},
            [Mupen_lua_ugui.visual_states.hovered] = {},
            [Mupen_lua_ugui.visual_states.active] = {},
            [Mupen_lua_ugui.visual_states.disabled] = {},
        },
        ['track'] = {
            [Mupen_lua_ugui.visual_states.normal] = {},
            [Mupen_lua_ugui.visual_states.hovered] = {},
            [Mupen_lua_ugui.visual_states.active] = {},
            [Mupen_lua_ugui.visual_states.disabled] = {},
        },
        ['thumb_horizontal'] = {
            [Mupen_lua_ugui.visual_states.normal] = {},
            [Mupen_lua_ugui.visual_states.hovered] = {},
            [Mupen_lua_ugui.visual_states.active] = {},
            [Mupen_lua_ugui.visual_states.disabled] = {},
        },
        ['thumb_vertical'] = {
            [Mupen_lua_ugui.visual_states.normal] = {},
            [Mupen_lua_ugui.visual_states.hovered] = {},
            [Mupen_lua_ugui.visual_states.active] = {},
            [Mupen_lua_ugui.visual_states.disabled] = {},
        },
    }

    data['raised_frame'][Mupen_lua_ugui.visual_states.normal] = get_nineslice_rect_collection(6)
    data['raised_frame'][Mupen_lua_ugui.visual_states.hovered] = get_nineslice_rect_collection(11)
    data['raised_frame'][Mupen_lua_ugui.visual_states.active] = get_nineslice_rect_collection(16)
    data['raised_frame'][Mupen_lua_ugui.visual_states.disabled] = get_nineslice_rect_collection(21)

    data['edit_frame'][Mupen_lua_ugui.visual_states.normal] = get_nineslice_rect_collection(28)
    data['edit_frame'][Mupen_lua_ugui.visual_states.hovered] = get_nineslice_rect_collection(33)
    data['edit_frame'][Mupen_lua_ugui.visual_states.active] = get_nineslice_rect_collection(38)
    data['edit_frame'][Mupen_lua_ugui.visual_states.disabled] = get_nineslice_rect_collection(43)

    data['track']['thickness'] = number_from_line(lines[49])
    data['track'][Mupen_lua_ugui.visual_states.normal] = get_nineslice_rect_collection(52)
    data['track'][Mupen_lua_ugui.visual_states.hovered] = get_nineslice_rect_collection(56)
    data['track'][Mupen_lua_ugui.visual_states.active] = get_nineslice_rect_collection(60)
    data['track'][Mupen_lua_ugui.visual_states.disabled] = get_nineslice_rect_collection(64)

    data['thumb_horizontal']['size'] = vector2_from_line(lines[69])
    data['thumb_horizontal'][Mupen_lua_ugui.visual_states.normal] = rectangle_from_line(lines[72])
    data['thumb_horizontal'][Mupen_lua_ugui.visual_states.hovered] = rectangle_from_line(lines[75])
    data['thumb_horizontal'][Mupen_lua_ugui.visual_states.active] = rectangle_from_line(lines[78])
    data['thumb_horizontal'][Mupen_lua_ugui.visual_states.disabled] = rectangle_from_line(lines[81])

    data['thumb_vertical']['size'] = vector2_from_line(lines[85])
    data['thumb_vertical'][Mupen_lua_ugui.visual_states.normal] = rectangle_from_line(lines[88])
    data['thumb_vertical'][Mupen_lua_ugui.visual_states.hovered] = rectangle_from_line(lines[91])
    data['thumb_vertical'][Mupen_lua_ugui.visual_states.active] = rectangle_from_line(lines[94])
    data['thumb_vertical'][Mupen_lua_ugui.visual_states.disabled] = rectangle_from_line(lines[97])

    local background_color = color_from_line(lines[1])
    return {
        background_color = background_color,
        data = data,
    }
end

local function move_color_towards(color, target, speed)
    local difference_sum = math.abs(color.r - target.r) + math.abs(color.g - target.g) + math.abs(color.b - target.b) + math.abs(color.a - target.a)
    local avg = difference_sum / 3
    if avg < 5 then
        return target
    end
    return {
        r = math.floor(color.r + (target.r - color.r) * speed),
        g = math.floor(color.g + (target.g - color.g) * speed),
        b = math.floor(color.b + (target.b - color.b) * speed),
        a = math.floor(color.a + (target.a - color.a) * speed),
    }
end

local function get_ustyle_path()
    return section_name_path .. '.ustyles'
end

local function draw_nineslice(identifier, slices, opacity, rectangle)
    if opacity == 0 then
        return
    end
    local color = {
        r = 255,
        g = 255,
        b = 255,
        a = opacity,
    }

    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x,
        y = rectangle.y,
        width = slices.top_left.width,
        height = slices.top_left.height,
    }, slices.top_left, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x + rectangle.width - slices.top_right.width,
        y = rectangle.y,
        width = slices.top_right.width,
        height = slices.top_right.height,
    }, slices.top_right, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x,
        y = rectangle.y + rectangle.height - slices.bottom_left.height,
        width = slices.bottom_left.width,
        height = slices.bottom_left.height,
    }, slices.bottom_left, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x + rectangle.width - slices.bottom_right.width,
        y = rectangle.y + rectangle.height - slices.bottom_right.height,
        width = slices.bottom_right.width,
        height = slices.bottom_right.height,
    }, slices.bottom_right, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x + slices.top_left.width,
        y = rectangle.y + slices.top_left.height,
        width = rectangle.width - slices.bottom_right.width * 2,
        height = rectangle.height - slices.bottom_right.height * 2,
    }, slices.center, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x,
        y = rectangle.y + slices.top_left.height,
        width = slices.left.width,
        height = rectangle.height - slices.bottom_left.height * 2,
    }, slices.left, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x + rectangle.width - slices.top_right.width,
        y = rectangle.y + slices.top_right.height,
        width = slices.left.width,
        height = rectangle.height - slices.bottom_right.height * 2,
    }, slices.right, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x + slices.top_left.width,
        y = rectangle.y,
        width = rectangle.width - slices.top_right.width * 2,
        height = slices.top.height,
    }, slices.top, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x + slices.top_left.width,
        y = rectangle.y + rectangle.height - slices.bottom.height,
        width = rectangle.width - slices.bottom_right.width * 2,
        height = slices.bottom.height,
    }, slices.bottom, identifier, color)
end

local function update_transition(control, visual_state)
    local opaque = {
        r = 255,
        g = 255,
        b = 255,
        a = 255,
    }
    local transparent = {
        r = 255,
        g = 255,
        b = 255,
        a = 0,
    }

    if not control_transitions[control.uid] then
        control_transitions[control.uid] = {
            [Mupen_lua_ugui.visual_states.normal] = transparent,
            [Mupen_lua_ugui.visual_states.hovered] = transparent,
            [Mupen_lua_ugui.visual_states.active] = transparent,
            [Mupen_lua_ugui.visual_states.disabled] = transparent,
        }
        control_transitions[control.uid][visual_state] = opaque
    end

    -- gradually reset all inactive transition targets
    for key, _ in pairs(control_transitions[control.uid]) do
        control_transitions[control.uid][key] = move_color_towards(
            control_transitions[control.uid][key], key == visual_state and opaque or transparent, 0.1)
    end
end

Mupen_lua_ugui.stylers.windows_10.draw_raised_frame = function(control, visual_state)
    update_transition(control, visual_state)
    for key, _ in pairs(control_transitions[control.uid]) do
        draw_nineslice(section_name_path .. '.png', ustyles[get_ustyle_path()].data['raised_frame'][key],
            control_transitions[control.uid][key].a, control.rectangle)
    end
end
Mupen_lua_ugui.stylers.windows_10.draw_edit_frame = function(control, visual_state)
    update_transition(control, visual_state)
    for key, _ in pairs(control_transitions[control.uid]) do
        draw_nineslice(section_name_path .. '.png', ustyles[get_ustyle_path()].data['edit_frame'][key],
            control_transitions[control.uid][key].a, control.rectangle)
    end
end
Mupen_lua_ugui.stylers.windows_10.draw_track = function(control, visual_state, is_horizontal)
    local track_rectangle = {}
    local track_thickness = ustyles[get_ustyle_path()].data['track']['thickness']
    if not is_horizontal then
        track_rectangle = {
            x = control.rectangle.x + control.rectangle.width / 2 - track_thickness / 2,
            y = control.rectangle.y,
            width = track_thickness,
            height = control.rectangle.height,
        }
    else
        track_rectangle = {
            x = control.rectangle.x,
            y = control.rectangle.y + control.rectangle.height / 2 - track_thickness / 2,
            width = control.rectangle.width,
            height = track_thickness,
        }
    end


    update_transition(control, visual_state)
    for key, _ in pairs(control_transitions[control.uid]) do
        draw_nineslice(section_name_path .. '.png', ustyles[get_ustyle_path()].data['track'][key],
            control_transitions[control.uid][key].a, track_rectangle)
    end
end

Mupen_lua_ugui.stylers.windows_10.draw_thumb = function(control, visual_state, is_horizontal, value)
    local head_rectangle = {}

    local info = ustyles[get_ustyle_path()].data[is_horizontal and 'thumb_horizontal' or 'thumb_vertical']
    local bar_width = info['size'].x
    local bar_height = info['size'].y

    if is_horizontal then
        head_rectangle = {
            x = control.rectangle.x + (value * control.rectangle.width) -
                bar_width / 2,
            y = control.rectangle.y + control.rectangle.height / 2 -
                bar_height / 2,
            width = bar_width,
            height = bar_height,
        }
    else
        head_rectangle = {
            x = control.rectangle.x + control.rectangle.width / 2 -
                bar_width / 2,
            y = control.rectangle.y + (value * control.rectangle.height) -
                bar_height / 2,
            width = bar_width,
            height = bar_height,
        }
    end
    update_transition(control, visual_state)
    for key, _ in pairs(control_transitions[control.uid]) do
        BreitbandGraphics.renderers.d2d.draw_image(head_rectangle, info[key], section_name_path .. '.png', control_transitions[control.uid][key], 'linear')
    end
end

local trackbar_value = 0
emu.atupdatescreen(function()
    section_name_path = folder('nineslice_styler.lua') .. 'res\\' .. styles[style_index]

    if not ustyles[get_ustyle_path()] then
        print('Parsing ustyles...')
        ustyles[get_ustyle_path()] = parse_ustyles(get_ustyle_path())
    end

    BreitbandGraphics.renderers.d2d.fill_rectangle({
        x = initial_size.width,
        y = 0,
        width = 200,
        height = initial_size.height,
    }, ustyles[get_ustyle_path()].background_color)

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
    Mupen_lua_ugui.joystick({
        uid = 0,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 200,
            width = 90,
            height = 90,
        },
        position = {
            x = 0.5,
            y = 0.5,
        },
    })
    Mupen_lua_ugui.joystick({
        uid = 1,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 10,
            y = 300,
            width = 90,
            height = 90,
        },
        position = {
            x = 0.5,
            y = 0.5,
        },
    })

    style_index = Mupen_lua_ugui.combobox({
        uid = 2,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 50,
            width = 120,
            height = 25,
        },
        items = styles,
        selected_index = style_index,
    })



    Mupen_lua_ugui.button({
        uid = 3,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 130,
            width = 90,
            height = 30,
        },
        text = 'Hello World!',
    })
    Mupen_lua_ugui.button({
        uid = 4,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 110,
            y = 130,
            width = 80,
            height = 30,
        },
        text = 'Hello World!',
    })
    trackbar_value = Mupen_lua_ugui.trackbar({
        uid = 5,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 400,
            width = 100,
            height = 20,
        },
        value = trackbar_value,
    })
    trackbar_value = Mupen_lua_ugui.trackbar({
        uid = 9,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 450,
            width = 20,
            height = 100,
        },
        value = trackbar_value,
    })
    Mupen_lua_ugui.textbox({
        uid = 6,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 110,
            y = 300,
            width = 60,
            height = 20,
        },
        text = 'qwertz',
    })
    Mupen_lua_ugui.textbox({
        uid = 7,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 110,
            y = 200,
            width = 60,
            height = 20,
        },
        text = 'qwertz',
    })
    a = Mupen_lua_ugui.listbox({
        uid = 8,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 120,
            y = 340,
            width = 70,
            height = 100,
        },
        items = {
            'a',
            'a',
            'a',
            'a',
            'a',
            'a',
            'a',
            'a',
            'a',
            'a',
            'a',
            'a',
        },
        selected_index = a,
    })
    Mupen_lua_ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
