local function folder(file)
    local s = debug.getinfo(2, 'S').source:sub(2)
    local p = file:gsub('[%(%)%%%.%+%-%*%?%^%$]', '%%%0'):gsub('[\\/]', '[\\/]') .. '$'
    return s:gsub(p, '')
end

dofile(folder('demos\\basic.lua') .. 'src\\bgfx.lua')
messages = dofile(folder('demos\\basic.lua') .. 'src\\messages.lua')
alignments = dofile(folder('demos\\basic.lua') .. 'src\\alignments.lua')
local ugui = dofile(folder('demos\\basic.lua') .. 'src\\ugui.lua')

ugui.register_control(dofile(folder('demos\\basic.lua') .. 'src\\controls\\panel.lua'))
ugui.register_control(dofile(folder('demos\\basic.lua') .. 'src\\controls\\label.lua'))

ugui.start()

ugui.add_child(-1, {
    type = 'panel',
    uid = 1,
    h_align = alignments.fill,
    v_align = alignments.fill,
})
ugui.add_child(1, {
    type = 'button',
    uid = 2,
    h_align = alignments.center,
    v_align = alignments.center,
})
ugui.add_child(2, {
    type = 'label',
    uid = 3,
    text = 'Hello World',
    h_align = alignments.fill,
    v_align = alignments.fill,
})
