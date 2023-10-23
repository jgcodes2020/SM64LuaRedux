function grid(x, y, x_span, y_span)
    if not x_span then
        x_span = 1
    end
    if not y_span then
        y_span = 1
    end

    local base_x = Drawing.initial_size.width + (Settings.grid_size * x)
    local base_y = (Settings.grid_size * y)

    local rect = {
        base_x + Settings.grid_gap,
        base_y + Settings.grid_gap,
        (Settings.grid_size * x_span) - Settings.grid_gap * 2,
        (Settings.grid_size * y_span) - Settings.grid_gap * 2,
    }

    if Drawing.scale > 1 + Drawing.scale_tolerance then
        -- scaling up, we space everything out but keep dimensions
        rect[2] = rect[2] * Drawing.scale
    end
    if Drawing.scale < 1 - Drawing.scale_tolerance then
        -- scaling down, we squish and compress everything
        -- TODO: fix this random crap
        -- local expanded = Drawing.size.width - Drawing.initial_size.width
        -- local scaled = expanded / Drawing.scale
        -- local halved = scaled / 2
        -- rect[1] = (rect[1] * Drawing.scale) + halved
        -- rect[1] = Drawing.initial_size.width + (Settings.grid_size * x)
        rect[1] = (Drawing.initial_size.width + (Settings.grid_size * x * Drawing.scale)) + Settings.grid_gap
        rect[2] = rect[2] * Drawing.scale
        rect[3] = rect[3] * Drawing.scale
        rect[4] = rect[4] * Drawing.scale
    end

    return { math.floor(rect[1]), math.floor(rect[2]), math.floor(rect[3]), math.floor(rect[4]) }
end

function grid_rect(x, y, x_span, y_span)
    local value = grid(x, y, x_span, y_span)
    return {
        x = value[1],
        y = value[2],
        width = value[3],
        height = value[4],
    }
end

local pow = math.pow

Buttons = {
    {
        name = "arcotan strain",
        text = "Atan Strain",
        box = function()
            return grid(4, 2, 3, 1)
        end,
        pressed = function()
            return Settings.atan_strain
        end,
        onclick = function(self)
            Settings.atan_strain = not Settings.atan_strain

            if Settings.atan_strain then
                Memory.update()
                Settings.atan_start = Memory.current.mario_global_timer
            end
        end
    },
    {
        name = "reverse arcotan strain",
        text = "I",
        box = function()
            return grid(7, 2, 1, 1)
        end,
        pressed = function()
            return Settings.reverse_arc
        end,
        onclick = function(self)
            Settings.reverse_arc = not Settings.reverse_arc
        end
    },
    {
        name = "increment arcotan ratio",
        text = "+",
        box = function()
            return grid(4, 7, 0.5, 0.5)
        end,

        onclick = function(self)
            Settings.atan_r = Settings.atan_r +
                10 ^ Settings.atan_exp
        end
    },
    {
        name = "decrement arcotan ratio",
        text = "-",
        box = function()
            return grid(4, 7.5, 0.5, 0.5)
        end,

        onclick = function(self)
            Settings.atan_r = Settings.atan_r -
                10 ^ Settings.atan_exp
        end
    },
    {
        name = "increment arcotan displacement",
        text = "+",
        box = function()
            return grid(4.5, 7, 0.5, 0.5)
        end,

        onclick = function(self)
            Settings.atan_d = Settings.atan_d +
                10 ^ Settings.atan_exp
        end
    },
    {
        name = "decrement arcotan displacement",
        text = "-",
        box = function()
            return grid(4.5, 7.5, 0.5, 0.5)
        end,

        onclick = function(self)
            Settings.atan_d = Settings.atan_d -
                10 ^ Settings.atan_exp
        end
    },
    {
        name = "increment arcotan length",
        text = "+",
        box = function()
            return grid(5, 7, 0.5, 0.5)
        end,


        onclick = function(self)
            Settings.atan_n = MoreMaths.round(
                math.max(0,
                    Settings.atan_n +
                    10 ^ math.max(-0.6020599913279624, Settings.atan_exp)), 2)
        end
    },
    {
        name = "decrement arcotan length",
        text = "-",
        box = function()
            return grid(5, 7.5, 0.5, 0.5)
        end,

        onclick = function(self)
            Settings.atan_n = MoreMaths.round(
                math.max(0,
                    Settings.atan_n -
                    10 ^ math.max(-0.6020599913279624, Settings.atan_exp)), 2)
        end
    },
    {
        name = "increment arcotan start frame",
        text = "+",
        box = function()
            return grid(5.5, 7, 0.5, 0.5)
        end,

        onclick = function(self)
            Settings.atan_start = math.max(0,
                Settings.atan_start +
                10 ^ math.max(0, Settings.atan_exp))
        end
    },
    {
        name = "decrement arcotan start frame",
        text = "-",
        box = function()
            return grid(5.5, 7.5, 0.5, 0.5)
        end,


        onclick = function(self)
            Settings.atan_start = math.max(0,
                Settings.atan_start -
                10 ^ math.max(0, Settings.atan_exp))
        end
    },
    {
        name = "increment arcotan step",
        text = "+",
        box = function()
            return grid(6, 7, 0.5, 0.5)
        end,


        onclick = function(self)
            Settings.atan_exp = math.max(-4,
                math.min(Settings.atan_exp + 1, 4))
        end
    },
    {
        name = "decrement arcotan step",
        text = "-",
        box = function()
            return grid(6, 7.5, 0.5, 0.5)
        end,


        onclick = function(self)
            Settings.atan_exp = math.max(-4,
                math.min(Settings.atan_exp - 1, 4))
        end
    },
    {
        name = "disabled",
        text = "Disabled",
        box = function()
            return grid(0, 0, 4, 1)
        end,

        pressed = function()
            return Settings.movement_mode == Settings.movement_modes.disabled
        end,
        onclick = function(self)
            Settings.movement_mode = Settings.movement_modes.disabled
        end
    },
    {
        name = "match yaw",
        text = "Match Yaw",
        box = function()
            return grid(0, 1, 4, 1)
        end,

        pressed = function()
            return Settings.movement_mode == Settings.movement_modes.match_yaw
        end,
        onclick = function(self)
            Settings.movement_mode = Settings.movement_modes.match_yaw
        end
    },
    {
        name = "reverse angle",
        text = "Reverse Angle",
        box = function()
            return grid(0, 2, 4, 1)
        end,

        pressed = function()
            return Settings.movement_mode == Settings.movement_modes.reverse_angle
        end,
        onclick = function(self)
            Settings.movement_mode = Settings.movement_modes.reverse_angle
        end
    },
    {
        name = "match angle",
        text = "Match Angle",
        box = function()
            return grid(0, 3, 4, 1)
        end,

        pressed = function()
            return Settings.movement_mode == Settings.movement_modes.match_angle
        end,
        onclick = function(self)
            Settings.movement_mode = Settings.movement_modes.match_angle
        end
    },
}
