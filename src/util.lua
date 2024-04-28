local util = {
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

    ---Picks all items in the collection via the predicate
    ---@param collection table
    ---@param predicate function A function which takes a collection element as a parameter and returns whether it should be included in the final collection. This function should be pure in regards to the parameter.
    ---@return table table A collection of the included items
    where = function(collection, predicate)
        local t = {}
        for i = 1, #collection, 1 do
            if predicate(collection[i]) then
                t[#t + 1] = collection[i]
            end
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

    ---Logs a string to the output console
    ---@param text string The string to log
    log = function(text)
    end,

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
}

---Paints the bounding boxes of a node's children
---@param root table A node
util.paint_bounding_boxes = function(root)
    util.iterate(root, function(node)
        BreitbandGraphics.draw_rectangle(BreitbandGraphics.inflate_rectangle(node.bounds, -1), BreitbandGraphics.colors.red, 0.1)
    end)
end

---Sums an array of numbers
---@param list number[] An array of numbers
function util.sum(list)
    return util.reduce(list, function(x, y) return x + y end, 0)
end


---Traverses all nodes above a node in bottom-up order
---@param ugui table The related ugui context
---@param node table The node to begin the iteration from
---@param predicate function A function which accepts a node
function util.iterate_upwards(ugui, node, predicate)
    local function iterate_upwards_impl(x, predicate)
        if predicate(x) then
            return
        end
        local parent = util.find(x.parent_uid, ugui.get_root_node())
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
function util.is_child_of(node, child_uid)
    local child = util.find(child_uid, node)
    return child ~= nil
end

---Gets a node's children
---@param ugui table The related ugui context
---@param uid number A unique control identifier
function util.get_child_uids(ugui, uid)
    local node = util.find(uid, ugui.get_root_node())
    return util.select(node.children, function(x)
        return x.uid
    end)
end

if false then
    util.log = print
end

return util
