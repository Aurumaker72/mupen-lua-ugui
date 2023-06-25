function folder(thisFileName)
    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder("demos\\nineslice_styler.lua") .. "mupen-lua-ugui.lua")

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

local styles = {
    "windows-10",
    "windows-11",
    "windows-aero",
    "windows-xp",
}
local style_index = 1
local section_name_path = ''

local ustyles = {}
local control_transitions = {}

local function parse_ustyles(path)
    local file = io.open(path, "rb")
    local lines = {}
    for line in io.lines(path) do
        local words = {}
        for word in line:gmatch("%w+") do
            table.insert(words, word)
        end
        table.insert(lines, words)
    end
    file:close()


    function rectangle_from_line(line)
        return {
            x = tonumber(line[1]),
            y = tonumber(line[2]),
            width = tonumber(line[3]),
            height = tonumber(line[4]),
        }
    end

    function color_from_line(line)
        return {
            r = tonumber(line[1]),
            g = tonumber(line[2]),
            b = tonumber(line[3]),
        }
    end

    function fill_structure(structure, index)
        local bounds = rectangle_from_line(lines[index])
        local center = rectangle_from_line(lines[index + 1])

        structure.center = center

        local corner_size = {
            x = math.abs(center.x - bounds.x),
            y = math.abs(center.y - bounds.y)
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
    end

    local rectangles = {
        [Mupen_lua_ugui.visual_states.normal] = {},
        [Mupen_lua_ugui.visual_states.hovered] = {},
        [Mupen_lua_ugui.visual_states.active] = {},
        [Mupen_lua_ugui.visual_states.disabled] = {},
    }

    fill_structure(rectangles[Mupen_lua_ugui.visual_states.normal], 4)
    fill_structure(rectangles[Mupen_lua_ugui.visual_states.hovered], 8)
    fill_structure(rectangles[Mupen_lua_ugui.visual_states.active], 12)
    fill_structure(rectangles[Mupen_lua_ugui.visual_states.disabled], 16)

    local background_color = color_from_line(lines[1])
    return {
        background_color = background_color,
        rectangles = rectangles
    }
end

local function move_color_towards(color, target)
    return {
        r = math.floor(color.r + (target.r - color.r) * 0.25),
        g = math.floor(color.g + (target.g - color.g) * 0.25),
        b = math.floor(color.b + (target.b - color.b) * 0.25),
        a = math.floor(color.a + (target.a - color.a) * 0.25),
    }
end

local function get_ustyle_path()
    return section_name_path .. ".ustyles"
end

local function draw_nineslice(identifier, slices, opacity, rectangle)
    if opacity == 0 then
        return
    end
    local color = {
        r = 255,
        g = 255,
        b = 255,
        a = opacity
    }

    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x,
        y = rectangle.y,
        width = slices.top_left.width,
        height = slices.top_left.height
    }, slices.top_left, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x + rectangle.width - slices.top_right.width,
        y = rectangle.y,
        width = slices.top_right.width,
        height = slices.top_right.height
    }, slices.top_right, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x,
        y = rectangle.y + rectangle.height - slices.bottom_left.height,
        width = slices.bottom_left.width,
        height = slices.bottom_left.height
    }, slices.bottom_left, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x + rectangle.width - slices.bottom_right.width,
        y = rectangle.y + rectangle.height - slices.bottom_right.height,
        width = slices.bottom_right.width,
        height = slices.bottom_right.height
    }, slices.bottom_right, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x + slices.top_left.width,
        y = rectangle.y + slices.top_left.height,
        width = rectangle.width - slices.bottom_right.width * 2,
        height = rectangle.height - slices.bottom_right.height * 2
    }, slices.center, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x,
        y = rectangle.y + slices.top_left.height,
        width = slices.left.width,
        height = rectangle.height - slices.bottom_left.height * 2
    }, slices.left, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x + rectangle.width - slices.top_right.width,
        y = rectangle.y + slices.top_right.height,
        width = slices.left.width,
        height = rectangle.height - slices.bottom_right.height * 2
    }, slices.right, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x + slices.top_left.width,
        y = rectangle.y,
        width = rectangle.width - slices.top_right.width * 2,
        height = slices.top.height
    }, slices.top, identifier, color)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = rectangle.x + slices.top_left.width,
        y = rectangle.y + rectangle.height - slices.bottom.height,
        width = rectangle.width - slices.bottom_right.width * 2,
        height = slices.bottom.height
    }, slices.bottom, identifier, color)
end

Mupen_lua_ugui.stylers.windows_10.draw_raised_frame = function(control, visual_state)
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
            [Mupen_lua_ugui.visual_states.normal] = opaque,
            [Mupen_lua_ugui.visual_states.hovered] = opaque,
            [Mupen_lua_ugui.visual_states.active] = opaque,
            [Mupen_lua_ugui.visual_states.disabled] = opaque,
        }
    end

    -- gradually reset all inactive transition targets
    for key, value in pairs(control_transitions[control.uid]) do
        if key == visual_state then
            goto continue
        end
        control_transitions[control.uid][key] = move_color_towards(
            control_transitions[control.uid][key], transparent)
        ::continue::
    end

    control_transitions[control.uid][visual_state] = move_color_towards(
        control_transitions[control.uid][visual_state], opaque)


    for key, _ in pairs(control_transitions[control.uid]) do
        draw_nineslice(section_name_path .. ".png", ustyles[get_ustyle_path()].rectangles[key],
            control_transitions[control.uid][key].a, control.rectangle)
    end
end


emu.atupdatescreen(function()
    section_name_path = folder('nineslice_styler.lua') .. 'res\\' .. styles[style_index]

    if not ustyles[get_ustyle_path()] then
        print("Parsing ustyles...")
        ustyles[get_ustyle_path()] = parse_ustyles(get_ustyle_path())
    end

    BreitbandGraphics.renderers.d2d.fill_rectangle({
        x = initial_size.width,
        y = 0,
        width = 200,
        height = initial_size.height
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
            height = 30,
        },
        items = styles,
        selected_index = style_index
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
        text = "Hello World!"
    })



    Mupen_lua_ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
