local path_root = debug.getinfo(1).short_src:gsub("\\[^\\]+\\[^\\]+$", "\\")

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "mupen-lua-ugui"
ugui = dofile(path_root .. 'mupen-lua-ugui.lua')

local rectangle = {
    x = 5,
    y = 200,
    width = 100,
    height = 100,
}

emu.atdrawd2d(function()
    BreitbandGraphics.fill_rectangle({
        x = 0,
        y = 0,
        width = wgui.info().width,
        height = wgui.info().height,
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
        window_size = {
            x = wgui.info().width,
            y = wgui.info().height,
        },
    })

    BreitbandGraphics.draw_rectangle(rectangle, BreitbandGraphics.colors.red, 1)
    BreitbandGraphics.draw_text2({
        text = '(start, start)',
        rectangle = rectangle,
        align_x = BreitbandGraphics.alignment.start,
        align_y = BreitbandGraphics.alignment.start,
        color = BreitbandGraphics.colors.black,
        font_name = ugui.standard_styler.params.font_name,
        font_size = ugui.standard_styler.params.font_size,
        fit = true,
    })
    BreitbandGraphics.draw_text2({
        text = '(center, center)',
        rectangle = rectangle,
        align_x = BreitbandGraphics.alignment.center,
        align_y = BreitbandGraphics.alignment.center,
        color = BreitbandGraphics.colors.black,
        font_name = ugui.standard_styler.params.font_name,
        font_size = ugui.standard_styler.params.font_size,
        fit = true,
    })
    BreitbandGraphics.draw_text2({
        text = '(end, end)',
        rectangle = rectangle,
        align_x = BreitbandGraphics.alignment['end'],
        align_y = BreitbandGraphics.alignment['end'],
        color = BreitbandGraphics.colors.black,
        font_name = ugui.standard_styler.params.font_name,
        font_size = ugui.standard_styler.params.font_size,
        fit = true,
    })

    if keys.leftclick then
        rectangle.width = math.max(1, keys.xmouse)
        rectangle.height = math.max(1, keys.ymouse)
    end

    if keys.rightclick then
        rectangle.x = math.max(1, keys.xmouse)
        rectangle.y = math.max(1, keys.ymouse)
    end

    if ugui.internal.get_just_pressed_keys()["F1"] then
        print(rectangle)
    end

    ugui.end_frame()
end)
