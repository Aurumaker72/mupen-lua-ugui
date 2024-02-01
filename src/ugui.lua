-- mupen-lua-ugui retained mode
-- Aurumaker72 2024

-- Map of control types to templates
local registry = {}

-- Map of uids to user data 
local udata = {}

local ugui = {}


---Registers a control, adding its type to the global registry
---@param control table A control
ugui.register_control = function(control)
    
end

---Gets the userdata of a control
---@param uid string A unique control identifier
---@return any
ugui.get_udata = function (uid)
    return udata[uid]
end

---Sets the userdata of a control
---@param uid string A unique control identifier
---@param data any The user data
ugui.set_udata = function (uid, data)
    udata[uid] = data
end

ugui.add_controls = function ()
    
end


return ugui
