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

--[[
Voxel Defense Armored Vehicle Launched Bridge (AVLB)
By: estlogic
Last Updated: 6/7/2021


OVERVIEW:

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

- VehicleObject (networked)
	- VehiclePack_AVLB_BridgeArmServer(networked)
	- MainArm (networked)
		- SubArm (networked)
			- Bridge (networked)
				- BridgeHalf1 (networked client-context folder)
					- ...
				- BridgeHalf2 (networked client-context folder)
					- ...
	- ...
	
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
bridge, and bridge half 2 to their target rotations simulatenously. After a half second pause, the bridge template is
spawned in and the visibility of the bridge on the arm is set to force off. After a half second pause the arm retracts 
in reverse order to how it extended.

The animation is the same for when the AVLB is retrieving a bridge, except the visibility of the bridge on the arm is 
set to inherit instead of force off.


VehiclePack_AVLB_BridgeArmClient

The VehiclePack_AVLB_BridgeArmClient is a support module for the VehiclePack_AVLB_BridgeArmServer script. This module 
is responsible for syncing the client-side geo of the arm with the networked groups. This module requires references to 
the same arm components as the ones used by the VehiclePack_AVLB_BridgeArmServer as well as their client-side counterparts. 
The module should be in client-context and the hierarchy should be arranged accordingly:

- VehicleObject (networked)
	- VehiclePack_AVLB_BridgeArmServer(networked)
	- MainArm (networked)
		- ...
	- ClientContext 
		- VehiclePack_AVLB_BridgeArmClient
		- VehiclePack_AVLB_ClientComponents
			- MainArm
				- PistonTop1
					- ...
				- PistionTop2
					- ...
				- PistionTop3
					- ...
				- SubArm
					- PistionBottom3
						- ...
					- ...
				
			- PistionBottom1
				- ... 
			- PistionBottom2
				- ...
			- ExtraFX
				- ...
		- TankBody
			- Hull
				-Treads
					- TreadsLeft
						- Tread
						- Wheels
							- Wheel
							- Wheel
							- ...
					- TreadsRight
						- Tread
						- Wheels
							- Wheel
							- Wheel
							- ...
			- ...
					
				
The client-side counterparts of the networked arm components should have the exact same pivot point position and rotation.
The VehiclePack_AVLB_BridgeArmClient also requires references to additional components such as pistions. The location of the 
pistions in the hierarchy layout above is only a suggestion and can be located anywhere desired. The script also requires 
references to sound effects for the arm movement and bridge equipping.

The VehiclePack_AVLB_BridgeArmClient also handles vehicle movement and vehicle sound effects. The script requires references 
to idle and active sound effects and the left and right tread groups. The left and right tread groups should contain the 
wheels of the vehicle named "Wheel." The script will search for these wheels and set their rotation speed based on the 
movement of the vehicle.

Voxel Defense, at your service.
--]]