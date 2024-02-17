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

ugui.start(300, function()
    ugui.add_child(nil, {
        type = 'stackpanel',
        uid = -1,
        props = {
            h_align = ugui.alignments.fill,
            v_align = ugui.alignments.fill,
            vertical = true,
        },
    })

    ugui.add_child(-1, {
        type = 'button',
        uid = 200,
        props = {
            h_align = ugui.alignments.center,
            v_align = ugui.alignments.center,
        },
    })

    ugui.add_child(200, {
        type = 'label',
        uid = 201,
        props = {
            text = 'Hello World',
            h_align = ugui.alignments.fill,
            v_align = ugui.alignments.fill,
            size = 28,
        },
    })
    for i = 1, 20, 1 do
        ugui.add_child(-1, {
            type = 'button',
            uid = i * 100,
            props = {
                h_align = ugui.alignments.center,
                v_align = ugui.alignments.center,
            },
        })
        ugui.add_child(i * 100, {
            type = 'label',
            uid = (i * 100) + 1,
            props = {
                text = 'Goodbye World',
                h_align = ugui.alignments.fill,
                v_align = ugui.alignments.fill,
            },
        })
    end

    
end)
