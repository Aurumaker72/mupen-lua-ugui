return {
    type = 'panel',
    message = function(ugui, inst, msg)
        if msg.type == ugui.messages.create then
            ugui.init_prop(inst.uid, 'color', BreitbandGraphics.hex_to_color('#F0F0F0'))
        end
        if msg.type == ugui.messages.measure then
            return ugui.util.measure_by_child(ugui, inst)
        end
        if msg.type == ugui.messages.paint then
            BreitbandGraphics.fill_rectangle(msg.rect, ugui.get_prop(inst.uid, 'color'))
        end
    end,
}