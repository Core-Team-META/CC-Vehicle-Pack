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

    This script handles the turret and its control by a player
--]]

local ReliableEvents = require(script:GetCustomProperty("VehiclePack_ReliableEvents"))

-- Internal custom properties
local VEHICLE = script:FindAncestorByType('Vehicle')
if not VEHICLE or not VEHICLE:IsA('Vehicle') then
    VEHICLE = script -- this is if someone wants the turret to be standalone
end

local TRIGGER = script:GetCustomProperty("Trigger"):WaitForObject()
local SEAT = script:GetCustomProperty("Seat"):WaitForObject()
local seatInfo = {}
local TURRET = script:GetCustomProperty("Turret"):WaitForObject()
local MUZZLE_1 = script:GetCustomProperty("Muzzle1"):WaitForObject()
local MUZZLE_2 = script:GetCustomProperty("Muzzle2"):WaitForObject()

local STANCE = TURRET:GetCustomProperty("AnimationStance")
local EXIT_BINDING = TURRET:GetCustomProperty("ExitBinding")
local MUST_HAVE_DRIVER = TURRET:GetCustomProperty("MustHaveDriver")
local FIRE_RATE = TURRET:GetCustomProperty("FireRate")
local BULLET_DAMAGE = TURRET:GetCustomProperty("BulletDamage")
local ROTATION_SPEED = TURRET:GetCustomProperty("TurretRotationSpeed")
local BULLET_TEMPLATE = TURRET:GetCustomProperty("BulletTemplate")

local isFiring = false
local fireCooldown = 0

local seats = {}

function FireTurret()
  local viewRot = TURRET:GetWorldRotation() * Vector3.FORWARD
  local bullet1 = Projectile.Spawn(BULLET_TEMPLATE, MUZZLE_1:GetWorldPosition(), viewRot)
  local bullet2 = Projectile.Spawn(BULLET_TEMPLATE, MUZZLE_2:GetWorldPosition(), viewRot)

  if seatInfo.passenger then
    bullet1.owner = seatInfo.passenger
    bullet2.owner = seatInfo.passenger
  end

  bullet1.lifeSpan = 3
  bullet2.lifeSpan = 3  

  bullet1.impactEvent:Connect(BulletHitEvent, t1)
  bullet2.impactEvent:Connect(BulletHitEvent, t2)
  
  bullet1.gravityScale = 0
  bullet2.gravityScale = 0

  --Task.Wait()

  if Object.IsValid(bullet1) and Object.IsValid(bullet2) then
    bullet1.speed = 15000
    bullet2.speed = 15000
  end
end

-- if you want to change want happens when a bullet
-- hits something, edit this function
function BulletHitEvent(projectile, other, hitresult)
  -- don't damage self
  if other == VEHICLE then return end

  -- create Damage
  local damage = Damage.New(BULLET_DAMAGE)
  damage:SetHitResult(hitresult)
  damage.sourcePlayer = projectile.owner
  damage.reason = DamageReason.COMBAT

  if other and other:IsA("Player") then
    other:ApplyDamage(damage)
    return
  end
  if other and other:IsA("Vehicle") then
    -- checks for the specific script to handle damage
    local s = other:FindDescendantByName("VehiclePack_VehicleDamageController")
    if s then
      s.context.DamageVehicle(damage)
    end
    return
  end
  if other and other.name == "Hitbox" then
    -- see if it's parent has the vehicle damage controller
    local s = other.parent:FindDescendantByName("VehiclePack_VehicleDamageController")
    if s then
      s.context.DamageVehicle(damage)
    end
    return
  end
end

function GetSeat(trigger, player)
    if not seatInfo.passenger then
        player.isCollidable = false

        seatInfo.passenger = player
        seatInfo.passengerStance = player.animationStance
        

        player.animationStance = STANCE
        player.isCrouchEnabled = true

        player:AttachToCoreObject(SEAT)


        ReliableEvents.BroadcastToPlayer(player, "VehiclePack_BattleTruck_VehicleTurretEnter", VEHICLE:GetReference())

        Task.Wait()
        seatInfo.bindingHandler = player.bindingPressedEvent:Connect(OnBindingPressed)
        seatInfo.bindingHandler2 = player.bindingReleasedEvent:Connect(OnBindingReleased)
    end
end

function ExitVehicle(player)
    if seatInfo.passenger == player then
        player:Detach()

        seatInfo.passenger = nil
        player.isCollidable = true
        player.animationStance = seatInfo.passengerStance

        if seatInfo.bindingHandler then
            seatInfo.bindingHandler:Disconnect()
        end

        if seatInfo.bindingHandler2 then
          seatInfo.bindingHandler2:Disconnect()
        end

        isFiring = false

        ReliableEvents.BroadcastToPlayer(player, "VehiclePack_BattleTruck_VehicleTurretExit")
    end
end

function OnDestroy()
  if seatInfo.passenger ~= nil then
    ExitVehicle(seatInfo.passenger)
  end
end

function OnBindingPressed(player, binding)
	if binding == EXIT_BINDING then
		ExitVehicle(player)
  end
  if binding == "ability_primary" then
    isFiring = true
    TURRET:SetNetworkedCustomProperty("IsFiring", true)
  end
end

function OnBindingReleased(player, binding)
  if binding == "ability_primary" then
    isFiring = false
    TURRET:SetNetworkedCustomProperty("IsFiring", false)
  end
end

function OnPlayerLeft(player)
    if seatInfo.passenger == player then
        seatInfo.passenger = nil	
        seatInfo.passengerStance = nil

        if seatInfo.bindingHandler then
            seatInfo.bindingHandler:Disconnect()
        end

        if seatInfo.bindingHandler2 then
            seatInfo.bindingHandler2:Disconnect()
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

function GetTurretRotation()
  if seatInfo.passenger then
    -- raycast from the player camera's center 
    local rayStart = seatInfo.passenger:GetViewWorldPosition()
    local cameraForward = seatInfo.passenger:GetViewWorldRotation() * Vector3.FORWARD
    local rayEnd = rayStart + cameraForward * 10000

    local hitResult = World.Raycast(rayStart, rayEnd, {ignorePlayers = true})

    local turretRot
    if hitResult then
      local hitPos = hitResult:GetImpactPosition()
      -- The green line is the impact normal
      turretRot = Rotation.New(hitPos - MUZZLE_1:GetWorldPosition(), Vector3.UP)
    else
      turretRot = Rotation.New(cameraForward, Vector3.UP)
    end

    return turretRot
  end

  return nil
end

function Tick(dt)
  if seatInfo.passenger then
    local turretRot

    if seatInfo.passenger.isMounted then
      seatInfo.passenger:SetMounted(false)
    end

    -- if the car flips over, kick the turret player out
    if VEHICLE:GetWorldTransform():GetUpVector() .. Vector3.UP < -0.707 and seatInfo.passenger ~= nil then
      ExitVehicle(seatInfo.passenger)
      turretRot = VEHICLE:GetWorldRotation()
    else 
      turretRot = GetTurretRotation()
    end

    TURRET:RotateTo(turretRot, ROTATION_SPEED)
  end

  if isFiring then
    fireCooldown = fireCooldown - dt
    if fireCooldown < 0 then
      FireTurret()
      fireCooldown = FIRE_RATE
    end
  end
end

TRIGGER.interactedEvent:Connect(GetSeat)
VEHICLE.destroyEvent:Connect(OnDestroy)
Game.playerLeftEvent:Connect(OnPlayerLeft)

