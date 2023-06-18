function folder(thisFileName)
    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder('demos\\nineslice_styler.lua') .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

local section_name_path = folder('nineslice_styler.lua') .. 'res\\windows-10'

local slice_cache = {}

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
        structure.top_left = rectangle_from_line(lines[index])
        structure.top_right = rectangle_from_line(lines[index + 1])
        structure.bottom_left = rectangle_from_line(lines[index + 2])
        structure.bottom_right = rectangle_from_line(lines[index + 3])
        structure.center = rectangle_from_line(lines[index + 4])
        structure.top = rectangle_from_line(lines[index + 5])
        structure.left = rectangle_from_line(lines[index + 6])
        structure.right = rectangle_from_line(lines[index + 7])
        structure.bottom = rectangle_from_line(lines[index + 8])
    end

    local rectangles = {
        [Mupen_lua_ugui.visual_states.normal] = {},
        [Mupen_lua_ugui.visual_states.hovered] = {},
        [Mupen_lua_ugui.visual_states.active] = {},
        [Mupen_lua_ugui.visual_states.disabled] = {},
    }

    fill_structure(rectangles[Mupen_lua_ugui.visual_states.normal], 2)
    fill_structure(rectangles[Mupen_lua_ugui.visual_states.hovered], 13)
    fill_structure(rectangles[Mupen_lua_ugui.visual_states.active], 24)
    fill_structure(rectangles[Mupen_lua_ugui.visual_states.disabled], 35)

    return rectangles
end

Mupen_lua_ugui.stylers.windows_10.draw_raised_frame = function(control, visual_state)
    local atlas_path = section_name_path .. ".png"
    local slices_path = section_name_path .. ".txt"

    if not slice_cache[slices_path] then
        print("Creating slice cache...")
        slice_cache[slices_path] = parse_slices(slices_path)
    end
    local result = slice_cache[slices_path][visual_state]

    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x,
        y = control.rectangle.y,
        width = result.top_left.width,
        height = result.top_left.height
    }, result.top_left, atlas_path, BreitbandGraphics.colors.white)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x + control.rectangle.width - result.top_right.width,
        y = control.rectangle.y,
        width = result.top_right.width,
        height = result.top_right.height
    }, result.top_right, atlas_path, BreitbandGraphics.colors.white)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x,
        y = control.rectangle.y + control.rectangle.height - result.bottom_left.height,
        width = result.bottom_left.width,
        height = result.bottom_left.height
    }, result.bottom_left, atlas_path, BreitbandGraphics.colors.white)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x + control.rectangle.width - result.bottom_right.width,
        y = control.rectangle.y + control.rectangle.height - result.bottom_right.height,
        width = result.bottom_right.width,
        height = result.bottom_right.height
    }, result.bottom_right, atlas_path, BreitbandGraphics.colors.white)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x + result.top_left.width,
        y = control.rectangle.y + result.top_left.height,
        width = control.rectangle.width - result.bottom_right.width * 2,
        height = control.rectangle.height - result.bottom_right.height * 2
    }, result.center, atlas_path, BreitbandGraphics.colors.white)

    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x,
        y = control.rectangle.y + result.top_left.height,
        width = result.left.width,
        height = control.rectangle.height - result.bottom_left.height * 2
    }, result.left, atlas_path, BreitbandGraphics.colors.white)

    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x + control.rectangle.width - result.top_right.width,
        y = control.rectangle.y + result.top_right.height,
        width = result.left.width,
        height = control.rectangle.height - result.bottom_right.height * 2
    }, result.right, atlas_path, BreitbandGraphics.colors.white)


    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x + result.top_left.width,
        y = control.rectangle.y,
        width = control.rectangle.width - result.top_right.width * 2,
        height = result.top.height
    }, result.top, atlas_path, BreitbandGraphics.colors.white)

    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x + result.top_left.width,
        y = control.rectangle.y + control.rectangle.height - result.bottom.height,
        width = control.rectangle.width - result.bottom_right.width * 2,
        height = result.bottom.height
    }, result.bottom, atlas_path, BreitbandGraphics.colors.white)
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
        uid = 0,
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
            uid = 0,
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
            uid = 1,
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
            uid = 2,
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
