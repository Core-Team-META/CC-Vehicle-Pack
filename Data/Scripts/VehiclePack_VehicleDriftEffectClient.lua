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
local DRIFT_SOUND = script:GetCustomProperty("DriftSound"):WaitForObject()
local TRAILS = script:GetCustomProperty("Trails"):WaitForObject()
local SMOKE_EFFECT = script:GetCustomProperty("SmokeEffect"):WaitForObject()

local isPlaying = false             -- is drifting effect playing

function Tick()
    if not VEHICLE.driver then
        if isPlaying then PlayDriftEffect(false) end 
        return 
    end

    local gear = VEHICLE.clientUserData.gear
    local isGrounded = VEHICLE.clientUserData.isGrounded
    local absoluteDriftValue =  math.abs(GetDriftValue()) * 10
    local speed = VEHICLE:GetVelocity().size

    if absoluteDriftValue > VEHICLE.maxSpeed * .1 and isGrounded then
        DRIFT_SOUND.volume = CoreMath.Clamp(absoluteDriftValue / speed, 0, 1)
        if not isPlaying then PlayDriftEffect(true) end
    else
        if VEHICLE.isBrakeEngaged and speed > 0 and isGrounded then
            DRIFT_SOUND.volume = CoreMath.Clamp(1 - speed / VEHICLE.maxSpeed, 0, 1)
            if not isPlaying then PlayDriftEffect(true) end
        else
            if isPlaying then PlayDriftEffect(false) end
        end
    end
end

function PlayDriftEffect(canPlay)
    if canPlay then
        DRIFT_SOUND:Play()
        SMOKE_EFFECT:Play()
        for _, child in ipairs(TRAILS:GetChildren()) do
            child:Play()
        end
    else
        DRIFT_SOUND:Stop()
        SMOKE_EFFECT:Stop()
        for _, child in ipairs(TRAILS:GetChildren()) do
            child:Stop()
        end
    end
    isPlaying = canPlay
end

function GetDriftValue()
    -- forward vector ^ ground up vector
    local sideways = VEHICLE:GetWorldTransform():GetForwardVector() ^ Vector3.UP

    -- dot product between sideways and velocity
    return sideways .. VEHICLE:GetVelocity()
end