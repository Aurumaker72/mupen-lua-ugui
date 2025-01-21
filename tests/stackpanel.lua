local group = {
    name = 'stackpanel',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'layout_produces_expected_results',
    params = {
        {
            func = function()
                ugui.push_stackpanel({rectangle = {x = 10}, horizontal = true, gap = 5})
                ugui.button({
                    uid = 1,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'A',
                })
                ugui.button({
                    uid = 2,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'B',
                })
                ugui.button({
                    uid = 3,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'C',
                })
                ugui.push_stackpanel({rectangle = {}, gap = 5})
                ugui.button({
                    uid = 4,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'D',
                })
                ugui.button({
                    uid = 5,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'E',
                })
                ugui.button({
                    uid = 6,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'F',
                })
                ugui.push_stackpanel({rectangle = {}, horizontal = true, gap = 5})
                ugui.button({
                    uid = 7,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'G',
                })
                ugui.pop()
                ugui.pop()
                ugui.button({
                    uid = 10,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'H',
                })
                ugui.pop()
            end,
            expected_rects = {
                {width = 20, y = 0, x = 10, height = 20},
                {width = 20, y = 0, x = 35, height = 20},
                {width = 20, y = 0, x = 60, height = 20},
                {width = 20, y = 25, x = 60, height = 20},
                {width = 20, y = 50, x = 60, height = 20},
                {width = 20, y = 75, x = 60, height = 20},
                {width = 20, y = 75, x = 85, height = 20},
                {width = 20, y = 0, x = 85, height = 20},
            },
        },
        {
            func = function()
                ugui.push_stackpanel({rectangle = {x = 10, y = 240}, gap = 5})
                ugui.button({
                    uid = 11,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'A',
                })
                ugui.button({
                    uid = 12,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'B',
                })
                ugui.button({
                    uid = 13,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'C',
                })
                ugui.push_stackpanel({rectangle = {}, horizontal = true, gap = 5})
                ugui.button({
                    uid = 14,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'D',
                })
                ugui.button({
                    uid = 15,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'E',
                })
                ugui.button({
                    uid = 16,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'F',
                })
                ugui.push_stackpanel({rectangle = {}, gap = 5})
                ugui.button({
                    uid = 17,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'G',
                })
                ugui.pop()
                ugui.pop()
                ugui.button({
                    uid = 18,
                    rectangle = {width = 20, height = 20, x = 0, y = 0},
                    text = 'H',
                })
                ugui.pop()
            end,
            expected_rects = {
                {height = 20, width = 20, x = 10, y = 240},
                {height = 20, width = 20, x = 10, y = 265},
                {height = 20, width = 20, x = 10, y = 290},
                {height = 20, width = 20, x = 35, y = 290},
                {height = 20, width = 20, x = 60, y = 290},
                {height = 20, width = 20, x = 85, y = 290},
                {height = 20, width = 20, x = 85, y = 315},
                {height = 20, width = 20, x = 10, y = 315},
            },
        },
    },
    func = function(ctx)
        local i = 1
        BreitbandGraphics.fill_rectangle = function(rectangle, color)
            if color ~= ugui.standard_styler.params.button.border[ugui.visual_states.normal] then
                return
            end

            print(rectangle)
            local expected_rect = ctx.data.expected_rects[i]
            ctx.assert_eq(expected_rect.x, rectangle.x)
            ctx.assert_eq(expected_rect.y, rectangle.y)
            ctx.assert_eq(expected_rect.width, rectangle.width)
            ctx.assert_eq(expected_rect.height, rectangle.height)

            i = i + 1
        end

        ugui.begin_frame({
            mouse_position = {x = 0, y = 0},
            wheel = 0,
            held_keys = {},
        })

        ctx.data.func()

        ugui.end_frame()
    end,
}

return group
