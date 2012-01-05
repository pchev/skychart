object Form1: TForm1
  Left = 278
  Top = 127
  Width = 149
  Height = 179
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GLScene1: TGLScene
    Left = 16
    Top = 16
    object DummyCube1: TDummyCube
      Position.Coordinates = {0000000000000000000048430000803F}
      CubeSize = 0.100000001490116
      object Disksup: TDisk
        ObjectsSorting = osRenderFarthestFirst
        Direction.Coordinates = {000000000000803F0000000000000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
        Material.BackProperties.Ambient.Color = {0000000000000000000000000000803F}
        Material.BackProperties.Diffuse.Color = {0000000000000000000000000000803F}
        Material.FrontProperties.Ambient.Color = {D1D0503DD1D0503DD1D0503D0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Emission.Color = {00000000000000000000000000000000}
        Material.FrontProperties.Specular.Color = {DAD9593FDAD9593FDAD9593F0000803F}
        Material.BlendingMode = bmTransparency
        Material.MaterialOptions = [moIgnoreFog]
        Material.Texture.TextureWrap = twNone
        Material.Texture.Disabled = False
        Material.MaterialLibrary = GLMaterialLibrary1
        InnerRadius = 0.3125
        Loops = 1
        OuterRadius = 0.5
        Slices = 72
        SweepAngle = 360
      end
      object Diskinf: TDisk
        ObjectsSorting = osRenderFarthestFirst
        Direction.Coordinates = {00000000000080BF0000000000000000}
        Up.Coordinates = {0000000000000000000080BF00000000}
        Material.BackProperties.Ambient.Color = {0000000000000000000000000000803F}
        Material.BackProperties.Diffuse.Color = {0000000000000000000000000000803F}
        Material.FrontProperties.Ambient.Color = {D1D0503DD1D0503DD1D0503D0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Emission.Color = {00000000000000000000000000000000}
        Material.FrontProperties.Specular.Color = {DAD9593FDAD9593FDAD9593F0000803F}
        Material.BlendingMode = bmTransparency
        Material.MaterialOptions = [moIgnoreFog]
        Material.Texture.TextureWrap = twNone
        Material.Texture.Disabled = False
        Material.MaterialLibrary = GLMaterialLibrary1
        InnerRadius = 0.3125
        Loops = 1
        OuterRadius = 0.5
        Slices = 72
        SweepAngle = 360
      end
      object GLLightSource1: TGLLightSource
        Ambient.Color = {0000003F0000003F0000003F0000803F}
        ConstAttenuation = 1
        Position.Coordinates = {00000000000000000000803F0000803F}
        LightStyle = lsParallel
        Specular.Color = {0000803F0000803F0000803F0000803F}
        SpotCutOff = 90
      end
    end
    object Sphere1: TSphere
      ObjectsSorting = osRenderFarthestFirst
      Position.Coordinates = {0000000000000000000048430000803F}
      Scale.Coordinates = {13F2E13E27A0C93E13F2E13E00000000}
      Up.Coordinates = {000000000000803F0000008000000000}
      Material.BackProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
      Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
      Material.FrontProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
      Material.Texture.MinFilter = miLinear
      Material.Texture.TextureMode = tmModulate
      Material.Texture.Disabled = False
      Material.MaterialLibrary = GLMaterialLibrary1
      Radius = 0.5
      Slices = 72
      Stacks = 31
    end
    object GLCamera1: TGLCamera
      DepthOfView = 100000
      FocalLength = 100
      TargetObject = DummyCube1
      CameraStyle = csOrthogonal
      Position.Coordinates = {000000000000A041000000000000803F}
      Direction.Coordinates = {00000000000000000000803F00000000}
      Up.Coordinates = {000000000000803F0000008000000000}
      Left = 328
      Top = 216
    end
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Materials = <
      item
        Name = 'mercury'
        Material.FrontProperties.Ambient.Color = {CDCC4C3DCDCC4C3DCDCC4C3D0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Specular.Color = {CDCCCC3DCDCCCC3DCDCCCC3D0000803F}
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmModulate
        Tag = 0
      end
      item
        Name = 'venus'
        Material.FrontProperties.Ambient.Color = {CDCC4C3DCDCC4C3DCDCC4C3D0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Specular.Color = {CDCC4C3DCDCC4C3DCDCC4C3D0000803F}
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmModulate
        Tag = 0
      end
      item
        Name = 'moon'
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Emission.Color = {CDCCCC3DCDCCCC3DCDCCCC3D0000803F}
        Material.FrontProperties.Specular.Color = {CDCC4C3ECDCC4C3ECDCC4C3E0000803F}
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmModulate
        Tag = 0
      end
      item
        Name = 'mars'
        Material.FrontProperties.Ambient.Color = {CDCC4C3DCDCC4C3DCDCC4C3D0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Specular.Color = {CDCCCC3DCDCCCC3DCDCCCC3D0000803F}
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmModulate
        Tag = 0
      end
      item
        Name = 'jupiter'
        Material.FrontProperties.Ambient.Color = {CDCC4C3DCDCC4C3DCDCC4C3D0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Specular.Color = {9A99193E9A99193E9A99193E0000803F}
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmModulate
        Tag = 0
      end
      item
        Name = 'saturn'
        Material.FrontProperties.Ambient.Color = {CDCC4C3DCDCC4C3DCDCC4C3D0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Specular.Color = {0000003F0000003F0000003F0000803F}
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmModulate
        Tag = 0
      end
      item
        Name = 'saturn_ring'
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Specular.Color = {8180003F8180003F8180003F0000803F}
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureWrap = twNone
        Tag = 0
      end
      item
        Name = 'uranus'
        Material.FrontProperties.Ambient.Color = {CDCC4C3DCDCC4C3DCDCC4C3D0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Specular.Color = {0000003F0000003F0000003F0000803F}
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmModulate
        Tag = 0
      end
      item
        Name = 'neptune'
        Material.FrontProperties.Ambient.Color = {CDCC4C3DCDCC4C3DCDCC4C3D0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Specular.Color = {9A99993E9A99993E9A99993E0000803F}
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmModulate
        Tag = 0
      end
      item
        Name = 'pluto'
        Material.FrontProperties.Ambient.Color = {CDCC4C3DCDCC4C3DCDCC4C3D0000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.FrontProperties.Specular.Color = {0000003F0000003F0000003F0000803F}
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmModulate
        Tag = 0
      end
      item
        Name = 'sun'
        Material.FrontProperties.Ambient.Color = {0000000000000000000000000000803F}
        Material.FrontProperties.Diffuse.Color = {0000803F0000803F0000803F0000803F}
        Material.Texture.MinFilter = miLinear
        Material.Texture.TextureMode = tmModulate
        Tag = 0
      end>
    Left = 16
    Top = 56
  end
  object GLMemoryViewer1: TGLMemoryViewer
    Camera = GLCamera1
    Buffer.BackgroundColor = clBlack
    Buffer.ContextOptions = []
    Buffer.AntiAliasing = aaNone
    Buffer.ShadeModel = smSmooth
    Left = 16
    Top = 96
  end
end
