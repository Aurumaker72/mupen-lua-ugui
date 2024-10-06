local group = {
    name = 'combobox',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'click_shows_topmost_listbox',
    func = function(ctx)
        ctx.fail("Test not implemented")
    end,
}

group.tests[#group.tests + 1] = {
    name = 'click_outside_hides_listbox',
    func = function(ctx)
        ctx.fail("Test not implemented")
    end,
}

return group
