local group = {
    name = 'carrousel_button',
    tests = {},
}

local items = {
    "Foo",
    "Bar",
    "Baz",
}

group.tests[#group.tests + 1] = {
    name = 'left_click_decrements_index',
    func = function(ctx)
        local button_rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        local index = 2

        for i = 1, 2, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 10,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i % 2 == 0,
                held_keys = {},
            })

            index = ugui.carrousel_button({
                uid = 5,
                rectangle = button_rect,
                selected_index = index,
                items = items,
            })

            if i == 2 and index ~= 1 then
                ctx.fail()
            end
            
            ugui.end_frame()
        end
    end,
}

group.tests[#group.tests + 1] = {
    name = 'right_click_increments_index',
    func = function(ctx)
        local button_rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        local index = 2

        for i = 1, 2, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 90,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i % 2 == 0,
                held_keys = {},
            })

            index = ugui.carrousel_button({
                uid = 5,
                rectangle = button_rect,
                selected_index = index,
                items = items,
            })

            if i == 2 and index ~= 3 then
                ctx.fail()
            end
            
            ugui.end_frame()
        end
    end,
}

group.tests[#group.tests + 1] = {
    name = 'min_to_max_wraparound_works',
    func = function(ctx)
        local button_rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        local index = 1

        for i = 1, 2, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 10,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i % 2 == 0,
                held_keys = {},
            })

            index = ugui.carrousel_button({
                uid = 5,
                rectangle = button_rect,
                selected_index = index,
                items = items,
            })

            if i == 2 and index ~= 3 then
                ctx.fail()
            end
            
            ugui.end_frame()
        end
    end,
}

group.tests[#group.tests + 1] = {
    name = 'max_to_min_wraparound_works',
    func = function(ctx)
        local button_rect = {
            x = 0,
            y = 0,
            width = 100,
            height = 25,
        }

        local index = 3

        for i = 1, 2, 1 do
            ugui.begin_frame({
                mouse_position = {
                    x = 90,
                    y = 10,
                },
                wheel = 0,
                is_primary_down = i % 2 == 0,
                held_keys = {},
            })

            index = ugui.carrousel_button({
                uid = 5,
                rectangle = button_rect,
                selected_index = index,
                items = items,
            })

            if i == 2 and index ~= 1 then
                ctx.fail()
            end
            
            ugui.end_frame()
        end
    end,
}


return group
