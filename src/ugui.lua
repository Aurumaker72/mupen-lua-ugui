-- mupen-lua-ugui retained mode
-- Aurumaker72 2024

local ugui = {
    _version = '0.0.1',
    messages = {
        -- The control has been created
        create = 0,
        -- The control is being destroyed
        destroy = 1,
        -- The control needs to be painted
        paint = 2,
        -- The control is being queried for its dimensions
        measure = 3,
        -- The control is asked to provide a rectangle[] for its children base bounds (which they are subsequently allowed to position themselves in),
        -- or an empty table if no transformations are performed
        get_base_child_bounds = 4,
        -- The control had a property modified
        prop_changed = 5,
        -- The mouse has entered the control's area
        mouse_enter = 6,
        -- The mouse has left the control's area
        mouse_leave = 7,
        -- The mouse is moving inside the control's area
        mouse_move = 8,
        -- The left mouse button has been pressed inside the control's area
        lmb_down = 9,
        -- The left mouse button has been released inside the control's area
        lmb_up = 10,
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
    util = {
        ---Message helper for measuring size by first child
        ---@param ugui table A ugui instance
        ---@param node table A node
        ---@return table The dimensions
        measure_by_child = function(ugui, node)
            -- Control's size is dictated by first child's dimensions
            if #node.children > 0 then
                return ugui.send_message(node.children[1], {
                    type = ugui.messages.measure,
                })
            else
                return {x = 0, y = 0}
            end
        end,

        ---Reduces an array
        ---@param list any[] An array
        ---@param fn function The reduction predicate
        ---@param init any The initial accumulator value
        ---@return any The final value of the accumulator
        reduce = function(list, fn, init)
            local acc = init
            for k, v in ipairs(list) do
                if 1 == k and not init then
                    acc = v
                else
                    acc = fn(acc, v)
                end
            end
            return acc
        end,

        ---Transforms all items in the collection via the predicate
        ---@param collection table
        ---@param predicate function A function which takes a collection element as a parameter and returns the modified element. This function should be pure in regards to the parameter.
        ---@return table table A collection of the transformed items
        select = function(collection, predicate)
            local t = {}
            for i = 1, #collection, 1 do
                t[i] = predicate(collection[i])
            end
            return t
        end,

        ---Deep clones an object
        ---@param obj any The current object
        ---@param seen any|nil The previous object, or nil for the first (obj)
        ---@return any A deep clone of the object
        deep_clone = function(obj, seen)
            local function deep_clone_impl(obj, seen)
                if type(obj) ~= 'table' then return obj end
                if seen and seen[obj] then return seen[obj] end
                local s = seen or {}
                local res = setmetatable({}, getmetatable(obj))
                s[obj] = res
                for k, v in pairs(obj) do
                    res[deep_clone_impl(k, s)] = deep_clone_impl(
                        v, s)
                end
                return res
            end

            return deep_clone_impl(obj, seen)
        end,

        ---Traverses all nodes under a node
        ---@param node table The node to begin the iteration from
        ---@param predicate function A function which accepts a node
        iterate = function(node, predicate)
            local function iterate_impl(node, predicate)
                predicate(node)
                for key, value in pairs(node.children) do
                    iterate_impl(value, predicate)
                end
            end

            iterate_impl(node, predicate)
        end,

        ---Finds a control in the root_node by its uid
        ---@param uid number A unique control identifier
        ---@param node table The node to begin the search from
        find = function(uid, node)
            local function find_impl(uid, node)
                if uid == node.uid then
                    return node
                end
                for _, child in pairs(node.children) do
                    if child.uid == uid then
                        return child
                    end
                    local result = find_impl(uid, child)
                    if result then
                        return result
                    end
                end
                return nil
            end

            return find_impl(uid, node)
        end,
    },
    internal = {
        ---Performs default message processing
        ---@param ugui table The related ugui context
        ---@param inst table The control instance
        ---@param msg table The message
        default_message_handler = function(ugui, inst, msg)
            if msg.type == ugui.messages.prop_changed then
                if msg.key == 'h_align' or msg.key == 'v_align' then
                    ugui.invalidate_layout(inst.uid)
                    ugui.invalidate_visuals(inst.uid)
                end
            end
        end,

        ---Finds the topmost node at the specified point
        ---@param point table The point to search at
        ---@return table|nil The node at the specified point, or null
        node_at_point = function(point, node)
            function node_at_point_impl(point, node)
                if not node then
                    return nil
                end
                if BreitbandGraphics.point_in_rect(point, node.bounds) and #node.children == 0 and node.props.hittest then
                    return node
                end
                for _, child in pairs(node.children) do
                    local result = node_at_point_impl(point, child)
                    if result then
                        return result
                    end
                end

                if BreitbandGraphics.point_in_rect(point, node.bounds) and node.props.hittest then
                    return node
                end

                return nil
            end

            return node_at_point_impl(point, node)
        end,
    },
}

-- The control tree
local root_node = nil

-- Map of control types to templates
local registry = {}

-- List of layout invalidated uids. Respective controls' children are implicitly contained as well.
local layout_queue = {}

-- List of paint invalidated uids. Respective controls' children are implicitly contained as well.
local paint_queue = {}

-- Window size upon script start
local start_size = nil

-- Uid of the node capturing the mouse
local mouse_capturing_uid = nil

---Returns the base layout bounds for a node
---@param node table The node
ugui.get_base_layout_bounds = function(node)
    local size = ugui.send_message(node, {type = ugui.messages.measure})

    local rect = {
        x = node.parent_bounds.x,
        y = node.parent_bounds.y,
        width = size.x,
        height = size.y,
    }

    if node.props.h_align == ugui.alignments.center then
        rect.x = node.parent_bounds.x + node.parent_bounds.width / 2 - size.x / 2
    end
    if node.props.h_align == ugui.alignments['end'] then
        rect.x = node.parent_bounds.x + node.parent_bounds.width - size.x
    end
    if node.props.h_align == ugui.alignments.fill then
        rect.width = node.parent_bounds.width
    end

    if node.props.v_align == ugui.alignments.center then
        rect.y = node.parent_bounds.y + node.parent_bounds.height / 2 - size.y / 2
    end
    if node.props.v_align == ugui.alignments['end'] then
        rect.y = node.parent_bounds.y + node.parent_bounds.height - size.y
    end
    if node.props.v_align == ugui.alignments.fill then
        rect.height = node.parent_bounds.height
    end
    return {
        x = math.ceil(rect.x),
        y = math.ceil(rect.y),
        width = math.ceil(rect.width),
        height = math.ceil(rect.height),
    }
end

---Lays out a node and its children
---@param node table The node
local function layout_node(node)
    -- When invalidating the layout of the root node, you'll correctly lay out the button since the stackpanel is computed first and they are aware of the correct bound parent size
    -- But when you invalidate the button node, they think the parent size is the regular stackpanel bounds, not the item
    -- I'm not quite sure how to solve this besides remembering parent bounds in a dictionary

    if not node.parent_bounds then
        -- Fallback: this is probably the root control, give it the screen
        node.parent_bounds = {x = start_size.width, y = 0, width = wgui.info().width - start_size.width, height = start_size.height}
    end

    -- Compute layout bounds and apply them
    node.bounds = ugui.get_base_layout_bounds(node)

    -- Layout node pass: let them reposition childrens' bounds after layout is finished
    local new_child_bounds = ugui.send_message(node, {type = ugui.messages.get_base_child_bounds})
    if new_child_bounds then
        -- Control provides individual parent bounds per child!
        for i, child in pairs(node.children) do
            child.parent_bounds = ugui.util.deep_clone(new_child_bounds[i])
            layout_node(child)
        end
    else
        -- Do child layout pass
        for _, child in pairs(node.children) do
            child.parent_bounds = ugui.util.deep_clone(node.bounds)
            layout_node(child)
        end
    end
end

---Paints a node and its children
---@param node table The node
local function paint_node(node)
    if not node.invalidated_visual then
        return
    end

    ugui.util.iterate(node, function(x)
        -- print('Painting ' .. x.type)
        ugui.send_message(x, {type = ugui.messages.paint, rect = x.bounds})
        x.invalidated_visual = false
    end)
end

---Invalidates a control's layout along with its children
---@param uid number A unique control identifier
ugui.invalidate_layout = function(uid)
    layout_queue[#layout_queue + 1] = uid
end

---Invalidates a control's visuals along with its children
---@param uid number A unique control identifier
ugui.invalidate_visuals = function(uid)
    ugui.util.find(uid, root_node).invalidated_visual = true
    paint_queue[#paint_queue + 1] = uid
end

---Registers a control template, adding its type to the global registry
---@param control table A control
ugui.register_template = function(control)
    registry[control.type] = control
end

---Returns a template from the global registry
---@param type string The template type
ugui.get_registered_template = function(type)
    return registry[type]
end

---Gets a control property's value
---@param uid number A unique control identifier
---@param key string The property key
---@return any|nil
ugui.get_prop = function(uid, key)
    return ugui.util.find(uid, root_node).props[key]
end

---Sets a control property's value, only if uninitialized
---@param uid number A unique control identifier
---@param key string The property key
---@param value any The property's new value
ugui.init_prop = function(uid, key, value)
    local node = ugui.util.find(uid, root_node)
    if type(node.props[key]) ~= 'nil' then
        return
    end
    node.props[key] = value
    ugui.send_message(node, {type = ugui.messages.prop_changed, key = key, value = value})
end

---Sets a control property's value
---@param uid number A unique control identifier
---@param key string The property key
---@param value any The property's new value
ugui.set_prop = function(uid, key, value)
    local node = ugui.util.find(uid, root_node)
    node.props[key] = value
    ugui.send_message(node, {type = ugui.messages.prop_changed, key = key, value = value})
end

---Appends a child to a control
---The control will be clobbered
---@param parent_uid number|nil A unique control identifier of the parent, or nil if the control is the root control
---@param control table A control
ugui.add_child = function(parent_uid, control)
    -- Initialize default properties
    control.children = {}
    control.props = control.props and control.props or {}
    control.padding = control.padding and control.padding or {x = 0, y = 0}
    control.bounds = nil
    control.invalidated_visual = true

    if parent_uid then
        -- We add the child to its parent's children array
        local parent = ugui.util.find(parent_uid, root_node)
        if not parent then
            print('Control ' .. control.type .. ' has no parent with uid ' .. parent_uid)
            return
        end
        parent.children[#parent.children + 1] = control
    else
        root_node = control
    end

    -- Notify it about existing
    ugui.send_message(control, {type = ugui.messages.create})

    ugui.init_prop(control.uid, 'visible', true)
    ugui.init_prop(control.uid, 'enabled', true)
    ugui.init_prop(control.uid, 'hittest', true)

    -- We also need to invalidate the parent completely
    ugui.invalidate_layout(parent_uid and parent_uid or control.uid)
    ugui.invalidate_visuals(parent_uid and parent_uid or control.uid)
end

---Sends a message to a node
---@param node table A node
---@param msg table A message
ugui.send_message = function(node, msg)
    -- TODO: If user-provided one exists, it takes priority and user must invoke lower one manually
    -- if node.message then
    --     node.message(ugui, msg)
    --     return
    -- end
    ugui.internal.default_message_handler(ugui, node, msg)
    return registry[node.type].message(ugui, node, msg)
end

---Captures the mouse, which causes the specified control to exclusively receive mouse events
---@param uid number A unique control identifier
ugui.capture_mouse = function(uid)
    if mouse_capturing_uid then
        print("Can't capture the mouse, as it's already being captured.")
        return
    end
    mouse_capturing_uid = uid
end

---Releases the mouse capture, restoring normal mouse event propagation
ugui.release_mouse = function()
    mouse_capturing_uid = nil
end

---Hooks emulator functions and begins operating
---@param width number The width of the expanded area
---@param start function The function to be called upon starting
ugui.start = function(width, start)
    local last_input = nil
    local curr_input = nil

    start_size = wgui.info()
    wgui.resize(start_size.width + width, start_size.height)

    start()

    emu.atupdatescreen(function()
        last_input = curr_input and ugui.util.deep_clone(curr_input) or input.get()
        curr_input = input.get()

        local mouse_point = {x = curr_input.xmouse, y = curr_input.ymouse}
        local last_mouse_point = {x = last_input.xmouse, y = last_input.ymouse}

        for _, uid in pairs(layout_queue) do
            layout_node(ugui.util.find(uid, root_node))
        end
        layout_queue = {}

        for _, uid in pairs(paint_queue) do
            paint_node(ugui.util.find(uid, root_node))
        end
        paint_queue = {}

        -- Paint bounding boxes of all controls (debug)
        -- iterate(root_node, function(node)
        --     BreitbandGraphics.draw_rectangle(BreitbandGraphics.inflate_rectangle(node.bounds, -1), BreitbandGraphics.colors.red, 1)
        -- end)

        -- Paint all controls every time (debug)
        -- iterate(root_node, function(node)
        --     ugui.send_message(node, {type = ugui.messages.paint, rect = node.bounds})
        -- end)

        local node_at_mouse = ugui.internal.node_at_point(mouse_point, root_node)
        local node_at_last_mouse = ugui.internal.node_at_point(last_mouse_point, root_node)

        if node_at_mouse ~= node_at_last_mouse then
            if node_at_mouse then
                ugui.send_message(node_at_mouse, {type = ugui.messages.mouse_enter})
            end
            if node_at_last_mouse then
                ugui.send_message(node_at_last_mouse, {type = ugui.messages.mouse_leave})
            end
        end
    end)

    emu.atstop(function()
        wgui.resize(wgui.info().width - width, wgui.info().height)
    end)
end

return ugui
