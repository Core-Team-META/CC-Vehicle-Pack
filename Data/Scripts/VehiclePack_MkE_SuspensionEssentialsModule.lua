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
local wheel = script:GetCustomProperty("Wheel"):WaitForObject()
local wheelRim = script:GetCustomProperty("WheelRim"):WaitForObject()

local steeringKnuckle = script:GetCustomProperty("SteeringKnuckle"):WaitForObject()
local movingAssembly = script:GetCustomProperty("MovingAssembly"):WaitForObject()

-- Function that initializes the moving assembly to follow the wheel and the steering knuckle to copy the rotation (look at) the wheel rim.
function Initialize()

	if Object.IsValid(wheel) and Object.IsValid(movingAssembly) then
		movingAssembly:Follow(wheel)
	end
	
	if Object.IsValid(wheelRim) and Object.IsValid(steeringKnuckle) then
		steeringKnuckle:LookAtContinuous(wheelRim, true)
	end

end

-- Initialization
Initialize()