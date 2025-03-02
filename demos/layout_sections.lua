local path_root = debug.getinfo(1).short_src:gsub("\\[^\\]+\\[^\\]+$", "\\")

---@module "breitbandgraphics"
BreitbandGraphics = dofile(path_root .. 'breitbandgraphics.lua')

---@module "mupen-lua-ugui"
ugui = dofile(path_root .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)

local mouse_wheel = 0

emu.atdrawd2d(function()
    local keys = input.get()
    ugui.begin_frame({
        mouse_position = {
            x = keys.xmouse,
            y = keys.ymouse,
        },
        wheel = mouse_wheel,
        is_primary_down = keys.leftclick,
        held_keys = keys,
    })

    -- if not ugui.internal.get_just_pressed_keys()["F"] then
    --     ugui.end_frame()
    --     return
    -- end


    BreitbandGraphics.fill_rectangle({
        x = initial_size.width,
        y = 0,
        width = 200,
        height = initial_size.height,
    }, {
        r = 253,
        g = 253,
        b = 253,
    })

    mouse_wheel = 0

    -- ugui.push_stackpanel({rectangle = {x = initial_size.width}, horizontal = true, gap = 5})
    -- ugui.button({
    --     uid = 1,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'A',
    -- })
    -- ugui.button({
    --     uid = 2,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'B',
    -- })
    -- ugui.button({
    --     uid = 3,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'C',
    -- })
    -- ugui.push_stackpanel({rectangle = {}, gap = 5})
    -- ugui.button({
    --     uid = 4,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'D',
    -- })
    -- ugui.button({
    --     uid = 5,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'E',
    -- })
    -- ugui.button({
    --     uid = 6,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'F',
    -- })
    -- ugui.push_stackpanel({rectangle = {}, horizontal = true, gap = 5})
    -- ugui.button({
    --     uid = 7,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'G',
    -- })
    -- ugui.pop()
    -- ugui.pop()
    -- ugui.button({
    --     uid = 10,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'H',
    -- })
    -- ugui.pop()

    -- ugui.push_stackpanel({rectangle = {x = initial_size.width, y = 240}, gap = 5})
    -- ugui.button({
    --     uid = 11,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'A',
    -- })
    -- ugui.button({
    --     uid = 12,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'B',
    -- })
    -- ugui.button({
    --     uid = 13,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'C',
    -- })
    -- ugui.push_stackpanel({rectangle = {}, horizontal = true, gap = 5})
    -- ugui.button({
    --     uid = 14,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'D',
    -- })
    -- ugui.button({
    --     uid = 15,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'E',
    -- })
    -- ugui.button({
    --     uid = 16,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'F',
    -- })
    -- ugui.push_stackpanel({rectangle = {}, gap = 5})
    -- ugui.button({
    --     uid = 17,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'G',
    -- })
    -- ugui.pop()
    -- ugui.pop()
    -- ugui.button({
    --     uid = 18,
    --     rectangle = {width = 20, height = 20, x = 0, y = 0},
    --     text = 'H',
    -- })
    -- ugui.pop()

    ugui.push_stackpanel({rectangle = {x = initial_size.width }, horizontal = false, gap = 5})
    ugui.button({
        uid = 19,
        rectangle = {width = 120, height = 20, x = 0, y = 0},
        text = 'A',
    })
    ugui.push_stackpanel({rectangle = {}, horizontal = true, gap = 5})
    ugui.button({
        uid = 20,
        rectangle = {width = 20, height = 20, x = 0, y = 0},
        text = 'B',
    })
    ugui.button({
        uid = 21,
        rectangle = {width = 20, height = 20, x = 0, y = 0},
        text = 'C',
    })
    ugui.button({
        uid = 22,
        rectangle = {width = 20, height = 20, x = 0, y = 0},
        text = 'D',
    })
    ugui.pop()
    ugui.pop()

    ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
emu.atwindowmessage(function(_, msg_id, wparam, _)
    if msg_id == 522 then
        local scroll = math.floor(wparam / 65536)
        if scroll == 120 then
            mouse_wheel = 1
        elseif scroll == 65416 then
            mouse_wheel = -1
        end
    end
end)
