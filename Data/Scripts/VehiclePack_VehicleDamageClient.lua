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

local CONTROLLER = script:GetCustomProperty("VehicleDamageController"):WaitForObject()

local MAX_HEALTH = CONTROLLER:GetCustomProperty("MaxHealth")
local DAMAGED_THRESHOLD = CONTROLLER:GetCustomProperty("DamagedThreshold")
local DAMAGE_TEMPLATE = CONTROLLER:GetCustomProperty("VehicleDamagedFX")
local EXPLOSION_TEMPLATE = CONTROLLER:GetCustomProperty("VehicleDestroyedFX")

local health = CONTROLLER:GetCustomProperty("Health")

local hasSpawnedDamageFX = false

local rand = RandomStream.New()

function Damaged()
  local diff = health
  health = CONTROLLER:GetCustomProperty("Health")
  diff = diff - health

  UI.ShowFlyUpText(string.format("%.0f", diff), CONTROLLER:GetWorldPosition() + Vector3.New(rand:GetNumber(-80, 80), rand:GetNumber(-80, 80), rand:GetNumber(-80, 80)),
                {duration = 0.5,
                color = Color.RED,
                isBig = IS_BIG_TEXT})

  if health < DAMAGED_THRESHOLD and not hasSpawnedDamageFX then
    hasSpawnedDamageFX = true
    local t = World.SpawnAsset(DAMAGE_TEMPLATE, {parent = script})
  end

  if health <= 0 then
    Explode()
  end
end

function Explode()
  local t = World.SpawnAsset(EXPLOSION_TEMPLATE, {position = script:GetWorldPosition()})
  t.parent = nil
end

function NetworkedPropertyChanged(owner, propName) 
  if propName == 'Health' then
    Damaged()
  end
end


CONTROLLER.networkedPropertyChangedEvent:Connect(NetworkedPropertyChanged)
script.destroyEvent:Connect(Explode)