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
local interractTrigger = script:GetCustomProperty("InterractTrigger"):WaitForObject()
local seats = script:GetCustomProperty("Seats"):WaitForObject()
local moduleMarkers = script:GetCustomProperty("ModuleMarkers"):WaitForObject()

local interractBinding = script:GetCustomProperty("InterractBinding")
local toggleLightsBinding = script:GetCustomProperty("ToggleLightsBinding")
local leftTurnSignalBinding = script:GetCustomProperty("LeftTurnSignalBinding")
local rightTurnBinding = script:GetCustomProperty("RightTurnBinding")
local hazardBinding = script:GetCustomProperty("HazardBinding")
local hornBinding = script:GetCustomProperty("HornBinding")
local lockBinding = script:GetCustomProperty("LockBinding")

local animationStance = script:GetCustomProperty("AnimationStance")

-- Local Variables
local allSeats = seats:GetChildren()
local allSeatTriggers = seats:FindDescendantsByName("SimulatedEntryTrigger")
local allModules = moduleMarkers:GetChildren()
local triggerListener = {}
local leftListener = nil
local destroyedListener = nil
local playerListener = {}
local recentDriver = nil

local function ToggleFromPropertyString(property, value, toggle)

	local currentString = script:GetCustomProperty(property)
	local newString = currentString
	
	local first, last = string.find(currentString, value .. "|")
	
	if not first and not last then
		if toggle > 0 or toggle < 0 then
			newString = currentString .. value .. "|"
		end
	elseif first and last then
		if toggle == 0 or toggle < 0 then
			newString = string.gsub(currentString, value .. "|", "")
		end
	end
	
	script:SetNetworkedCustomProperty(property, newString)
	
end

-- Function that sets the server user data for all seats and sets up the main trigger.
function Initialize()

	for _, s in ipairs(allSeats) do
		s.serverUserData.VehiclePack = {}
		s.serverUserData.VehiclePack.currentPassenger = nil
		s.serverUserData.VehiclePack.previousStance = nil
	end
	
	if Object.IsValid(interractTrigger) then
		triggerListener.beginOverlap = interractTrigger.beginOverlapEvent:Connect(OnBeginOverlap)
		triggerListener.endOverlap = interractTrigger.endOverlapEvent:Connect(OnEndOverlap)	
	end
	
end

function FindNearestModule(player)

	local nearestModule = nil
	local playerLocation = player:GetWorldPosition()
	local moduleLocation = nil
	local moduleRange = nil
	local moduleDistance = nil
	local shortestDistance = math.huge
	
	for _, t in ipairs(allSeatTriggers) do
		moduleLocation = t:GetWorldPosition()
		moduleRange = t:GetCustomProperty("Range")
		moduleDistance = (moduleLocation - playerLocation).size 
		
		if moduleDistance < shortestDistance and moduleDistance <= moduleRange then
			shortestDistance = moduleDistance
			nearestModule = t.parent
		end
	end
	
	for _, t in ipairs(allModules) do
		moduleLocation = t:GetWorldPosition()
		moduleRange = t:GetCustomProperty("Range")
		moduleDistance = (moduleLocation - playerLocation).size 
		
		if moduleDistance < shortestDistance and moduleDistance <= moduleRange then
			shortestDistance = moduleDistance
			nearestModule = t
		end
	end
	
	return nearestModule

end

-- Function that Performs several tasks:
-- The function checks the binding pressed and processes it based on if it is the interract binding or not.
-- If the binding is the interraction binding, the function checks if the vehicle is locked.
-- If the vehicle is not locked, the function finds the nearest module within range.
-- The function could either assign or remove a driver, assign or remove a passenger, or toggle a hatch module depending on the nearest module and server user data.
-- If the binding is not the interraction binding, the function checks if the player is the driver.
-- If the player is the driver, then the function changes custom properties based on which driver specific bindings was pressed.
-- If the player is not the driver, then the function checks if the interract button was pressed and lets the player leave the vehicle if they were locked inside.
function OnBindingPressed(player, binding)

	if not playerListener[player] then
		playerListener[player] = {}
	end

	if playerListener[player].bindingProcessing then
		return
	end
	
	playerListener[player].bindingProcessing = true
	
	local vehicleLock = script:GetCustomProperty("VehicleLock")
	local driverOverride = player == vehicle.driver or not vehicleLock
	
	if binding == interractBinding and driverOverride then -- Interractables from the outside.
		local nearestModule = FindNearestModule(player)
		
		if Object.IsValid(nearestModule) and string.find(nearestModule.name, "Driver") and not vehicle.driver then
			recentDriver = player
			nearestModule.serverUserData.VehiclePack.currentPassenger = player
			playerListener[player].passengerSeat = nearestModule
			playerListener[player].bindingReleasedListener = player.bindingReleasedEvent:Connect(OnBindingReleased)
			script:SetNetworkedCustomProperty("ActiveToggle", true)
			vehicle:SetDriver(player)
			ToggleFromPropertyString("PlayersInVehicle", player.id .. ":" .. nearestModule.name, 1)
		elseif vehicle.driver == player then
			local seatModule = playerListener[player].passengerSeat
			seatModule.serverUserData.VehiclePack.currentPassenger = nil
			playerListener[player].bindingReleasedListener:Disconnect()
			playerListener[player].bindingReleasedListener = nil
			script:SetNetworkedCustomProperty("VehicleLock", false)
			script:SetNetworkedCustomProperty("ActiveToggle", false)
			vehicle:RemoveDriver(player)
			ToggleFromPropertyString("PlayersInVehicle", player.id .. ":" .. seatModule.name, 0)
			player:SetWorldPosition(seatModule:GetChildren()[1]:GetWorldPosition() + Vector3.New(-40, -20, 100))
		elseif Object.IsValid(nearestModule) and string.find(nearestModule.name, "Passenger") and not nearestModule.serverUserData.VehiclePack.currentPassenger then
			nearestModule.serverUserData.VehiclePack.currentPassenger = player
			playerListener[player].previousStance = player.animationStance
			player.isCollidable = false
			Task.Wait()
            player:AttachToCoreObject(nearestModule)
            player.animationStance = animationStance
            playerListener[player].passengerSeat = nearestModule
            ToggleFromPropertyString("PlayersInVehicle", player.id .. ":" .. nearestModule.name, 1)
        elseif playerListener[player].passengerSeat and vehicle.driver ~= player then
        	local seatModule = playerListener[player].passengerSeat
			seatModule.serverUserData.VehiclePack.currentPassenger = nil
			playerListener[player].passengerSeat = nil
			player:Detach()
			player.isCollidable = true
			if playerListener[player].previousStance then
           		player.animationStance = playerListener[player].previousStance
           	end
            playerListener[player].isPassenger = false
            ToggleFromPropertyString("PlayersInVehicle", player.id .. ":" .. seatModule.name, 0)
        elseif Object.IsValid(nearestModule) and not string.find(nearestModule.name, "Passenger") and not string.find(nearestModule.name, "Driver") then
        	ToggleFromPropertyString("ActiveModules", nearestModule.name, -1)
        end 
    elseif player == vehicle.driver then -- Driver specific interractables.
		local turnSignalState = script:GetCustomProperty("TurnSignalState")
		local lightState = script:GetCustomProperty("LightsToggle")
		
		if binding == "ability_extra_31" then
			script:SetNetworkedCustomProperty("Reversing", true)
		elseif binding == hornBinding then 
			script:SetNetworkedCustomProperty("HornToggle", true)
		elseif binding == leftTurnSignalBinding then
			if turnSignalState == 1 then
				script:SetNetworkedCustomProperty("TurnSignalState", 0)
			else 
				script:SetNetworkedCustomProperty("TurnSignalState", 1)
			end
		elseif binding == rightTurnBinding then
			if turnSignalState == 2 then
				script:SetNetworkedCustomProperty("TurnSignalState", 0)
			else 
				script:SetNetworkedCustomProperty("TurnSignalState", 2)
			end	
		elseif binding == toggleLightsBinding then
			if not lightState then
				script:SetNetworkedCustomProperty("LightsToggle", true)
			else
				script:SetNetworkedCustomProperty("LightsToggle", false)
			end
		elseif binding == hazardBinding then
			if turnSignalState == -1 then
				script:SetNetworkedCustomProperty("TurnSignalState", 0)
			else 
				script:SetNetworkedCustomProperty("TurnSignalState", -1)
			end
		elseif binding == lockBinding then
			if not vehicleLock then
				script:SetNetworkedCustomProperty("VehicleLock", true)
			else
				script:SetNetworkedCustomProperty("VehicleLock", false)
			end
		end
	elseif binding == interractBinding and playerListener[player].passengerSeat then -- Emergency exit. (when vehicle is locked)
    	local seatModule = playerListener[player].passengerSeat
		seatModule.serverUserData.VehiclePack.currentPassenger = nil
		playerListener[player].passengerSeat = nil
		player:Detach()
		player.isCollidable = true
		if playerListener[player].previousStance then
       		player.animationStance = playerListener[player].previousStance
       	end
        playerListener[player].isPassenger = false
        ToggleFromPropertyString("PlayersInVehicle", player.id .. ":" .. seatModule.name, 0)
	end
	
	Task.Wait(0.2)
	
	script:SetNetworkedCustomProperty("HornToggle", false)
	
	playerListener[player].bindingProcessing = false

end

-- Function that releases the turn signals and reverse lights. (Binding listener is only attached to the driver)
function OnBindingReleased(player, binding)

	local turnSignalState = script:GetCustomProperty("TurnSignalState")

	if binding == "ability_extra_31" then
		script:SetNetworkedCustomProperty("Reversing", false)
	elseif binding == "ability_extra_30" and turnSignalState == 1 then
		script:SetNetworkedCustomProperty("TurnSignalState", 0)
	elseif binding == "ability_extra_32" and turnSignalState == 2 then
		script:SetNetworkedCustomProperty("TurnSignalState", 0)
	end

end

-- Function that connects binding listeners to players only if the player is in the main trigger.
function OnBeginOverlap(trigger, other)

	if not other or not other:IsA("Player") then
		return
	end
	
	if not other.serverUserData.VehiclePack then
		other.serverUserData.VehiclePack = {}
	end
	
	if not playerListener[other] then
		playerListener[other] = {}
	end
	
	playerListener[other].bindingPressedListener = other.bindingPressedEvent:Connect(OnBindingPressed)
	
end 

-- Function that removes binding listeners from a player once the player leaves the main trigger.
function OnEndOverlap(trigger, other)

	if not other or not other:IsA("Player") then
		return
	end
	
	for _, s in ipairs(allSeats) do
		if s.serverUserData.VehiclePack.currentPassenger == other then
			return
		end
	end	
	
	OnPlayerLeft(other)

end

-- Function that resets modules that the player was in when leaving the game. (This resets the driver and passenger seats)
function OnPlayerLeft(player)

	if playerListener[player] and playerListener[player].bindingPressedListener then
		playerListener[player].bindingPressedListener:Disconnect()
		playerListener[player].bindingPressedListener = nil
	end
	
	for _, s in ipairs(allSeats) do
		if s.serverUserData.VehiclePack.currentPassenger == player then
			s.serverUserData.VehiclePack.currentPassenger = nil
			ToggleFromPropertyString("PlayersInVehicle", player.id .. ":" .. s.name, 0)
		end
	end
	
	if player == recentDriver then
		if playerListener[player] and playerListener[player].bindingReleasedListener then
			playerListener[player].bindingReleasedListener:Disconnect()
			playerListener[player].bindingReleasedListener = nil
		end
		
		script:SetNetworkedCustomProperty("VehicleLock", false)
		script:SetNetworkedCustomProperty("ActiveToggle", false)
		recentDriver = nil
	end 
	
end

function OnDestroyed(destroyedVehicle)

	destroyedListener:Disconnect()

	for p, v in ipairs(playerListener) do
		if v and v.bindingPressedListener then
			v.bindingPressedListener:Disconnect()
		end
		
		if v and v.bindingReleasedListener then
			v.bindingReleasedListener:Disconnect()
		end
	end
	
	leftListener:Disconnect()
	
	if triggerListener.beginOverlap then
		triggerListener.beginOverlap:Disconnect()
	end
	
	if triggerListener.endOverlap then
		triggerListener.endOverlap:Disconnect()
	end

end

-- Initialization
Initialize()
leftListener = Game.playerLeftEvent:Connect(OnPlayerLeft)
destroyedListener = vehicle.destroyEvent:Connect(OnDestroyed)