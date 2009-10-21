object frmConvertToFBD: TfrmConvertToFBD
  Left = 0
  Top = 0
  ActiveControl = edPublisher
  BorderStyle = bsToolWindow
  Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1077' '#1074' FBD'
  ClientHeight = 467
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RzPanel1: TRzPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 553
    Height = 414
    Align = alClient
    BorderOuter = fsFlatRounded
    TabOrder = 0
    object RzLabel1: TRzLabel
      Left = 207
      Top = 201
      Width = 55
      Height = 13
      Caption = #1040#1085#1085#1086#1090#1072#1094#1080#1103
    end
    object lblAuthor: TRzLabel
      Left = 12
      Top = 10
      Width = 52
      Height = 13
      Caption = 'lblAuthor'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTitle: TRzLabel
      Left = 12
      Top = 27
      Width = 43
      Height = 13
      Caption = 'lblAuthor'
    end
    object mmAnnotation: TMemo
      Left = 207
      Top = 220
      Width = 338
      Height = 141
      Color = clCream
      ScrollBars = ssBoth
      TabOrder = 4
      WordWrap = False
    end
    object RzGroupBox1: TRzGroupBox
      Left = 207
      Top = 125
      Width = 338
      Height = 65
      Caption = #1040#1074#1090#1086#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      TabOrder = 3
      object RzLabel2: TRzLabel
        Left = 18
        Top = 18
        Width = 19
        Height = 13
        Caption = #1048#1084#1103
      end
      object RzLabel3: TRzLabel
        Left = 93
        Top = 18
        Width = 49
        Height = 13
        Caption = #1054#1090#1095#1077#1089#1090#1074#1086
      end
      object RzLabel8: TRzLabel
        Left = 179
        Top = 17
        Width = 44
        Height = 13
        Caption = #1060#1072#1084#1080#1083#1080#1103
      end
      object RzLabel9: TRzLabel
        Left = 267
        Top = 17
        Width = 19
        Height = 13
        Caption = #1053#1080#1082
      end
      object edFirstName: TRzEdit
        Left = 4
        Top = 33
        Width = 74
        Height = 21
        Color = clCream
        TabOrder = 0
      end
      object edMiddleName: TRzEdit
        Left = 84
        Top = 33
        Width = 82
        Height = 21
        Color = clCream
        TabOrder = 1
      end
      object edLastName: TRzEdit
        Left = 172
        Top = 33
        Width = 68
        Height = 21
        Color = clCream
        TabOrder = 2
      end
      object edNickName: TRzEdit
        Left = 246
        Top = 33
        Width = 82
        Height = 21
        Color = clCream
        TabOrder = 3
      end
    end
    object RzGroupBox2: TRzGroupBox
      Left = 207
      Top = 48
      Width = 338
      Height = 71
      Caption = #1048#1079#1076#1072#1090#1077#1083#1100
      TabOrder = 2
      object RzLabel4: TRzLabel
        Left = 11
        Top = 47
        Width = 23
        Height = 13
        Caption = 'ISBN'
      end
      object RzLabel6: TRzLabel
        Left = 192
        Top = 21
        Width = 31
        Height = 13
        Caption = #1043#1086#1088#1086#1076
      end
      object RzLabel7: TRzLabel
        Left = 276
        Top = 47
        Width = 19
        Height = 13
        Caption = #1043#1086#1076
      end
      object RzLabel5: TRzLabel
        Left = 11
        Top = 21
        Width = 48
        Height = 13
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
      end
      object edISBN: TRzEdit
        Left = 40
        Top = 43
        Width = 230
        Height = 21
        Color = clCream
        TabOrder = 2
      end
      object edPublisher: TRzEdit
        Left = 62
        Top = 18
        Width = 124
        Height = 21
        Color = clCream
        TabOrder = 0
      end
      object edYear: TRzEdit
        Left = 301
        Top = 45
        Width = 28
        Height = 21
        Color = clCream
        TabOrder = 3
      end
      object edCity: TRzEdit
        Left = 229
        Top = 18
        Width = 100
        Height = 21
        Color = clCream
        TabOrder = 1
      end
    end
    object btnOpenBook: TRzBitBtn
      Left = 520
      Top = 5
      Width = 25
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1082#1085#1080#1075#1091
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnOpenBookClick
      ImageIndex = 2
      Images = ImageList1
    end
    object RzGroupBox3: TRzGroupBox
      Left = 4
      Top = 48
      Width = 198
      Height = 313
      Caption = #1054#1073#1083#1086#1078#1082#1072
      TabOrder = 1
      object FCover: TImage
        AlignWithMargins = True
        Left = 4
        Top = 17
        Width = 190
        Height = 260
        Hint = #1054#1073#1083#1086#1078#1082#1072
        Align = alTop
        Center = True
        ParentShowHint = False
        Proportional = True
        ShowHint = True
        Stretch = True
      end
      object btnPasteCover: TRzBitBtn
        Left = 102
        Top = 283
        Width = 89
        Hint = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072
        Caption = #1048#1079' '#1073#1091#1092#1077#1088#1072
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnPasteCoverClick
        ImageIndex = 0
        Images = ImageList1
      end
      object btnLoad: TRzBitBtn
        Left = 5
        Top = 283
        Width = 89
        Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1092#1072#1081#1083#1072
        Caption = #1048#1079' '#1092#1072#1081#1083#1072
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btnLoadClick
        ImageIndex = 1
        Images = ImageList1
      end
    end
    object RzGroupBox13: TRzGroupBox
      Left = 7
      Top = 360
      Width = 538
      Height = 49
      Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088#1099
      TabOrder = 5
      object RzLabel10: TRzLabel
        Left = 4
        Top = 22
        Width = 22
        Height = 13
        Caption = #1059#1044#1050
      end
      object RzLabel11: TRzLabel
        Left = 169
        Top = 22
        Width = 19
        Height = 13
        Caption = #1041#1041#1050
      end
      object RzLabel12: TRzLabel
        Left = 334
        Top = 22
        Width = 32
        Height = 13
        Caption = #1043#1056#1053#1058#1048
      end
      object edUDK: TRzEdit
        Left = 32
        Top = 17
        Width = 132
        Height = 21
        Color = clCream
        TabOrder = 0
      end
      object edBBK: TRzEdit
        Left = 194
        Top = 17
        Width = 134
        Height = 21
        Color = clCream
        TabOrder = 1
      end
      object edGRNTI: TRzEdit
        Left = 372
        Top = 17
        Width = 157
        Height = 21
        Color = clCream
        TabOrder = 2
      end
    end
  end
  object RzPanel2: TRzPanel
    AlignWithMargins = True
    Left = 3
    Top = 423
    Width = 553
    Height = 41
    Align = alBottom
    BorderOuter = fsFlatRounded
    TabOrder = 1
    ExplicitTop = 376
    object btnSave: TBitBtn
      Left = 360
      Top = 10
      Width = 98
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Default = True
      DoubleBuffered = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF7F2B287F2B28A18283A18283A18283A1
        8283A18283A18283A182837A1C1C7F2B28FF00FFFF00FFFF00FFFF00FF7F2B28
        CA4D4DB64545DDD4D5791617791617DCE0E0D7DADECED5D7BDBABD76100F9A2D
        2D7F2B28FF00FFFF00FFFF00FF7F2B28C24A4BB14444E2D9D9791617791617D9
        D8DAD9DEE1D3D9DCC1BDC1761111982D2D7F2B28FF00FFFF00FFFF00FF7F2B28
        C24A4AB04242E6DCDC791617791617D5D3D5D8DEE1D7DDE0C6C2C5700F0F962C
        2C7F2B28FF00FFFF00FFFF00FF7F2B28C24A4AB04141EADEDEE7DDDDDDD4D5D7
        D3D5D5D7D9D7D8DACAC2C57E17179E31317F2B28FF00FFFF00FFFF00FF7F2B28
        BF4748B84545BA4C4CBD5757BB5756B64E4EB44949BD5251BB4B4CB54242BF4A
        4A7F2B28FF00FFFF00FFFF00FF7F2B28A33B39B1605DC68684CB918FCC9190CC
        908FCB8988C98988CB9391CC9696BD4B4C7F2B28FF00FFFF00FFFF00FF7F2B28
        BD4B4CF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7BD4B
        4C7F2B28FF00FFFF00FFFF00FF7F2B28BD4B4CF7F7F7F7F7F7F7F7F7F7F7F7F7
        F7F7F7F7F7F7F7F7F7F7F7F7F7F7BD4B4C7F2B28FF00FFFF00FFFF00FF7F2B28
        BD4B4CF7F7F7BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFF7F7F7BD4B
        4C7F2B28FF00FFFF00FFFF00FF7F2B28BD4B4CF7F7F7F7F7F7F7F7F7F7F7F7F7
        F7F7F7F7F7F7F7F7F7F7F7F7F7F7BD4B4C7F2B28FF00FFFF00FFFF00FF7F2B28
        BD4B4CF7F7F7BFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFF7F7F7BD4B
        4C7F2B28FF00FFFF00FFFF00FF7F2B28BD4B4CF7F7F7F7F7F7F7F7F7F7F7F7F7
        F7F7F7F7F7F7F7F7F7F7F7F7F7F7BD4B4C7F2B28FF00FFFF00FFFF00FFFF00FF
        7F2B28F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F77F2B
        28FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object BitBtn1: TBitBtn
      Left = 464
      Top = 10
      Width = 81
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      DoubleBuffered = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF892602FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FF8A27039C34028A2703FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8A2703AD4101AB3E018A27
        03FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FF8A27038E2903B849009F35018A2703FF00FFFF00FF892602892602
        8926028926028926028926028926028A27038A2703FF00FF8A27038E2903B849
        009830028A2703FF00FF892602D8721BC65B0CB64902B44300B54500B64500B6
        46009C3402892602FF00FF8A2703932E02B849008E2903FF00FF892602FFA637
        E27B1ED86C10892602892602892602892602892602FF00FFFF00FFFF00FF8A27
        03A63B01A63B018A2703892602FFAA39E27B1EDE791EC1590F872302FF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FF902B02B64500892703892602FFAA39
        A03B0A8A2803F6932AAC460C872402FF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FF892603C45100892603892602FFAB3A8926028623019D3809FA982EC25B1287
        2402FF00FFFF00FFFF00FFFF00FF8A2703932D02BC4B00892603892602FFAB3A
        892602FF00FF8824029E3809EB8928D16C198E2803892502FF00FF8A26038926
        03B14300A63B018A2703892602FFAC3A892602FF00FFFF00FF8925028F2A03D5
        701FEA8623AB43099A3403972F02B14300B645008E2903FF00FF882402FB9C33
        892602FF00FFFF00FFFF00FF892602882402A5400CCB6516CB600FB246039A33
        028926038A2703FF00FFFF00FF892502FF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FF8926028925028926028926038A2703FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ModalResult = 2
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = BitBtn1Click
    end
    object btnPrevious: TBitBtn
      Left = 12
      Top = 10
      Width = 86
      Height = 25
      Hint = #1055#1088#1077#1076#1099#1076#1091#1097#1072#1103#13#1082#1085#1080#1075#1072
      Caption = #1053#1072#1079#1072#1076
      DoubleBuffered = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FF521E156B25087D2C057E2D056D2607551F13FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF552117552117BF5C15E19855EF
        BD8AF0BF8CE29D5BC26218541F16541F16FF00FFFF00FFFF00FFFF00FFFF00FF
        6C290EAF4704EBB179FFFEF8FEF8F4F2DAC4F2D9C2FCF6F0FFFFFCEEBA87B64E
        07602311FF00FFFF00FFFF00FF732D0DB04602F4D0ABFFFEFED78E50C05308BA
        4500BA4600C05307D48443FCF7F0F8DDBDB64D05541F16FF00FFFF00FF732D0D
        E6AB72FFFFFFCF762CB73F00BB4800BF5103BC4A00BA4600B63D00CC7227FCF8
        F3EFBC88541F16FF00FF893406C05C11FFFCFAE1A46AC04B00C65D0CEABF96D1
        7F37B84100BB4800E2AD7AD3823CD18039FFFFFFC16016551F139A3B02DD9554
        FFFFFFD16F1FD47729F4DAC1FFFFFFD58138C4570BEAC29DFFFFFFD78C4BBC4A
        00FCF8F3E29D5A6D2607A94403EBBB8AFBEDDEE19856FBF3EAFFFFFFFFFEFEE3
        A972F6E3CEFFFFFFFFFFFFD78E4DB73F00F2DAC2EFC08E7D2C04B04A06EEBF90
        FCF0E6E79D5AFAE6D1FFFFFFFFFFFFE5A76DF0CEACFFFFFFFFFFFFD78E4CB740
        00F3DEC7EFBD8A7B2C04B04905E9AA6EFFFFFFEBA05AEB994FF8D8B8FFFFFFE5
        9E5DD16A17E7B280FFFFFFD88F4DBD4C01FEFBF8E097526B2408AD4502DD893F
        FFFCF8FAD7B4F4A65DF0A158F6CBA3E7A466D77322CB600EDE9A5DCE782ED78C
        4BFFFFFEBD5A10521F16FF00FFB24701F8CEA5FFFFFFFED1A5F6A75FEB9649E2
        8A3DD97929CF6715C04B00D07930FFFFFFEAAF73501F18FF00FFFF00FFB24701
        E0873BFEE5CBFFFFFFFAD5B2EDA562E28A3FD97B2DD4782AE1A46CFFFFFFF3CC
        A4AC4402501F18FF00FFFF00FFFF00FFB64C04DE873BF8CEA3FFFAF3FFFFFFFE
        F6EEFCF3EAFFFFFFFEF7EEE6A56AAC44035A2214FF00FFFF00FFFF00FFFF00FF
        FF00FFAF4501AF4501DC8840E9A76CEEBB89EBB581DC914DBD590F5D23155D23
        15FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA34103A54507A6
        46089E40068B3505752D0CFF00FFFF00FFFF00FFFF00FFFF00FF}
      ParentDoubleBuffered = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnPreviousClick
    end
    object btnNext: TBitBtn
      Left = 120
      Top = 10
      Width = 86
      Height = 25
      Hint = #1057#1083#1077#1076#1091#1102#1097#1072#1103#13#1082#1085#1080#1075#1072
      Caption = #1042#1087#1077#1088#1077#1076
      DoubleBuffered = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FF7D2C056B2508521E15551F136D26077E2D05FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF893204552117BF5C15E19855EF
        BD8AF0BF8CE29D5BC26218541F16903503FF00FFFF00FFFF00FFFF00FFFF00FF
        6C290EAF4704EBB179FFFEF8FEF8F4F2DAC4F2D9C2FCF6F0FFFFFCEEBA87B64E
        07602311FF00FFFF00FFFF00FF9A3800B04602F4D0ABFEFCFAD78C4EC05409BA
        4600BA4500BF5206D48644FCF8F4F8DDBDB64D05903502FF00FFFF00FF732D0D
        E6AB72FFFFFFD17E35B73F00BB4700BB4900BF5003BB4600B63E00C96A1EFCF8
        F6EFBC88541F16FF00FFA94403C05C11FFFCFADE9A5DD98C48E5B07EC15303BB
        4600D07B33E6B78BBD4D03B53A00D58A46FFFFFFC160167D2C049A3B02DD9554
        FFFFFFD06E1EE2A166FFFFFFEEC7A1C75C0CD17D33FFFFFFEECEAFC2580FBC4B
        01FCF8F4E29D5A6D2607893406EBBB8AFBF0E7D77322E9AD75FFFFFFFFFFFFF4
        DEC9E1A167FFFEFEFFFFFFF8EBDDCA6B21F0D4B8EFC08E551F139A3B02EEBF90
        FCF4EBE08435EEB783FFFFFFFFFFFFF3D0B0E2A166FFFFFFFFFFFFF0D4B8C560
        15F2D9BFEFBD8A521F16A94403E9AA6EFFFFFFEB9F58F3C292FFFFFFF2C79DD9
        7725E19754FFFFFFE7B78ABC4A03BF4F03FEFBFAE097526B2408AD4502DD893F
        FFFCF8FAD3ACFAC592F7C99CE99244E08232E39C59E5AC77C45404B73F00D995
        56FFFFFE501F187B2C04FF00FFB24701F8CEA5FFFFFFFED1A5F4A45AEB994EE2
        8A3CD9792ACC6310C14F01D07931FFFFFFEAAF73893103FF00FFFF00FFC96518
        E0873BFEE5CBFFFFFFFAD5B1EDA563E28B3FD97B2CD4782AE1A46CFFFFFFF3CC
        A4AC4402893103FF00FFFF00FFFF00FFB64C04DE873BF8CEA3FFFAF3FFFFFFFE
        F6EEFCF3EAFFFFFFFEF7EEE6A56AAC44035A2214FF00FFFF00FFFF00FFFF00FF
        FF00FFC56418AF4501DC8840E9A76CEEBB89EBB581DC914DBD590F752D0C9034
        02FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA646088B350575
        2D0C752D0C8B35059E4006FF00FFFF00FFFF00FFFF00FFFF00FF}
      ParentDoubleBuffered = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnNextClick
    end
  end
  object ImageList1: TImageList
    ColorDepth = cd32Bit
    Left = 392
    Top = 256
    Bitmap = {
      494C010103000800880010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000838383FF838383FF828282FF828282FF818181FF808080FF808080FF7E7E
      7EFF7D7D7DFF7D7D7DFF7D7D7DFF00000000336073C0448099FF448099FF4480
      99FF448099FF448099FF448099FF448099FF224354FF31617BFF31617BFF325A
      70FF354650FF2A4759EF000000000000000000000000676767FF676767FF6767
      67FF666666FF666666FF666666FF666666FF666666FF656565FF656565FF6565
      65FF656565FF656565FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003B80AAFF3B80AAFF3B80
      AAFF929292FFF9F9F9FFF2F2F2FFF3F3F3FFF3F3F3FFF3F3F3FFF2F2F2FFF2F2
      F2FFF2F2F2FFF8F8F8FF8C8C8CFF000000005595AEFF6AB5D3FF6AB5D3FF6AB5
      D3FF6AB5D3FF6AB5D3FF6AB5D3FF6AB5D3FF31637AFF4A9DC4FF4A9DC4FF406D
      85FFEEA97EFF405B6BFF000000000000000000000000757575FFFCFCFCFF98A9
      CBFFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF6F6F6FFF6F6F6FFF6F6
      F6FFFCFCFCFF737373FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003B80AAFF67B1CFFF69B3
      D1FF9D9D9DFFF3F3F3FFE8E8E8FFE9E9E9FFE9E9E9FFE9E9E9FFE8E8E8FFE7E7
      E7FFE6E6E6FFF2F2F2FF999999FF000000005A99B2FF6DB9D6FF6DB9D6FF6DB9
      D6FF6DB9D6FF6DB9D6FF6DB9D6FF6DB9D6FF6B8B9AFFCCCCCCFFCCCCCCFF467B
      95FFEEA97EFF45687DFF000000000000000000000000818181FF7C7C7DFF98A9
      CBFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B0
      8CFFD9B08CFF7E7E7EFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003B80AAFF69B4D2FF6BB6
      D3FFA7A7A7FFF5F5F5FFECECECFFECECECFFECECECFFECECECFFECECECFFEBEB
      EBFFE9E9E9FFF4F4F4FFA3A3A3FF000000005F9DB5FF70BDD9FF70BDD9FF70BD
      D9FF70BDD9FF70BDD9FF70BDD9FF70BDD9FF7696A4FFE4E4E4FFCCCCCCFF508A
      A5FFE4E4E4FF4B7188FF0000000000000000000000008B8B8BFFF8F8F8FF98A9
      CBFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE3E3E3FFE2E2E2FFE1E1E1FFE0E0
      E0FFF7F7F7FF8A8A8AFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004186AEFF6CB7D4FF6DBA
      D5FFAEAEAEFFF7F7F7FFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEEEEEEFFEEEE
      EEFFECECECFFF5F5F5FFACACACFF0000000064A1B8FF73C1DCFF73C1DCFF73C1
      DCFF73C1DCFF73C1DCFF73C1DCFF73C1DCFF7B9297FFE9D0B9FFCCCCCCFF548D
      A8FFE4E4E4FF50788DFF000000000000000000000000959595FFD9B08CFF98A9
      CBFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B0
      8CFFD9B08CFF929292FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000488CB3FF6EBBD6FF6FBD
      D8FFB4B4B4FFF8F8F8FFF1F1F1FFF2F2F2FFF2F2F2FFF2F2F2FFF1F1F1FFF0F0
      F0FFEFEFEFFFF6F6F6FFB2B2B2FF0000000069A6BBFF76C5DFFF76C5DFFF76C5
      DFFF76C5DFFF76C5DFFF76C5DFFF76C5DFFF7D9CA9FFE7E7E7FFCCCCCCFF5791
      ABFFE4E4E4FF567E92FF0000000000000000000000009A9A9AFFFAFAFAFF98A9
      CBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEAEAEAFFEAEAEAFFE9E9E9FFE6E6
      E6FFF8F8F8FF999999FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004D91B7FF70BED8FF71C0
      DAFFB9B9B9FFF9F9F9FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF3F3F3FFF2F2
      F2FFF1F1F1FFF7F7F7FFB7B7B7FF000000006EAABFFF79CAE2FF79CAE2FF79CA
      E2FF79CAE2FF79CAE2FF79CAE2FF76C5DFFF82969BFFE9D0B9FFCCCCCCFF5B95
      AEFFE4E4E4FF5D8597FF000000000000000000000000A1A1A1FFD9B08CFF98A9
      CBFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B0
      8CFFD9B08CFFA0A0A0FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000569BBFFF72C1DBFF74C3
      DDFFBBBBBBFFFAFAFAFFF6F6F6FFF6F6F6FFF7F7F7FFF6F6F6FFF6F6F6FFF5F5
      F5FFF3F3F3FFF8F8F8FFBABABAFF0000000073AFC2FF7CCFE5FF7CCFE5FF7CCF
      E5FF7CCFE5FF7CCFE5FF7CCFE5FF7CCFE5FF6D93A3FF8DB2C2FFCCCCCCFF62A7
      C4FF689AAFFF5D7E8CEF000000000000000000000000A5A5A5FF7C7C7DFF98A9
      CBFFF0F0F0FFF2F2F2FFF2F2F2FFF0F0F0FFF0F0F0FFEFEFEFFFEEEEEEFFEDED
      EDFFFAFAFAFFA5A5A5FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005DA1C3FF74C4DEFF76C6
      E0FFBEBEBEFFFBFBFBFFF8F8F8FFF8F8F8FFF8F8F8FFF8F8F8FFF7F7F7FFF6F6
      F6FFF5F5F5FFF9F9F9FFBDBDBDFF0000000078B3C5FF80D3E8FF80D3E8FF80D3
      E8FF80D3E8FF80D3E8FF80D3E8FF80D3E8FF83C1D6FF789FAEFF90AAB5FF74B5
      D2FF6F97A7FF0E121420000000000000000000000000A9A9A9FFD9B08CFF98A9
      CBFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B0
      8CFFD9B08CFFA7A7A7FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000062A7C8FF76C7E0FF78C9
      E2FFBFBFBFFFFCFCFCFFF9F9F9FFFAFAFAFFFAFAFAFFFAFAFAFFF9F9F9FFF8F8
      F8FFF6F6F6FFFAFAFAFFBFBFBFFF000000007DB7C9FF83D7EBFF83D7EBFF83D7
      EBFF83D7EBFF83D7EBFF83D7EBFF83D7EBFF83D7EBFF82CADCFF8FA5AEFF7CB3
      CAFF6F97A7FF00000000000000000000000000000000ABABABFFFCFCFCFF98A9
      CBFFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF4F4F4FFF3F3F3FFF2F2F2FFF0F0
      F0FFFBFBFBFFABABABFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006AAFCEFF79CAE2FF7ACC
      E4FFC0C0C0FFFCFCFCFFFAFAFAFFFBFBFBFFFBFBFBFFFBFBFBFFFAFAFAFFC6C6
      C6FFC4C4C4FFCDCDCDFFBFBFBFFF0000000083BCCDFF86DBEEFF86DBEEFF86DB
      EEFF86DBEEFF86DBEEFF86DBEEFF86DBEEFF86DBEEFF86DBEEFF92A6AFFF87B9
      D0FF6F97A7FF00000000000000000000000000000000ACACACFFD9B08CFF98A9
      CBFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B0
      8CFFD9B08CFFACACACFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006BB1CFFF7BCDE5FF7CCF
      E6FFC0C0C0FFFDFDFDFFFBFBFBFFFBFBFBFFFCFCFCFFFBFBFBFFFBFBFBFFCBCB
      CBFFEEEEEEFFC9C9C9FF7777779F0000000087C0D0FF89DFF1FF89DFF1FF89DF
      F1FF89DFF1FF89DFF1FF89DFF1FF89DFF1FF89DFF1FF89DFF1FF87A0AAFF90BF
      D4FF6F97A7FF00000000000000000000000000000000ADADADFFFCFCFCFF98A9
      CBFFF8F8F8FFF8F8F8FFFAFAFAFFF8F8F8FFF8F8F8FFF7F7F7FFF6F6F6FFF3F3
      F3FFFCFCFCFFADADADFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006CB2D0FF7DD0E7FFA0A3
      A4FF929596FF8B8E8FFF848788FF848788FF7C8081FF7C8081FF7C8081FFE9E9
      E9FFCACACAFF7777779F00000000000000008CC4D3FF8CE3F4FF8CE3F4FF8CE3
      F4FF8CE3F4FF8CE3F4FF8CE3F4FF8CE3F4FF8CE3F4FF8CE3F4FF8AA1ABFF98C5
      D9FF6F97A7FF00000000000000000000000000000000AFAFAFFFD9B08CFF98A9
      CBFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFD9B08CFFAFAFAFFFBCBC
      BCFFD0D0D0FFA2A2A2EF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006DB3D0FF80D3E9FF81BA
      C9FF848686FF8B8D8EFF9EA3A4FFA5ADAEFF8F9292FF848586FFAAAAAAFFC0C0
      C0FF93B2C0FF00000000000000000000000091C9D7FF8FE7F8FF8FE7F8FF8FE7
      F8FF8FE7F8FF8FE7F8FF8FE7F8FF8FE7F8FF8FE7F8FF8FE7F8FF8DA3ACFFA0CB
      DDFF6F97A7FF00000000000000000000000000000000AFAFAFFF7C7C7DFF98A9
      CBFFFAFAFAFFFBFBFBFFFBFBFBFFFBFBFBFFFAFAFAFFF8F8F8FFBCBCBCFFD9D9
      D9FFA4A4A4EF2121213000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006EB4D1FF82D6ECFF84D8
      EDFF898A8AFFBFC3C4FFB6BBBCFFC8D0D1FFC1C5C6FF828383FF8EE8F9FF90EA
      FAFF50A2C5FF00000000000000000000000096CEDAFF92EBFBFF92EBFBFF92EB
      FBFF92EBFBFF92EBFBFF92EBFBFF92EBFBFF92EBFBFF92EBFBFF6D8F9DFFA7CF
      E0FF6F97A7FF00000000000000000000000000000000AFAFAFFFFFFFFFFF98A9
      CBFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFF8F8F8FFD0D0D0FFA4A4
      A4EF212121300000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006FB6D2FF6FB6D2FF70B7
      D3FF6C8F9EFF7296A4FF849298FF86959BFF6B8F9DFF6D929FFF72BBD7FF65B4
      D2FF5BABCBFF000000000000000000000000759EA5C09BD2DDFF9BD2DDFF9BD2
      DDFF9BD2DDFF9BD2DDFF9BD2DDFF9BD2DDFF9BD2DDFF9BD2DDFF879FA9FF729A
      A7E0384C548000000000000000000000000000000000AFAFAFFFAFAFAFFFAFAF
      AFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFA4A4A4EF2121
      2130000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
