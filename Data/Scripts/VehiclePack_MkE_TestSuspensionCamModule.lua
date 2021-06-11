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
local camera = script:GetCustomProperty("Camera"):WaitForObject()
local obstructingPart = script:GetCustomProperty("ObstructingPart"):WaitForObject()
local obstructingWheel = script:GetCustomProperty("ObstructingWheel"):WaitForObject()
local toggleBinding = script:GetCustomProperty("ToggleBinding")
local otherCamBindings = script:GetCustomProperty("OtherCamBindings")
local enableTestCam = script:GetCustomProperty("EnableTestCam")

-- Local Variables
local cameraToggle = false
local bindingPresssedListener = nil
local oldCamera = nil

-- Function that changes the camera based on if a camera binding has been pressed.
function OnBindingPressed(player, binding)
	
	if binding ~= toggleBinding then
		if string.find(otherCamBindings, binding) then
			cameraToggle = false
			obstructingPart.visibility = Visibility.INHERIT
			obstructingWheel.visibility = Visibility.INHERIT		
		end
		return
	end
	
	if not cameraToggle then
		cameraToggle = true
		oldCamera = player:GetActiveCamera()
		player:SetDefaultCamera(camera)
		obstructingPart.visibility = Visibility.FORCE_OFF
		obstructingWheel.visibility = Visibility.FORCE_OFF
	else
		cameraToggle = false
		player:SetDefaultCamera(oldCamera)
		obstructingPart.visibility = Visibility.INHERIT
		obstructingWheel.visibility = Visibility.INHERIT
	end

end

function OnEntered(vehicle, driver)

	bindingPresssedListener = driver.bindingPressedEvent:Connect(OnBindingPressed)
	
end

-- Function that disconnects the binding listener, restores the camera if needed, and restores visibility of parts when the driver leaves.
function OnLeft(vehicle, driver)

	bindingPresssedListener:Disconnect()
	
	Task.Wait(0.1)
	
	if Object.IsValid(driver) and driver:GetActiveCamera() == camera then
		player:SetDefaultCamera(oldCamera)
	end
	
	cameraToggle = false
	obstructingPart.visibility = Visibility.INHERIT
	obstructingWheel.visibility = Visibility.INHERIT
	
end

-- Initialization
if enableTestCam then
	vehicle.driverEnteredEvent:Connect(OnEntered)
	vehicle.driverExitedEvent:Connect(OnLeft)
end

