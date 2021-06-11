Assets {
  Id: 3147836820774097506
  Name: "VehiclePack_AVLB_BridgeArmClient"
  PlatformAssetType: 3
  TextAsset {
    CustomParameters {
      Overrides {
        Name: "cs:Vehicle"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:BridgeArmServer"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:MainArmServer"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:MainArmClient"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:SubArmServer"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:SubArmClient"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:PistonTop1"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:PistonTop2"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:PistonTop3"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:PistonBottom1"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:PistonBottom2"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:PistonBottom3"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:LeftTreads"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:RightTreads"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:IdleSFX"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:ActiveSFX"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:ActiveFX"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:MainArmStartSFX"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:MainArmLoopSFX"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:SubArmStartSFX"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:SubArmLoopSFX"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:BridgeHingeLoopSFX"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:BridgeEquippedSFX"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:ServoEndSFX"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:Vehicle:tooltip"
        String: "Object Reference of the 4-Wheeled Vehicle Object."
      }
      Overrides {
        Name: "cs:BridgeArmServer:tooltip"
        String: "Object Reference of the VehiclePack_AVLB_BridgeArmServer script. (This module needs to read custom properties from this script)"
      }
      Overrides {
        Name: "cs:SubArmServer:tooltip"
        String: "Server/networked group  that represents the pivot point of the sub arm. This group should be the same sub arm group used by the VehiclePack_AVLB_BridgeArmServer."
      }
      Overrides {
        Name: "cs:MainArmServer:tooltip"
        String: "Server/networked group  that represents the pivot point of the main arm. This group should be the same main arm group used by the VehiclePack_AVLB_BridgeArmServer."
      }
      Overrides {
        Name: "cs:MainArmClient:tooltip"
        String: "Group that contains the geo for the main arm. The pivot point position and rotation should match its server counterpart."
      }
      Overrides {
        Name: "cs:SubArmClient:tooltip"
        String: "Group that contains the geo for the sub arm. The pivot point position and rotation should match its server counterpart."
      }
      Overrides {
        Name: "cs:PistonTop1:tooltip"
        String: "Group that contains the top part of a piston that supports the main arm or the sub arm."
      }
      Overrides {
        Name: "cs:PistonTop2:tooltip"
        String: "Group that contains the top part of a piston that supports the main arm or the sub arm."
      }
      Overrides {
        Name: "cs:PistonTop3:tooltip"
        String: "Group that contains the top part of a piston that supports the main arm or the sub arm."
      }
      Overrides {
        Name: "cs:PistonBottom1:tooltip"
        String: "Group that contains the bottom part of a piston that supports the main arm or the sub arm. Group should be alligned with its top counterpart."
      }
      Overrides {
        Name: "cs:PistonBottom2:tooltip"
        String: "Group that contains the bottom part of a piston that supports the main arm or the sub arm. Group should be alligned with its top counterpart."
      }
      Overrides {
        Name: "cs:PistonBottom3:tooltip"
        String: "Group that contains the bottom part of a piston that supports the main arm or the sub arm. Group should be alligned with its top counterpart."
      }
      Overrides {
        Name: "cs:LeftTreads:tooltip"
        String: "Group containing the left treads and wheels of the vehicle."
      }
      Overrides {
        Name: "cs:RightTreads:tooltip"
        String: "Group containing the right treads and wheels of the vehicle."
      }
      Overrides {
        Name: "cs:IdleSFX:tooltip"
        String: "Sound effect that plays when the vehicle is active. (The vehicle has a driver)"
      }
      Overrides {
        Name: "cs:ActiveSFX:tooltip"
        String: "Sound effect that plays whenever the player moves the vehicle."
      }
      Overrides {
        Name: "cs:MainArmStartSFX:tooltip"
        String: "Sound effect that plays then the main arm starts moving."
      }
      Overrides {
        Name: "cs:MainArmLoopSFX:tooltip"
        String: "Sound effect that plays while the main arm is moving."
      }
      Overrides {
        Name: "cs:SubArmStartSFX:tooltip"
        String: "Sound effect that plays then the sub arm starts moving."
      }
      Overrides {
        Name: "cs:SubArmLoopSFX:tooltip"
        String: "Sound effect that plays while the sub arm is moving."
      }
      Overrides {
        Name: "cs:BridgeHingeLoopSFX:tooltip"
        String: "Sound effect that plays while the bridge is folding."
      }
      Overrides {
        Name: "cs:BridgeEquippedSFX:tooltip"
        String: "Sound effect that plays when a bridge is equipped on the vehicle."
      }
      Overrides {
        Name: "cs:ServoEndSFX:tooltip"
        String: "Sound effect that plays when an arm movement stops and the arm collided with the ground. (This is when the main arm phase finishes and when the bridge is placed)"
      }
      Overrides {
        Name: "cs:ActiveFX:tooltip"
        String: "Group that contains the effects that would play when the vehicle is active. (Exaust smoke etc.)"
      }
    }
  }
  SerializationVersion: 87
}
