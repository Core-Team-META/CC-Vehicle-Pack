Assets {
  Id: 11481617001287633814
  Name: "VehiclePack_AVLB_BridgeArmServer"
  PlatformAssetType: 3
  TextAsset {
    CustomParameters {
      Overrides {
        Name: "cs:Vehicle"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:BridgeTemplate"
        AssetReference {
          Id: 9105522519098283347
        }
      }
      Overrides {
        Name: "cs:BridgeSpawnPosition"
        Vector {
        }
      }
      Overrides {
        Name: "cs:DeployBinding"
        String: "ability_extra_43"
      }
      Overrides {
        Name: "cs:ReplaceBinding"
        String: "ability_extra_17"
      }
      Overrides {
        Name: "cs:ResetBridgesBinding"
        String: "ability_extra_17"
      }
      Overrides {
        Name: "cs:MaxBridges"
        Int: 3
      }
      Overrides {
        Name: "cs:MainArm"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:MainExtended"
        Rotator {
          Pitch: -75
        }
      }
      Overrides {
        Name: "cs:MainAnimationTime"
        Float: 3
      }
      Overrides {
        Name: "cs:SubArm"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:SubExtended"
        Rotator {
          Pitch: 120
        }
      }
      Overrides {
        Name: "cs:SubAnimationTime"
        Float: 3
      }
      Overrides {
        Name: "cs:Bridge"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:BridgeExtendedRotation"
        Rotator {
          Pitch: 30
        }
      }
      Overrides {
        Name: "cs:BridgeSecondHalf"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:SecondHalfExtended"
        Rotator {
          Pitch: 170
        }
      }
      Overrides {
        Name: "cs:LeftWheelsModifier"
        Float: 0
      }
      Overrides {
        Name: "cs:RightWheelsModifier"
        Float: 0
      }
      Overrides {
        Name: "cs:AnimationPhase"
        Int: 0
      }
      Overrides {
        Name: "cs:HasBridge"
        Bool: true
      }
      Overrides {
        Name: "cs:AnimationPhase:isrep"
        Bool: true
      }
      Overrides {
        Name: "cs:HasBridge:isrep"
        Bool: true
      }
      Overrides {
        Name: "cs:RightWheelsModifier:isrep"
        Bool: true
      }
      Overrides {
        Name: "cs:LeftWheelsModifier:isrep"
        Bool: true
      }
      Overrides {
        Name: "cs:Vehicle:tooltip"
        String: "Object Reference of the 4-Wheeled Vehicle Object."
      }
      Overrides {
        Name: "cs:BridgeTemplate:tooltip"
        String: "Asset reference of that spawns when placing a bridge."
      }
      Overrides {
        Name: "cs:BridgeSpawnPosition:tooltip"
        String: "Position of where the bridge will spawn relative to the vehicle\'s current position."
      }
      Overrides {
        Name: "cs:DeployBinding:tooltip"
        String: "Binding to deploy a bridge."
      }
      Overrides {
        Name: "cs:ReplaceBinding:tooltip"
        String: "Binding to replace or reload a new bridge. (Previously placed bridges will not be destroyed when replacing a bridge)"
      }
      Overrides {
        Name: "cs:ResetBridgesBinding:tooltip"
        String: "Binding to remove all bridges placed by this vehicle. Resets the number of bridges the vehicle can place."
      }
      Overrides {
        Name: "cs:MaxBridges:tooltip"
        String: "Integer for the maximum number of bridges the vehicle can place. The number of bridges the vehicle can place is reset to this value whenever the player resets placed bridges."
      }
      Overrides {
        Name: "cs:MainArm:tooltip"
        String: "Group that represents the main arm pivot point. This group should be networked and contain the sub arm."
      }
      Overrides {
        Name: "cs:MainExtended:tooltip"
        String: "Rotation the main arm rotates to during the bridge deploying animation. The main arm defaults to a rotation of zero when the animation completes."
      }
      Overrides {
        Name: "cs:MainAnimationTime:tooltip"
        String: "Integer for the time it takes for the main arm to extend or or retract."
      }
      Overrides {
        Name: "cs:SubArm:tooltip"
        String: "Group that represents the sub arm pivot point. This group should be networked and contain the bridge group."
      }
      Overrides {
        Name: "cs:SubExtended:tooltip"
        String: "Rotation the sub arm rotates to during the bridge deploying animation. The sub arm defaults to a rotation of zero when the animation completes."
      }
      Overrides {
        Name: "cs:SubAnimationTime:tooltip"
        String: "Integer for the time it takes for the sub arm to extend or or retract."
      }
      Overrides {
        Name: "cs:Bridge:tooltip"
        String: "Group that represents the bridge pivot point. This group should be networked and contain the bridge client-context groups."
      }
      Overrides {
        Name: "cs:BridgeExtendedRotation:tooltip"
        String: "Rotation the bridge assembly rotates to during the bridge deploying animation. The bridge assembly defaults to a rotation of zero when the animation completes."
      }
      Overrides {
        Name: "cs:BridgeSecondHalf:tooltip"
        String: "Group that contains the client-context geo for the second half of the bridge assembly. "
      }
      Overrides {
        Name: "cs:SecondHalfExtended:tooltip"
        String: "Rotation the second half of the bridge rotates to during the bridge deploying animation. The second half of the bridge defaults to a rotation of zero when the animation completes. For best effect, the rotation should be such that the two halves of the bridge are oriented in the same way as the bridge in the bridge template."
      }
      Overrides {
        Name: "cs:LeftWheelsModifier:tooltip"
        String: "Integer to show the expected rotation of the wheels due to movement of the vehicle. (-1 = reverse rotation, 0 = zero rotation, 1 = forward rotation)"
      }
      Overrides {
        Name: "cs:RightWheelsModifier:tooltip"
        String: "Integer to show the expected rotation of the wheels due to movement of the vehicle. (-1 = reverse rotation, 0 = zero rotation, 1 = forward rotation)"
      }
      Overrides {
        Name: "cs:AnimationPhase:tooltip"
        String: "Integer showing the current phase the bridge layer is in. (0 = default, 1 = main arm phase, 2 = sub arm phase)"
      }
      Overrides {
        Name: "cs:HasBridge:tooltip"
        String: "Boolean to show if a bridge is currently equipped."
      }
    }
  }
  SerializationVersion: 87
}
