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

        ---Traverses all nodes under a node, without calling the predicate for the node itself
        ---@param node table The node to begin the iteration from
        ---@param predicate function A function which accepts a node
        iterate_exclusive = function(node, predicate)
            local function iterate_exclusive_impl(x, predicate)
                predicate(x)
                for _, child in pairs(x.children) do
                    iterate_exclusive_impl(child, predicate)
                end
            end

            for _, child in pairs(node.children) do
                iterate_exclusive_impl(child, predicate)
            end
        end,

        ---Finds a control in the root_node by its uid
        ---@param uid number|nil A unique control identifier
        ---@param node table The node to begin the search from
        find = function(uid, node)
            if uid == nil then
                return nil
            end
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
        ---Finds the topmost node at the specified point
        ---@param point table The point to search at
        ---@return table|nil The node at the specified point, or null
        node_at_point = function(point, node)
            function node_at_point_impl(point, node)
                if not node then
                    return nil
                end
                if BreitbandGraphics.point_in_rect(point, node.bounds) and #node.children == 0 and not node.props.clickthrough then
                    return node
                end
                for _, child in pairs(node.children) do
                    local result = node_at_point_impl(point, child)
                    if result then
                        return result
                    end
                end

                if BreitbandGraphics.point_in_rect(point, node.bounds) and not node.props.clickthrough then
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

-- List of visually invalidated controls.
-- We store uids and not rects, because we might not have computed the bounds yet when invalidating the visuals.
-- However, layout is guaranteed to have been processed when dirty rects are being repainted, so we pull those at the repaint phase.
local dirty_uids = {}

-- Window size upon script start
local start_size = nil

-- Uid of the node capturing the mouse
local mouse_capturing_uid = nil

local last_input = nil
local curr_input = nil
local last_lmb_down_pos = {x = 0, y = 0}

---Paints the bounding boxes of a node's children
---@param root table A node
function ugui.internal.paint_bounding_boxes(root)
    ugui.util.iterate(root, function(node)
        BreitbandGraphics.draw_rectangle(BreitbandGraphics.inflate_rectangle(node.bounds, -1), BreitbandGraphics.colors.red, 1)
    end)
end

---Traverses all nodes above a node in bottom-up order
---@param node table The node to begin the iteration from
---@param predicate function A function which accepts a node
function ugui.util.iterate_upwards(node, predicate)
    local function iterate_upwards_impl(x, predicate)
        if predicate(x) then
            return
        end
        local parent = ugui.util.find(x.parent_uid, root_node)
        if not parent then
            return
        end
        iterate_upwards_impl(parent, predicate)
    end

    iterate_upwards_impl(node, predicate)
end

--- Whether a node is a child of another node
---@param node table The parent node
---@param child_uid number The child node's identifier
function ugui.util.is_child_of(node, child_uid)
    local child = ugui.util.find(child_uid, node)
    return child ~= nil
end

---Gets the root node. Writing to it externally will probably break the library.
function ugui.util.get_root_node()
    return root_node
end

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

---Processes the dirty rectangle queue
local function process_dirty_rects()
    if #dirty_uids == 0 then
        return
    end

    -- Iterate through each control and see if it intersects the dirty rect. If so, repaint it.
    -- We need to store a list of the intersecting controls, as they need to be repainted in reverse order, not top-to-bottom.
    for _, uid in pairs(dirty_uids) do
        local affected_nodes = {}
        local rect = ugui.util.find(uid, root_node).bounds

        ugui.util.iterate(root_node, function(x)
            if BreitbandGraphics.rectangles_intersect(x.bounds, rect) then
                affected_nodes[#affected_nodes + 1] = x
            end
        end)

        print(string.format('[paint] painting %s controls', #affected_nodes))
        
        -- We need to clip drawing to the affected rect, as we'd clobber other graphics otherwise
        BreitbandGraphics.push_clip(rect)
        for i = 1, #affected_nodes, 1 do
            ugui.send_message(affected_nodes[i], {type = ugui.messages.paint, rect = affected_nodes[i].bounds})
        end
        BreitbandGraphics.pop_clip()
    end


    dirty_uids = {}
end

---Processes all pending layout operations
local function process_layout()
    if #layout_queue == 0 then
        return
    end
    print(string.format('[layout] Performing %s node layouts...', #layout_queue))
    for _, uid in pairs(layout_queue) do
        layout_node(ugui.util.find(uid, root_node))
    end
    layout_queue = {}
end

---Invalidates a control's layout along with its children
---@param uid number A unique control identifier
ugui.invalidate_layout = function(uid)
    layout_queue[#layout_queue + 1] = uid
end

---Invalidates a control's visuals
---@param uid number A unique control identifier
ugui.invalidate_visuals = function(uid)
    dirty_uids[#dirty_uids + 1] = uid
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
    local node = ugui.util.find(uid, root_node)
    if not node then
        return nil
    end
    local value = node.props[key]

    if key == 'disabled' then
        -- Special handling for disabled prop: children of disabled controls get "disabled" as well
        -- The library lies to external callers, but keeps the raw state private
        ugui.util.iterate_upwards(node, function(x)
            if x.props.disabled then
                value = true
                return true
            end
        end)
    end

    return value
end

---Sets a control property's value, only if uninitialized
---@param uid number A unique control identifier
---@param key string The property key
---@param value any The property's new value
ugui.init_prop = function(uid, key, value)
    local node = ugui.util.find(uid, root_node)
    if not node then
        return false
    end
    if type(node.props[key]) ~= 'nil' then
        return
    end
    node.props[key] = value
    ugui.send_message(node, {type = ugui.messages.prop_changed, key = key})
end

---Sets a control property's value
---@param uid number A unique control identifier
---@param key string The property key
---@param value any The property's new value
ugui.set_prop = function(uid, key, value)
    local node = ugui.util.find(uid, root_node)
    if not node then
        return false
    end
    node.props[key] = value
    ugui.send_message(node, {type = ugui.messages.prop_changed, key = key})
end

---Appends a child to a control
---The control will be clobbered
---@param parent_uid number|nil A unique control identifier of the parent, or nil if the control is the root control
---@param control table A control
ugui.add_child = function(parent_uid, control)
    -- Initialize default properties
    control.children = {}
    control.props = control.props and control.props or {}
    control.bounds = nil
    control.invalidated_visual = true
    control.parent_uid = parent_uid

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

    -- Standard props:
    -- hidden: bool - Node doesn't receive input or paint events.
    -- disabled: bool - Node doesn't receive input events.
    -- clickthrough: bool - Node isn't considered during hittesting and thus cant be clicked on, hovered, pushed, etc...
    -- padding: point - Space to add implicitly during control measurement
    ugui.init_prop(control.uid, 'padding', {x = 0, y = 0})

    for key, value in pairs(control.props) do
        ugui.send_message(control, {type = ugui.messages.prop_changed, key = key})
    end

    -- We also need to invalidate the parent completely
    ugui.invalidate_layout(parent_uid and parent_uid or control.uid)
    ugui.invalidate_visuals(parent_uid and parent_uid or control.uid)
end

---Sends a message to a node
---@param node table A node
---@param msg table A message
ugui.send_message = function(node, msg)
    ugui.default_message_handler(ugui, node, msg)

    -- Message interception: input events are dumped for disabled controls
    if msg.type == ugui.messages.mouse_enter
        or msg.type == ugui.messages.mouse_leave
        or msg.type == ugui.messages.mouse_move
        or msg.type == ugui.messages.lmb_down
        or msg.type == ugui.messages.lmb_up then
        if ugui.get_prop(node.uid, 'disabled') then
            -- FIXME: We assume input events have no return value, which should be fine?
            return nil
        end
    end

    -- If user-provided message handler exists, it takes priority and is called before the registry one
    local result = nil
    if node.props.process_message then
        result = node.props.process_message(ugui, node, msg)

        -- If no value is provided, we try with the registry one,
        -- since no value could mean either that messgae doesnt have a return value, or it just wasnt handled
        if not result then
            result = registry[node.type].message(ugui, node, msg)
        end
    else
        result = registry[node.type].message(ugui, node, msg)
    end

    -- Message interception: we add padding to measurements
    if msg.type == ugui.messages.measure then
        result.x = result.x + node.props.padding.x
        result.y = result.y + node.props.padding.y
    end

    return result
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

---Gets the current mouse position
ugui.get_mouse_position = function()
    return {x = curr_input.xmouse, y = curr_input.ymouse}
end

---Performs default message processing
---@param ugui table The related ugui context
---@param inst table The control instance
---@param msg table The message
function ugui.default_message_handler(ugui, inst, msg)
    if msg.type == ugui.messages.prop_changed then
        if msg.key == 'h_align' or msg.key == 'v_align' or msg.key == 'disabled' or msg.key == 'hidden' or msg.key == 'padding' then
            ugui.invalidate_layout(inst.uid)
            ugui.invalidate_visuals(inst.uid)
        end
    end
end

---Hooks emulator functions and begins operating
---@param params table The start parameters
---@param start function The function to be called upon starting
ugui.start = function(params, start)
    start_size = wgui.info()
    wgui.resize(start_size.width + params.width, start_size.height)

    start()

    emu.atdrawd2d(function()
        last_input = curr_input and ugui.util.deep_clone(curr_input) or input.get()
        curr_input = input.get()

        local mouse_point = {x = curr_input.xmouse, y = curr_input.ymouse}
        local last_mouse_point = {x = last_input.xmouse, y = last_input.ymouse}

        process_layout()
        process_dirty_rects()

        local node_at_mouse = ugui.internal.node_at_point(mouse_point, root_node)
        local node_at_last_mouse = ugui.internal.node_at_point(last_mouse_point, root_node)
        local node_at_lmb_down = ugui.internal.node_at_point(last_lmb_down_pos, root_node)

        if curr_input.leftclick and not last_input.leftclick then
            last_lmb_down_pos = {x = curr_input.xmouse, y = curr_input.ymouse}
        end


        -- WM_MOUSEMOVE
        if mouse_point.x ~= last_mouse_point.x or mouse_point.y ~= last_mouse_point.y then
            local capturing_node = ugui.util.find(mouse_capturing_uid, root_node)

            -- If we have a captured control, it gets special treatment
            if capturing_node then
                --  1. Send MouseMove unconditionall
                ugui.send_message(capturing_node, {type = ugui.messages.mouse_move})
                --  2. Send MouseEnter/Leave based solely off of its bounds
                if BreitbandGraphics.point_in_rect(mouse_point, capturing_node.bounds) and not BreitbandGraphics.point_in_rect(last_mouse_point, capturing_node.bounds) then
                    ugui.send_message(capturing_node, {type = ugui.messages.mouse_enter})
                end
                if not BreitbandGraphics.point_in_rect(mouse_point, capturing_node.bounds) and BreitbandGraphics.point_in_rect(last_mouse_point, capturing_node.bounds) then
                    ugui.send_message(capturing_node, {type = ugui.messages.mouse_leave})
                end
            else
                -- We have no captured control, so it's safe to regularly send MouseMove to the window under the mouse


                -- Going off-screen
                if not node_at_mouse and node_at_last_mouse then
                    ugui.send_message(node_at_last_mouse, {type = ugui.messages.mouse_leave})
                end

                -- Returning from off-screen
                if node_at_mouse and not node_at_last_mouse then
                    ugui.send_message(node_at_mouse, {type = ugui.messages.mouse_enter})
                end

                if node_at_mouse then
                    ugui.send_message(node_at_mouse, {type = ugui.messages.mouse_move})

                    if node_at_last_mouse then
                        if node_at_last_mouse.uid ~= node_at_mouse.uid then
                            ugui.send_message(node_at_mouse, {type = ugui.messages.mouse_enter})
                            ugui.send_message(node_at_last_mouse, {type = ugui.messages.mouse_leave})
                        end
                    end
                end
            end
        end

        -- WM_LBUTTONDOWN
        if curr_input.leftclick and not last_input.leftclick then
            if node_at_mouse then
                ugui.send_message(node_at_mouse, {type = ugui.messages.lmb_down})
            end
        end

        -- WM_LBUTTONUP
        if not curr_input.leftclick and last_input.leftclick then
            if node_at_lmb_down then
                ugui.send_message(node_at_lmb_down, {type = ugui.messages.lmb_up})

                -- If we release the mouse while outside of the captured control, we might be over another control by now
                -- That means it has to receive mouse_enter message
                if node_at_mouse and node_at_mouse.uid ~= node_at_lmb_down.uid then
                    ugui.send_message(node_at_mouse, {type = ugui.messages.mouse_enter})
                end
            end
        end
    end)

    emu.atstop(function()
        wgui.resize(wgui.info().width - params.width, wgui.info().height)
    end)
end

return ugui
