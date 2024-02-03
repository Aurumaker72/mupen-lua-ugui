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
        if msg.type == ugui.messages.position_children then
            local bounds = {}
            local current_height = 0
            for _, child in pairs(inst.children) do
                local child_height = ugui.send_message(child, {type = ugui.messages.measure}).y
                bounds[#bounds + 1] = {
                    x = child.bounds.x,
                    y = child.bounds.y + current_height,
                    width = child.bounds.width,
                    height = child_height,
                }
                current_height = current_height + child_height
            end
            return bounds
        end
        if msg.type == ugui.messages.paint then

        end
    end,
}
