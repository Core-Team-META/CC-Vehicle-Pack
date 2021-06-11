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
local bridgeArmServer = script:GetCustomProperty("BridgeArmServer"):WaitForObject()

local mainArmServer = script:GetCustomProperty("MainArmServer"):WaitForObject()
local mainArmClient = script:GetCustomProperty("MainArmClient"):WaitForObject()

local subArmServer = script:GetCustomProperty("SubArmServer"):WaitForObject()
local subArmClient = script:GetCustomProperty("SubArmClient"):WaitForObject()

local pistonTop1 = script:GetCustomProperty("PistonTop1"):WaitForObject()
local pistonTop2 = script:GetCustomProperty("PistonTop2"):WaitForObject()
local pistonTop3 = script:GetCustomProperty("PistonTop3"):WaitForObject()

local pistonBottom1 = script:GetCustomProperty("PistonBottom1"):WaitForObject()
local pistonBottom2 = script:GetCustomProperty("PistonBottom2"):WaitForObject()
local pistonBottom3 = script:GetCustomProperty("PistonBottom3"):WaitForObject()

local leftTreads = script:GetCustomProperty("LeftTreads"):WaitForObject()
local rightTreads = script:GetCustomProperty("RightTreads"):WaitForObject()

local idleSFX = script:GetCustomProperty("IdleSFX"):WaitForObject()
local activeSFX = script:GetCustomProperty("ActiveSFX"):WaitForObject()
local activeFX = script:GetCustomProperty("ActiveFX"):WaitForObject()

local mainArmStartSFX = script:GetCustomProperty("MainArmStartSFX"):WaitForObject()
local mainArmLoopSFX = script:GetCustomProperty("MainArmLoopSFX"):WaitForObject()

local subArmStartSFX = script:GetCustomProperty("SubArmStartSFX"):WaitForObject()
local subArmLoopSFX = script:GetCustomProperty("SubArmLoopSFX"):WaitForObject()

local bridgeHingeLoopSFX = script:GetCustomProperty("BridgeHingeLoopSFX"):WaitForObject()
local bridgeEquippedSFX = script:GetCustomProperty("BridgeEquippedSFX"):WaitForObject()

local servoEndSFX = script:GetCustomProperty("ServoEndSFX"):WaitForObject()

-- Local Variables
local leftWheels = leftTreads:FindDescendantsByName("Wheel")
local rightWheels = rightTreads:FindDescendantsByName("Wheel")
local leftWheelModifier = 0
local rightWheelModifier = 0
local vehicleSpeed = 0
local previousPhase = 0

-- Function that initializes the pistons of the arm. 
function Initialize()

	pistonTop1:LookAtContinuous(pistonBottom1)
	pistonBottom1:LookAtContinuous(pistonTop1)
	
	pistonTop2:LookAtContinuous(pistonBottom2)
	pistonBottom2:LookAtContinuous(pistonTop2)

	pistonTop3:LookAtContinuous(pistonBottom3)
	pistonBottom3:LookAtContinuous(pistonTop3)	

end

-- Function that changes the current sound effect playing based on the animation phase of the arm and when the vehicle equips a bridge.
function OnPropertyChanged(serverScript, property)

	local value = serverScript:GetCustomProperty(property)

	if property == "AnimationPhase" then
	
		if previousPhase == 1 or (value == 2 and previousPhase == 2) then
			servoEndSFX:Play()
			previousPhase = 0
		elseif value ~= 0 then
			previousPhase = value
		end
	
		mainArmLoopSFX:Stop()
		subArmLoopSFX:Stop()
		bridgeHingeLoopSFX:Stop()
		
		Task.Wait()
		
		if value == 1 then
			mainArmStartSFX:Play()
			Task.Wait(0.1)
			mainArmLoopSFX:Play()
		elseif value == 2 then
			subArmStartSFX:Play()
			Task.Wait(0.1)
			subArmLoopSFX:Play()
			if previousPhase == 2 then
				bridgeHingeLoopSFX:Play()
			end
		end
		
	elseif property == "HasBridge" then
		if value then
			bridgeEquippedSFX:Play()
		end
	end

end

-- Tick function that updates the rotation of the client-side arm geo with the networked arm pivots, 
-- adjusts the sound and visual effects based on vehicle speed, 
-- and adjusts wheel speed based on the movement of the vehicle.
function Tick()

	mainArmClient:RotateTo(mainArmServer:GetRotation(), 0.01, true)
	subArmClient:RotateTo(subArmServer:GetRotation(), 0.01, true)
	
	leftWheelModifier = bridgeArmServer:GetCustomProperty("LeftWheelsModifier")
	rightWheelModifier = bridgeArmServer:GetCustomProperty("RightWheelsModifier")
	vehicleSpeed = vehicle:GetVelocity().size
	
	if vehicle.driver and not idleSFX.isPlaying then
		idleSFX:Play()
		activeSFX:Play()
		activeFX.visibility = Visibility.INHERIT
	elseif not vehicle.driver and idleSFX.isPlaying then
		idleSFX:Stop()
		activeSFX:Stop()
		activeFX.visibility = Visibility.FORCE_OFF
	end

	activeSFX.pitch = vehicleSpeed - 400
	
	for _, w in ipairs(leftWheels) do
	
		w:RotateContinuous(Rotation.New(0, -leftWheelModifier, 0), vehicleSpeed, true)
	
	end
	
	for _, w in ipairs(rightWheels) do
	
		w:RotateContinuous(Rotation.New(0, -rightWheelModifier, 0), vehicleSpeed, true)
	
	end
	
end

-- Initialization
Initialize()
bridgeArmServer.networkedPropertyChangedEvent:Connect(OnPropertyChanged)