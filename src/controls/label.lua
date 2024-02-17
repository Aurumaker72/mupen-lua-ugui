return {
    type = 'label',
    message = function(ugui, inst, msg)
        if msg.type == ugui.messages.create then
            ugui.init_prop(inst.uid, 'hittest', false)
            ugui.init_prop(inst.uid, 'text', 'Hello World!')
            ugui.init_prop(inst.uid, 'font', 'Calibri')
            ugui.init_prop(inst.uid, 'color', BreitbandGraphics.hex_to_color('#000000'))
            ugui.init_prop(inst.uid, 'size', 11)
            ugui.init_prop(inst.uid, 'text_h_align', 'center')
            ugui.init_prop(inst.uid, 'text_v_align', 'center')
        end
        if msg.type == ugui.messages.measure then
            local size = BreitbandGraphics.get_text_size(ugui.get_prop(inst.uid, 'text'), ugui.get_prop(inst.uid, 'size'), ugui.get_prop(inst.uid, 'font'))
            return {x = size.width + 1, y = size.height + 1}
        end
        if msg.type == ugui.messages.paint then
            BreitbandGraphics.draw_text(
                msg.rect,
                ugui.get_prop(inst.uid, 'text_h_align'),
                ugui.get_prop(inst.uid, 'text_v_align'),
                {},
                ugui.get_prop(inst.uid, 'color'),
                ugui.get_prop(inst.uid, 'size'),
                ugui.get_prop(inst.uid, 'font'),
                ugui.get_prop(inst.uid, 'text'))
        end
    end,
}
