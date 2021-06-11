Assets {
  Id: 11381304149602306805
  Name: "VehiclePack_MkE_DoorModule"
  PlatformAssetType: 3
  TextAsset {
    CustomParameters {
      Overrides {
        Name: "cs:VehicleServer"
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
        Name: "cs:Doors"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:VehicleServer:tooltip"
        String: "Object Reference of the VehiclePack_MkE_VehicleServer script. (This module needs to read custom properties from this script)"
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
        Name: "cs:Doors:tooltip"
        String: "Group that contains all of the client-context door geos."
      }
    }
  }
  SerializationVersion: 87
}
