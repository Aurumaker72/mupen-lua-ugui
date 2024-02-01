-- mupen-lua-ugui retained mode
-- Aurumaker72 2024
local ugui = {}

-- The control tree
local tree = {}

-- Map of control types to templates
local registry = {}

-- Map of uids to user data
local udata = {}

-- List of invalidated uids
-- All children of the controls will be repainted too
local invalidated_uids = {}

---Finds a control in the tree by its uid 
---@param uid number A unique control identifier
---@param node table The node to begin the search from 
local function find(uid, node)
    for key, value in pairs(node.content) do
        if value.uid == uid then
            return value
        end
        find(uid, value.content)
    end
    return nil
end

---Traverses all nodes under a node
---@param node table The node to begin the iteration from
---@param predicate function A function which accepts a node
local function iterate(node, predicate)
    for key, value in pairs(node.content) do
        iterate(value, predicate)
    end
end

---Registers a control, adding its type to the global registry
---@param control table A control
ugui.register_control = function(control)
    registry[control.type] = control
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

---Invalidates a control
---@param uid number A unique control identifier
ugui.invalidate = function (uid)
    invalidated_uids[#invalidated_uids+1] = uid
end

---Appends a child to a control
---@param uid number A unique control identifier of the parent
---@param control table A control
ugui.append_child = function(uid, control)
    -- We add the child to its parent's content array
    local parent = find(uid, tree)
    parent.content[#parent.content+1] = control

    -- We also need to invalidate the parent
    ugui.invalidate(uid)
end

---Hooks emulator functions and begins operating
ugui.hook = function()
    emu.atupdatescreen(function()
        -- TODO
    end)
end

return ugui
