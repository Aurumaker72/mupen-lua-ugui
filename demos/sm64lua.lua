function folder(thisFileName)
    local str = debug.getinfo(2, "S").source:sub(2)
    return (str:match("^.*/(.*).lua$") or str):sub(1, -(thisFileName):len() - 1)
end

dofile(folder("demos\\sm64lua.lua") .. "mupen-lua-ugui.lua")

Mupen_lua_ugui.spinner = function(control)
    local width = 15
    local value = control.value

    value = math.min(value, control.maximum_value)
    value = math.max(value, control.minimum_value)

    local new_text = Mupen_lua_ugui.textbox({
        uid = control.uid,
        is_enabled = true,
        rectangle = {
            x = control.rectangle.x,
            y = control.rectangle.y,
            width = control.rectangle.width - width * 2,
            height = control.rectangle.height,
        },
        text = tostring(value),
    })

    if tonumber(new_text) then
        value = tonumber(new_text)
    end

    if control.is_horizontal then
        if (Mupen_lua_ugui.button({
                uid = control.uid + 1,
                is_enabled = not (value == control.minimum_value),
                rectangle = {
                    x = control.rectangle.x + control.rectangle.width - width * 2,
                    y = control.rectangle.y,
                    width = width,
                    height = control.rectangle.height,
                },
                text = "-",
            }))
        then
            value = value - 1
        end

        if (Mupen_lua_ugui.button({
                uid = control.uid + 1,
                is_enabled = not (value == control.maximum_value),
                rectangle = {
                    x = control.rectangle.x + control.rectangle.width - width,
                    y = control.rectangle.y,
                    width = width,
                    height = control.rectangle.height,
                },
                text = "+",
            }))
        then
            value = value + 1
        end
    else
        if (Mupen_lua_ugui.button({
                uid = control.uid + 1,
                is_enabled = not (value == control.maximum_value),
                rectangle = {
                    x = control.rectangle.x + control.rectangle.width - width * 2,
                    y = control.rectangle.y,
                    width = width * 2,
                    height = control.rectangle.height / 2,
                },
                text = "+",
            }))
        then
            value = value + 1
        end

        if (Mupen_lua_ugui.button({
                uid = control.uid + 1,
                is_enabled = not (value == control.minimum_value),
                rectangle = {
                    x = control.rectangle.x + control.rectangle.width - width * 2,
                    y = control.rectangle.y + control.rectangle.height / 2,
                    width = width * 2,
                    height = control.rectangle.height / 2,
                },
                text = "-",
            }))
        then
            value = value - 1
        end
    end

    return value
end

local initial_size = wgui.info()
wgui.resize(initial_size.width + 200, initial_size.height)


emu.atupdatescreen(function()
    BreitbandGraphics.renderers.d2d.fill_rectangle({
        x = initial_size.width,
        y = 0,
        width = 200,
        height = initial_size.height,
    }, {
        r = 253,
        g = 253,
        b = 253,
    })

    local keys = input.get()

    Mupen_lua_ugui.begin_frame(BreitbandGraphics.renderers.d2d, Mupen_lua_ugui.stylers.windows_10, {
        pointer = {
            position = {
                x = keys.xmouse,
                y = keys.ymouse,
            },
            is_primary_down = keys.leftclick,
        },
        keyboard = {
            held_keys = keys,
        },
    })

    Mupen_lua_ugui.toggle_button({
        uid = 0,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 0,
            width = 100,
            height = 25,
        },
        text = "Disabled",
    })
    Mupen_lua_ugui.toggle_button({
        uid = 1,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 30,
            width = 100,
            height = 25,
        },
        text = "Match Yaw",
    })
    Mupen_lua_ugui.toggle_button({
        uid = 2,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 60,
            width = 100,
            height = 25,
        },
        text = "Reverse Angle",
    })
    Mupen_lua_ugui.toggle_button({
        uid = 3,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 90,
            width = 100,
            height = 25,
        },
        text = "Match Angle",
    })
    Mupen_lua_ugui.toggle_button({
        uid = 4,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 105,
            y = 0,
            width = 60,
            height = 25,
        },
        text = "Always",
    })
    Mupen_lua_ugui.toggle_button({
        uid = 5,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 165,
            y = 0,
            width = 30,
            height = 25,
        },
        text = ".99",
    })
    Mupen_lua_ugui.toggle_button({
        uid = 6,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 105,
            y = 30,
            width = 45,
            height = 25,
        },
        text = "Left",
    })
    Mupen_lua_ugui.toggle_button({
        uid = 7,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 150,
            y = 30,
            width = 45,
            height = 25,
        },
        text = "Right",
    })


    Mupen_lua_ugui.toggle_button({
        uid = 8,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 105,
            y = 60,
            width = 45,
            height = 25,
        },
        text = "DYaw",
    })
    Mupen_lua_ugui.toggle_button({
        uid = 9,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 150,
            y = 60,
            width = 45,
            height = 25,
        },
        text = "Swim",
    })

    Mupen_lua_ugui.textbox({
        uid = 10,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 105,
            y = 90,
            width = 90,
            height = 25,
        },
        text = "000000",
    })

    Mupen_lua_ugui.joystick({
        uid = 11,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 120,
            width = 100,
            height = 100,
        },
        position = {
            x = 0.5,
            y = 0.5,
        },
    })

    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width + 105,
        y = 120,
        width = 100,
        height = 20,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "Magnitude")

    Mupen_lua_ugui.spinner({
        uid = 12,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 105,
            y = 140,
            width = 90,
            height = 25,
        },
        value = 0,
        is_horizontal = false,
        minimum_value = 0,
        maximum_value = 128,
    })

    Mupen_lua_ugui.button({
        uid = 13,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 105,
            y = 170,
            width = 90,
            height = 25,
        },
        text = "Speedkick",
    })

    Mupen_lua_ugui.toggle_button({
        uid = 14,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 105,
            y = 200,
            width = 45,
            height = 20,
        },
        text = "High",
    })
    Mupen_lua_ugui.toggle_button({
        uid = 15,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 150,
            y = 200,
            width = 45,
            height = 20,
        },
        text = "Reset",
    })

    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 220,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "Yaw Facing: EXAMPLE (EXAMPLE2)")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 235,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "Yaw Intended: EXAMPLE (EXAMPLE2)")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 250,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "H Speed: EXAMPLE")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 265,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "H Sliding Speed: EXAMPLE")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 280,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "XZ Movement: EXAMPLE")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 295,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "Speed Efficiency: EXAMPLE")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 310,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "Y Speed: EXAMPLE")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 325,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "Mario X: EXAMPLE")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 340,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "Mario Y: EXAMPLE")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 355,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "Mario Z: EXAMPLE")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 370,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "Read-only: EXAMPLE")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 385,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "RNG Value: EXAMPLE")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 400,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "RNG Index: EXAMPLE")
    BreitbandGraphics.renderers.d2d.draw_text({
        x = initial_size.width,
        y = 415,
        width = 99999,
        height = 15,
    }, "start", "start", {}, BreitbandGraphics.colors.black, 11, "MS Sans Serif", "Moved Distance: EXAMPLE")

    Mupen_lua_ugui.toggle_button({
        uid = 17,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 430,
            width = 100,
            height = 25,
        },
        text = "Record Ghost",
    })

    Mupen_lua_ugui.button({
        uid = 18,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 460,
            width = 100,
            height = 25,
        },
        text = "Apply RNG",
    })

    Mupen_lua_ugui.toggle_button({
        uid = 19,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 100,
            y = 460,
            width = 15,
            height = 25,
        },
        text = "V",
    })

    Mupen_lua_ugui.toggle_button({
        uid = 20,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 115,
            y = 460,
            width = 15,
            height = 25,
        },
        text = "I",
    })

    Mupen_lua_ugui.textbox({
        uid = 21,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 130,
            y = 460,
            width = 70,
            height = 25,
        },
        text = "EXAMPLE",
    })

    Mupen_lua_ugui.toggle_button({
        uid = 21,
        is_enabled = true,
        rectangle = {
            x = initial_size.width,
            y = 490,
            width = 140,
            height = 25,
        },
        text = "Measure distance moved",
    })
    Mupen_lua_ugui.toggle_button({
        uid = 22,
        is_enabled = true,
        rectangle = {
            x = initial_size.width + 140,
            y = 490,
            width = 60,
            height = 25,
        },
        text = "Ignore Y",
    })
    Mupen_lua_ugui.end_frame()
end)

emu.atstop(function()
    wgui.resize(initial_size.width, initial_size.height)
end)
