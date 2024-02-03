return {
    type = 'button',
    message = function(ugui, inst, msg)
        if msg.type == ugui.messages.measure then
            return ugui.send_message(inst.children[1], {
                type = ugui.messages.measure,
            })
        end
        if msg.type == ugui.messages.paint then
        end
    end,
}
