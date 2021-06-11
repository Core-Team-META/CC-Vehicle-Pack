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

  Author: Burnzie

  Keeps a vehicle spawned at a location after a set delay.

  To use: Drag and drop the script into the scene and set a vehicle template for it to spawn.
  Feel free to adjust position and rotation of the script
--]]

local TEMPLATE = script:GetCustomProperty("Vehicle")
local DELAY = script:GetCustomProperty("TimeToRespawn")

local eventHandler = nil
local spawnedVehicle = nil
local vehicleHasDied = false
local countdown = DELAY

function Spawn()
  spawnedVehicle = World.SpawnAsset(TEMPLATE, {position = script:GetWorldPosition(), rotation = script:GetWorldRotation()})
  eventHandler = spawnedVehicle.destroyEvent:Connect(Destroyed)
  vehicleHasDied = false
end

function Destroyed()
  eventHandler:Disconnect()
  spawnedVehicle = nil
  vehicleHasDied = true
end

function Tick(dt)
  if vehicleHasDied then
    countdown = countdown - dt
    if countdown < 0 then
      countdown = DELAY
      Spawn()
    end
  end
end

Spawn()