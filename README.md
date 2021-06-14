<div align="center">

# CC-Vehicle-Pack

A drag and drop vehicle template pack.

[![Build Status](https://github.com/Core-Team-META/CC-Vehicle-Pack/workflows/CI/badge.svg)](https://github.com/Core-Team-META/CC-Vehicle-Pack/actions/workflows/ci.yml?query=workflow%3ACI%29)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/Core-Team-META/CC-Vehicle-Pack?style=plastic)

![TitleCard](/Screenshots/Vehicles.png)

</div>

## Overview

## Setup and Info

### Vehicle Spawners

This are very straightforward. Drag and Drop the
VehiclePack_VehicleSpawner template into your game
at the position and orientation you want your vehicle
to spawn at. Click on the template, drag the template
of the Vehicle you want to spawn in (such as the ATV),
and set the TimeToRespawn to your desired value (which
represents how long it will take to respawn your vehicle
after it is destroyed).

### Vehicle Damage

In order to let your Vehicles be damageable, drag and drop the
VehiclePack_VehicleDamageController template into your vehicle
at the top level. Click on it and adjust its properties
as you wish. NOTE: If you wish to reduce its networked object
impact, feel free to drag the script inside the damage controller
into a different client context, it will still work. If you do that,
you can also delete the ClientContext object inside the controller.
It's setup this way so it work drag and drop, but it still works
both ways.

### Turrets

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

### Vehicle Kill Zone

Drag and drop the VehiclePack_VehicleKillZone into the game and
resize to the dimensions and rotation you wish. Whenever a
Vehicle enters this area, it will be instantly destroyed.
It usually makes sense to also pair this template with the
"Kill Zone" in Core Content, which is for players.

### AVLB

The AVLB is a specialized vehicle designed to place bridges accross gaps in the terrain. This vehicle can be useful for
an obstacle or puzzle game with unique obstacles or used as a key to unlock parts of a map that would have been
impossible to reach otherwise. The AVLB can set multiple bridges down at a time and can pick the bridges it placed back
up. Each AVLB in the game can only pick up the bridges it dropped and cannot pick up bridges laid by other AVLBs. The
number of bridges an AVLB can place can be controlled by the creator through a custom property.

For use in third person games where the player has control over their character (such as in an RPG or open world), the
AVLB is truly drag-and-drop ready. No setup required.

For use in in other games (such as first person games, or vehicle locked racing games), the AVLB just requires
adjustment with the vehicle object settings. The driver camera should be changed or removed for first person games, and
the exit binding should be set to none for vehicle locked games.

For more details, see the module descriptions below, look at the tooltips for each custom property, or view the
code inside each module script. Both module has all of the necessary components to function in the AVLB example, so
it is recommended to look at the groups the belong to each module in the AVLB example before modifying the vehicle.
The groups used for each module can be found by hovering over the custom property containing the group reference,
right click, and select "Find in Hierarchy." Custom property tooltips can be found by hovering over the name of the
custom property.

DEFAULT BINDINGS:

Place or remove a bridge: Left Click
Replace (reload) a new bridge: Right Click
Reset all bridges: Space

MODULES:

VehiclePack_AVLB_BridgeArmServer

The VehiclePack_AVLB_BridgeArmServer is the key component for the bridge launching feature. This script is responsible
for the animation of the arm, spawning or despawning the physical bridges, and keeping track of the bridges placed.
The script should be networked and the hierarchy should be arranged accordingly:

![Screenshot (981)](https://user-images.githubusercontent.com/55603848/121970681-e8ebfe00-cd2b-11eb-990b-5e8fa978a068.png)

The pivot point for the main arm group should be placed where the base hinge joint of the main arm would be on the
vehicle. The pivot point for the sub arm group should be placed where the secondary hinge joint of the main arm would
be on the vehicle. if the AVLB arm was a human arm, the main arm group should be located at the shoulder and the sub
arm group should be located on the elbow. The bridge pivot point should be located where the bridge and the arm
connect, and the pivot point for the bridge half 2 should be located at the center hinge joint of the bridge. The
rotation of all groups needs to be zero and the entire arm needs to be in the folded state by default.

The VehiclePack_AVLB_BridgeArmServer script requires a reference to the vehicle object, an asset reference to a
template of the placable bridge, and references to the arm components. The VehiclePack_AVLB_BridgeArmServer script also
needs the extended rotation for each component and the time it takes for that component to finish extending or
retracting. The bridge and bridge half 2 do not have an animation time since they animate with the sub arm.
The maximum number of bridges the AVLB can place, the position the bridges spawn relative to the vehicle, and the
desired bindings for placing, replacing, and resetting the bridges can be assigned in the custom properties of the
VehiclePack_AVLB_BridgeArmServer script.

The bridge template should be a flattened physics cube with a client-context folder contianing the geo of the bridge in
its extended state. For best effect, the bridge should use the exact same geo from the bridge halves used on the
vehicle itself.

The AVLB places the bridge by first extending the main arm to its target rotation. Then the AVLB extends the sub arm,
bridge, and bridge half 2 to their target rotations simultaneously. After a half second pause, the bridge template is
spawned in and the visibility of the bridge on the arm is set to force off. After a half second pause the arm retracts
in reverse order to how it extended.

The animation is the same for when the AVLB is retrieving a bridge, except the visibility of the bridge on the arm is
set to inherit instead of force off.

VehiclePack_AVLB_BridgeArmClient

The VehiclePack_AVLB_BridgeArmClient is a support module for the VehiclePack_AVLB_BridgeArmServer script. This module
is responsible for syncing the client-side geo of the arm with the networked groups. This module requires references to
the same arm components as the ones used by the VehiclePack_AVLB_BridgeArmServer as well as their client-side counterparts.
The module should be in client-context and the hierarchy should be arranged accordingly:

![Screenshot (982)](https://user-images.githubusercontent.com/55603848/121970717-fef9be80-cd2b-11eb-8e9d-6eb3297b2e54.png)
![Screenshot (983)](https://user-images.githubusercontent.com/55603848/121970720-00c38200-cd2c-11eb-8764-867aab2d5a86.png)

The client-side counterparts of the networked arm components should have the exact same pivot point position and rotation.
The VehiclePack_AVLB_BridgeArmClient also requires references to additional components such as pistons. The location of the
pistons in the hierarchy layout above is only a suggestion and can be located anywhere desired. The script also requires
references to sound effects for the arm movement and bridge equipping.

The VehiclePack_AVLB_BridgeArmClient also handles vehicle movement and vehicle sound effects. The script requires references
to idle and active sound effects and the left and right tread groups. The left and right tread groups should contain the
wheels of the vehicle named "Wheel." The script will search for these wheels and set their rotation speed based on the
movement of the vehicle.

Voxel Defense, at your service.

### Voxel MkE

The Mk.E is an easy to use vehicle that has a variety of quality of life features such as opening doors, opening hood
and tailgate, turn signals, hazzard lights, daytime running lights, head lights, tail lights, reverse lights, horn,
first person view, and working suspension. The features are implemented in modules, making it easy to add or remove
specific features.

For use in third person games where the player has control over their character (such as in an RPG or open world), the
Mk.E is truly drag-and-drop ready. No setup required.

For use in first person games, the Mk.E just requires the VehiclePack_MkE_FirstPersonCamModule script and cameras in
the vehicle to be removed.

For use in vehicle locked games (such as racing games), the Mk.E only needs a quick setup. The seat markers should
be removed, the VehiclePack_MkE_DoorModule script should be removed, and the interract binding should be set to a
blank entry (empty string) under the VehiclePack_MkE_VehicleServer script custom properties.

For more details, see the module descriptions below, look at the tooltips for each custom property, or view the
code inside each module script. Each module has all of the necessary components to function in the Mk.E example, so
it is recommended to look at the groups the belong to each module in the Mk.E example before modifying the vehicle.
The groups used for each module can be found by hovering over the custom property containing the group reference,
right click, and select "Find in Hierarchy." Custom property tooltips can be found by hovering over the name of the
custom property.

DEFAULT BINDINGS:

Interract (Open doors or hatches): F
Toggle headlights: T
Left turn signal: Q
Right turn signal: E
Hazzard lights: H
Horn: Shift
Lock the vehicle (Does not lock players in, only works while driver is in the vehicle): X
First person camera: C
Suspension testing camera (default disabled): V

MODULES:

VehiclePack_MkE_VehicleServer

The VehiclePack_MkE_VehicleServer script is a key component that a few modules rely on. This script contains custom
properities to set the bindings for the various interractions with the vehicle. This script keeps track of the
interractions between the players and the vehicles. The script then changes custom properties as a method of sending
information to the client-side modules about the state of the vehicle (if a seat is occupied, a hatch is open, etc.).
This script should be networked and it is recommended to have this script as a child of the vehicle object.

It is assumed that the vehicle will attach the driver automatically, so it is suggested to set the vehicle to attach
the driver and set the positioning and animation stance for the driver in the Driver settings of the vehicle object
properties. The enter trigger property should be empty and the exit binding should be set to none under the driver
settings.

Aside from needing a reference to the vehicle object and setting up the bindings, the VehiclePack_MkE_VehicleServer
script can use three other references: the interract trigger, the seats group, and the module markers group. The
hierarchy should be arranged accordingly:

![Screenshot (985)](https://user-images.githubusercontent.com/55603848/121971250-2a30dd80-cd2d-11eb-9695-6f52066e76a6.png)

The interract trigger should also be in the networked context like the VehiclePack_MkE_VehicleServer script. The
trigger should cover the entire vehicle, and it represents the maximum range the player must be in to interract with
the components of the vehicle (open doors, open hatches etc.). ironically, the interract trigger should not be
interractable. The interract trigger serves as one large trigger to help several simulated triggers work.

The seats and module marker groups should be inside a static context group to reduce networked object count.

The seats group contains objects that need to have specific names. Direct children to the seats group must contain
the word "Driver" or "Passenger." There should only be one driver object, and the name of passenger objects must be
different. Each driver or passenger object should be moved to where the player will be located in the vehicle for
that corresponding seat. Each driver or passenger object needs a child called "SimulatedEntryTrigger." This object
should be located where a trigger would be to open the corresponding door. The simulated trigger requires one
custom property: an integer called "Range." Range determines how close the player must be to interract with the
simulated trigger.

The module markers group contain objects that can have any name. Each child of the module markers group should
have a unique name. These should be setup like the simulated entry triggers for the seats (including the setting
the range custom property). The children of the module markers group are simulated triggers for openable hatches on
the vehicle such as a hood and trunk.

VehiclePack_MkE_DoorModule

The VehiclePack_MkE_DoorModule animates the doors of the vehicle to open and close. This module requires a reference
to the VehiclePack_MkE_VehicleServer script, the interract trigger, the seats group in the networked context, and a
doors group in client-context. This script should be in client context, and the hierarchy should be arranged
accordingly:

![Screenshot (986)](https://user-images.githubusercontent.com/55603848/121971229-1f764880-cd2d-11eb-85cc-b2ad3a7d119e.png)


The doors group contains groups that share the exact same names for the children of the seats group. Each group in the
doors group should be located at the hinge of their corresponding door and contain the following custom properties:
a rotation called "DoorClosed," a rotation called "DoorOpened," a float called "RotationSpeed," an object reference
called "CloseSFX," and an object reference called "OpenSFX." the door opened and door closed custom properties set the
rotation for when the door is opened and closed, the rotation speed custom property set how long it takes for the door
to open or close, and the close sound effect and open sound effect custom properties are references to sound effect
objects that will play when the door is closed or opened.

To open a door, the VehiclePack_MkE_DoorModule checks if a player is within range of a simulated trigger in the seats
group and checks the "PlayersInVehicle" and "VehicleLock" custom properties in the VehiclePack_MkE_VehicleServer
script. If the door is opened only if a player is within range of a trigger, the name of the door is not in the
"PlayersInVehicle" custom property, and the vehicle lock is disabled. Otherwise, the door is closed.

VehiclePack_MkE_HatchModule

The VehiclePack_MkE_HatchModule animates the hatches of the vehicle to open or close. This module requires a reference
to the VehiclePack_MkE_VehicleServer script and the hatches group in client-context. This script should be in client
context, and the hierarchy should be arranged accordingly:

![Screenshot (987)](https://user-images.githubusercontent.com/55603848/121971212-19806780-cd2d-11eb-9fdd-d990aee29037.png)

Similar to the doors group in the VehiclePack_MkE_DoorModule, the hatches group contains groups that share the exact
same names for the children of the module markers group. Each group in the hatches group should be located at the
hinge of their corresponding hatch. Each group should contain the same custom properties as the the door groups, but
"DoorClosed" and "DoorOpened" should be renamed to "HatchClosed" and "HatchOpened" respectively.

To open a hatch, the VehiclePack_MkE_HatchModule checks the "ActiveModules" custom property in the
VehiclePack_MkE_VehicleServer script. If the name of the hatch is in the string of this custom property, the hatch is
opened. If the name is not in the string, the hatch is closed.

VehiclePack_MkE_LightsAndHornModule

The VehiclePack_MkE_LightsAndHornModule controls the lights of the vehicle based on the bindings pressed by the driver
and the state of the vehicle (if the vehicle has a driver, if the the vehicle is reversing, etc.). This module
requires a reference to the vehicle object, the VehiclePack_MkE_VehicleServer script, groups containing the on and off
versions of each type of light on the vehicle, light sound effects, the horn sound effect, and the vehicle lock sound
effect. This module should be in client context.

By default, the visibility for the on versions of each light should be set to force off. The groups with the on
version of certain lights, such as the headlights, should contain a light source (such as a point light object).

Headlights and turn signals are controlled by the driver. The light toggle sound effect plays when the driver turns
the headlights on or off. The turn signal sound effect plays each time the turn signal toggles on and off.
Turn signals turn off automatically after the driver completes the corresponding turn. Tail lights turn on
automatically when the driver applies the brake or handbrake. The reverse lights turn on automatically when the
driver moves the vehicle in reverse.

VehiclePack_MkE_FirstPersonCamModule

The VehiclePack_MkE_FirstPersonCamModule enables the driver and passengers to swap between the default third person
camera and a specific first person camera. This module requires a reference to the VehiclePack_MkE_VehicleServer
script, the default third person camera for the vehicle, and the first person cameras group. The module also requires
the desired binding to toggle between the cameras. This module should be in client context.

The first person cameras group contains a camera for the driver and each of the passengers. The cameras are set in
a location where the player's head would be for each seating position. The name of each camera must the identical to
the name of the seat the camera is for.

When a player presses the binding to swap cameras, the VehiclePack_MkE_FirstPersonCamModule checks the
"PlayersInVehicle" custom property of the VehiclePack_MkE_VehicleServer script to check if the player is in the
vehicle and what seat the player is in. Then the VehiclePack_MkE_FirstPersonCamModule saves the current default
camera and sets a new camera that corresponds with the seat the player is in. When the player toggles the camera
back or leaves the vehicle, the VehiclePack_MkE_FirstPersonCamModule restores the camera to the previous default
camera.

VehiclePack_MkE_ElectricMotorSoundModule

The VehiclePack_MkE_ElectricMotorSoundModule controls the sound effects created by the vehicle when idling and
moving. This module requires a reference to the vehicle object, a reference to the looping sound effect for when the
vehicle is idle, a reference to the looping sound effect for when the vehicle is moving, and a reference to the
looping sound effect that simulates the sound the vehicle going over terrain. The sound modifier and sound start pitch
affect the starting pitch of the active sound effect and how much the pitch of the active sound effect is affected by
vehicle speed. This module should be in client context and does not require VehiclePack_MkE_VehicleServer script.

When a driver is in the vehicle, the VehiclePack_MkE_ElectricMotorSoundModule plays the idle sound effect. As the
vehicle starts moving, the VehiclePack_MkE_ElectricMotorSoundModule plays the active sound effect and terrain sound
effect.

VehiclePack_MkE_TestSuspensionCamModule

The VehiclePack_MkE_ElectricMotorSoundModule is a testing module intended for creators to check if their customized
version of the suspension is working correctly.This module requires a reference to the vehicle object, a reference
to the camera for viewing the suspension, and references to groups that would obstruct the view of the suspension. The
module also requires the binding to toggle the camera and a list of other bindings that can change the camera (such as
the binding set in the VehiclePack_MkE_FirstPersonCamModule). Only the driver has access to this feature, and the
feature can be disabled entirely by unchecking the "EnableTestCam" custom property. This module should be in client
context and does not require VehiclePack_MkE_VehicleServer script.

When the driver presses the the binding to swap cameras, the VehiclePack_MkE_TestSuspensionCamModule sets the
visibility of the obstructing groups to force off and changes the camera for viewing the suspension. The driver can
press the binding again or leave the vehicle to swap the camera back and set the visibility of the obstructing groups
to inherit.

VehiclePack_MkE_SuspensionEssentialsModule

The VehiclePack_MkE_SuspensionEssentialsModule provides the basic setup for suspension that actively follows the
wheels. This module requires a reference to the wheel it is assigned to, the wheel rim, the steering knuckle, and the
moving assembly of the suspension. This module should be in client context and does not require
VehiclePack_MkE_VehicleServer script. The hierarchy should be arranged accordingly:

![Screenshot (988)](https://user-images.githubusercontent.com/55603848/121971199-11c0c300-cd2d-11eb-8838-6e624fe68a65.png)

When making a new suspension unit or adjusting the wheel height, it is recommended to keep the pivot point of the
client context folder and the parent of the suspension model to zero to make it easier to copy the position of
wheels of the vehicle object. The pivot of the moving assembly should have the exact same position as its
corresponding wheel. The steering knuckle should be close to the wheel and in between the body and the wheel. The
steering knuckle should be rotated such that it is facing the wheel (in local view, the red (X) position arrow should
be facing towards the wheel). The reference for the rim of the wheel can be any object in the center front edge of the
wheel (the object should be in front of the steering knuckle).

The suspension works by having the moving assembly follow the wheel while the steering knuckle continuously looks at
the wheel rim. When the driver steers the vehicle, the steering knuckle for the front wheels rotate left or right
along with the wheels.

VehiclePack_MkE_SuspensionExtrasModule

The VehiclePack_MkE_SuspensionExtrasModule is a specialized module for animating the suspension of the Mk.E. This
module requires references for the entire suspension module and the major components for the suspension. Each
component also requires a reference to its target object.

The additional suspension works by having each component continuously look at its target. As long as the suspension
does not overextend, it will look like the components are connecting the wheel to the body of the vehicle. If the
"EnableRotatingAxle" custom property is enabled, the axle that would drive the wheel will rotate with the wheel.
The rotation of the axle is affected by which way the vehicle is moving, the speed of the vehicle, and the axle
rotation modifier custom property. The axle rotation modifier should be set to a positive number for left side
suspension modules and a negative number for right side suspension modules. The VehiclePack_MkE_SuspensionExtrasModule
rotates the axle by searching for groups or objects labeled "RotateThis" inside the suspension module and setting
the rotation of those groups or objects. The VehiclePack_MkE_SuspensionExtrasModule also searches for groups called
"AntiRoll." There is an anti roll group as a child for each component, and each anti roll group contains the geo for
the corresponding component. The VehiclePack_MkE_SuspensionExtrasModule modifies the rotation of the anti roll group
to maintain the correct orientation for each component. Without anti roll, the components can rotate freely along
their local X axis.

It is highly recommended to look at the tooltips of the VehiclePack_MkE_SuspensionExtrasModule custom properties,
go over the position and rotation of each component in each suspension module, and go through the code for the
VehiclePack_MkE_SuspensionExtrasModule before attempting to replace or modify this module.

Thank you for choosing Voxel Motors.

## Credits

- Developer: [estlogic (META)](https://www.coregames.com/user/385b45d7abdb499f8664c6cb01df521b)
- Developer: [Burnzie (META)](https://www.coregames.com/user/05844b173bca411582347a1d07d953f2)
