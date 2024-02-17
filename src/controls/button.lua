return {
    type = 'button',
    message = function(ugui, inst, msg)
        if msg.type == ugui.messages.measure then
            return ugui.util.measure_by_child(ugui, inst)
        end
        if msg.type == ugui.messages.paint then
            
        end
    end,
}
