return {
    type = "label",
    message = function (inst, msg)
        if msg.type == messages.measure then
            return BreitbandGraphics.get_text_size(inst.text, 11, "Calibri")
        end
        if msg.type == messages.paint then
            BreitbandGraphics.draw_text(msg.rect, "center", "center", {}, BreitbandGraphics.colors.black, 11, "Calibri", inst.text)
        end
    end
}