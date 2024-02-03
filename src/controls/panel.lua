return {
    type = 'panel',
    message = function(ugui, inst, msg)
        if msg.type == ugui.messages.measure then
            -- Size of panel is equal to that of only child
            assert(#inst.children <= 1)
            return ugui.message(inst.children[1].uid, {
                type = ugui.messages.measure,
            })
        end
        if msg.type == ugui.messages.paint then
        end
    end,
}
