return {
    type = 'stackpanel',
    message = function(ugui, inst, msg)
        if msg.type == ugui.messages.create then
            ugui.init_prop(inst.uid, 'clickthrough', true)
            ugui.init_prop(inst.uid, 'horizontal', false)
        end
        if msg.type == ugui.messages.measure then
            if #inst.children == 0 then
                return {x = 0, y = 0}
            end

            local child_sizes = {}
            for _, child in pairs(inst.children) do
                child_sizes[#child_sizes + 1] = ugui.send_message(child, {type = ugui.messages.measure})
            end

            local widths = ugui.util.select(child_sizes, function(t) return t.x end)
            local heights = ugui.util.select(child_sizes, function(t) return t.y end)

            if ugui.get_prop(inst.uid, 'horizontal') then
                return {
                    x = ugui.util.reduce(widths, function(x, y) return x + y end, 0),
                    y = math.max(table.unpack(heights)),
                }
            else
                return {
                    x = math.max(table.unpack(widths)),
                    y = ugui.util.reduce(heights, function(x, y) return x + y end, 0),
                }
            end
        end
        if msg.type == ugui.messages.arrange then
            local bounds = {}
            local size_accumulator = 0
            if ugui.get_prop(inst.uid, 'horizontal') then
                for _, child in pairs(inst.children) do
                    local child_width = ugui.send_message(child, {type = ugui.messages.measure}).x
                    local item_rect = {
                        x = inst.bounds.x + size_accumulator,
                        y = inst.bounds.y,
                        width = child_width,
                        height = inst.bounds.height,
                    }
                    bounds[#bounds + 1] = item_rect
                    size_accumulator = size_accumulator + child_width
                end
            else
                for _, child in pairs(inst.children) do
                    local child_height = ugui.send_message(child, {type = ugui.messages.measure}).y
                    local item_rect = {
                        x = inst.bounds.x,
                        y = inst.bounds.y + size_accumulator,
                        width = inst.bounds.width,
                        height = child_height,
                    }
                    bounds[#bounds + 1] = item_rect
                    size_accumulator = size_accumulator + child_height
                end
            end

            return bounds
        end
    end,
}