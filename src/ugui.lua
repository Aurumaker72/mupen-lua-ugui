-- mupen-lua-ugui retained mode
-- Aurumaker72 2024
local ugui = {}

-- The control tree
local tree = {}

-- Map of control types to templates
local registry = {}

-- Map of uids to user data
local udata = {}

---Registers a control, adding its type to the global registry
---@param control table A control
ugui.register_control = function(control)

end

---Gets the userdata of a control
---@param uid number A unique control identifier
---@return any
ugui.get_udata = function(uid)
    return udata[uid]
end

---Sets the userdata of a control
---@param uid number A unique control identifier
---@param data any The user data
ugui.set_udata = function(uid, data)
    udata[uid] = data
end

---Appends a child to a control
---@param uid number A unique control identifier
---@param control table A control
ugui.append_child = function(uid, control)

end

---Hooks emulator functions and begins operating
ugui.hook = function()
    emu.atupdatescreen(function()
        -- TODO
    end)
end

return ugui
