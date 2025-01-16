local group = {
    name = 'core',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'uid_reuse_causes_error',
    func = function(ctx)
        local success = pcall(function()
            ugui.begin_frame({
                mouse_position = {x = 15, y = 15},
                wheel = 0,
                is_primary_down = true,
                held_keys = {},
            })
            ugui.button({
                uid = 5,
                rectangle = {x = 0, y = 0, width = 100, height = 20},
                text = 'Hello World!',
            })
            ugui.textbox({
                uid = 5,
                rectangle = {x = 0, y = 0, width = 100, height = 20},
                text = 'Hello World!',
            })
            ugui.end_frame()
        end)
        ctx.assert(not success, 'Uid reuse undetected')
    end,
}

group.tests[#group.tests + 1] = {
    name = 'malformed_control_generates_error',
    params = {
        {
            uid = nil,
            rectangle = {
                x = 5,
                y = 55,
                width = 90,
                height = 20,
            },
        },
        {
            uid = 100,
            rectangle = {
                x = nil,
                y = 55,
                width = 90,
                height = 20,
            },
        },
        {
            uid = 100,
            rectangle = {
                x = 5,
                y = nil,
                width = 90,
                height = 20,
            },
        },
        {
            uid = 100,
            rectangle = {
                x = 5,
                y = 55,
                width = nil,
                height = 20,
            },
        },
        {
            uid = 100,
            rectangle = {
                x = 5,
                y = 55,
                width = 90,
                height = nil,
            },
        },
    },
    func = function(ctx)
        local control_funcs = {
            ugui.button,
            ugui.toggle_button,
            ugui.carrousel_button,
            ugui.textbox,
            ugui.joystick,
            ugui.combobox,
            ugui.listbox,
            ugui.trackbar,
            ugui.scrollbar,
            ugui.menu,
        }

        local success, err = pcall(function()
            for _, control_func in pairs(control_funcs) do
                ugui.begin_frame({
                    mouse_position = {x = 15, y = 15},
                    wheel = 0,
                    is_primary_down = true,
                    held_keys = {},
                })
                control_func(ctx.data)
                ugui.end_frame()
            end
        end)

        ctx.assert(not success, 'Malformed control not detected')
    end,
}

group.tests[#group.tests + 1] = {
    name = 'unbalanced_frame_boundaries_causes_error',
    params = {
        {
            funcs = {
                ugui.begin_frame,
                ugui.begin_frame,
            },
            valid = false,
        },
        {
            funcs = {
                ugui.begin_frame,
                ugui.end_frame,
                ugui.end_frame,
            },
            valid = false,
        },
        {
            funcs = {
                ugui.end_frame,
            },
            valid = false,
        },
        {
            funcs = {
                ugui.begin_frame,
                ugui.end_frame,
            },
            valid = true,
        },
        {
            funcs = {
                ugui.begin_frame,
                ugui.end_frame,
                ugui.begin_frame,
                ugui.end_frame,
            },
            valid = true,
        },
    },
    func = function(ctx)
        local success, _ = pcall(function()
            for _, func in pairs(ctx.data.funcs) do
                func({})
            end
        end)
        ctx.assert_eq(ctx.data.valid, success)
    end,
}

return group
