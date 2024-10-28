local group = {
    name = 'breitbandgraphics',
    tests = {},
}

group.tests[#group.tests + 1] = {
    name = 'draw_text_fit_calls_d2d_draw_text_with_correct_font_size',
    params = {
        {
            rectangle = {x = 244, y = 195, width = 137, height = 204},
            font_size = {12, 12, 12},

        },
        {
            rectangle = {x = 204, y = 212, width = 39, height = 266},
            font_size = {7.8, 5.92, 8.83},
        },
        {
            rectangle = {y = 144, x = 304, height = 9, width = 274},
            font_size = {7.2, 7.2, 7.2},
        },
    },
    func = function(ctx)
        local d2d_draw_text = d2d.draw_text


        local i = 1
        d2d.draw_text = function(rect_x,
            rect_y,
            rect_r,
            rect_b,
            text,
            font_name,
            font_size,
            d_weight,
            d_style,
            d_horizontal_alignment,
            d_vertical_alignment,
            d_options,
            brush)
            ctx.assert_eq(math.floor(ctx.data.font_size[i]), math.floor(font_size))
            i = i + 1
        end

        BreitbandGraphics.draw_text(ctx.data.rectangle, 'start', 'start', {fit = true}, BreitbandGraphics.colors.black, ugui.standard_styler.font_size, ugui.standard_styler.font_name, '(start, start)')
        BreitbandGraphics.draw_text(ctx.data.rectangle, 'center', 'center', {fit = true}, BreitbandGraphics.colors.black, ugui.standard_styler.font_size, ugui.standard_styler.font_name, '(center, center)')
        BreitbandGraphics.draw_text(ctx.data.rectangle, 'end', 'end', {fit = true}, BreitbandGraphics.colors.black, ugui.standard_styler.font_size, ugui.standard_styler.font_name, '(end, end)')

        d2d.draw_text = d2d_draw_text
    end,
}

return group
