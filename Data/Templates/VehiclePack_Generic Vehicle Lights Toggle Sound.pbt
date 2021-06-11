Assets {
  Id: 3266028967231586625
  Name: "VehiclePack_Generic Vehicle Lights Toggle Sound"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 10937839354280581010
      Objects {
        Id: 10937839354280581010
        Name: "Generic Vehicle Lights Toggle Sound"
        Transform {
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 4781671109827199097
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        AudioInstance {
          AudioAsset {
            Id: 6945834466686502107
          }
          AutoPlay: true
          Transient: true
          Volume: 0.5
          Falloff: -1
          Radius: -1
          IsSpatializationEnabled: true
          IsAttenuationEnabled: true
        }
      }
    }
    Assets {
      Id: 6945834466686502107
      Name: "Flesh Skin Face Slap Light 01 SFX"
      PlatformAssetType: 7
      PrimaryAsset {
        AssetType: "AudioAssetRef"
        AssetId: "sfx_flesh_skin_face_slap_light_01a_Cue_ref"
      }
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  SerializationVersion: 87
}
