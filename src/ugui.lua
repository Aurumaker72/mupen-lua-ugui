-- mupen-lua-ugui retained mode
-- Aurumaker72 2024
local ugui = {}

-- The control tree
local tree = {
    uid = -1,
    type = 'panel',
    h_align = alignments.fill,
    v_align = alignments.fill,
    content = {},
}

-- Map of control types to templates
local registry = {}

-- List of invalidated uids
-- All children of the controls will be repainted too
local invalidated_uids = {}

---Deep clones an object
---@param obj any The current object
---@param seen any|nil The previous object, or nil for the first (obj)
---@return any A deep clone of the object
local function deep_clone(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do
        res[deep_clone(k, s)] = deep_clone(
            v, s)
    end
    return res
end

---Finds a control in the tree by its uid
---@param uid number A unique control identifier
---@param node table The node to begin the search from
local function find(uid, node)
    if uid == node.uid then
        return node
    end
    for _, child in pairs(node.content) do
        if child.uid == uid then
            return child
        end
        return find(uid, child)
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

---Registers a control template, adding its type to the global registry
---@param control table A control
ugui.register_control = function(control)
    print('Registering ' .. control.type)
    registry[control.type] = control
end

---Gets the userdata of a control
---@param uid number A unique control identifier
---@return any
ugui.get_udata = function(uid)
    return find(uid, tree).udata
end

---Sets the userdata of a control
---@param uid number A unique control identifier
---@param data any The user data
ugui.set_udata = function(uid, data)
    find(uid, tree).udata = data
end

---Invalidates a control
---@param uid number A unique control identifier
ugui.invalidate = function(uid)
    invalidated_uids[#invalidated_uids + 1] = uid
end

---Appends a child to a control
---The control will be clobbered
---@param uid number A unique control identifier of the parent
---@param control table A control
ugui.add_child = function(uid, control)
    print('Adding ' .. control.type .. ' (' .. control.uid .. ') to ' .. uid)

    -- Controls have no content by default
    control.content = {}

    -- We add the child to its parent's content array
    local parent = find(uid, tree)
    parent.content[#parent.content + 1] = control

    -- We also need to invalidate the parent
    ugui.invalidate(uid)
end

---Sends a message to a control
---@param uid number A unique control identifier of the parent
---@param msg table A message
ugui.message = function(uid, msg)
    local control = find(uid, tree)

    -- First, the template gets the message
    if registry[control.type] then
        print(msg.type .. ' sent to template: ' .. control.type .. ' (' .. uid .. ')')
        registry[control.type].message(control, msg)
    end

    -- Then, user-provided one (if it exists)
    if control.message then
        print(msg.type .. ' sent to user: ' .. control.type .. ' (' .. uid .. ')')
        control.message(msg)
    end
end

---Hooks emulator functions and begins operating
ugui.start = function()
    local last_input = nil
    local curr_input = nil

    local start_size = wgui.info()
    wgui.resize(start_size.width + 200, start_size.height)

    emu.atupdatescreen(function()
        last_input = curr_input and deep_clone(curr_input) or input.get()
        curr_input = input.get()

        -- Repaint all invalidated controls
        for _, uid in pairs(invalidated_uids) do
            ugui.message(uid, {
                type = messages.paint,
                rect = {x = start_size.width, y = 0, width = 200, height = start_size.height},
            })
        end
        invalidated_uids = {}
    end)

    emu.atstop(function()
        wgui.resize(wgui.info().width - 200, wgui.info().height)
    end)
end

return ugui
