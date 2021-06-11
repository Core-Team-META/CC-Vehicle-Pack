Assets {
  Id: 18177270447424573636
  Name: "VehiclePack_MkE_TestSuspensionCamModule"
  PlatformAssetType: 3
  TextAsset {
    CustomParameters {
      Overrides {
        Name: "cs:Vehicle"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:Camera"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:ObstructingPart"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:ObstructingWheel"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:ToggleBinding"
        String: "ability_extra_42"
      }
      Overrides {
        Name: "cs:OtherCamBindings"
        String: "ability_extra_41"
      }
      Overrides {
        Name: "cs:EnableTestCam"
        Bool: false
      }
      Overrides {
        Name: "cs:Vehicle:tooltip"
        String: "Object Reference of the 4-Wheeled Vehicle Object."
      }
      Overrides {
        Name: "cs:Camera:tooltip"
        String: "Camera object used to view the suspension module."
      }
      Overrides {
        Name: "cs:ObstructingPart:tooltip"
        String: "Group that contains objects that would obstruct the view of the suspension."
      }
      Overrides {
        Name: "cs:ObstructingWheel:tooltip"
        String: "Group that contains the wheel the suspension module is connected to."
      }
      Overrides {
        Name: "cs:ToggleBinding:tooltip"
        String: "Binding to toggle the test suspension camera. (Driver only)"
      }
      Overrides {
        Name: "cs:OtherCamBindings:tooltip"
        String: "List of other bindings that would cause the camera to change (such as the first person camera module). The list does not need to have separators like commas etc. (The script uses string.find() to check bindings)"
      }
      Overrides {
        Name: "cs:EnableTestCam:tooltip"
        String: "Boolean to enable or disable the ability to access the test suspension camera."
      }
    }
  }
  SerializationVersion: 87
}
