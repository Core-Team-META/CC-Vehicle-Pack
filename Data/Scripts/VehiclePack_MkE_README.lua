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
Voxel Motors Mk.E (with Supervoxel Offroad Package)
By: estlogic
Last Updated: 6/7/2021


OVERVIEW:

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

Interract (Open doors or hatches):	F
Toggle headlights:	T
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

- VehicleObject (networked)
	- VehiclePack_MkE_VehicleServer (networked)
	- InterractTrigger (networked)
	- StaticContext (networked)
		- Seats
			- Driver
				- SimulatedEntryTrigger
			- Passenger1
				- SimulatedEntryTrigger
			- ...
		- ModuleMarkers
			- Hatch1
			- Hatch2
			- ...
	- ClientContext
		- ...
		
The interract trigger should also be in the networked context like the VehiclePack_MkE_VehicleServer script. The 
tigger should cover the entire vehicle, and it represents the maximum range the player must be in to interract with 
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

- VehicleObject (networked)
	- VehiclePack_MkE_VehicleServer (networked)
	- InterractTrigger (networked)
	- StaticContext (networked)
		- ...
	- ClientContext
		- VehiclePack_MkE_DoorModule
			- Doors
				- Driver
					- ...
				- Passenger1
					- ...
				- ...
				
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

- VehicleObject (networked)
	- VehiclePack_MkE_VehicleServer (networked)
	- InterractTrigger (networked)
	- StaticContext (networked)
		- ...
	- ClientContext
		- VehiclePack_MkE_HatchModule
			- Hatches
				- Hatch1
					- ...
				- Hatch2
					- ...
				- ...
				
Similar to the doors group in the VehiclePack_MkE_DoorModule, the hatches group contains gorups that share the exact 
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
visiblity of the obstructing groups to force off and changes the camera for viewing the suspension. The driver can 
press the binding again or leave the vehicle to swap the camera back and set the visibility of the obstructing groups 
to inherit.


VehiclePack_MkE_SuspensionEssentialsModule

The VehiclePack_MkE_SuspensionEssentialsModule provides the basic setup for suspension that actively follows the 
wheels. This module requires a reference to the wheel it is assigned to, the wheel rim, the steering knuckle, and the 
moving assembly of the suspension. This module should be in client context and does not require 
VehiclePack_MkE_VehicleServer script. The hierarchy should be arranged accordingly:

- VehicleObject (networked)
	- VehiclePack_MkE_VehicleServer (networked)
	- InterractTrigger (networked)
	- StaticContext (networked)
		- ...
	- ClientContext
		- Wheels 
			- FrontLeftWheel
				- WheelRim
				- ...
			- FrontRightWheel
				- WheelRim
				- ...
			- ...
		- VehiclePack_MkE_SuspensionModules
			- FrontLeftSuspensionModule
				- VehiclePack_MkE_SuspensionEssentialsModule
				- VehiclePack_MkE_SuspensionExtrasModule
				- MovingAssembly
					- SteeringKnuckle
					- ...
				- StationaryAssembly
					- ...
			- FrontRightSuspensionModule
				- ...
			- ...

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

It is hightly recommended to look at the tooltips of the VehiclePack_MkE_SuspensionExtrasModule custom properties,  
go over the position and rotation of each component in each suspension module, and go through the code for the 
VehiclePack_MkE_SuspensionExtrasModule before attempting to replace or modify this module.


Thank you for choosing Voxel Motors.
--]]