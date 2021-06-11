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

    This script handles passengers that sits with the driver.
--]]

local ReliableEvents = require(script:GetCustomProperty("VehiclePack_ReliableEvents"))

-- Internal custom properties
local VEHICLE = script:FindAncestorByType('Vehicle')
if not VEHICLE:IsA('Vehicle') then
    error(script.name .. " should be part of Vehicle object hierarchy.")
end

local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()
local SEATS = script:GetCustomProperty("Seats"):WaitForObject()
local STANCE = script:GetCustomProperty("AnimationStance")
local EXIT_BINDING = script:GetCustomProperty("ExitBinding")
local MUST_HAVE_DRIVER = script:GetCustomProperty("MustHaveDriver")

local seats = {}

function GetSeat(trigger, player)
    for _, seatInfo in ipairs(seats) do
        if not seatInfo.passenger then
            player.isCollidable = false

            seatInfo.passenger = player
            seatInfo.passengerStance = player.animationStance
            

            player.animationStance = STANCE
            player.isCrouchEnabled = true

            player:AttachToCoreObject(seatInfo.seat)


            ReliableEvents.BroadcastToPlayer(player, "VehiclePack_VehiclePassengerEnter")

            Task.Wait()
            seatInfo.bindingHandler = player.bindingPressedEvent:Connect(OnBindingPressed)
            break
        end
    end
end

function ExitVehicle(player)
    for _, seatInfo in ipairs(seats) do
        if seatInfo.passenger == player then
            player:Detach()

            seatInfo.passenger = nil
			player.isCollidable = true
			player.animationStance = seatInfo.passengerStance

            if seatInfo.bindingHandler then
                seatInfo.bindingHandler:Disconnect()
            end

            ReliableEvents.BroadcastToPlayer(player, "VehiclePack_VehiclePassengerExit")
            break
        end
    end
end

function OnBindingPressed(player, binding)
	if binding == EXIT_BINDING then
		ExitVehicle(player)
	end
end

function OnPlayerLeft(player)
    for _, seatInfo in ipairs(seats) do
        if seatInfo.passenger == player then
			seatInfo.passenger = nil	
			seatInfo.passengerStance = nil

            if seatInfo.bindingHandler then
                seatInfo.bindingHandler:Disconnect()
            end
            break
        end
    end
end

function OnDriverEntered(vehicle, player)
    TRIGGER.isInteractable = true
end

function OnDriverExited(vehicle, player)
    TRIGGER.isInteractable = false
end

--Initialize
if MUST_HAVE_DRIVER then
    VEHICLE.driverEnteredEvent:Connect(OnDriverEntered)
    VEHICLE.driverExitedEvent:Connect(OnDriverExited)
    TRIGGER.isInteractable = false
end

TRIGGER.interactedEvent:Connect(GetSeat)
Game.playerLeftEvent:Connect(OnPlayerLeft)

for index, child in ipairs(SEATS:GetChildren()) do
    table.insert(seats, {
        seat = child
    })
end

