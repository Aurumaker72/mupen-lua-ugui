return {
    type = 'stackpanel',
    message = function(ugui, inst, msg)
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

            return {
                x = math.max(table.unpack(widths)),
                y = ugui.util.reduce(heights, function(x, y) return x + y end, 0),
            }
        end
        if msg.type == ugui.messages.get_base_child_bounds then
            local bounds = {}
            local current_height = 0
            for _, child in pairs(inst.children) do
                local child_height = ugui.send_message(child, {type = ugui.messages.measure}).y
                local item_rect = {
                    x = inst.bounds.x,
                    y = inst.bounds.y + current_height,
                    width = inst.bounds.width,
                    height = child_height,
                }
                bounds[#bounds + 1] = item_rect
                current_height = current_height + child_height
            end
            return bounds
        end

        return ugui.get_registered_template('panel').message(ugui, inst, msg)
    end,
}
