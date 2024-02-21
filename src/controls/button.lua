local states = {
    normal = 1,
    hover = 2,
    active = 3,
    disabled = 0,
}
local raised_frame_back_colors = {
    [1] = BreitbandGraphics.hex_to_color('#E1E1E1'),
    [2] = BreitbandGraphics.hex_to_color('#E5F1FB'),
    [3] = BreitbandGraphics.hex_to_color('#CCE4F7'),
    [0] = BreitbandGraphics.hex_to_color('#CCCCCC'),
}
local raised_frame_border_colors = {
    [1] = BreitbandGraphics.hex_to_color('#ADADAD'),
    [2] = BreitbandGraphics.hex_to_color('#0078D7'),
    [3] = BreitbandGraphics.hex_to_color('#005499'),
    [0] = BreitbandGraphics.hex_to_color('#BFBFBF'),
}

return {
    type = 'button',
    message = function(ugui, inst, msg)
        if msg.type == ugui.messages.create then
            ugui.init_prop(inst.uid, 'state', states.normal)
            ugui.init_prop(inst.uid, 'padding', {x = 10, y = 6})
        end
        if msg.type == ugui.messages.measure then
            return ugui.util.measure_by_child(ugui, inst)
        end
        if msg.type == ugui.messages.prop_changed then
            if msg.key == 'state' then
                ugui.invalidate_visuals(inst.uid)
            end
        end
        if msg.type == ugui.messages.paint then
            local state = ugui.get_prop(inst.uid, 'state')
            BreitbandGraphics.fill_rectangle(msg.rect, raised_frame_border_colors[state])
            BreitbandGraphics.fill_rectangle(BreitbandGraphics.inflate_rectangle(msg.rect, -1), raised_frame_back_colors[state])
        end
        if msg.type == ugui.messages.mouse_enter then
            ugui.set_prop(inst.uid, 'state', states.hover)
        end
        if msg.type == ugui.messages.mouse_leave then
            ugui.set_prop(inst.uid, 'state', states.normal)
        end
    end,
}
