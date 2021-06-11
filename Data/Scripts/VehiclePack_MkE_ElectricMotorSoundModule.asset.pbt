Assets {
  Id: 4628399602461883673
  Name: "VehiclePack_MkE_ElectricMotorSoundModule"
  PlatformAssetType: 3
  TextAsset {
    CustomParameters {
      Overrides {
        Name: "cs:Vehicle"
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
        Name: "cs:TerrainSFX"
        ObjectReference {
        }
      }
      Overrides {
        Name: "cs:SoundModifier"
        Float: 0.3
      }
      Overrides {
        Name: "cs:SoundStartPitch"
        Float: -1400
      }
      Overrides {
        Name: "cs:Vehicle:tooltip"
        String: "Object Reference of the 4-Wheeled Vehicle Object."
      }
      Overrides {
        Name: "cs:IdleSFX:tooltip"
        String: "Sound Effect that plays when the vehicle is active. (has a driver)"
      }
      Overrides {
        Name: "cs:ActiveSFX:tooltip"
        String: "Sound Effect that plays when the vehicle is moving. (this pitch of this SFX will be modified by the vehicle speed, SoundModifier value, and SoundStartPitch value)"
      }
      Overrides {
        Name: "cs:TerrainSFX:tooltip"
        String: "Additional Sound Effect to simulate the vehicle going over terrain."
      }
      Overrides {
        Name: "cs:SoundModifier:tooltip"
        String: "Float value that will modify the pitch of the ActiveSFX. (formala = vehicleSpeed * SoundModifier + SoundStartPitch)"
      }
      Overrides {
        Name: "cs:SoundStartPitch:tooltip"
        String: "Integer value that determines the starting pitch the ActiveSFX will start with. (formala = vehicleSpeed * SoundModifier + SoundStartPitch)"
      }
    }
  }
  SerializationVersion: 87
}
