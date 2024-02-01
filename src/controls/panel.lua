return {
    type = "panel",
    message = function (inst, msg)
        if msg.type == messages.measure then
            
        end
        if msg.type == messages.paint then
            BreitbandGraphics.fill_rectangle(msg.rect, BreitbandGraphics.colors.red)
        end
    end
}