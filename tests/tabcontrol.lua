local group = {
    name = 'tabcontrol',
    setup = function()
        local print2 = print
        print = function() end
        dofile(folder('tests\\tabcontrol.lua') .. 'mupen-lua-ugui-ext.lua')
        print = print2
    end,
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'no_items_doesnt_crash',
    func = function(ctx)
        ugui.begin_frame({
            mouse_position = {
                x = 10,
                y = 10,
            },
            wheel = 0,
            held_keys = {},
        })
        ugui.tabcontrol({
            uid = 1,
            rectangle = {
                x = 10,
                y = 10,
                width = 190,
                height = 25,
            },
        })
        ugui.end_frame()
        ctx.assert(true)
    end,
}

return group
