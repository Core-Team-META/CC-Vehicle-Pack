--[[

  Author: Burnzie (Team META)

  -- Vehicle Spawners --

  This are very straightfoward. Drag and Drop the 
  VehiclePack_VehicleSpawner template into your game
  at the position and orientation you want your vehicle
  to spawn at. Click on the template, drag the template 
  of the Vehicle you want to spawn in (such as the ATV),
  and set the TimeToRespawn to your desired value (which
  represents how long it will take to respawn your vehicle
  after it is destroyed).

  -- Vehicle Damage --

  In order to let your Vehicles be damageable, drag and drop the 
  VehiclePack_VehicleDamageController template into your vehicle 
  at the top level. Click on it and adjust its properties
  as you wish. NOTE: If you wish to reduce its networked object
  impact, feel free to drag the script inside the damage controller
  into a different client context, it will still work. If you do that,
  you can also delete the ClientContext object inside the controller.
  It's setup this way so it work drag and drop, but it still works
  both ways.

  -- Turrets --

  PLEASE NOTE: It is best to use a VehicleSpawner to spawn turrets
  in your game. If you do not do this, and your turrets are 
  damageable, then your turrets will not respawn.
  
  There are two forms of turrets in this pack: a vehicle mounted 
  turret and a standalone turret. Keep in mind both forms have a
  Server-side and a client-side component. A 'Turret (networked)'
  and a 'Turret (client)'. Select these objects to adjust the
  setting/effects of the turret. 
  
  If you wish to modify the look of the turret, check in the
  ClientContext for the 'Turret Root' and 'Turret Base' groups. 
  These contain the geometry. Adjust the 'Hitbox' object as necessary.
  NOTE: the location of the 'Turret Root' object is the point at which
  the turret will rotate around, so make sure this is at the correct 
  position for your model.

  If you wish to modify the Reticule UI, check under the
  'Turret (client)' object for the 'Reticule' object.

  -- Vehicle Kill Zone --

  Drag and drop the VehiclePack_VehicleKillZone into the game and
  resize to the dimensions and rotation you wish. Whenever a
  Vehicle enters this area, it will be instantly destroyed.
  It usually makes sense to also pair this template with the
  "Kill Zone" in Core Content, which is for players.

--]]