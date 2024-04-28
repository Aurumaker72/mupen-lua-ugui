local function folder(file)
    local s = debug.getinfo(2, 'S').source:sub(2)
    local p = file:gsub('[%(%)%%%.%+%-%*%?%^%$]', '%%%0'):gsub('[\\/]', '[\\/]') .. '$'
    return s:gsub(p, '')
end

dofile(folder('demos\\grids.lua') .. 'src\\bgfx.lua')
local ugui = dofile(folder('demos\\grids.lua') .. 'src\\ugui.lua')

ugui.register_template(dofile(folder('demos\\grids.lua') .. 'src\\controls\\panel.lua'))
ugui.register_template(dofile(folder('demos\\grids.lua') .. 'src\\controls\\grid.lua'))
ugui.register_template(dofile(folder('demos\\grids.lua') .. 'src\\controls\\label.lua'))
ugui.register_template(dofile(folder('demos\\grids.lua') .. 'src\\controls\\button.lua'))

local tree = {
    type = 'panel',
    children = {
        {
            type = 'grid',
            props = {
                cols = {2, 2},
                rows = {2, 1.2, 2, -1},
            },
            children = {
                {
                    type = 'button',
                    props = {
                        col = 2,
                        row = 2,
                    },
                    children = {
                        {
                            type = 'label',
                            props = {
                                text = 'Hello A',
                            },
                        },
                    },
                },
                {
                    type = 'button',
                    props = {
                        col = 1,
                        row = 1,
                    },
                    children = {
                        {
                            type = 'label',
                            props = {
                                text = 'Hello B',
                            },
                        },
                    },
                },
                {
                    type = 'button',
                    props = {
                        col = 1,
                        row = 4,
                    },
                    children = {
                        {
                            type = 'label',
                            props = {
                                text = 'Hello C (i am small)',
                            },
                        },
                    },
                },
            },
        },
    },
}



ugui.start({
    width = 300,
}, function()
    ugui.add_from_tree(nil, tree)
end)
