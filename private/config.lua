--- remap left/down/up/right
local function pressFn(mods, key)
    if key == nil then
        key = mods
        mods = {}
    end

    return function() hs.eventtap.keyStroke(mods, key, 1000) end
end

local function remap(mods, key, pressFn)
    hs.hotkey.bind(mods, key, pressFn, nil, pressFn)
end


remap({ 'ctrl' }, 'h', pressFn('left'))
remap({ 'ctrl' }, 'j', pressFn('down'))
remap({ 'ctrl' }, 'k', pressFn('up'))
remap({ 'ctrl' }, 'l', pressFn('right'))

remap({ 'ctrl', 'shift' }, 'h', pressFn({ 'shift' }, 'left'))
remap({ 'ctrl', 'shift' }, 'j', pressFn({ 'shift' }, 'down'))
remap({ 'ctrl', 'shift' }, 'k', pressFn({ 'shift' }, 'up'))
remap({ 'ctrl', 'shift' }, 'l', pressFn({ 'shift' }, 'right'))

remap({ 'ctrl', 'cmd' }, 'h', pressFn({ 'cmd' }, 'left'))
remap({ 'ctrl', 'cmd' }, 'j', pressFn({ 'cmd' }, 'down'))
remap({ 'ctrl', 'cmd' }, 'k', pressFn({ 'cmd' }, 'up'))
remap({ 'ctrl', 'cmd' }, 'l', pressFn({ 'cmd' }, 'right'))

remap({ 'ctrl', 'alt' }, 'h', pressFn({ 'alt' }, 'left'))
remap({ 'ctrl', 'alt' }, 'j', pressFn({ 'alt' }, 'down'))
remap({ 'ctrl', 'alt' }, 'k', pressFn({ 'alt' }, 'up'))
remap({ 'ctrl', 'alt' }, 'l', pressFn({ 'alt' }, 'right'))

remap({ 'ctrl', 'shift', 'cmd' }, 'h', pressFn({ 'shift', 'cmd' }, 'left'))
remap({ 'ctrl', 'shift', 'cmd' }, 'j', pressFn({ 'shift', 'cmd' }, 'down'))
remap({ 'ctrl', 'shift', 'cmd' }, 'k', pressFn({ 'shift', 'cmd' }, 'up'))
remap({ 'ctrl', 'shift', 'cmd' }, 'l', pressFn({ 'shift', 'cmd' }, 'right'))

remap({ 'ctrl', 'shift', 'alt' }, 'h', pressFn({ 'shift', 'alt' }, 'left'))
remap({ 'ctrl', 'shift', 'alt' }, 'j', pressFn({ 'shift', 'alt' }, 'down'))
remap({ 'ctrl', 'shift', 'alt' }, 'k', pressFn({ 'shift', 'alt' }, 'up'))
remap({ 'ctrl', 'shift', 'alt' }, 'l', pressFn({ 'shift', 'alt' }, 'right'))

remap({ 'ctrl', 'cmd', 'alt' }, 'h', pressFn({ 'cmd', 'alt' }, 'left'))
remap({ 'ctrl', 'cmd', 'alt' }, 'j', pressFn({ 'cmd', 'alt' }, 'down'))
remap({ 'ctrl', 'cmd', 'alt' }, 'k', pressFn({ 'cmd', 'alt' }, 'up'))
remap({ 'ctrl', 'cmd', 'alt' }, 'l', pressFn({ 'cmd', 'alt' }, 'right'))

remap({ 'ctrl', 'cmd', 'alt', 'shift' }, 'h', pressFn({ 'cmd', 'alt', 'shift' }, 'left'))
remap({ 'ctrl', 'cmd', 'alt', 'shift' }, 'j', pressFn({ 'cmd', 'alt', 'shift' }, 'down'))
remap({ 'ctrl', 'cmd', 'alt', 'shift' }, 'k', pressFn({ 'cmd', 'alt', 'shift' }, 'up'))
remap({ 'ctrl', 'cmd', 'alt', 'shift' }, 'l', pressFn({ 'cmd', 'alt', 'shift' }, 'right'))

--- Example for catching fn press event
---play = hs.hotkey.bind({}, 'space',
---    function()
---        hs.alert.show(hs.eventtap.checkKeyboardModifiers().fn)
---        if hs.eventtap.checkKeyboardModifiers().fn then
---            hs.alert.show('FN is DOWN!!!')
---        else
---            play:disable()
---            hs.eventtap.keyStroke({}, 'space')
---            hs.timer.doAfter(
---                0.1,
---                function()
---                    play:enable()
---                end
---            )
---        end
---    end
---)

--- hs.eventtap.new(
---     {hs.eventtap.event.types.flagsChanged},
---     function (e)
---         if e:getFlags().fn then
---             hs.alert.show('FN is DOWN!!!')
---         end
---     end
--- ):start()


-- move cursor between monitors
--hs.hotkey.bind({ 'shift' }, '`',
--    function()
--        local screen = hs.mouse.getCurrentScreen()
--        local nextScreen = screen:next()
--        local rect = nextScreen:fullFrame()
--        local center = hs.geometry.rectMidPoint(rect)
--        hs.mouse.setAbsolutePosition(center)
--    end
--)


--- remap left shift(tap to capslock, hold to shift)
len = function(t)
    local length = 0
    for k, v in pairs(t) do
    --hs.alert.show(k)
        length = length + 1
    end
    return length
end

is_rightshift = function(evt)
    return hs.keycodes.map[evt:getKeyCode()] == 'rightshift'
end

prev_modifiers = {}
send_capslock = false

remap_handler = function(event)
    local curr_modifiers = event:getFlags()
    if len(curr_modifiers) == 1 and len(prev_modifiers) == 0 and is_rightshift(event) then
        --hs.alert.show('only rightshift down...')
        send_capslock = true
    elseif len(curr_modifiers) == 0 and is_rightshift(event) and send_capslock then
        hs.eventtap.event.newSystemKeyEvent('CAPS_LOCK', true):post()
        hs.timer.usleep(500)
        hs.eventtap.event.newSystemKeyEvent( 'CAPS_LOCK', false):post();
        --hs.alert.show('rightshift down...')
        send_capslock = false
    else
        --hs.alert.show('other modifiers down')
        send_capslock = false
    end
    prev_modifiers = curr_modifiers
    return false
end

modifier_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, remap_handler)
modifier_tap:start()

none_modifier_tap = hs.eventtap.new(
        {hs.eventtap.event.types.keyDown},
        function(evt)
            send_capslock = false
            return false
        end
)
none_modifier_tap:start()
