local function folder(file)
    local s = debug.getinfo(2, 'S').source:sub(2)
    local p = file:gsub('[%(%)%%%.%+%-%*%?%^%$]', '%%%0'):gsub('[\\/]', '[\\/]') .. '$'
    return s:gsub(p, '')
end

dofile(folder('demos\\basic.lua') .. 'src\\bgfx.lua')
local messages = dofile(folder('demos\\basic.lua') .. 'src\\messages.lua')
local alignments = dofile(folder('demos\\basic.lua') .. 'src\\alignments.lua')
local ugui = dofile(folder('demos\\basic.lua') .. 'src\\ugui.lua')

ugui.register_control(dofile(folder('demos\\basic.lua') .. 'src\\controls\\dummy.lua'))
ugui.register_control(dofile(folder('demos\\basic.lua') .. 'src\\controls\\label.lua'))

ugui.append_child(0, {
    type = 'stackpanel',
    uid = 1,
    message = function(msg)
        if msg == messages.create then
            print('hello world')
        end
    end,
})
ugui.append_child(1, {
    type = 'button',
    uid = 2,
    message = function(msg)

    end,
})
ugui.append_child(2, {
    type = 'label',
    uid = 3,
    text = 'Hello World',
    message = function(msg)

    end,
})
