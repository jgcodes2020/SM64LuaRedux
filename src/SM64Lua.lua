-- Input Direction lua:
-- Author: MKDasher
-- Hacker: Eddio0141
-- Special thanks to Pannenkoek2012 and Peter Fedak for angle calculation support.
-- Also thanks to MKDasher to making the code very clean
-- Other contributors:
--	Madghostek, Xander, galoomba, ShadoXFM, Lemon, Manama, tjk, Aurumaker72

function swap(arr, index_1, index_2)
    local tmp = VarWatch.active_variables[index_2]
    VarWatch.active_variables[index_2] = VarWatch.active_variables[index_1]
    VarWatch.active_variables[index_1] = tmp
end

function expand_rect(t)
    return {
        x = t[1],
        y = t[2],
        width = t[3],
        height = t[4],
    }
end

function spread(template)
    local result = {}
    for key, value in pairs(template) do
        result[key] = value
    end

    return function(table)
        for key, value in pairs(table) do
            result[key] = value
        end
        return result
    end
end

function select(arr, prop)
    local t = {}
    for i = 1, #arr, 1 do
        t[i] = arr[i][prop]
    end
    return t
end

folder = debug.getinfo(1).source:sub(2):match("(.*\\)")
res_path = folder .. "res\\"
local tabs_path = folder .. "tabs\\"
local core_path = folder .. "core\\"


dofile(folder .. "mupen-lua-ugui.lua")
dofile(folder .. "mupen-lua-ugui-ext.lua")
dofile(res_path .. "base.lua")
dofile(core_path .. "Settings.lua")
dofile(core_path .. "Drawing.lua")
dofile(core_path .. "Memory.lua")
dofile(core_path .. "Joypad.lua")
dofile(core_path .. "Angles.lua")
dofile(core_path .. "Engine.lua")
dofile(core_path .. "Buttons.lua")
dofile(core_path .. "Program.lua")
dofile(core_path .. "MoreMaths.lua")
dofile(core_path .. "Actions.lua")
dofile(core_path .. "Swimming.lua")
dofile(core_path .. "RNGToIndex.lua")
dofile(core_path .. "IndexToRNG.lua")
dofile(core_path .. "recordghost.lua")
dofile(core_path .. "VarWatch.lua")

local tabs = {
    dofile(tabs_path .. "TAS.lua"),
    dofile(tabs_path .. "Timer.lua"),
    dofile(tabs_path .. "RNG.lua"),
    dofile(tabs_path .. "Settings.lua"),
}

local current_tab_index = 1
local mouse_wheel = 0

Mupen_lua_ugui_ext.apply_nineslice(Settings.styles[Settings.active_style_index].theme)
Drawing.size_up()

function at_input()
    Program.new_frame()
    Program.main()
    tabs[current_tab_index].update()
    Program.rngSetter()
    Joypad.send()
    Swimming.swim()
    Ghost.main()
end

function at_update_screen()
    local keys = input.get()
    Mupen_lua_ugui.begin_frame({
        mouse_position = {
            x = keys.xmouse,
            y = keys.ymouse,
        },
        wheel = mouse_wheel,
        is_primary_down = keys.leftclick,
        held_keys = keys,
    })
    mouse_wheel = 0

    BreitbandGraphics.fill_rectangle({
        x = Drawing.initial_size.width,
        y = 0,
        width = Drawing.size.width - Drawing.initial_size.width,
        height = Drawing.size.height
    }, Settings.styles[Settings.active_style_index].theme.background_color)

    tabs[current_tab_index].draw()

    current_tab_index = Mupen_lua_ugui.carrousel_button({
        uid = 420,
        is_enabled = true,
        rectangle = grid_rect(0, 16, 8, 1),
        items = select(tabs, "name"),
        selected_index = current_tab_index,
    })

    Mupen_lua_ugui.end_frame()
end

-- run 2 fake updates pass to get everything to pull itself together (UpdatePrevPos)
at_input()
at_input()

emu.atinput(at_input)
emu.atupdatescreen(at_update_screen)

emu.atstop(function()
    Drawing.size_down()
end)

emu.atreset(Drawing.size_up)

emu.atwindowmessage(function(hwnd, msg_id, wparam, lparam)
    if msg_id == 522 then                         -- WM_MOUSEWHEEL
        -- high word (most significant 16 bits) is scroll rotation in multiples of WHEEL_DELTA (120)
        local scroll = math.floor(wparam / 65536) --(wparam & 0xFFFF0000) >> 16
        if scroll == 120 then
            mouse_wheel = 1
        elseif scroll == 65416 then -- 65536 - 120
            mouse_wheel = -1
        end
    end
end)
