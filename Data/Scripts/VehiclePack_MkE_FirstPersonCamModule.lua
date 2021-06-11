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
local defaultCamera = script:GetCustomProperty("DefaultCamera"):WaitForObject()
local firstPersonCameras = script:GetCustomProperty("FirstPersonCameras"):WaitForObject()
local cameraBinding = script:GetCustomProperty("CameraBinding")

-- Local Variables
local allFPCameras = firstPersonCameras:GetChildren()

local localPlayer = Game.GetLocalPlayer()
local bindingPressedListener = nil
local selectedCamera = nil
local oldCamera = nil
local oldVisibility = nil

-- Function that swaps the player's camera if the specified binding was pressed.
function OnBindingPressed(player, binding)
	if binding ~= cameraBinding or not selectedCamera or player ~= localPlayer then 
		return
	end
	
	local activeCam = localPlayer:GetActiveCamera()
	
	if activeCam == defaultCamera then
		localPlayer:SetDefaultCamera(selectedCamera)
		localPlayer.isVisibleToSelf = false
	else
		localPlayer:SetDefaultCamera(defaultCamera)
		localPlayer.isVisibleToSelf = true
	end

end

-- Function that checks if the local player was added or removed from the vehicle and sets or disconnects the binding listener accordingly.
function OnPropertyChanged(vehicleScript, property)

	if property ~= "PlayersInVehicle" then
		return
	end
	
	local seatsString = vehicleScript:GetCustomProperty(property)
	
	for _, s in ipairs{CoreString.Split(seatsString, "|")} do
		if string.find(s, localPlayer.id) then
			for _, c in ipairs(allFPCameras) do
				if string.find(s, c.name) then
					if not selectedCamera then
						bindingPressedListener = localPlayer.bindingPressedEvent:Connect(OnBindingPressed)
						selectedCamera = c
						oldCamera = localPlayer:GetDefaultCamera()
						oldVisibility = localPlayer.isVisibleToSelf
						localPlayer:SetDefaultCamera(defaultCamera)
					end
					return
				end
			end
		end
	end
	
	if bindingPressedListener then
		bindingPressedListener:Disconnect()
		bindingPressedListener = nil
	end
	
	if selectedCamera and localPlayer then
		localPlayer.isVisibleToSelf = oldVisibility
		localPlayer:SetDefaultCamera(oldCamera)
		selectedCamera = nil
	end
	
end

-- Initialization
vehicleServer.networkedPropertyChangedEvent:Connect(OnPropertyChanged)