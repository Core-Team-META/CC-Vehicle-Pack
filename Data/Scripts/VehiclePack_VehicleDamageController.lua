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

  Vehicle Damage Controller
  Author: Burnzie

  Drag and drop this script into your vehicles in order allow them to be damaged
--]]

local VEHICLE = script:FindAncestorByType('Vehicle')
if not VEHICLE or not VEHICLE:IsA('Vehicle') then
    VEHICLE = script.parent
end

local MAX_HEALTH = script:GetCustomProperty("MaxHealth")
local DAMAGED_THRESHOLD = script:GetCustomProperty("DamagedThreshold")

local health = MAX_HEALTH

local hasSpawnedDamageFX = false

function DamageVehicle(damage)
  health = health - damage.amount

  script:SetNetworkedCustomProperty("Health", health)

  if health <= 0 then
    Task.Wait()
    if Object.IsValid(VEHICLE) then
      if VEHICLE:IsA("Vehicle") then
        VEHICLE:RemoveDriver()
      end
      VEHICLE:Destroy()
    end
  end
end

function DestroyVehicle()
  script:SetNetworkedCustomProperty("Health", 0)
  Task.Wait()
  if Object.IsValid(VEHICLE) then
    if VEHICLE:IsA("Vehicle") then
      VEHICLE:RemoveDriver()
    end
    VEHICLE:Destroy()
  end
end