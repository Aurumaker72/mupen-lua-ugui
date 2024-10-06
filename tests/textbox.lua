local group = {
    name = 'textbox',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'remains_active_control_after_click_release',
    func = function(ctx)
        local rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        for i = 1, 3, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 10,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i == 2,
                held_keys = {},
            })

            ugui.textbox({
                uid = 5,
                rectangle = rect,
                text = 'Hello World!',
            })

            if i == 3 and ugui.internal.active_control ~= 5 then
                ctx.fail()
            end

            ctx.log((ugui.internal.active_control or 'nil') .. ' ' .. ((i % 2 == 0) and 'true' or 'false') .. ' i = ' .. i)

            ugui.end_frame()
        end
    end,
}

group.tests[#group.tests + 1] = {
    name = 'active_control_changes_after_click_on_another_control',
    func = function(ctx)
        local textbox_rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }
        local button_rect = {
            x = 0,
            y = 25,
            width = 100,
            height = 25,
        }


        for i = 1, 5, 1 do
            local mouse_position = {x = 10, y = 10}

            if i > 3 then
                mouse_position = {x = 10, y = 30}
            end

            ugui.begin_frame({
                mouse_position = mouse_position,
                wheel = 0,
                is_primary_down = i % 2 == 0,
                held_keys = {},
            })

            ugui.textbox({
                uid = 5,
                rectangle = textbox_rect,
                text = 'Hello World!',
            })

            ugui.button({
                uid = 10,
                rectangle = button_rect,
                text = 'Hello World!',
            })

            if i == 5 and ugui.internal.active_control ~= 10 then
                ctx.fail()
            end

            ctx.log((ugui.internal.active_control or 'nil') .. ' ' .. ((i % 2 == 0) and 'true' or 'false') .. ' i = ' .. i)

            ugui.end_frame()
        end
    end,
}

-- NOTE: This is pretty flaky since it depends on D2D text measuring behaviour but whatever
group.tests[#group.tests + 1] = {
    name = 'click_picks_correct_selection_start_index',
    params = {
        {
            mouse_x = 12,
            expected_start_index = 3,
        },
        {
            mouse_x = 24,
            expected_start_index = 5,
        },
        {
            mouse_x = 25,
            expected_start_index = 5,
        },
        {
            mouse_x = 99,
            expected_start_index = 5,
        },
    },
    func = function(ctx)
        local rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        for i = 1, 2, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = ctx.data.mouse_x,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i == 2,
                held_keys = {},
            })

            ugui.textbox({
                uid = 5,
                rectangle = rect,
                text = 'Test',
            })

            if i == 2 and ugui.internal.control_data[5].selection_start ~= ctx.data.expected_start_index then
                ctx.fail()
            end

            ctx.log((ugui.internal.control_data[5].selection_start or 'nil') .. ' ' .. ((i % 2 == 0) and 'true' or 'false') .. ' i = ' .. i)

            ugui.end_frame()
        end
    end,
}

-- NOTE: This is pretty flaky since it depends on D2D text measuring behaviour but whatever
group.tests[#group.tests + 1] = {
    name = 'drag_picks_correct_selection_indicies',
    params = {
        {
            begin_mouse_x = 12,
            end_mouse_x = 25,
            expected_start_index = 3,
            expected_end_index = 5,
        },
        {
            begin_mouse_x = 12,
            end_mouse_x = 99,
            expected_start_index = 3,
            expected_end_index = 5,
        },
        {
            begin_mouse_x = 25,
            end_mouse_x = 12,
            expected_start_index = 5,
            expected_end_index = 3,
        },
        {
            begin_mouse_x = 99,
            end_mouse_x = 12,
            expected_start_index = 5,
            expected_end_index = 3,
        },
    },
    func = function(ctx)
        local rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        for i = 1, 10, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = i >= 3 and ctx.data.end_mouse_x or ctx.data.begin_mouse_x,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i >= 2,
                held_keys = {},
            })

            ugui.textbox({
                uid = 5,
                rectangle = rect,
                text = 'Test',
            })

            if i >= 3 then
                if ugui.internal.control_data[5].selection_start ~= ctx.data.expected_start_index then
                    ctx.fail()
                end
                if ugui.internal.control_data[5].selection_end ~= ctx.data.expected_end_index then
                    ctx.fail()
                end
            end

            ctx.log((ugui.internal.control_data[5].selection_start or 'nil') .. ' ' .. ((i % 2 == 0) and 'true' or 'false') .. ' i = ' .. i)
            ctx.log((ugui.internal.control_data[5].selection_end or 'nil') .. ' ' .. ((i % 2 == 0) and 'true' or 'false') .. ' i = ' .. i)

            ugui.end_frame()
        end
    end,
}


return group
