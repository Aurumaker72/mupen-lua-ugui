local group = {
    name = 'listbox',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'draw_text_called_correctly',
    func = function(ctx)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'click_sets_correct_selected_index',
    params = {
        {
            items = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J'},
            rect = {x = 10, y = 10, width = 100, height = 200},
            mouse_position = {x = 10, y = 10},
            expected_index = 1,
        },
        {
            items = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J'},
            rect = {x = 10, y = 10, width = 100, height = 200},
            mouse_position = {x = 10, y = 100},
            expected_index = 1,
        },
    },
    func = function(ctx)
        local selected_index = nil

        ugui.begin_frame({
            mouse_position = ctx.data.mouse_position,
            wheel = 0,
            is_primary_down = false,
            held_keys = {},
        })
        selected_index = ugui.listbox({
            uid = 5,
            rectangle = ctx.data.rect,
            items = ctx.data.items,
            selected_index = selected_index,
        })
        ugui.end_frame()

        ugui.begin_frame({
            mouse_position = ctx.data.mouse_position,
            wheel = 0,
            is_primary_down = true,
            held_keys = {},
        })
        selected_index = ugui.listbox({
            uid = 5,
            rectangle = ctx.data.rect,
            items = ctx.data.items,
            selected_index = selected_index,
        })
        ugui.end_frame()

        ctx.log(selected_index)
        ctx.assert_eq(ctx.data.expected_index, selected_index)
    end,
}

group.tests[#group.tests + 1] = {
    name = 'overflow_shows_scrollbars',
    func = function(ctx)
    end,
}

return group
