Assets {
  Id: 10622349094141400834
  Name: "VehiclePack_MkE_VehicleServer"
  PlatformAssetType: 3
  TextAsset {
    CustomParameters {
      Overrides {
        Name: "cs:Vehicle"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:InterractTrigger"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:Seats"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:ModuleMarkers"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:InterractBinding"
        String: "ability_extra_33"
      }
      Overrides {
        Name: "cs:ToggleLightsBinding"
        String: "ability_extra_24"
      }
      Overrides {
        Name: "cs:LeftTurnSignalBinding"
        String: "ability_extra_20"
      }
      Overrides {
        Name: "cs:RightTurnBinding"
        String: "ability_extra_22"
      }
      Overrides {
        Name: "cs:HazardBinding"
        String: "ability_extra_35"
      }
      Overrides {
        Name: "cs:HornBinding"
        String: "ability_extra_17"
      }
      Overrides {
        Name: "cs:LockBinding"
        String: "ability_extra_40"
      }
      Overrides {
        Name: "cs:AnimationStance"
        String: "unarmed_sit_car_low"
      }
      Overrides {
        Name: "cs:VehicleLock"
        Bool: false
      }
      Overrides {
        Name: "cs:Reversing"
        Bool: false
      }
      Overrides {
        Name: "cs:ActiveToggle"
        Bool: false
      }
      Overrides {
        Name: "cs:HornToggle"
        Bool: false
      }
      Overrides {
        Name: "cs:LightsToggle"
        Bool: false
      }
      Overrides {
        Name: "cs:TurnSignalState"
        Int: 0
      }
      Overrides {
        Name: "cs:ActiveModules"
        String: ""
      }
      Overrides {
        Name: "cs:PlayersInVehicle"
        String: ""
      }
      Overrides {
        Name: "cs:ActiveModules:isrep"
        Bool: true
      }
      Overrides {
        Name: "cs:PlayersInVehicle:isrep"
        Bool: true
      }
      Overrides {
        Name: "cs:HornToggle:isrep"
        Bool: true
      }
      Overrides {
        Name: "cs:ActiveToggle:isrep"
        Bool: true
      }
      Overrides {
        Name: "cs:VehicleLock:isrep"
        Bool: true
      }
      Overrides {
        Name: "cs:LightsToggle:isrep"
        Bool: true
      }
      Overrides {
        Name: "cs:TurnSignalState:isrep"
        Bool: true
      }
      Overrides {
        Name: "cs:Reversing:isrep"
        Bool: true
      }
      Overrides {
        Name: "cs:Vehicle:tooltip"
        String: "Object Reference of the 4-Wheeled Vehicle Object."
      }
      Overrides {
        Name: "cs:InterractTrigger:tooltip"
        String: "Networked trigger box that covers the entire vehicle. This trigger determines if a player is in range to interract with any of the vehicle\'s features."
      }
      Overrides {
        Name: "cs:Seats:tooltip"
        String: "Group containing all of the markers for the seat location and simulated trigger of each seat."
      }
      Overrides {
        Name: "cs:ModuleMarkers:tooltip"
        String: "Group containing the simulated triggers for all of the additional non-seat modules."
      }
      Overrides {
        Name: "cs:InterractBinding:tooltip"
        String: "Binding for interracting with vehicle from the outside. This includes the ability to enter the vehicle and open hatches."
      }
      Overrides {
        Name: "cs:ToggleLightsBinding:tooltip"
        String: "Binding to toggle the headlights. (Driver only)"
      }
      Overrides {
        Name: "cs:LeftTurnSignalBinding:tooltip"
        String: "Binding to toggle the left turn signal. (Driver only)"
      }
      Overrides {
        Name: "cs:RightTurnBinding:tooltip"
        String: "Binding to toggle the right turn signal. (Driver only)"
      }
      Overrides {
        Name: "cs:HazardBinding:tooltip"
        String: "Binding to toggle hazard lights. (Driver only)"
      }
      Overrides {
        Name: "cs:HornBinding:tooltip"
        String: "Binding to honk the horn. (Driver only)"
      }
      Overrides {
        Name: "cs:LockBinding:tooltip"
        String: "Binding to lock the vehicle. This means that other players cannot enter the vehicle or interract with any modules. (Driver only, is toggled off when the driver leaves)"
      }
      Overrides {
        Name: "cs:VehicleLock:tooltip"
        String: "Bool that is enabled when the vehicle is locked by the driver."
      }
      Overrides {
        Name: "cs:Reversing:tooltip"
        String: "Bool that is enabled when the vehicle is reversing."
      }
      Overrides {
        Name: "cs:ActiveToggle:tooltip"
        String: "Bool that is enabled when the vehicle is active (has a driver)."
      }
      Overrides {
        Name: "cs:HornToggle:tooltip"
        String: "Bool that is enabled when the horn has been pressed."
      }
      Overrides {
        Name: "cs:LightsToggle:tooltip"
        String: "Bool that is enabled when the headlights are toggled on."
      }
      Overrides {
        Name: "cs:TurnSignalState:tooltip"
        String: "Interger that shows the state of the turn signals. (-1 = hazard, 0 = inactive, 1 = left, 2 = right)"
      }
      Overrides {
        Name: "cs:ActiveModules:tooltip"
        String: "String that shows which module is active due to an interraction with a player."
      }
      Overrides {
        Name: "cs:PlayersInVehicle:tooltip"
        String: "String that shows players who are in the vehicle and which seat that player is in."
      }
      Overrides {
        Name: "cs:AnimationStance:tooltip"
        String: "Animation stance applied to the passengers of the vehicle."
      }
    }
  }
  SerializationVersion: 87
}
