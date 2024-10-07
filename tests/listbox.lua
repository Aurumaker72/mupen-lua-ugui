local group = {
    name = 'listbox',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'click_sets_correct_selected_index',
    func = function(ctx)
        ctx.assert(false, 'Test not implemented')
    end,
}

group.tests[#group.tests + 1] = {
    name = 'overflow_shows_scrollbars',
    func = function(ctx)
        ctx.assert(false, 'Test not implemented')
    end,
}

return group
