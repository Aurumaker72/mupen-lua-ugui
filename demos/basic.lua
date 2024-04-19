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

local tree = {
    type = 'panel',
    props = {
        h_align = ugui.alignments.fill,
        v_align = ugui.alignments.fill,
    },
    children = {
        {
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
                        checkable = true,
                        click = function(ugui, inst)
                            ugui.set_prop(2, 'disabled', ugui.get_prop(inst.uid, 'checked'))
                        end,
                    },
                    children = {
                        {
                            type = 'label',
                            props = {
                                h_align = ugui.alignments.center,
                                v_align = ugui.alignments.center,
                                text = 'Disable others',
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
