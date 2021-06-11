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

-- Internal custom properties
local VEHICLE = script:FindAncestorByType('Vehicle')
if not VEHICLE or not VEHICLE:IsA('Vehicle') then
  VEHICLE = script -- this is if someone wants the turret to be standalone  
end


-- User exposed cutom property
local TURRET_ENTER_SOUND_TEMPLATE = script.parent:GetCustomProperty("TurretEnterSoundTemplate")
local TURRET_EXIT_SOUND_TEMPLATE = script.parent:GetCustomProperty("TurretExitSoundTemplate")
local TURRET_CAMERA = script:GetCustomProperty("TurretCamera"):WaitForObject()
local TURRET_ROOT = script:GetCustomProperty("TurretRoot"):WaitForObject()
local TURRET_ROOT_SERVER = script:GetCustomProperty("TurretRootServer"):WaitForObject()
local TURRET_UI = script:GetCustomProperty("TurretUI"):WaitForObject()
local MUZZLE_1 = script:GetCustomProperty("Muzzle1"):WaitForObject()
local MUZZLE_2 = script:GetCustomProperty("Muzzle2"):WaitForObject()

local FIRE_RATE = TURRET_ROOT_SERVER:GetCustomProperty("FireRate")
local BULLET_TEMPLATE = TURRET_ROOT_SERVER:GetCustomProperty("BulletTemplate")
local FLASH_TEMPLATE = TURRET_ROOT_SERVER:GetCustomProperty("MuzzleFlashTemplate")

local isFiring = false
local fireCooldown = 0

-- Constant variables
local DEFAULT_LIFESPAN = 1

function OnTurretEnter(v)
    if (v:GetObject() ~= VEHICLE and v:GetObject():IsA("Vehicle")) or (v:GetObject():GetCustomProperty("Root") and v:GetObject():GetCustomProperty("Root"):WaitForObject():FindDescendantByName("VehiclePack_Turret_VehicleTurretControllerClient") ~= script) then return end
    SpawnTemplate(TURRET_ENTER_SOUND_TEMPLATE)
    Game.GetLocalPlayer():SetOverrideCamera(TURRET_CAMERA, 0.7)
    TURRET_UI.visibility = Visibility.FORCE_ON
end

function OnTurretExit(v)
    isFiring = false
    SpawnTemplate(TURRET_EXIT_SOUND_TEMPLATE)
    Game.GetLocalPlayer():ClearOverrideCamera()
    if Object.IsValid(TURRET_UI) then
     TURRET_UI.visibility = Visibility.FORCE_OFF
    end
end

function FireTurret()
  local viewRot = TURRET_ROOT:GetWorldRotation()
  local f1 =  World.SpawnAsset(FLASH_TEMPLATE, {position = MUZZLE_1:GetWorldPosition(), rotation = viewRot})
  local f2 =  World.SpawnAsset(FLASH_TEMPLATE, {position = MUZZLE_2:GetWorldPosition(), rotation = viewRot})
end

function NetworkedPropertyChanged(owner, propName) 
  if propName == 'IsFiring' then
    isFiring = owner:GetCustomProperty(propName)
  end
end

function SpawnTemplate(template)
    if template then
        local instance = World.SpawnAsset(template, {parent = VEHICLE})
        if instance.lifeSpan == 0 then
            instance.lifeSpan = DEFAULT_LIFESPAN
        end
    end
end

function Tick(dt)
  TURRET_ROOT:RotateTo(TURRET_ROOT_SERVER:GetWorldRotation(), dt*3)

  if isFiring then
    fireCooldown = fireCooldown - dt
    if fireCooldown < 0 then
      FireTurret()
      fireCooldown = FIRE_RATE
    end
  end
end

--Initialize
Events.Connect("VehiclePack_BattleTruck_VehicleTurretEnter", OnTurretEnter)
Events.Connect("VehiclePack_BattleTruck_VehicleTurretExit", OnTurretExit)

TURRET_ROOT_SERVER.networkedPropertyChangedEvent:Connect(NetworkedPropertyChanged)

TURRET_ROOT:Follow(TURRET_ROOT_SERVER)