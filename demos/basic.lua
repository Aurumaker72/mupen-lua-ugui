local function folder(file)
    local s = debug.getinfo(2, 'S').source:sub(2)
    local p = file:gsub('[%(%)%%%.%+%-%*%?%^%$]', '%%%0'):gsub('[\\/]', '[\\/]') .. '$'
    return s:gsub(p, '')
end

dofile(folder('demos\\basic.lua') .. 'src\\bgfx.lua')
local ugui = dofile(folder('demos\\basic.lua') .. 'src\\ugui.lua')


ugui.add_controls({
    type = "stackpanel",
    uid = 0,
    content = {
        {
            type = "button",
            uid = 1,
            content = {
                  {
                      type = "label",
                      uid = 2,
                      content = "Hello World!"
                  }
            }
        }
    }
})
