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

-- Custom Properties
local vehicle = script:GetCustomProperty("Vehicle"):WaitForObject()
local idleSFX = script:GetCustomProperty("IdleSFX"):WaitForObject()
local activeSFX = script:GetCustomProperty("ActiveSFX"):WaitForObject()
local terrainSFX = script:GetCustomProperty("TerrainSFX"):WaitForObject()

local soundModifier = script:GetCustomProperty("SoundModifier")
local soundStartPitch = script:GetCustomProperty("SoundStartPitch")

-- Tick function that starts, stops, and modifies the sound effects of the vehicle based on if there is a driver in the vehicle,
-- if the vehicle is moving at a significant speed, and how fast the vehicle is moving. (Pitch is increased or decreased based on speed)
function Tick()

	if not vehicle.driver then
	
		if Object.IsValid(idleSFX) and idleSFX.isPlaying then
			idleSFX:Stop()
		end
		
		if Object.IsValid(activeSFX) and activeSFX.isPlaying then
			activeSFX:Stop()
		end
		
		return
	end

	if Object.IsValid(idleSFX) and not idleSFX.isPlaying then
		idleSFX:Play()
	end
	
	local vehicleSpeed = vehicle:GetVelocity().size
	
	if vehicleSpeed < 10 then
	
		if Object.IsValid(activeSFX) and activeSFX.isPlaying then
			activeSFX:Stop()
		end
		
		if Object.IsValid(terrainSFX) and terrainSFX.isPlaying then
			terrainSFX:Stop()
		end
		
		return
	end
	
	if Object.IsValid(activeSFX) then
		activeSFX.pitch = soundStartPitch + vehicleSpeed * soundModifier
		
		if not activeSFX.isPlaying then
			activeSFX:Play()
		end

		if Object.IsValid(terrainSFX) and not terrainSFX.isPlaying then
			terrainSFX:Play()
		end
	end
		
	Task.Wait(0.05)
	
end

