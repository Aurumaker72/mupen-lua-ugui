local function compute_axis_data(ugui, inst, axis_hints, size_key, size_key_2)
    local sizes = {}

    -- In the first pass, treat all axis hints as "Auto" (-1)
    for _, value in pairs(axis_hints) do
        -- For Auto, we find the maximum width/height of all children
        local child_sizes = {}
        for _, child in pairs(inst.children) do
            child_sizes[#child_sizes + 1] = ugui.send_message(child, {type = ugui.messages.measure})
        end
        local max_child_size = math.max(table.unpack(ugui.util.select(child_sizes, function(t) return t[size_key] end)))
        sizes[#sizes + 1] = max_child_size
    end

    -- Normalize non-auto axis hints from {2, 2, 4} into {0.25, 0.25, 1}
    local max_hint = ugui.util.sum(ugui.util.select(axis_hints, function(n) return n == -1 and 0 or n end))
    for i, value in pairs(axis_hints) do
        if value ~= -1 then
            axis_hints[i] = (axis_hints[i] / max_hint)
        end
    end

    -- -1  = Auto
    -- >-1 = Use specified size
    for i, value in pairs(axis_hints) do
        if value ~= -1 then
            sizes[i] = value
        end
    end

    local origins = {}
    local sum = 0
    for i = 1, #sizes, 1 do
        origins[i] = sum
        sum = sum + sizes[i]
    end

    return {sizes = sizes, origins = origins}
end

return {
    type = 'grid',
    message = function(ugui, inst, msg)
        if msg.type == ugui.messages.create then
            ugui.init_prop(inst.uid, 'clickthrough', true)
            ugui.init_prop(inst.uid, 'cols', {})
            ugui.init_prop(inst.uid, 'rows', {})
        end
        if msg.type == ugui.messages.measure then
            local row_data = compute_axis_data(ugui, inst, ugui.util.deep_clone(ugui.get_prop(inst.uid, 'rows')), 'y', 'height')
            local col_data = compute_axis_data(ugui, inst, ugui.util.deep_clone(ugui.get_prop(inst.uid, 'cols')), 'x', 'width')

            print(col_data.sizes[#col_data.sizes - 1] * )
            return {
                x = col_data.origins[#col_data.origins - 1],
                y = row_data.origins[#row_data.origins - 1],
            }
        end
        if msg.type == ugui.messages.arrange then
            local row_data = compute_axis_data(ugui, inst, ugui.util.deep_clone(ugui.get_prop(inst.uid, 'rows')), 'y', 'height')
            local col_data = compute_axis_data(ugui, inst, ugui.util.deep_clone(ugui.get_prop(inst.uid, 'cols')), 'x', 'width')

            local bounds = {}
            for _, child in pairs(inst.children) do
                local col_index = ugui.get_prop(child.uid, 'col') or 1
                local row_index = ugui.get_prop(child.uid, 'row') or 1

                bounds[#bounds + 1] = {
                    x = col_data.origins[col_index],
                    y = row_data.origins[row_index],
                    width = col_data.sizes[col_index],
                    height = row_data.sizes[row_index],
                }
            end

            for _, value in pairs(bounds) do
                value.x = value.x + inst.bounds.x
                value.y = value.y + inst.bounds.y
            end

            return bounds
        end
    end,
}
