Assets {
  Id: 13480409597429909602
  Name: "VehiclePack_Turret_TurretBase"
  PlatformAssetType: 3
  TextAsset {
    CustomParameters {
      Overrides {
        Name: "cs:FireRate"
        Float: 0.12
      }
      Overrides {
        Name: "cs:BulletDamage"
        Float: 10
      }
      Overrides {
        Name: "cs:TurretRotationSpeed"
        Float: 0.2
      }
      Overrides {
        Name: "cs:MustHaveDriver"
        Bool: false
      }
      Overrides {
        Name: "cs:ExitBinding"
        String: "ability_extra_33"
      }
      Overrides {
        Name: "cs:AnimationStance"
        String: "unarmed_sit_car_low"
      }
      Overrides {
        Name: "cs:BulletTemplate"
        AssetReference {
          Id: 15426300336907337930
        }
      }
      Overrides {
        Name: "cs:MuzzleFlashTemplate"
        AssetReference {
          Id: 81146691793097081
        }
      }
      Overrides {
        Name: "cs:IsFiring"
        Bool: false
      }
      Overrides {
        Name: "cs:IsFiring:isrep"
        Bool: true
      }
    }
  }
  SerializationVersion: 87
}
