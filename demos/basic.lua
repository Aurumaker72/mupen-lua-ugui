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
        vertical = true,
    },
    children = {
        {
            type = 'button',
            props = {
                h_align = ugui.alignments.center,
                v_align = ugui.alignments.center,
            },
            children = {},
        },
    },
}

local uid_gen = 0

local function build_from_tree(node, parent_uid)
    uid_gen = uid_gen + 1

    ugui.add_child(parent_uid, {
        type = node.type,
        uid = uid_gen,
        props = node.props,
    })

    if node.children then
        for _, child in pairs(node.children) do
            build_from_tree(child, uid_gen)
        end
    end
end

ugui.start(300, function()
    build_from_tree(tree, nil)
end)
