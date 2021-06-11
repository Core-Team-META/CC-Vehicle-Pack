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
local interractTrigger = script:GetCustomProperty("InterractTrigger"):WaitForObject()
local seats = script:GetCustomProperty("Seats"):WaitForObject()
local doors = script:GetCustomProperty("Doors"):WaitForObject()

-- Local Variables
local allSeatTriggers = seats:FindDescendantsByName("SimulatedEntryTrigger")

-- Tick function that performs several tasks:
-- The function checks if a player is within range of a simulated trigger of for a door.
-- The function checks if the vehicle is locked.
-- If a player is within range, the function checks if a player is already in the specific seat by the door by checking a 
-- custom property in the VehiclePack_MkE_VehicleServer script.
-- If a player is within range, the door is not locked, and there is nobody in the seat then the function opens the door.
function Tick()

	local nearbyPlayers = {}

	for _, o in ipairs(interractTrigger:GetOverlappingObjects()) do 
		if o:IsA("Player") then
			table.insert(nearbyPlayers, o)
		end
	end
	
	local occupiedSeats = vehicleServer:GetCustomProperty("PlayersInVehicle")
	local locked = vehicleServer:GetCustomProperty("VehicleLock")
	
	for _, t in ipairs(allSeatTriggers) do
		local playerInRange = false
		local door = doors:FindChildByName(t.parent.name)
		
		if not door.clientUserData.VehiclePack then
			door.clientUserData.VehiclePack = {}
		end
		
		for _, p in ipairs(nearbyPlayers) do
			local moduleRange = t:GetCustomProperty("Range")
			local moduleDistance = (p:GetWorldPosition() - t:GetWorldPosition()).size
			
			if moduleDistance <= moduleRange then
				playerInRange = true
			end
		end
		
		if playerInRange and not locked and not door.clientUserData.VehiclePack.isOpen and not string.find(occupiedSeats, t.parent.name) then
			local doorOpen = door:GetCustomProperty("DoorOpened")
			local rotationSpeed = door:GetCustomProperty("RotationSpeed")
			local openSFX = door:GetCustomProperty("OpenSFX"):WaitForObject()
			door:RotateTo(doorOpen, rotationSpeed, true)
			door.clientUserData.VehiclePack.isOpen = true
			
			if Object.IsValid(openSFX) then
				openSFX:Play()
			end
		elseif door.clientUserData.VehiclePack.isOpen then 
			if not playerInRange or locked then
				local doorOpen = door:GetCustomProperty("DoorClosed")
				local rotationSpeed = door:GetCustomProperty("RotationSpeed")
				local closeSFX = door:GetCustomProperty("CloseSFX"):WaitForObject()
				door:RotateTo(doorOpen, rotationSpeed, true)
				door.clientUserData.VehiclePack.isOpen = false
				
				Task.Wait(rotationSpeed/2)
				
				if Object.IsValid(closeSFX) then
					closeSFX:Play()
				end
			end
		end
	end						
	
end