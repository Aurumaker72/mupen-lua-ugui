return {
    type = 'label',
    message = function(ugui, inst, msg)
        if msg.type == ugui.messages.create then
            ugui.set_prop(inst.uid, "text", "Hello World!")
        end
        if msg.type == ugui.messages.measure then
            local size = BreitbandGraphics.get_text_size(ugui.get_prop(inst.uid, "text"), 11, 'Calibri')
            return {x = size.width, y = size.height}
        end
        if msg.type == ugui.messages.paint then
            BreitbandGraphics.draw_text(msg.rect, 'center', 'center', {}, BreitbandGraphics.colors.white, 11, 'Calibri', ugui.get_prop(inst.uid, "text"))
        end
    end,
}
