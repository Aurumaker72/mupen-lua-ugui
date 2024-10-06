local group = {
    name = 'trackbar',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'click_sets_correct_position',
    func = function(ctx)
        ctx.fail('Test not implemented')
    end,
}

return group
