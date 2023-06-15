function folder(thisFileName)
    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder('demos\\nineslice_styler.lua') .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

local button_atlas_path = folder('nineslice_styler.lua') .. 'img/button-11.png'

Mupen_lua_ugui.stylers.windows_10.draw_button = function(control)
    local visual_state = Mupen_lua_ugui.get_visual_state(control)
    local offset = 0

    if visual_state == Mupen_lua_ugui.visual_states.hovered then
        offset = 11
    elseif visual_state == Mupen_lua_ugui.visual_states.active then
        offset = 22
    elseif visual_state == Mupen_lua_ugui.visual_states.disabled then
        offset = 33
    end

    local text_color = {
        r = 0,
        g = 0,
        b = 0
    }

    if visual_state == Mupen_lua_ugui.visual_states.disabled then
        text_color = {
            r = 160,
            g = 160,
            b = 160,
        }
    end

    -- top-left corner
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x,
        y = control.rectangle.y,
        width = 5,
        height = 4
    }, {
        x = 1,
        y = 1 + offset,
        width = 5,
        height = 4
    }, button_atlas_path, BreitbandGraphics.colors.white)


    -- top-righ corner
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x + control.rectangle.width - 5,
        y = control.rectangle.y,
        width = 5,
        height = 4
    }, {
        x = 7,
        y = 1 + offset,
        width = 5,
        height = 4
    }, button_atlas_path, BreitbandGraphics.colors.white)

    -- bottom-left corner
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x,
        y = control.rectangle.y + control.rectangle.height - 4,
        width = 5,
        height = 4
    }, {
        x = 1,
        y = 6 + offset,
        width = 5,
        height = 4
    }, button_atlas_path, BreitbandGraphics.colors.white)

    -- bottom-right corner
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x + control.rectangle.width - 5,
        y = control.rectangle.y + control.rectangle.height - 4,
        width = 5,
        height = 4
    }, {
        x = 7,
        y = 6 + offset,
        width = 5,
        height = 4
    }, button_atlas_path, BreitbandGraphics.colors.white)

    -- top side (if you know what i mean :o)
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x + 5,
        y = control.rectangle.y,
        width = control.rectangle.width - 10,
        height = 4
    }, {
        x = 6,
        y = 1 + offset,
        width = 1,
        height = 4
    }, button_atlas_path, BreitbandGraphics.colors.white)

    -- bottom side
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x + 5,
        y = control.rectangle.y + control.rectangle.height - 4,
        width = control.rectangle.width - 10,
        height = 4
    }, {
        x = 6,
        y = 6 + offset,
        width = 1,
        height = 4
    }, button_atlas_path, BreitbandGraphics.colors.white)

    -- left side
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x,
        y = control.rectangle.y + 4,
        width = 5,
        height = control.rectangle.height - 8
    }, {
        x = 1,
        y = 5 + offset,
        width = 5,
        height = 1
    }, button_atlas_path, BreitbandGraphics.colors.white)

    -- right side
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x + control.rectangle.width - 5,
        y = control.rectangle.y + 4,
        width = 5,
        height = control.rectangle.height - 8
    }, {
        x = 7,
        y = 5 + offset,
        width = 5,
        height = 1
    }, button_atlas_path, BreitbandGraphics.colors.white)

    -- fill
    BreitbandGraphics.renderers.d2d.draw_image({
        x = control.rectangle.x + 5,
        y = control.rectangle.y + 4,
        width = control.rectangle.width - 10,
        height = control.rectangle.height - 8
    }, {
        x = 5,
        y = 4 + offset,
        width = 3,
        height = 3
    }, button_atlas_path, BreitbandGraphics.colors.white)

    Mupen_lua_ugui.renderer.draw_text(control.rectangle, 'center', 'center',
        {}, text_color,
        12,
        "MS Sans Serif", control.text)
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
    Mupen_lua_ugui.button({
        uid = 0,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 10,
            width = 90,
            height = 30,
        },
        text = "Test"
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
        button_atlas_path = folder('nineslice_styler.lua') .. 'img/button-10.png'
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
        button_atlas_path = folder('nineslice_styler.lua') .. 'img/button-11.png'
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
            text = "Windows 95"
        }) then
        button_atlas_path = folder('nineslice_styler.lua') .. 'img/button-95.png'
    end

    if Mupen_lua_ugui.button({
            uid = 3,
            is_enabled = true,
            rectangle = {
                x = initial_size.width + 10,
                y = 170,
                width = 90,
                height = 30,
            },
            text = "Windows 7"
        }) then
        button_atlas_path = folder('nineslice_styler.lua') .. 'img/button-7.png'
    end



    Mupen_lua_ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
