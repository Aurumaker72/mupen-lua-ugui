-- mupen-lua-ugui retained mode
-- Aurumaker72 2024
local ugui = {
    messages = {
        -- The control has been created
        create = 0,
        -- The control is being destroyed
        destroy = 1,
        -- The control needs to be painted
        paint = 2,
        -- The control is being queried for its dimensions
        measure = 2,
    },
    alignments = {
        -- The object is aligned to the start of its container
        start = 0,
        -- The object is aligned to the center of its container
        center = 1,
        -- The object is aligned to the end of its container
        ['end'] = 2,
        -- The object fills its container
        fill = 3,
    },
}

-- The control tree
local root_node = {
    uid = -1,
    type = 'panel',
    h_align = ugui.alignments.fill,
    v_align = ugui.alignments.fill,
    bounds = {},
    children = {},
}

-- Map of control types to templates
local registry = {}

-- List of invalidated uids
-- All children of the controls will be repainted too
local layout_queue = {}

-- Window size upon script start
local start_size = nil

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

---Finds a control in the root_node by its uid
---@param uid number A unique control identifier
---@param node table The node to begin the search from
local function find(uid, node)
    if uid == node.uid then
        return node
    end
    for _, child in pairs(node.children) do
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
    predicate(node)
    for key, value in pairs(node.children) do
        iterate(value, predicate)
    end
end

---Lays out a node and its children
---@param node table The node
---@param parent_rect table The parent's rectangle
local function layout_node(node, parent_rect)
    node.bounds = parent_rect
    for _, child in pairs(node.children) do
        layout_node(child, node.bounds)
    end
end

---Invalidates a control's layout along with its children
---@param uid number A unique control identifier
local function invalidate_layout(uid)
    layout_queue[#layout_queue + 1] = uid
end

---Registers a control template, adding its type to the global registry
---@param control table A control
ugui.register_control = function(control)
    registry[control.type] = control
end

---Gets the userdata of a control
---@param uid number A unique control identifier
---@return any
ugui.get_udata = function(uid)
    return find(uid, root_node).udata
end

---Sets the userdata of a control
---@param uid number A unique control identifier
---@param data any The user data
ugui.set_udata = function(uid, data)
    find(uid, root_node).udata = data
end

---Appends a child to a control
---The control will be clobbered
---@param parent_uid number A unique control identifier of the parent
---@param control table A control
ugui.add_child = function(parent_uid, control)
    print('Adding ' .. control.type .. ' (' .. control.uid .. ') to ' .. parent_uid)

    -- Initialize default properties
    control.children = {}
    control.bounds = nil
    control.invalidated = true

    -- We add the child to its parent's children array
    local parent = find(parent_uid, root_node)
    parent.children[#parent.children + 1] = control

    -- Notify it about existing
    ugui.message(control.uid, {type = ugui.messages.create})

    -- We also need to invalidate the parent's layout
    invalidate_layout(parent_uid)
end

---Sends a message to a control
---@param uid number A unique control identifier of the parent
---@param msg table A message
ugui.message = function(uid, msg)
    local control = find(uid, root_node)

    -- First, the template gets the message
    if registry[control.type] then
        registry[control.type].message(ugui, control, msg)
    end

    -- Then, user-provided one (if it exists)
    if control.message then
        control.message(ugui, msg)
    end
end

---Hooks emulator functions and begins operating
---@param start function The function to be called upon starting
ugui.start = function(start)
    local last_input = nil
    local curr_input = nil

    start_size = wgui.info()
    wgui.resize(start_size.width + 200, start_size.height)

    -- Fill out root node bounds
    root_node.bounds = {x = start_size.width, y = 0, width = 200, height = start_size.height}

    start()

    -- At startup, invalidate root node
    invalidate_layout(root_node.uid)

    emu.atupdatescreen(function()
        last_input = curr_input and deep_clone(curr_input) or input.get()
        curr_input = input.get()

        -- Relayout all invalidated controls
        for _, uid in pairs(layout_queue) do
            layout_node(find(uid, root_node), root_node.bounds)
        end
        layout_queue = {}

        -- Paint bounding boxes of all controls (debug)
        iterate(root_node, function(node)
            BreitbandGraphics.draw_rectangle(BreitbandGraphics.inflate_rectangle(node.bounds, -1), BreitbandGraphics.colors.red, 1)
        end)
    end)

    emu.atstop(function()
        wgui.resize(wgui.info().width - 200, wgui.info().height)
    end)
end

return ugui
