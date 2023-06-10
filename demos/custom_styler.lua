local function clamp(value, min, max)
    if value < min then
        return min
    end
    if value > max then
        return max
    end
    return value
end

local function remap(value, from1, to1, from2, to2)
    return (value - from1) / (to1 - from1) * (to2 - from2) + from2
end

local function draw_raised_frame(control, visual_state)
    local back_color = {
        r = 253,
        g = 253,
        b = 253
    }
    local border_color = {
        r = 208,
        g = 208,
        b = 208
    }
    if visual_state == Mupen_lua_ugui.visual_states.active then
        back_color = {
            r = 204,
            g = 228,
            b = 247
        }
        border_color = {
            r = 0,
            g = 84,
            b = 153
        }
    elseif visual_state == Mupen_lua_ugui.visual_states.hovered then
        back_color = {
            r = 229,
            g = 241,
            b = 251
        }
        border_color = {
            r = 0,
            g = 84,
            b = 153
        }
    elseif visual_state == Mupen_lua_ugui.visual_states.disabled then
        back_color = {
            r = 249,
            g = 249,
            b = 249
        }
        border_color = {
            r = 233,
            g = 233,
            b = 233
        }
    end
    Mupen_lua_ugui.renderer.fill_rounded_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, 1),
        border_color,
        {
            x = 4,
            y = 4
        })
    Mupen_lua_ugui.renderer.fill_rounded_rectangle(control.rectangle, back_color,
        {
            x = 4,
            y = 4
        })
end

function draw_button(control)
    local visual_state = Mupen_lua_ugui.get_visual_state(control)
    -- override for toggle_button
    if control.is_checked and control.is_enabled then
        visual_state = Mupen_lua_ugui.visual_states.active
    end

    draw_raised_frame(control, visual_state)
    local text_color = {
        r = 0,
        g = 0,
        b = 0
    }
    if visual_state == Mupen_lua_ugui.visual_states.disabled then
        text_color = {
            r = 160,
            g = 160,
            b = 160,
        }
    end
    Mupen_lua_ugui.renderer.draw_text(control.rectangle, 'center', 'center', text_color, 14,
        "Microsoft Sans Serif", control.text)
end

function draw_togglebutton(control)
    Mupen_lua_ugui.stylers.windows_10.draw_button(control)
end

function draw_textbox(control)
    local visual_state = Mupen_lua_ugui.get_visual_state(control)
    local back_color = {
        r = 255,
        g = 255,
        b = 255
    }
    local border_color = {
        r = 236,
        g = 236,
        b = 236
    }
    local text_color = {
        r = 0,
        g = 0,
        b = 0,
    }
    local highlight_color = {
        r = 131,
        g = 131,
        b = 131,
    }

    if Mupen_lua_ugui.active_control_uid == control.uid and control.is_enabled then
        visual_state = Mupen_lua_ugui.visual_states.active
    end
    if visual_state == Mupen_lua_ugui.visual_states.active then
        border_color = {
            r = 0,
            g = 84,
            b = 153
        }
        highlight_color = {
            r = 0,
            g = 103,
            b = 192
        }
    elseif visual_state == Mupen_lua_ugui.visual_states.disabled then
        back_color = {
            r = 240,
            g = 240,
            b = 240,
        }
        border_color = {
            r = 204,
            g = 204,
            b = 204,
        }
        text_color = {
            r = 109,
            g = 109,
            b = 109,
        }
    end

    Mupen_lua_ugui.renderer.fill_rounded_rectangle(BreitbandGraphics.inflate_rectangle({
            x = control.rectangle.x,
            y = control.rectangle.y,
            width = control.rectangle.width,
            height = control.rectangle.height - 1,
        }, 1),
        border_color,
        {
            x = 4,
            y = 4
        })
    Mupen_lua_ugui.renderer.fill_rounded_rectangle(control.rectangle, back_color,
        {
            x = 4,
            y = 4
        })
    Mupen_lua_ugui.renderer.draw_line({
        x = control.rectangle.x,
        y = control.rectangle.y + control.rectangle.height,
    }, {
        x = control.rectangle.x + control.rectangle.width,
        y = control.rectangle.y + control.rectangle.height,
    }, highlight_color, visual_state == Mupen_lua_ugui.visual_states.active and 2 or 0.5)

    Mupen_lua_ugui.renderer.draw_text(control.rectangle, 'start', 'start', text_color, 14,
        "Microsoft Sans Serif", control.text)
    local string_to_caret = control.text:sub(1, Mupen_lua_ugui.control_data[control.uid].caret_index - 1)
    local caret_x = Mupen_lua_ugui.renderer.get_text_size(string_to_caret, 14, "Microsoft Sans Serif").width
    if visual_state == Mupen_lua_ugui.visual_states.active then
        Mupen_lua_ugui.renderer.draw_line({
            x = control.rectangle.x + caret_x,
            y = control.rectangle.y + 2
        }, {
            x = control.rectangle.x + caret_x,
            y = control.rectangle.y +
                math.max(15,
                    Mupen_lua_ugui.renderer.get_text_size(string_to_caret, 14, "Microsoft Sans Serif")
                    .height) -- TODO: move text measurement into BreitbandGraphics
        }, {
            r = 0,
            g = 0,
            b = 0
        }, 1)
    end
end

function draw_joystick(control)
    draw_raised_frame(control, Mupen_lua_ugui.visual_states.normal)
    local visual_state = Mupen_lua_ugui.get_visual_state(control)
    local back_color = {
        r = 255,
        g = 255,
        b = 255
    }
    local outline_color = {
        r = 0,
        g = 0,
        b = 0
    }
    local tip_color = {
        r = 255,
        g = 0,
        b = 0
    }
    local line_color = {
        r = 0,
        g = 0,
        b = 255
    }
    if visual_state == Mupen_lua_ugui.visual_states.disabled then
        outline_color = {
            r = 191,
            g = 191,
            b = 191
        }
        tip_color = {
            r = 255,
            g = 128,
            b = 128
        }
        line_color = {
            r = 128,
            g = 128,
            b = 255
        }
    end
    local stick_position = {
        x = remap(control.position.x, 0, 1, control.rectangle.x,
            control.rectangle.x + control.rectangle.width),
        y = remap(control.position.y, 0, 1, control.rectangle.y,
            control.rectangle.y + control.rectangle.height)
    }
    Mupen_lua_ugui.renderer.fill_ellipse(control.rectangle, back_color)
    Mupen_lua_ugui.renderer.draw_ellipse(control.rectangle, outline_color, 1)
    Mupen_lua_ugui.renderer.draw_line({
        x = control.rectangle.x + control.rectangle.width / 2,
        y = control.rectangle.y,
    }, {
        x = control.rectangle.x + control.rectangle.width / 2,
        y = control.rectangle.y + control.rectangle.height
    }, outline_color, 1)
    Mupen_lua_ugui.renderer.draw_line({
        x = control.rectangle.x,
        y = control.rectangle.y + control.rectangle.height / 2,
    }, {
        x = control.rectangle.x + control.rectangle.width,
        y = control.rectangle.y + control.rectangle.height / 2,
    }, outline_color, 1)
    Mupen_lua_ugui.renderer.draw_line({
        x = control.rectangle.x + control.rectangle.width / 2,
        y = control.rectangle.y + control.rectangle.height / 2,
    }, {
        x = stick_position.x,
        y = stick_position.y,
    }, line_color, 3)
    local tip_size = 8
    Mupen_lua_ugui.renderer.fill_ellipse({
        x = stick_position.x - tip_size / 2,
        y = stick_position.y - tip_size / 2,
        width = tip_size,
        height = tip_size,
    }, tip_color)
end

function draw_trackbar(control)
    local visual_state = Mupen_lua_ugui.get_visual_state(control)
    local track_color = {
        r = 231,
        g = 234,
        b = 234
    }
    local track_border_color = {
        r = 214,
        g = 214,
        b = 214
    }
    local head_color = {
        r = 0,
        g = 122,
        b = 217
    }
    if Mupen_lua_ugui.active_control_uid == control.uid and control.is_enabled then
        visual_state = Mupen_lua_ugui.visual_states.active
    end
    if visual_state == Mupen_lua_ugui.visual_states.hovered then
        head_color = {
            r = 23,
            g = 23,
            b = 23,
        }
    elseif visual_state == Mupen_lua_ugui.visual_states.active then
        head_color = {
            r = 204,
            g = 204,
            b = 204,
        }
    elseif visual_state == Mupen_lua_ugui.visual_states.disabled then
        head_color = {
            r = 204,
            g = 204,
            b = 204,
        }
    end
    local is_horizontal = control.rectangle.width > control.rectangle.height
    local HEAD_WIDTH = 6
    local TRACK_THICKNESS = 2
    local HEAD_HEIGHT = (TRACK_THICKNESS + 2 * 2) * 3
    local track_rectangle = {}
    local head_rectangle = {}
    if not is_horizontal then
        track_rectangle = {
            x = control.rectangle.x + control.rectangle.width / 2 - TRACK_THICKNESS / 2,
            y = control.rectangle.y,
            width = TRACK_THICKNESS,
            height = control.rectangle.height
        }
        head_rectangle = {
            x = control.rectangle.x + control.rectangle.width / 2 - HEAD_HEIGHT / 2,
            y = control.rectangle.y + (control.value * control.rectangle.height) - HEAD_WIDTH / 2,
            width = HEAD_HEIGHT,
            height = HEAD_WIDTH
        }
    else
        track_rectangle = {
            x = control.rectangle.x,
            y = control.rectangle.y + control.rectangle.height / 2 - TRACK_THICKNESS / 2,
            width = control.rectangle.width,
            height = TRACK_THICKNESS
        }
        head_rectangle = {
            x = control.rectangle.x + (control.value * control.rectangle.width) - HEAD_WIDTH / 2,
            y = control.rectangle.y + control.rectangle.height / 2 - HEAD_HEIGHT / 2,
            width = HEAD_WIDTH,
            height = HEAD_HEIGHT
        }
    end
    Mupen_lua_ugui.renderer.fill_rectangle(BreitbandGraphics.inflate_rectangle(track_rectangle, 1),
        track_border_color)
    Mupen_lua_ugui.renderer.fill_rectangle(track_rectangle, track_color)
    Mupen_lua_ugui.renderer.fill_rectangle(head_rectangle, head_color)
end

function draw_combobox(control)
    local visual_state = Mupen_lua_ugui.get_visual_state(control)
    local text_color = {
        r = 0,
        g = 0,
        b = 0,
    }
    if Mupen_lua_ugui.control_data[control.uid].is_open and control.is_enabled then
        visual_state = Mupen_lua_ugui.visual_states.active
    end
    draw_raised_frame(control, visual_state)
    if visual_state == Mupen_lua_ugui.visual_states.disabled then
        text_color = {
            r = 109,
            g = 109,
            b = 109,
        }
    end
    Mupen_lua_ugui.renderer.draw_text({
            x = control.rectangle.x + 2,
            y = control.rectangle.y,
            width = control.rectangle.width,
            height = control.rectangle.height,
        }, 'start', 'center', text_color, 14, "Microsoft Sans Serif",
        control.items[control.selected_index])
    Mupen_lua_ugui.renderer.draw_text({
            x = control.rectangle.x,
            y = control.rectangle.y,
            width = control.rectangle.width - 8,
            height = control.rectangle.height,
        }, 'end', 'center', text_color, 14, "Segoe UI Mono",
        Mupen_lua_ugui.control_data[control.uid].is_open and "^" or "v")
    if Mupen_lua_ugui.control_data[control.uid].is_open then
        Mupen_lua_ugui.renderer.fill_rectangle(BreitbandGraphics.inflate_rectangle({
            x = control.rectangle.x,
            y = control.rectangle.y + control.rectangle.height,
            width = control.rectangle.width,
            height = #control.items * 20
        }, 1), {
            r = 0,
            g = 120,
            b = 215
        })
        for i = 1, #control.items, 1 do
            local rect = {
                x = control.rectangle.x,
                y = control.rectangle.y + control.rectangle.height + (20 * (i - 1)),
                width = control.rectangle.width,
                height = 20
            }
            local back_color = {
                r = 255,
                g = 255,
                b = 255
            }
            local text_color = {
                r = 0,
                g = 0,
                b = 0
            }
            if Mupen_lua_ugui.control_data[control.uid].hovered_index == i then
                back_color = {
                    r = 0,
                    g = 120,
                    b = 215
                }
                text_color = {
                    r = 255,
                    g = 255,
                    b = 255
                }
            end
            Mupen_lua_ugui.renderer.fill_rectangle(rect, back_color)
            rect.x = rect.x + 2
            Mupen_lua_ugui.renderer.draw_text(rect, 'start', 'center', text_color, 14,
                "Microsoft Sans Serif",
                control.items[i])
        end
    end
end

function draw_listbox(control)
    Mupen_lua_ugui.renderer.fill_rectangle(BreitbandGraphics.inflate_rectangle(control.rectangle, 1), {
        r = 130,
        g = 135,
        b = 144
    })
    Mupen_lua_ugui.renderer.fill_rectangle(control.rectangle, {
        r = 255,
        g = 255,
        b = 255
    })
    local visual_state = Mupen_lua_ugui.get_visual_state(control)
    -- item y position:
    -- y = (20 * (i - 1)) - (y_translation * ((20 * #control.items) - control.rectangle.height))
    local index_begin = (Mupen_lua_ugui.control_data[control.uid].y_translation *
        ((20 * #control.items) - control.rectangle.height)) / 20
    local index_end = (control.rectangle.height + (Mupen_lua_ugui.control_data[control.uid].y_translation *
        ((20 * #control.items) - control.rectangle.height))) / 20
    index_begin = math.max(index_begin, 0)
    index_end = math.min(index_end, #control.items)
    Mupen_lua_ugui.renderer.push_clip(control.rectangle)
    for i = math.floor(index_begin), math.ceil(index_end), 1 do
        local y = (20 * (i - 1)) -
            (Mupen_lua_ugui.control_data[control.uid].y_translation * ((20 * #control.items) - control.rectangle.height))
        local text_color = {
            r = 0,
            g = 0,
            b = 0,
        }
        -- TODO: add clipping support, as proper smooth scrolling is not achievable without clipping
        if control.selected_index == i then
            local accent_color = {
                r = 0,
                g = 120,
                b = 215
            }
            if visual_state == Mupen_lua_ugui.visual_states.disabled then
                accent_color = {
                    r = 204,
                    g = 204,
                    b = 204,
                }
            end
            Mupen_lua_ugui.renderer.fill_rectangle({
                x = control.rectangle.x,
                y = control.rectangle.y + y,
                width = control.rectangle.width,
                height = 20
            }, accent_color)
            text_color = {
                r = 255,
                g = 255,
                b = 255
            }
        end
        if visual_state == Mupen_lua_ugui.visual_states.disabled then
            text_color = {
                r = 160,
                g = 160,
                b = 160,
            }
        end
        Mupen_lua_ugui.renderer.draw_text({
                x = control.rectangle.x + 2,
                y = control.rectangle.y + y,
                width = control.rectangle.width,
                height = 20
            }, 'start', 'center', text_color, 14, "Microsoft Sans Serif",
            control.items[i])
    end
    if #control.items * 20 > control.rectangle.height then
        local scrollbar_y = Mupen_lua_ugui.control_data[control.uid].y_translation * control.rectangle
            .height
        local scrollbar_height = 2 * 20 * (control.rectangle.height / (20 * #control.items))
        -- we center the scrollbar around the translation value
        scrollbar_y = scrollbar_y - scrollbar_height / 2
        scrollbar_y = clamp(scrollbar_y, 0, control.rectangle.height - scrollbar_height)
        Mupen_lua_ugui.renderer.fill_rectangle({
            x = control.rectangle.x + control.rectangle.width - 10,
            y = control.rectangle.y,
            width = 10,
            height = control.rectangle.height
        }, {
            r = 240,
            g = 240,
            b = 240
        })
        Mupen_lua_ugui.renderer.fill_rectangle({
            x = control.rectangle.x + control.rectangle.width - 10,
            y = control.rectangle.y + scrollbar_y,
            width = 10,
            height = scrollbar_height
        }, {
            r = 204,
            g = 204,
            b = 204
        })
    end
    Mupen_lua_ugui.renderer.pop_clip()
end

local windows_11 = {
    draw_button = draw_button,
    draw_togglebutton = draw_togglebutton,
    draw_textbox = draw_textbox,
    draw_joystick = draw_joystick,
    draw_trackbar = draw_trackbar,
    draw_combobox = draw_combobox,
    draw_listbox = draw_listbox,
}

function folder(thisFileName)
    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder('demos\\custom_styler.lua') .. 'mupen-lua-ugui.lua')

local initial_size = wgui.info()
wgui.resize(initial_size.width + 250, initial_size.height)

emu.atupdatescreen(function()
    BreitbandGraphics.renderers.d2d.fill_rectangle({
        x = initial_size.width,
        y = 0,
        width = 250,
        height = initial_size.height
    }, {
        r = 253,
        g = 253,
        b = 253
    })

    local keys = input.get()

    Mupen_lua_ugui.begin_frame(BreitbandGraphics.renderers.d2d, windows_11, {
        pointer = {
            position = {
                x = keys.xmouse,
                y = keys.ymouse,
            },
            is_primary_down = keys.leftclick
        },
        keyboard = {
            held_keys = keys
        }
    })

    Mupen_lua_ugui.button({
        uid = 0,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 10,
            width = 90,
            height = 30,
        },
        text = "Test"
    })

    if (Mupen_lua_ugui.button({
            uid = 1,
            is_enabled = false,
            rectangle = {
                x = initial_size.width + 10 + 100,
                y = 10,
                width = 90,
                height = 30,
            },
            text = "Test"
        })) then
        print('a')
    end

    Mupen_lua_ugui.textbox({
        uid = 2,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 50,
            width = 90,
            height = 30,
        },
        text = "Test"
    })

    Mupen_lua_ugui.textbox({
        uid = 3,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 10 + 100,
            y = 50,
            width = 90,
            height = 30,
        },
        text = "Test"
    })

    Mupen_lua_ugui.combobox({
        uid = 4,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 90,
            width = 90,
            height = 30,
        },
        items = {
            "Test"
        },
        selected_index = 1,
    })

    Mupen_lua_ugui.combobox({
        uid = 5,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 10 + 100,
            y = 90,
            width = 90,
            height = 30,
        },
        items = {
            "Test"
        },
        selected_index = 1,
    })

    Mupen_lua_ugui.trackbar({
        uid = 6,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 130,
            width = 90,
            height = 30,
        },
        value = 0
    })

    Mupen_lua_ugui.trackbar({
        uid = 7,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 10 + 100,
            y = 130,
            width = 90,
            height = 30,
        },
        value = 0
    })


    Mupen_lua_ugui.listbox({
        uid = 8,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 170,
            width = 90,
            height = 30,
        },
        selected_index = 1,
        items = {
            "Test",
            "Item"
        }
    })

    Mupen_lua_ugui.listbox({
        uid = 9,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 10 + 100,
            y = 170,
            width = 90,
            height = 30,
        },
        selected_index = 1,
        items = {
            "Test",
            "Item"
        }
    })

    Mupen_lua_ugui.joystick({
        uid = 10,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 10,
            y = 210,
            width = 90,
            height = 90,
        },
        position = {
            x = 0,
            y = 0.5,
        }
    })

    Mupen_lua_ugui.joystick({
        uid = 11,
        is_enabled = false,
        rectangle = {
            x = initial_size.width + 10 + 100,
            y = 210,
            width = 90,
            height = 90,
        },
        position = {
            x = 1,
            y = 0.5,
        }
    })


    Mupen_lua_ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
