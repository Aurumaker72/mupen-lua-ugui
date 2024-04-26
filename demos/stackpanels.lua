local function folder(file)
    local s = debug.getinfo(2, 'S').source:sub(2)
    local p = file:gsub('[%(%)%%%.%+%-%*%?%^%$]', '%%%0'):gsub('[\\/]', '[\\/]') .. '$'
    return s:gsub(p, '')
end

dofile(folder('demos\\stackpanels.lua') .. 'src\\bgfx.lua')
local ugui = dofile(folder('demos\\stackpanels.lua') .. 'src\\ugui.lua')

ugui.register_template(dofile(folder('demos\\stackpanels.lua') .. 'src\\controls\\panel.lua'))
ugui.register_template(dofile(folder('demos\\stackpanels.lua') .. 'src\\controls\\stackpanel.lua'))
ugui.register_template(dofile(folder('demos\\stackpanels.lua') .. 'src\\controls\\label.lua'))
ugui.register_template(dofile(folder('demos\\stackpanels.lua') .. 'src\\controls\\button.lua'))

local tree = {
    type = 'panel',
    children = {
        {
            type = 'stackpanel',
            children = {
                {
                    type = 'button',
                    props = {
                        h_align = ugui.alignments.center,
                        v_align = ugui.alignments.center,
                        checkable = true,
                        click = function(ugui, inst)
                            ugui.set_prop(2, 'disabled', ugui.get_prop(inst.uid, 'checked'))
                            ugui.set_prop(3, 'hidden', ugui.get_prop(inst.uid, 'checked'))
                            ugui.set_prop(4, 'hidden', ugui.get_prop(inst.uid, 'checked'))
                        end,
                    },
                    children = {
                        {
                            type = 'label',
                            props = {
                                h_align = ugui.alignments.center,
                                v_align = ugui.alignments.center,
                                text = 'Change others',
                            },
                        },
                    },
                },
                {
                    type = 'stackpanel',
                    props = {
                        h_align = ugui.alignments['end'],
                        horizontal = true,
                    },
                    children = {
                        {
                            type = 'button',
                            uid = 2,
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
                                        text = 'Can be disabled',
                                    },
                                },
                            },
                        },
                        {
                            type = 'button',
                            uid = 3,
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
                                        text = 'i can disappear, ooooohhhh',
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
                            type = 'stackpanel',
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
                                        text = 'in a stackpanel!',
                                    },
                                },
                                {
                                    type = 'button',
                                    uid = 4,
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
                                                text = 'build nested layouts',
                                            },
                                        },
                                    },
                                },
                                {
                                    type = 'label',
                                    props = {
                                        h_align = ugui.alignments.center,
                                        v_align = ugui.alignments.center,
                                        text = 'woah!',
                                    },
                                },
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
    ugui.util.build_hierarchy_from_simple_tree(tree)
end)
