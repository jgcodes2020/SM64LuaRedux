local function draw_square_button(uid, key, text, rect, color)
    ugui.toggle_button({
        uid = uid,
        rectangle = rect,
        text = text,
        is_checked = Joypad.input[key]
    })
end
local function draw_circle_button(uid, key, text, rect, color)
    ugui.toggle_button({
        uid = uid,
        rectangle = rect,
        text = text,
        is_checked = Joypad.input[key]
    })
end


local function draw_field(rect, text, scale)
    BreitbandGraphics.draw_text(rect, "start", "center",
        { aliased = Presets.styles[Settings.active_style_index].theme.pixelated_text },
        BreitbandGraphics.invert_color(Presets.styles[Settings.active_style_index].theme.background_color),
        Presets.styles[Settings.active_style_index].theme.font_size * Drawing.scale * scale,
        Presets.styles[Settings.active_style_index].theme.font_name,
        text)
end

return {
    name = "Timer 2",
    draw = function()
        local x_offset = 0.5

        ugui.joystick({
            uid = 30,
            rectangle = grid_rect(x_offset, 0, 4, 4),
            position = {
                x = ugui.internal.remap(Joypad.input.X, -128, 128, 0, 1),
                y = ugui.internal.remap(-Joypad.input.Y, -128, 128, 0, 1),
            },
            mag = 0
        })
        BreitbandGraphics.draw_text(grid_rect(4 + x_offset, 0.5, 4 - x_offset, 1), "center", "center",
            { aliased = Presets.styles[Settings.active_style_index].theme.pixelated_text },
            BreitbandGraphics.invert_color(Presets.styles[Settings.active_style_index].theme.background_color),
            Presets.styles[Settings.active_style_index].theme.font_size * Drawing.scale * 2,
            "Consolas",
            "X: " .. Joypad.input.X)
        BreitbandGraphics.draw_text(grid_rect(4 + x_offset, 1.5, 4 - x_offset, 1), "center", "center",
            { aliased = Presets.styles[Settings.active_style_index].theme.pixelated_text },
            BreitbandGraphics.invert_color(Presets.styles[Settings.active_style_index].theme.background_color),
            Presets.styles[Settings.active_style_index].theme.font_size * Drawing.scale * 2,
            "Consolas",
            "Y: " .. Joypad.input.Y)
            BreitbandGraphics.draw_text(grid_rect(4 + x_offset, 2.5, 4 - x_offset, 1), "center", "center",
            { aliased = Presets.styles[Settings.active_style_index].theme.pixelated_text },
            BreitbandGraphics.invert_color(Presets.styles[Settings.active_style_index].theme.background_color),
            Presets.styles[Settings.active_style_index].theme.font_size * Drawing.scale * 2,
            "Consolas",
            Timer.get_frame_text())

        draw_square_button(40, "L", "L", grid_rect(1 + x_offset, 4, 3, 1), BreitbandGraphics.hex_to_color("#DDDDDD"))
        draw_square_button(45, "R", "R", grid_rect(4 + x_offset, 4, 3, 1), BreitbandGraphics.hex_to_color("#DDDDDD"))
        draw_square_button(50, "Z", "Z", grid_rect(0 + x_offset, 5, 1, 3), BreitbandGraphics.hex_to_color("#DDDDDD"))
        draw_square_button(55, "S", "S", grid_rect(1 + x_offset, 6 + 0.5, 1, 1),
            BreitbandGraphics.hex_to_color("#EE1C24"))
        draw_square_button(60, "B", "B", grid_rect(2 + x_offset, 5 + 0.5, 1, 1),
            BreitbandGraphics.hex_to_color("#009245"))
        draw_square_button(65, "A", "A", grid_rect(3 + x_offset, 6 + 0.5, 1, 1),
            BreitbandGraphics.hex_to_color("#3366CC"))
        draw_square_button(70, "Cleft", "<", grid_rect(4 + x_offset, 6, 1, 1), BreitbandGraphics.hex_to_color("#FFFF00"))
        draw_square_button(75, "Cup", "^", grid_rect(5 + x_offset, 5, 1, 1), BreitbandGraphics.hex_to_color("#FFFF00"))
        draw_square_button(80, "Cright", ">", grid_rect(6 + x_offset, 6, 1, 1), BreitbandGraphics.hex_to_color("#FFFF00"))
        draw_square_button(85, "Cdown", "v", grid_rect(5 + x_offset, 7, 1, 1), BreitbandGraphics.hex_to_color("#FFFF00"))

        draw_field(grid_rect(x_offset, 8, 16, 0.5), string.format("Frame %s", Timer.get_frames()), 1)

        draw_field(grid_rect(x_offset, 8.75, 16, 0.5), VarWatch_compute_value("yaw_facing"),
            1.25)
        draw_field(grid_rect(x_offset, 9.25, 16, 0.5),
            VarWatch_compute_value("yaw_intended"), 1)

        draw_field(grid_rect(x_offset, 10, 16, 0.5), VarWatch_compute_value("h_spd"), 1.25)
        draw_field(grid_rect(x_offset, 10.5, 16, 0.5),
            string.format("H Sliding Spd: %s",
                Formatter.ups(Engine.GetHSlidingSpeed())), 1)
        draw_field(grid_rect(x_offset, 11, 16, 0.5),
            string.format("XZ Movement: %s", Memory.current.mario_intended_yaw), 1)


        draw_field(grid_rect(x_offset, 11.75, 16, 0.5), VarWatch_compute_value("v_spd"), 1.25)
        draw_field(grid_rect(x_offset, 12.25, 16, 0.5), VarWatch_compute_value("position_x"), 1)
        draw_field(grid_rect(x_offset, 12.75, 16, 0.5), VarWatch_compute_value("position_y"), 1)
        draw_field(grid_rect(x_offset, 13.25, 16, 0.5), VarWatch_compute_value("position_z"), 1)
        draw_field(grid_rect(x_offset, 14, 16, 0.5), VarWatch_compute_value("action"), 1.25)
    end
}
