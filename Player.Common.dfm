object Common: TCommon
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 461
  Width = 766
  object Connection: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\p.wojcik\Desktop\PlayerProject\assets\database' +
        '\Base.db'
      'OpenMode=ReadWrite'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 40
    Top = 24
  end
  object QNews: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'Select * From NEWS')
    Left = 120
    Top = 104
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 184
    Top = 104
  end
end
