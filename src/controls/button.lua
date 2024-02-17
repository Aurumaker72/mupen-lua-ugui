return {
    type = 'button',
    message = function(ugui, inst, msg)
        if msg.type == ugui.messages.create then
            ugui.init_prop(inst.uid, 'state', 0)
        end
        if msg.type == ugui.messages.measure then
            return ugui.util.measure_by_child(ugui, inst)
        end
        if msg.type == ugui.messages.paint then
            BreitbandGraphics.draw_rectangle(msg.rect, BreitbandGraphics.colors.red, 1)
        end
        if msg.type == ugui.messages.mouse_enter then
            
        end
        if msg.type == ugui.messages.mouse_leave then
            print('leave')

        end
    end,
}
