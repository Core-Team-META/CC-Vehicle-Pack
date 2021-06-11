Assets {
  Id: 10451764744139227460
  Name: "Custom Plastic Matte"
  PlatformAssetType: 13
  SerializationVersion: 87
  CustomMaterialAsset {
    BaseMaterialId: 132672053610873933
    ParameterOverrides {
      Overrides {
        Name: "color"
        Color {
          R: 0.068
          G: 0.068
          B: 0.068
          A: 1
        }
      }
      Overrides {
        Name: "roughness"
        Float: 0.44862774
      }
      Overrides {
        Name: "specular"
        Float: 0.262637019
      }
    }
    Assets {
      Id: 132672053610873933
      Name: "Plastic Matte"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "plastic_matte_001"
      }
    }
  }
}
