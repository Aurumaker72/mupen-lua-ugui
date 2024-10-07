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
        ctx.assert(not success, "Uid reuse undetected")
    end,
}

return group
