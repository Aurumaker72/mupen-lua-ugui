function folder(thisFileName)
    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder('demos\\nineslice_styler.lua') .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

local section_name_path = folder('nineslice_styler.lua') .. 'res\\windows-10'

local slice_cache = {}
local control_transitions = {}

function parse_slices(path)
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
            height = tonumber(line[4])
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

    fill_structure(rectangles[Mupen_lua_ugui.visual_states.normal], 2)
    fill_structure(rectangles[Mupen_lua_ugui.visual_states.hovered], 6)
    fill_structure(rectangles[Mupen_lua_ugui.visual_states.active], 10)
    fill_structure(rectangles[Mupen_lua_ugui.visual_states.disabled], 14)

    return rectangles
end

local function move_color_towards(color, target)
    -- if (math.abs(target.r - color.r) + math.abs(target.g - color.g) + math.abs(target.b - color.b)) / 3 < 5 then
    --     return target
    -- end

    return {
        r = math.floor(color.r + (target.r - color.r) * 0.25),
        g = math.floor(color.g + (target.g - color.g) * 0.25),
        b = math.floor(color.b + (target.b - color.b) * 0.25),
        a = math.floor(color.a + (target.a - color.a) * 0.25),
    }
end


Mupen_lua_ugui.stylers.windows_10.draw_raised_frame = function(control, visual_state)
    local atlas_path = section_name_path .. ".png"
    local slices_path = section_name_path .. ".txt"

    if not slice_cache[slices_path] then
        print("Creating slice cache...")
        slice_cache[slices_path] = parse_slices(slices_path)
    end

    function draw_nineslice(result, opacity)
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
            x = control.rectangle.x,
            y = control.rectangle.y,
            width = result.top_left.width,
            height = result.top_left.height
        }, result.top_left, atlas_path, color)
        BreitbandGraphics.renderers.d2d.draw_image({
            x = control.rectangle.x + control.rectangle.width - result.top_right.width,
            y = control.rectangle.y,
            width = result.top_right.width,
            height = result.top_right.height
        }, result.top_right, atlas_path, color)
        BreitbandGraphics.renderers.d2d.draw_image({
            x = control.rectangle.x,
            y = control.rectangle.y + control.rectangle.height - result.bottom_left.height,
            width = result.bottom_left.width,
            height = result.bottom_left.height
        }, result.bottom_left, atlas_path, color)
        BreitbandGraphics.renderers.d2d.draw_image({
            x = control.rectangle.x + control.rectangle.width - result.bottom_right.width,
            y = control.rectangle.y + control.rectangle.height - result.bottom_right.height,
            width = result.bottom_right.width,
            height = result.bottom_right.height
        }, result.bottom_right, atlas_path, color)
        BreitbandGraphics.renderers.d2d.draw_image({
            x = control.rectangle.x + result.top_left.width,
            y = control.rectangle.y + result.top_left.height,
            width = control.rectangle.width - result.bottom_right.width * 2,
            height = control.rectangle.height - result.bottom_right.height * 2
        }, result.center, atlas_path, color)

        BreitbandGraphics.renderers.d2d.draw_image({
            x = control.rectangle.x,
            y = control.rectangle.y + result.top_left.height,
            width = result.left.width,
            height = control.rectangle.height - result.bottom_left.height * 2
        }, result.left, atlas_path, color)

        BreitbandGraphics.renderers.d2d.draw_image({
            x = control.rectangle.x + control.rectangle.width - result.top_right.width,
            y = control.rectangle.y + result.top_right.height,
            width = result.left.width,
            height = control.rectangle.height - result.bottom_right.height * 2
        }, result.right, atlas_path, color)


        BreitbandGraphics.renderers.d2d.draw_image({
            x = control.rectangle.x + result.top_left.width,
            y = control.rectangle.y,
            width = control.rectangle.width - result.top_right.width * 2,
            height = result.top.height
        }, result.top, atlas_path, color)

        BreitbandGraphics.renderers.d2d.draw_image({
            x = control.rectangle.x + result.top_left.width,
            y = control.rectangle.y + control.rectangle.height - result.bottom.height,
            width = control.rectangle.width - result.bottom_right.width * 2,
            height = result.bottom.height
        }, result.bottom, atlas_path, color)
    end

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


    for key, value in pairs(control_transitions[control.uid]) do
        draw_nineslice(slice_cache[slices_path][key],
            control_transitions[control.uid][key].a)
    end
end


emu.atupdatescreen(function()
    BreitbandGraphics.renderers.d2d.fill_rectangle({
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

    Mupen_lua_ugui.begin_frame(BreitbandGraphics.renderers.d2d, Mupen_lua_ugui.stylers.windows_10, {
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
            y = 0.5
        }
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
            y = 0.5
        }
    })

    if Mupen_lua_ugui.button({
            uid = 2,
            is_enabled = true,
            rectangle = {
                x = initial_size.width + 10,
                y = 50,
                width = 90,
                height = 30,
            },
            text = "Windows 10"
        }) then
        section_name_path = folder('nineslice_styler.lua') .. 'res\\windows-10'
    end

    if Mupen_lua_ugui.button({
            uid = 3,
            is_enabled = true,
            rectangle = {
                x = initial_size.width + 10,
                y = 90,
                width = 90,
                height = 30,
            },
            text = "Windows 11"
        }) then
        section_name_path = folder('nineslice_styler.lua') .. 'res\\windows-11'
    end

    if Mupen_lua_ugui.button({
            uid = 4,
            is_enabled = true,
            rectangle = {
                x = initial_size.width + 10,
                y = 130,
                width = 90,
                height = 30,
            },
            text = "Windows 7"
        }) then
        section_name_path = folder('nineslice_styler.lua') .. 'res\\windows-aero'
    end



    Mupen_lua_ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
