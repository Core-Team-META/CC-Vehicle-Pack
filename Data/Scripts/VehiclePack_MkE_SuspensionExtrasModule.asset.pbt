Assets {
  Id: 5540097534519487693
  Name: "VehiclePack_MkE_SuspensionExtrasModule"
  PlatformAssetType: 3
  TextAsset {
    CustomParameters {
      Overrides {
        Name: "cs:SuspensionModule"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:Vehicle"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:Axle"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:AxleTarget"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:UpperArm"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:UpperArmTarget"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:LowerArm"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:LowerArmTarget"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:ShockTop"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:ShockBottom"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:TieRod"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:TieRodTarget"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:EnableRotatingAxle"
        Bool: true
      }
      Overrides {
        Name: "cs:AxleRotationModifier"
        Float: 1
      }
      Overrides {
        Name: "cs:SuspensionModule:tooltip"
        String: "Group representing the entire suspension module."
      }
      Overrides {
        Name: "cs:Vehicle:tooltip"
        String: "Object Reference of the 4-Wheeled Vehicle Object."
      }
      Overrides {
        Name: "cs:Axle:tooltip"
        String: "Group containing the axle. The axle is the rotating rod that would drive power to the wheel in a real vehicle. This group should be in the MovingAssembly group."
      }
      Overrides {
        Name: "cs:AxleTarget:tooltip"
        String: "Group or object representing the location the axle will target. As the axle moves up and down with the moving assembly, the axle will face towards the axle target. This group or object should be in the StationaryAssembly group."
      }
      Overrides {
        Name: "cs:UpperArm:tooltip"
        String: "Group containing the upper control arm. The upper control arm is the assembly above the axle. This group should be in the MovingAssembly group. "
      }
      Overrides {
        Name: "cs:UpperArmTarget:tooltip"
        String: "Group or object representing the target of the upper control arm. As the upper control arm moves with the moving assembly, the upper control arm will face towards the upper arm target. This group should be in the StaticAssembly group."
      }
      Overrides {
        Name: "cs:LowerArmTarget:tooltip"
        String: "Group or object representing the target of the lower control arm. As the lower control arm moves with the moving assembly, the lower control arm will face towards the lower arm target. This group should be in the StaticAssembly group."
      }
      Overrides {
        Name: "cs:LowerArm:tooltip"
        String: "Group containing the lower control arm. The lower control arm is the assembly below the axle. This group should be in the MovingAssembly group. "
      }
      Overrides {
        Name: "cs:ShockTop:tooltip"
        String: "Group that contains the upper portion of the shock absorber. The shock absorber is the piston looking element that connects the lower control arm to the body of the vehicle. This group should be in the StaticAssembly group."
      }
      Overrides {
        Name: "cs:ShockBottom:tooltip"
        String: "Group that contains the lower portion of the shock absorber. This group should be in the MovingAssembly group."
      }
      Overrides {
        Name: "cs:TieRod:tooltip"
        String: "Group that contains the tie rod. The tie rod is only on wheels that can be turned by the steering wheels (usually the front wheels). The tie rod is the long rod in front of the axle attached to the steering knuckle. This group should be in the MovingAssembly group."
      }
      Overrides {
        Name: "cs:TieRodTarget:tooltip"
        String: "Group or object representing the target of the tie rod. As the tie rod moves with the moving assembly, the tie rod will face towards the tie rod target. This group should be in the StaticAssembly group."
      }
      Overrides {
        Name: "cs:EnableRotatingAxle:tooltip"
        String: "Boolean to allow or prevent the axle from rotating with the wheel of the vehicle."
      }
      Overrides {
        Name: "cs:AxleRotationModifier:tooltip"
        String: "Float value used to modify the rotation speed of the axle. This value should be flipped positive or negative depending on which side of the vehicle the module is on. (For example, -2 for right side modules and 2 for left side modules)"
      }
    }
  }
  SerializationVersion: 87
}
