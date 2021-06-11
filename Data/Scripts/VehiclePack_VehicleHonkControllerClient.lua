--[[
Copyright 2021 Manticore Games, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Internal custom properties
local VEHICLE = script:FindAncestorByType('Vehicle')
if not VEHICLE:IsA('Vehicle') then
    error(script.name .. " should be part of Vehicle object hierarchy.")
end

-- User exposed cutom property
local HONK_BINDING = script:GetCustomProperty("HonkBinding")
local HORN_SOUND = script:GetCustomProperty("HornSound"):WaitForObject()

-- Internal variables
local isPressing = false
local pressedHandle = nil
local releasedHandle = nil

function Tick()
    if isPressing then
        PlayHonkLoopSound(true)
    else
        PlayHonkLoopSound(false)
    end
end

function PlayHonkLoopSound(play)
    if play then
        if not HORN_SOUND.isPlaying then
            HORN_SOUND:Play()
        end
    else
        if HORN_SOUND.isPlaying then
            HORN_SOUND:Stop()
        end
    end
end

function OnBindingPressed(player, binding)
    if VEHICLE.driver ~= player then return end
    if binding == HONK_BINDING then 
        isPressing = true
    end
end

function OnBindingReleased(player, binding)
    if VEHICLE.driver ~= player then return end
    if binding == HONK_BINDING then
        isPressing = false
        PlayHonkLoopSound(false)
    end
end

function OnDriverEntered(vehicle, player)
    pressedHandle = player.bindingPressedEvent:Connect(OnBindingPressed)
    releasedHandle = player.bindingReleasedEvent:Connect(OnBindingReleased)
end

function OnDriverExited(vehicle, player)
    if pressedHandle then pressedHandle:Disconnect() end
    if releasedHandle then releasedHandle:Disconnect() end

    isPressing = false
    PlayHonkLoopSound(false)
end

--Initialize
VEHICLE.driverEnteredEvent:Connect(OnDriverEntered)
VEHICLE.driverExitedEvent:Connect(OnDriverExited)

if VEHICLE.driver then
    OnDriverEntered(vehicle, VEHICLE.driver)
end

