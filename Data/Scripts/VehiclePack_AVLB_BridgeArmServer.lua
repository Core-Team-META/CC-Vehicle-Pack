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
local bridgeTemplate = script:GetCustomProperty("BridgeTemplate")

local bridgeSpawnPosition = script:GetCustomProperty("BridgeSpawnPosition")

local deployBinding = script:GetCustomProperty("DeployBinding")
local replaceBinding = script:GetCustomProperty("ReplaceBinding")
local resetBridgesBinding = script:GetCustomProperty("ResetBridgesBinding")

local maxBridges = script:GetCustomProperty("MaxBridges")

local mainArm = script:GetCustomProperty("MainArm"):WaitForObject()
local mainExtended = script:GetCustomProperty("MainExtended")
local mainAnimationTime = script:GetCustomProperty("MainAnimationTime")

local subArm = script:GetCustomProperty("SubArm"):WaitForObject()
local subExtended = script:GetCustomProperty("SubExtended")
local subAnimationTime = script:GetCustomProperty("SubAnimationTime")

local bridge = script:GetCustomProperty("Bridge"):WaitForObject()
local bridgeExtendedRotation = script:GetCustomProperty("BridgeExtendedRotation")

local bridgeSecondHalf = script:GetCustomProperty("BridgeSecondHalf"):WaitForObject()
local secondHalfExtended = script:GetCustomProperty("SecondHalfExtended")

-- Local Variables
local bindingPresssedListener = nil
local deployed = false
local leftModifier = 0
local rightModifier = 0
local bridgeTracker = {}
local midAnimation = false

function ExtendAnimation()

	script:SetNetworkedCustomProperty("AnimationPhase", 1)
	mainArm:RotateTo(mainExtended, mainAnimationTime, true)
	
	Task.Wait(mainAnimationTime)
	
	script:SetNetworkedCustomProperty("AnimationPhase", 0)
	
	Task.Wait(0.5)
	
	script:SetNetworkedCustomProperty("AnimationPhase", 2)
	subArm:RotateTo(subExtended, subAnimationTime, true)
	
	Task.Wait(subAnimationTime * 0.1) 
	
	bridgeSecondHalf:RotateTo(secondHalfExtended * 0.07, subAnimationTime * 0.05, true)
	
	Task.Wait(subAnimationTime * 0.05)
	
	bridgeSecondHalf:RotateTo(secondHalfExtended * 0.05, subAnimationTime * 0.05, true)
			
	Task.Wait(subAnimationTime * 0.05)
	
	bridgeSecondHalf:RotateTo(secondHalfExtended * 0.15, subAnimationTime * 0.05, true)
	
	Task.Wait(subAnimationTime * 0.05)
	
	bridgeSecondHalf:RotateTo(secondHalfExtended, subAnimationTime * 0.6, true)
	bridge:RotateTo(bridgeExtendedRotation, subAnimationTime * 0.75, true)
	
	Task.Wait(subAnimationTime * 0.75)
	
	script:SetNetworkedCustomProperty("AnimationPhase", 0)
	
	Task.Wait(0.5)
		
end

function RetractAnimation()

	script:SetNetworkedCustomProperty("AnimationPhase", 2)

	subArm:RotateTo(Rotation.ZERO, subAnimationTime, true)
	bridge:RotateTo(Rotation.ZERO, subAnimationTime, true)
	bridgeSecondHalf:RotateTo(secondHalfExtended * 0.8, subAnimationTime * 0.25 + 1, true)
	
	Task.Wait(subAnimationTime * 0.25)
		
	bridgeSecondHalf:RotateTo(Rotation.ZERO, subAnimationTime * 0.75 - 1, true)
	
	Task.Wait(subAnimationTime * 0.75 + 0.5)
	
	script:SetNetworkedCustomProperty("AnimationPhase", 0)
	
	Task.Wait(0.5)
				
	mainArm:RotateTo(Rotation.ZERO, mainAnimationTime, true)
	
	script:SetNetworkedCustomProperty("AnimationPhase", 1)
	
	Task.Wait(mainAnimationTime)
	
	script:SetNetworkedCustomProperty("AnimationPhase", 0)
	
	Task.Wait(0.5)
		
end

-- Function to check if the player entered a command such as place a bridge, remove a bridge, replace a bridge, or reset all bridges.
-- The player will not be able enter a new command while the arm is animating.
function OnBindingPressed(player, binding)

	if midAnimation then
		return
	end

	midAnimation = true
	
	if binding == deployBinding  and not deployed and #bridgeTracker < maxBridges then
		ExtendAnimation()
		
		local bridgePosition = vehicle:GetWorldPosition() + vehicle:GetWorldRotation() * bridgeSpawnPosition
		local bridgeRotation = vehicle:GetWorldRotation()
		local newBridge = World.SpawnAsset(bridgeTemplate, {position = bridgePosition, rotation = bridgeRotation})
		table.insert(bridgeTracker, newBridge)
		bridge.visibility = Visibility.FORCE_OFF
		
		RetractAnimation()
		deployed = true
	elseif binding == deployBinding then
		local selectedBridge = nil
		local selectedBridgeIndex = nil
		local possiblePosition = vehicle:GetWorldPosition() + vehicle:GetWorldRotation() * bridgeSpawnPosition
		local possibleRotation = vehicle:GetWorldRotation()
		
		for x, b in ipairs(bridgeTracker) do
			if (b:GetWorldPosition() - possiblePosition).size < 500 then
				local rotationDifference = math.abs((b:GetWorldRotation() - possibleRotation).z)
				local checkFacing = (vehicle:GetWorldPosition() - possiblePosition).size > (mainArm:GetWorldPosition() - possiblePosition).size
				if checkFacing and rotationDifference < 30 or (rotationDifference > 155 and rotationDifference < 205) then
					selectedBridge = b
					selectedBridgeIndex = x
				end
			end
		end
		
		if not selectedBridge then
			return
		end
		
		ExtendAnimation()
		
		bridge.visibility = Visibility.INHERIT
		table.remove(bridgeTracker, selectedBridgeIndex)
		selectedBridge:Destroy()
		
		RetractAnimation()		
		deployed = false
	elseif binding == replaceBinding and deployed and #bridgeTracker < maxBridges then
		bridge.visibility = Visibility.INHERIT
		deployed = false
	elseif binding == resetBridgesBinding then
		for x = 1, #bridgeTracker, 1 do
			bridgeTracker[x]:Destroy()
			bridgeTracker[x] = nil
		end
		
		bridgeTracker = {}
	end
	
	Task.Wait(0.5)
	
	midAnimation = false
	
	script:SetNetworkedCustomProperty("HasBridge", not deployed)
	
end

function OnEntered(vehicle, driver)

	bindingPresssedListener = driver.bindingPressedEvent:Connect(OnBindingPressed)
	
end

function OnLeft(vehicle, driver)

	bindingPresssedListener:Disconnect()
		
end

-- Tick function to adjust the custom properties that affect the rotation speed for the left and right wheels.
-- Rotation direction is affected by whether the player is moving the tank forward or backward,
-- and the speed may be modified depending on if the player is turning left or right.
-- (Turning left = right wheels rotate faster, turning right = right wheels rotate faster)
function Tick()

	if not vehicle.driver then
		return
	end
	
	leftModifier = 0
	rightModifier = 0
	
	if vehicle.driver:IsBindingPressed("ability_extra_21") then
		leftModifier = leftModifier + 1
		rightModifier = rightModifier  + 1
	elseif vehicle.driver:IsBindingPressed("ability_extra_31") then
		leftModifier = leftModifier - 1
		rightModifier = rightModifier  - 1
	end
	
	if vehicle.driver:IsBindingPressed("ability_extra_30") then
		leftModifier = leftModifier - 0.5
		rightModifier = rightModifier  + 0.5
	elseif vehicle.driver:IsBindingPressed("ability_extra_32") then
		leftModifier = leftModifier + 0.5
		rightModifier = rightModifier  - 0.5
	end
	
	script:SetNetworkedCustomProperty("LeftWheelsModifier", leftModifier)
	script:SetNetworkedCustomProperty("RightWheelsModifier", rightModifier)

end

-- Initialization
vehicle.driverEnteredEvent:Connect(OnEntered)
vehicle.driverExitedEvent:Connect(OnLeft)