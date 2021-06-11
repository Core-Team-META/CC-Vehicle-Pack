Assets {
  Id: 11080260048402193633
  Name: "VehiclePack_MkE_FirstPersonCamModule"
  PlatformAssetType: 3
  TextAsset {
    CustomParameters {
      Overrides {
        Name: "cs:VehicleServer"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:DefaultCamera"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:FirstPersonCameras"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:CameraBinding"
        String: "ability_extra_42"
      }
      Overrides {
        Name: "cs:VehicleServer:tooltip"
        String: "Object Reference of the VehiclePack_MkE_VehicleServer script. (This module needs to read custom properties from this script)"
      }
      Overrides {
        Name: "cs:DefaultCamera:tooltip"
        String: "Camera object that is used as the default camera when driving or riding the vehicle."
      }
      Overrides {
        Name: "cs:FirstPersonCameras:tooltip"
        String: "Group that contains all of the labeled first person cameras for the driver and each passenger."
      }
      Overrides {
        Name: "cs:CameraBinding:tooltip"
        String: "Binding used to toggle between default camera and first person camera."
      }
    }
  }
  SerializationVersion: 87
}
