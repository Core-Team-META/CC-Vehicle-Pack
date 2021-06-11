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
local suspensionModule = script:GetCustomProperty("SuspensionModule"):WaitForObject()
local vehicle = script:GetCustomProperty("Vehicle"):WaitForObject()

local axle = script:GetCustomProperty("Axle"):WaitForObject()
local axleTarget = script:GetCustomProperty("AxleTarget"):WaitForObject()

local upperArm = script:GetCustomProperty("UpperArm"):WaitForObject()
local upperArmTarget = script:GetCustomProperty("UpperArmTarget"):WaitForObject()

local lowerArm = script:GetCustomProperty("LowerArm"):WaitForObject()
local lowerArmTarget = script:GetCustomProperty("LowerArmTarget"):WaitForObject()

local shockTop = script:GetCustomProperty("ShockTop"):WaitForObject()
local shockBottom = script:GetCustomProperty("ShockBottom"):WaitForObject()

local tieRod = script:GetCustomProperty("TieRod"):WaitForObject()
local tieRodTarget = script:GetCustomProperty("TieRodTarget"):WaitForObject()

local enableRotatingAxle = script:GetCustomProperty("EnableRotatingAxle")
local axleRotationModifier = script:GetCustomProperty("AxleRotationModifier")

-- Local Variables
local antiRolls = suspensionModule:FindDescendantsByName("AntiRoll")
local axleRotatables = suspensionModule:FindDescendantsByName("RotateThis")

local rotationDirection = 0

-- Function that sets all components to face towards (look at) their targets.
function Initialize()

	if Object.IsValid(axle) and Object.IsValid(axleTarget) then
		axle:LookAtContinuous(axleTarget)
	end
	
	if Object.IsValid(upperArm) and Object.IsValid(upperArmTarget) then
		upperArm:LookAtContinuous(upperArmTarget)
	end
	
	if Object.IsValid(lowerArm) and Object.IsValid(lowerArmTarget) then
		lowerArm:LookAtContinuous(lowerArmTarget)
	end
	
	if Object.IsValid(shockTop) and Object.IsValid(shockBottom) then
		shockTop:LookAtContinuous(shockBottom)
		shockBottom:LookAtContinuous(shockTop)
	end
	
	if Object.IsValid(tieRod) and Object.IsValid(tieRodTarget) then
		tieRod:LookAtContinuous(tieRodTarget)
	end
	
	if enableRotatingAxle and Object.IsValid(vehicle) and Object.IsValid(axleRotatable) then
		axleRotatable:RotateContinuous(Rotation.New(axleRotationModifier, 0, 0), vehicle:GetVelocity().size, true)
	end

end

-- Tick function that ensures allignment of the suspension components and adjusts axle speed based on vehicle speed and direction.
function Tick()

	for _, a in ipairs(antiRolls) do
		if Object.IsValid(a) and Object.IsValid(a.parent) then
			a:RotateTo(Rotation.New(-a.parent:GetRotation().x, 0, 0), 0, true)
		end
	end
	
	if vehicle.driver and vehicle.driver:IsBindingPressed("ability_extra_21") then
		rotationDirection = 1
	elseif vehicle.driver and vehicle.driver:IsBindingPressed("ability_extra_31") then
		rotationDirection = -1
	end
	
	if enableRotatingAxle and Object.IsValid(vehicle) then
		for _, a in ipairs(axleRotatables) do
			a:RotateContinuous(Rotation.New(rotationDirection * axleRotationModifier, 0, 0), vehicle:GetVelocity().size, true)
		end
	end
	
	Task.Wait()

end

-- Initialization
Initialize()