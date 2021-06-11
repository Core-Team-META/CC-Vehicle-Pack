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
local vehicleServer = script:GetCustomProperty("VehicleServer"):WaitForObject()
local hatches = script:GetCustomProperty("Hatches"):WaitForObject()

-- Local Variables
local allHatches = hatches:GetChildren()

-- Function that initializes the client user data for all hatches in the vehicle.
function Initialize()
	
	for _, h in ipairs(allHatches) do
		if Object.IsValid(h) then
			h.clientUserData.VehiclePack = {}
			h.clientUserData.VehiclePack.isOpen = false
		end
	end
	
end

-- Function that performs several tasks:
-- The function checks a custom property string in the VehiclePack_MkE_VehicleServer script.
-- If the name of the hatch is found in the string, the hatch is opened, and otherwise it is closed.
function OnPropertyChanged(vehicleScript, property)

	if property ~= "ActiveModules" then
		return
	end
	
	local moduleString = vehicleScript:GetCustomProperty(property)

	for _, h in ipairs(allHatches) do
		if Object.IsValid(h) and string.find(moduleString, h.name) then
			if not h.clientUserData.VehiclePack.isOpen then
				h.clientUserData.VehiclePack.isOpen = true
				local openRotation = h:GetCustomProperty("HatchOpened")
				local rotationSpeed = h:GetCustomProperty("RotationSpeed")
				local openSFX = h:GetCustomProperty("OpenSFX"):WaitForObject()
				
				h:RotateTo(openRotation, rotationSpeed, true)
				
				if Object.IsValid(openSFX) then
					openSFX:Play()
				end
			end
		elseif Object.IsValid(h) then
			if h.clientUserData.VehiclePack.isOpen then
				h.clientUserData.VehiclePack.isOpen = false
				local closeRotation = h:GetCustomProperty("HatchClosed")
				local rotationSpeed = h:GetCustomProperty("RotationSpeed")
				local closeSFX = h:GetCustomProperty("CloseSFX"):WaitForObject()
				
				h:RotateTo(closeRotation, rotationSpeed, true)
				
				Task.Wait(rotationSpeed/2)
				
				if Object.IsValid(closeSFX) then
					closeSFX:Play()
				end	
			end		
		end
	end	
	
end

-- Initialization
Initialize()
vehicleServer.networkedPropertyChangedEvent:Connect(OnPropertyChanged)