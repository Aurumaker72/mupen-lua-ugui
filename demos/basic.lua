local function folder(file)
    local s = debug.getinfo(2, 'S').source:sub(2)
    local p = file:gsub('[%(%)%%%.%+%-%*%?%^%$]', '%%%0'):gsub('[\\/]', '[\\/]') .. '$'
    return s:gsub(p, '')
end

dofile(folder('demos\\basic.lua') .. 'src\\bgfx.lua')
local ugui = dofile(folder('demos\\basic.lua') .. 'src\\ugui.lua')

ugui.register_control(dofile(folder('demos\\basic.lua') .. 'src\\controls\\panel.lua'))
ugui.register_control(dofile(folder('demos\\basic.lua') .. 'src\\controls\\label.lua'))

ugui.start(function()
    ugui.add_child(-1, {
        type = 'stackpanel',
        uid = 100,
        h_align = ugui.alignments.fill,
        v_align = ugui.alignments.fill,
    })

    ugui.add_child(100, {
        type = 'button',
        uid = 200,
        h_align = ugui.alignments.center,
        v_align = ugui.alignments.center,
    })
    ugui.add_child(200, {
        type = 'label',
        uid = 201,
        text = 'Hello World',
        h_align = ugui.alignments.fill,
        v_align = ugui.alignments.fill,
    })

    ugui.add_child(100, {
        type = 'button',
        uid = 300,
        h_align = ugui.alignments.center,
        v_align = ugui.alignments.center,
    })
    ugui.add_child(300, {
        type = 'label',
        uid = 301,
        text = 'Goodbye World',
        h_align = ugui.alignments.fill,
        v_align = ugui.alignments.fill,
    })
end)
