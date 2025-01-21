local group = {
    name = 'layout',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'pop_on_empty_stack_causes_error',
    params = {
        {
            funcs = {
                ugui.push_stackpanel,
                ugui.push_stackpanel,
                ugui.pop,
                ugui.pop,
                ugui.pop,
            },
            expected = false,
        },
        {
            funcs = {
                ugui.push_stackpanel,
                ugui.pop,
                ugui.pop,
            },
            expected = false,
        },
        {
            funcs = {
                ugui.pop,
            },
            expected = false,
        },
        {
            funcs = {
                ugui.push_stackpanel,
                ugui.pop,
            },
            expected = true,
        },
    },
    func = function(ctx)
        local success = pcall(function()
            ugui.begin_frame({
                mouse_position = {x = 15, y = 15},
                wheel = 0,
                is_primary_down = true,
                held_keys = {},
            })
            for _, func in pairs(ctx.data.funcs) do
                func({rectangle = {x = 0, y = 0}})
            end
            ugui.end_frame()
        end)
        ctx.assert_eq(ctx.data.expected, success)
    end,
}

return group
