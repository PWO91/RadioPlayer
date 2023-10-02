unit Player.Common;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, System.IOUtils,
  Fmx.Dialogs,

  {$IF Defined(ANDROID)}
   System.Android.Service,
  {$ENDIF}

  Bass,
  System.Generics.Collections,
  Fmx.ListBox, FireDAC.Comp.UI;

type

  TChannel = record
    Id: Integer;
    Title: string;
    Url: string;
    Favorite: Integer;
  end;

  TPChannel = TPair<integer, TChannel>;

  TChannels = TDictionary<Integer, TChannel>;

  TCommon = class(TDataModule)
    Connection: TFDConnection;
    QNews: TFDQuery;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    {$IF Defined(ANDROID32)}
    FService: TLocalServiceConnection;
    {$ENDIF}
    FTitle: String;
    FUrl: String;
    FActiveChannel : HSTREAM;
    FLastUrl: String;
    function GetVolume: Single;
    procedure SetVolume(const Value: Single);
    function SelectConnection(Value: TFDConnection) : TFDConnection;
  public
    property Title: String read FTitle write FTitle;
    property Url: String read FUrl write FUrl;
    property ActiveChannel: HSTREAM read FActiveChannel write FActiveChannel;
    property Volume: Single read GetVolume write SetVolume;
    //Player control
    procedure PlayChannel;
    procedure PauseChannel;
    function GetChannelState: Integer;
    function GetChannelLevel: Cardinal;

    function AddEditChannel(const Value: TChannel; Connection: TFDConnection = nil): Boolean;
    function GetStations(const Filter: string='';  Connection: TFDConnection = nil) : TChannels;
    procedure ClearListBox(var ListBox: TListBox);
    procedure AddChannelToListBox(const Channel: TPChannel; var ListBox: TListBox);
    procedure ToggleFavorite(const Channel: TChannel);
    procedure UpdateChannel(const Channel: TCHannel);
  end;

function HiWord(x:longword):word;
function LoWord(x:longword):word;

var
  Common: TCommon;


implementation

uses
   Player.Frm.Channels.Item;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function HiWord(x:longword):word;
begin
        HiWord := (x and $FFFF0000) shr 16;
end;
function LoWord(x:longword):word;
begin
        LoWord := (x and $0000FFFF);
end;

procedure TCommon.PauseChannel;
begin
  BASS_ChannelPause(Common.FActiveChannel);
end;

procedure TCommon.PlayChannel;
begin
  if FLastUrl <> FUrl then
  begin
    BASS_StreamFree(Common.FActiveChannel);
    Common.FActiveChannel := BASS_StreamCreateURL(PChar(FUrl),
                                         0,
                                         BASS_STREAM_BLOCK or
                                         BASS_STREAM_STATUS or
                                         BASS_STREAM_AUTOFREE or
                                         BASS_UNICODE,
                                         nil,
                                         nil);
  end;
  BASS_ChannelPlay(Common.FActiveChannel, FALSE);
  FlastUrl:= FUrl;
end;

function TCommon.SelectConnection(Value: TFDConnection): TFDConnection;
begin
  if Assigned(Value) then
    Result := Value else
    Result := Connection;
end;

procedure TCommon.SetVolume(const Value: Single);
begin
  BASS_SetVolume(Value);
end;

procedure TCommon.ToggleFavorite(const Channel: TChannel);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(Self);
  try
    Query.Connection := SelectConnection(Connection);
    Query.SQL.Add('UPDATE PLAYLIST SET Favorite= Not Favorite WHERE Id=:Id');
    Query.ParamByName('Id').AsInteger := Channel.Id;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TCommon.UpdateChannel(const Channel: TChannel);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(Self);
  try
    Query.Connection := SelectConnection(Connection);
    Query.SQL.Add('UPDATE PLAYLIST SET Title=:Title, Url=:Url, Favorite=:Favorite WHERE Id=:Id');
    Query.ParamByName('Title').AsString := Channel.Title;
    Query.ParamByName('Url').AsString := Channel.Url;
    Query.ParamByName('Favorite').AsInteger := Channel.Favorite;
    Query.ParamByName('Id').AsInteger := Channel.Id;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

function TCommon.GetVolume: Single;
begin
  Result := BASS_GetVolume;
end;

function TCommon.GetChannelLevel: Cardinal;
begin
  Result := BASS_ChannelGetLevel(FActiveChannel);
end;

function TCommon.GetChannelState: Integer;
begin
{
  BASS_ACTIVE_STOPPED = 0;
  BASS_ACTIVE_PLAYING = 1;
  BASS_ACTIVE_STALLED = 2;
  BASS_ACTIVE_PAUSED = 3;
}
  Result := Bass.BASS_ChannelIsActive(Common.FActiveChannel);
end;

{
  @param(Value TChannel record thant need to o added to database)
  @returns(@true to success, @false error)
  Method use to add new station to database
}
function TCommon.GetStations(const Filter: string; Connection: TFDConnection): TChannels;
var
  Query: TFDQuery;
  Channel: TChannel;
begin
  Query := TFDQuery.Create(Self);
  Result := TChannels.Create;
  try
    Query.Connection := SelectConnection(Connection);
    Query.SQL.Add('Select * From PLAYLIST Where Upper(Title) LIKE UPPER(:Filter) Order By Id');
    Query.ParamByName('Filter').Value := Filter.QuotedString('%');
    Query.Open;

    Query.First;
    while not Query.Eof do
    begin
      Channel.Id        := Query.FieldByName('Id').AsInteger;
      Channel.Title     := Query.FieldByName('Title').AsString;
      Channel.Url       := Query.FieldByName('Url').AsString;
      Channel.Favorite  := Query.FieldByName('Favorite').AsInteger;

      Result.Add(Channel.Id, Channel);

      Query.Next;
    end;

  finally
    Query.Close;
    FreeAndNil(Query);
  end;
end;


{
  This method is use to add channel item do ListBox
}
procedure TCommon.AddChannelToListBox(const Channel: TPChannel; var ListBox: TListBox);
var
  Item: TPlayerFrmChannelsItem;
  LbItem: TListBoxItem;
begin
  LbItem := TListBoxItem.Create(ListBox);
  LbItem.Name := 'StationItem' + Channel.Value.Id.ToString;
  LbItem.Text := '';
  Item:= TPlayerFrmChannelsItem.Create(LbItem);

  Item.Channel := Channel.Value;

  if Channel.Value.Favorite = 1 then
    Item.ImgFavorite.Opacity := 1.0;

   Item.Height:= 50;

   LbItem.Width := Item.Width;
   LbItem.Height:= Item.Height;

   Item.Container.Parent := LbItem;

   ListBox.AddObject(LbItem);
   ListBox.ItemHeight:= Item.Height + 10;
end;

function TCommon.AddEditChannel(const Value: TChannel; Connection: TFDConnection): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(Self);
  try
    Query.Connection := SelectConnection(Connection);

    //Add new channel because Id = 0
    if Value.Id = 0 then
    begin
      Query.SQL.Add('Insert Into PLAYLIST (Title, Url) Values (:Title, :Url)');
      Query.ParamByName('Title').AsString := Value.Title;
      Query.ParamByName('Url').AsString := Value.Url;
      Query.ExecSQL;
      Result := True;
    end;

    //Add new channel because Id = 0
    if Value.Id <> 0 then
    begin
      Query.SQL.Add('Update PLAYLIST Set Title=:Title, Url=:Url Where Id=:Id');
      Query.ParamByName('Title').AsString := Value.Title;
      Query.ParamByName('Url').AsString := Value.Url;
      Query.ParamByName('Id').AsInteger := Value.Id;
      Query.ExecSQL;
      Result := True;
    end;

  finally
    FreeAndNil(Query);
  end;
end;

procedure TCommon.ClearListBox(var ListBox: TListBox);
var
  i: Integer;
begin
  //Clear all components attached to ListBox
  for I := ListBox.ComponentCount-1 downto 0  do
    if ListBox.Components[i].ClassName = 'TListBoxItem' then
      FreeAndNil(ListBox.Components[i]);
end;

procedure TCommon.DataModuleCreate(Sender: TObject);
begin
  {$IF Defined(ANDROID)}
  Connection.Params.Values['Database'] :=
      TPath.Combine(TPath.GetDocumentsPath, 'Base.db');
  {$ENDIF}
  Connection.Connected:= True;


end;

end.
