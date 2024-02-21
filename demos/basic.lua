local function folder(file)
    local s = debug.getinfo(2, 'S').source:sub(2)
    local p = file:gsub('[%(%)%%%.%+%-%*%?%^%$]', '%%%0'):gsub('[\\/]', '[\\/]') .. '$'
    return s:gsub(p, '')
end

dofile(folder('demos\\basic.lua') .. 'src\\bgfx.lua')
local ugui = dofile(folder('demos\\basic.lua') .. 'src\\ugui.lua')

ugui.register_template(dofile(folder('demos\\basic.lua') .. 'src\\controls\\panel.lua'))
ugui.register_template(dofile(folder('demos\\basic.lua') .. 'src\\controls\\stackpanel.lua'))
ugui.register_template(dofile(folder('demos\\basic.lua') .. 'src\\controls\\label.lua'))
ugui.register_template(dofile(folder('demos\\basic.lua') .. 'src\\controls\\button.lua'))


-- local tree = {
--     type = 'stackpanel',
--     props = {
--         h_align = ugui.alignments.fill,
--         v_align = ugui.alignments.fill,
--         vertical = true,
--     },
--     children = {
--         {
--             type = 'button',
--             props = {
--                 h_align = ugui.alignments.center,
--                 v_align = ugui.alignments.center,
--             },
--             children = {
--                 {
--                     type = 'label',
--                     props = {
--                         text = 'Hello World',
--                         h_align = ugui.alignments.fill,
--                         v_align = ugui.alignments.fill,
--                         size = 28,
--                     },
--                 },
--             },
--         },
--         {
--             type = 'button',
--             props = {
--                 h_align = ugui.alignments.center,
--                 v_align = ugui.alignments.center,
--             },
--             children = {
--                 {
--                     type = 'label',
--                     props = {
--                         text = 'Hello World',
--                         h_align = ugui.alignments.fill,
--                         v_align = ugui.alignments.fill,
--                         size = 28,
--                     },
--                 },
--             },
--         },
--     },
-- }

local tree = {
    type = 'stackpanel',
    props = {
        h_align = ugui.alignments.fill,
        v_align = ugui.alignments.fill,
    },
    children = {
        {
            type = 'button',
            props = {
                h_align = ugui.alignments.center,
                v_align = ugui.alignments.center,
            },
            children = {
                {
                    type = 'label',
                    props = {
                        h_align = ugui.alignments.center,
                        v_align = ugui.alignments.center,
                        text = 'Hello World!',
                    },
                },
            },
        },
        {
            type = 'stackpanel',
            props = {
                h_align = ugui.alignments.center,
                v_align = ugui.alignments.fill,
                horizontal = true,
            },
            children = {
                {
                    type = 'button',
                    props = {
                        h_align = ugui.alignments.center,
                        v_align = ugui.alignments.center,
                    },
                    children = {
                        {
                            type = 'label',
                            props = {
                                h_align = ugui.alignments.center,
                                v_align = ugui.alignments.center,
                                text = 'Goodbye World!',
                            },
                        },
                    },
                },
                {
                    type = 'button',
                    props = {
                        h_align = ugui.alignments.center,
                        v_align = ugui.alignments.center,
                    },
                    children = {
                        {
                            type = 'label',
                            props = {
                                h_align = ugui.alignments.center,
                                v_align = ugui.alignments.center,
                                text = 'Goodbye World!',
                            },
                        },
                    },
                },
            },
        },
        {
            type = 'button',
            props = {
                h_align = ugui.alignments.center,
                v_align = ugui.alignments.center,
            },
            children = {
                {
                    type = 'label',
                    props = {
                        h_align = ugui.alignments.center,
                        v_align = ugui.alignments.center,
                        text = 'Goodbye World!',
                    },
                },
            },
        },
    },
}

local used_uids = {}

local function make_uids(node, current_uid, parent_uid)
    node.uid = current_uid
    node.parent_uid = parent_uid

    if not node.children then
        node.children = {}
    end

    node.uid = math.random(0, 100000)
    while used_uids[node.uid] do
        node.uid = math.random(0, 100000)
    end

    used_uids[node.uid] = true

    for _, child in pairs(node.children) do
        make_uids(child, current_uid, node.uid)
    end
end

local function iterate(node, predicate)
    predicate(node)
    for key, value in pairs(node.children) do
        iterate(value, predicate)
    end
end

ugui.start({
    width = 300,
}, function()
    make_uids(tree, 0, nil)

    iterate(tree, function(node)
        ugui.add_child(node.parent_uid, {
            type = node.type,
            uid = node.uid,
            props = node.props,
        })
    end)
end)
