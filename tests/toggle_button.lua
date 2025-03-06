local group = {
    name = 'toggle_button',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'click_toggles_check_state',
    func = function(ctx)
        local button_rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        local checked = false

        for i = 1, 4, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 10,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i % 2 == 0,
                held_keys = {},
            })

            checked = ugui.toggle_button({
                uid = 5,
                rectangle = button_rect,
                text = 'Hello World!',
                is_checked = checked,
            })

            if i == 4 then
                ctx.assert(not checked, 'Expected unchecked, got checked')
            end

            ctx.log((checked and 'true' or 'false') .. ' ' .. ((i % 2 == 0) and 'true' or 'false') .. ' i = ' .. i)

            ugui.end_frame()
        end
    end,
}

group.tests[#group.tests + 1] = {
    name = 'is_checked_nil_acts_as_false',
    func = function(ctx)

        ugui.begin_frame({
            mouse_position = {
                x = 10,
                y = 10,
            },
            wheel = 0,
            is_primary_down = false,
            held_keys = {},
        })

        local checked = ugui.toggle_button({
            uid = 5,
            rectangle = { x = 0, y = 0, width = 100, height = 23 },
            text = 'Hello World!',
            is_checked = nil,
        })

        ctx.assert_eq(false, checked)

        ugui.end_frame()
    end,
}


return group
