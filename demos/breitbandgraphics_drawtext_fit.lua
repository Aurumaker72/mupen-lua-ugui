local function folder(file)
    local s = debug.getinfo(2, 'S').source:sub(2)
    local p = file:gsub('[%(%)%%%.%+%-%*%?%^%$]', '%%%0'):gsub('[\\/]', '[\\/]') .. '$'
    return s:gsub(p, '')
end

dofile(folder('demos\\breitbandgraphics_drawtext_fit.lua') .. 'mupen-lua-ugui.lua')

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
    BreitbandGraphics.draw_text(rectangle, 'start', 'start', {fit = true}, BreitbandGraphics.colors.black, ugui.standard_styler.params.font_size, ugui.standard_styler.params.font_name, '(start, start)')
    BreitbandGraphics.draw_text(rectangle, 'center', 'center', {fit = true}, BreitbandGraphics.colors.black, ugui.standard_styler.params.font_size, ugui.standard_styler.params.font_name, '(center, center)')
    BreitbandGraphics.draw_text(rectangle, 'end', 'end', {fit = true}, BreitbandGraphics.colors.black, ugui.standard_styler.params.font_size, ugui.standard_styler.params.font_name, '(end, end)')

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
