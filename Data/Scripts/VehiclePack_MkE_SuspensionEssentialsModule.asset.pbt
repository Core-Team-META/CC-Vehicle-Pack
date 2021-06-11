Assets {
  Id: 2448159832194473745
  Name: "VehiclePack_MkE_SuspensionEssentialsModule"
  PlatformAssetType: 3
  TextAsset {
    CustomParameters {
      Overrides {
        Name: "cs:Wheel"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:WheelRim"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:SteeringKnuckle"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:MovingAssembly"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:Wheel:tooltip"
        String: "Group that contains the geo for the designated wheel for this module. This wheel group should be the same group used by the vehicle object."
      }
      Overrides {
        Name: "cs:WheelRim:tooltip"
        String: "Group or object that represents the face of the wheel. This group or object should have its pivot point towards the outside of the wheel. (The pivot of the wheel rim should be further away from the body of the vehicle than the pivot of the wheel geo itself)"
      }
      Overrides {
        Name: "cs:SteeringKnuckle:tooltip"
        String: "Group containing the steering knuckle component of the suspension. This group will look at the wheel rim for when the vehicle is turning. (This group usually contains components such as the brake disc)"
      }
      Overrides {
        Name: "cs:MovingAssembly:tooltip"
        String: "Group that contains the moving part of the suspension. This group will follow the position of the wheel."
      }
    }
  }
  SerializationVersion: 87
}
