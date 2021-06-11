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
local vehicleServer = script:GetCustomProperty("VehicleServer"):WaitForObject()

local runningLightsOn = script:GetCustomProperty("RunningLightsOn"):WaitForObject()
local runningLightsOff = script:GetCustomProperty("RunningLightsOff"):WaitForObject()
local headLightsOn = script:GetCustomProperty("HeadLightsOn"):WaitForObject()
local headlightsOff = script:GetCustomProperty("HeadlightsOff"):WaitForObject()
local tailLightsOn = script:GetCustomProperty("TailLightsOn"):WaitForObject()
local tailLightsOff = script:GetCustomProperty("TailLightsOff"):WaitForObject()
local reverseLightsOn = script:GetCustomProperty("ReverseLightsOn"):WaitForObject()
local reverseLightsOff = script:GetCustomProperty("ReverseLightsOff"):WaitForObject()
local leftSignalOn = script:GetCustomProperty("LeftSignalOn"):WaitForObject()
local leftSignalOff = script:GetCustomProperty("LeftSignalOff"):WaitForObject()
local rightSignalOn = script:GetCustomProperty("RightSignalOn"):WaitForObject()
local rightSignalOff = script:GetCustomProperty("RightSignalOff"):WaitForObject()

local turnSignalSFX = script:GetCustomProperty("TurnSignalSFX"):WaitForObject()
local lightToggleSFX = script:GetCustomProperty("LightToggleSFX"):WaitForObject()
local hornSFX = script:GetCustomProperty("HornSFX"):WaitForObject()
local lockSFX = script:GetCustomProperty("LockSFX"):WaitForObject()

-- Local Variables
local timeTracker = 0
local signalInAnimation = false

local function SwapVisibility(objectOne, objectTwo, toggle)
	if toggle then
		if Object.IsValid(objectOne) then
			objectOne.visibility = Visibility.INHERIT
		end
		
		if Object.IsValid(objectTwo) then
			objectTwo.visibility = Visibility.FORCE_OFF
		end
	else 
		if Object.IsValid(objectOne) then
			objectOne.visibility = Visibility.FORCE_OFF
		end
		
		if Object.IsValid(objectTwo) then
			objectTwo.visibility = Visibility.INHERIT
		end
	end
end

-- Function that honks the horn, toggles the lights, toggles the daytime running lights, or plays the lock sound effect 
-- based on custom properties from VehiclePack_MkE_VehicleServer script.
function OnPropertyChanged(vehicleScript, property)
	local value = vehicleScript:GetCustomProperty(property)
	
	if property == "HornToggle" then
		if value then
			hornSFX:Play()
		end		
	elseif property == "LightsToggle" then
		SwapVisibility(headLightsOn, headlightsOff, value)
		if Object.IsValid(lightToggleSFX) then
			lightToggleSFX:Play()
		end
	elseif property == "ActiveToggle" then
		SwapVisibility(runningLightsOn, runningLightsOff, value)
	elseif property == "VehicleLock" then
		lockSFX:Play()
	end

end

function ToggleLeftSignal()

	signalInAnimation = true
	
	SwapVisibility(leftSignalOn, leftSignalOff, true)

	if Object.IsValid(turnSignalSFX) then
		turnSignalSFX:Play()
	end
	
	Task.Wait(0.5)
	
	SwapVisibility(leftSignalOn, leftSignalOff, false)
	
	Task.Wait(0.5)
	
	signalInAnimation = false

end

function ToggleRightSignal()
	
	signalInAnimation = true

	SwapVisibility(rightSignalOn, rightSignalOff, true)

	if Object.IsValid(turnSignalSFX) then
		turnSignalSFX:Play()
	end
	
	Task.Wait(0.5)
	
	SwapVisibility(rightSignalOn, rightSignalOff, false)
	
	Task.Wait(0.5)	
	
	signalInAnimation = false
end

function ToggleHazardSignal()
	
	signalInAnimation = true
	
	SwapVisibility(leftSignalOn, leftSignalOff, true)
	SwapVisibility(rightSignalOn, rightSignalOff, true)

	if Object.IsValid(turnSignalSFX) then
		turnSignalSFX:Play()
	end
	
	Task.Wait(0.5)
	
	SwapVisibility(leftSignalOn, leftSignalOff, false)
	SwapVisibility(rightSignalOn, rightSignalOff, false)
		
	Task.Wait(0.5)	
	
	signalInAnimation = false
end

-- Tick function that controls the reverse lights, tail lights, and turn signals based on vehicle movement and turn signal state 
-- from VehiclePack_MkE_VehicleServer script.
function Tick(dt)

	if vehicle.isBrakeEngaged or vehicle.isHandbrakeEngaged then
		SwapVisibility(tailLightsOn, tailLightsOff, true)
	else
		SwapVisibility(tailLightsOn, tailLightsOff, false)
	end
	
	local reversing = vehicleServer:GetCustomProperty("Reversing")
	
	if reversing then
		SwapVisibility(reverseLightsOn, reverseLightsOff, true)
	else
		SwapVisibility(reverseLightsOn, reverseLightsOff, false)
	end
	
	local turnSignalState = vehicleServer:GetCustomProperty("TurnSignalState")
	
	if not signalInAnimation then
		if turnSignalState == 1 then
			Task.Spawn(ToggleLeftSignal, 0)
		elseif turnSignalState == 2 then
			Task.Spawn(ToggleRightSignal, 0)
		elseif turnSignalState == -1 then
			Task.Spawn(ToggleHazardSignal, 0)
		end
	end

end

-- Initialization
vehicleServer.networkedPropertyChangedEvent:Connect(OnPropertyChanged)
