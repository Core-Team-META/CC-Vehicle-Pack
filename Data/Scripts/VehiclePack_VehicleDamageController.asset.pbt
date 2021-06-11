Assets {
  Id: 915753454738301404
  Name: "VehiclePack_VehicleDamageController"
  PlatformAssetType: 3
  TextAsset {
    CustomParameters {
      Overrides {
        Name: "cs:Health"
        Float: 100
      }
      Overrides {
        Name: "cs:MaxHealth"
        Float: 100
      }
      Overrides {
        Name: "cs:AllowFriendlyFire"
        Bool: false
      }
      Overrides {
        Name: "cs:VehicleDamagedFX"
        AssetReference {
          Id: 11994547233176381386
        }
      }
      Overrides {
        Name: "cs:VehicleDestroyedFX"
        AssetReference {
          Id: 12654325458437760092
        }
      }
      Overrides {
        Name: "cs:DamagedThreshold"
        Float: 50
      }
      Overrides {
        Name: "cs:Health:isrep"
        Bool: true
      }
    }
  }
  SerializationVersion: 87
}
