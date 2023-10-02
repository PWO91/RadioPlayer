unit Player.Frm.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Layouts,
  System.Actions, FMX.ActnList, FMX.Ani, FMX.ListBox,
  FMX.Effects, FMX.Media, FMX.MediaLibrary, FMX.Platform, System.Messaging,
  FMX.StdActns, FMX.MediaLibrary.Actions,
  Fmx.DialogService, FMX.WebBrowser, Bass, BassEnc, BassEnc_FLAC, BassEnc_MP3, BassEnc_OGG, BassEnc_OPUS, BassFLAC,

  Player.Common, Player.Frm.Player, Player.Frm.Item, Player.Frm.News, PLayer.Frm.Channels, Player.Frm.Channels.Edit,


  {
    Load Platform unit based of platform
  }

  {$IF Defined(ANDROID)}
   FMX.Platform.Android,
  {$ENDIF}

  {$IF Defined(WIN64)}
   FMX.Platform.Win,
  {$ENDIF}
  StrUtils, System.Math.Vectors, FMX.Controls3D,
  FMX.Layers3D,
  Player.Frm.Favorites;


type
  TPlayerFrmMain = class(TForm)
    TcBody: TTabControl;
    TiLogin: TTabItem;
    Rectangle2: TRectangle;
    StyleBook1: TStyleBook;
    TiPages: TTabItem;
    BottomMenu: TRectangle;
    TcContent: TTabControl;
    TiContent1: TTabItem;
    TiContent2: TTabItem;
    TiContent3: TTabItem;
    TiContent4: TTabItem;
    TiContent5: TTabItem;
    ActionList: TActionList;
    ChangeTabAction1: TChangeTabAction;
    Layout1: TLayout;
    Edit1: TEdit;
    Edit2: TEdit;
    SpeedButton6: TSpeedButton;
    Line1: TLine;
    Image6: TImage;
    Image7: TImage;
    Label3: TLabel;
    SpeedButton7: TSpeedButton;
    Label4: TLabel;
    GridPanelLayout2: TGridPanelLayout;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    FloatAnimation4: TFloatAnimation;
    GridPanelLayout1: TGridPanelLayout;
    BtGoHome: TSpeedButton;
    Image1: TImage;
    BtGoPlayer: TSpeedButton;
    Image2: TImage;
    BtGoNews: TSpeedButton;
    Image3: TImage;
    BtGoFavorites: TSpeedButton;
    Image4: TImage;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    PlayerContainer: TLayout;
    TcHeader: TTabControl;
    TiLogo: TTabItem;
    Rectangle1: TRectangle;
    Label1: TLabel;
    TiPlayer: TTabItem;
    Rectangle5: TRectangle;
    LbRadioTitle: TLabel;
    HeaderPlayer: TLayout;
    Circle1: TCircle;
    GlowEffect2: TGlowEffect;
    Circle2: TCircle;
    ImPlay: TImage;
    ImPause: TImage;
    GuiUpdate: TTimer;
    FloatAnimation1: TFloatAnimation;
    NewsContainer: TLayout;
    AFavorites: TAction;
    AChannels: TAction;
    ANews: TAction;
    APlayer: TAction;
    GoHomeGlow: TInnerGlowEffect;
    GoFavoritesGlow: TInnerGlowEffect;
    GoNewsGlow: TInnerGlowEffect;
    GoPlayerGlow: TInnerGlowEffect;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure OpenPlayerClick(Sender: TObject);
    procedure BtShowPlayerClick(Sender: TObject);
    procedure GuiUpdateTimer(Sender: TObject);
    procedure Circle1Click(Sender: TObject);

    procedure RefreshLists;
    procedure EditItem(Channel: TChannel);
    procedure AddItem;
    procedure GoHome;
    procedure AFavoritesExecute(Sender: TObject);
    procedure AChannelsExecute(Sender: TObject);
    procedure ANewsExecute(Sender: TObject);
    procedure APlayerExecute(Sender: TObject);
  private
    procedure ShowPlayer;
  public

  end;

var
  PlayerFrmMain: TPlayerFrmMain;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.GGlass.fmx ANDROID}
{$R *.Moto360.fmx ANDROID}

procedure TPlayerFrmMain.AChannelsExecute(Sender: TObject);
begin
  if not Assigned(PlayerFrmChannels) then
  begin
    PlayerFrmChannels := TPlayerFrmChannels.Create(Application);
    PlayerFrmChannels.Container.Parent := TiContent3;
  end;

  PlayerFrmChannels.Refresh;

  TcContent.SetActiveTabWithTransition(TiContent1, TTabTransition.Slide);
  TcHeader.SetActiveTabWithTransition(TiLogo, TTabTransition.Slide);
end;

procedure TPlayerFrmMain.AddItem;
var
  NewChannel: TChannel;
begin
  if not Assigned(PlayerFrmChannelsEdit) then
  begin
    PlayerFrmChannelsEdit:= TPlayerFrmChannelsEdit.Create(Application);
    PlayerFrmChannelsEdit.Container.Parent := TiContent5;
  end;



  NewChannel.Id := 0;
  NewChannel.Title := 'Title';
  NewChannel.Url:= 'http://';
  NewChannel.Favorite := 0;
  PlayerFrmChannelsEdit.Channel:= NewChannel;


  TcContent.SetActiveTabWithTransition(TiContent5, TTabTransition.Slide);
end;

procedure TPlayerFrmMain.AFavoritesExecute(Sender: TObject);
begin
  if not Assigned(FrmPlayerFavorites) then
  begin
    FrmPlayerFavorites := TFrmPlayerFavorites.Create(Application);
    FrmPlayerFavorites.Container.Parent := TiContent3;
  end;

  FrmPlayerFavorites.Refresh;

  TcContent.SetActiveTabWithTransition(TiContent3, TTabTransition.Slide);

  if Common.Url <> '' then
  TcHeader.SetActiveTabWithTransition(TiPlayer, TTabTransition.Slide) else
  TcHeader.SetActiveTabWithTransition(TiLogo, TTabTransition.Slide);
end;

procedure TPlayerFrmMain.ANewsExecute(Sender: TObject);
begin
  if not Assigned(FrmPlayerNews) then
  begin
    FrmPlayerNews := TFrmPlayerNews.Create(Application);
    FrmPlayerNews.Container.Parent := NewsContainer;
  end;

  TcContent.SetActiveTabWithTransition(TiContent4, TTabTransition.Slide);
end;

procedure TPlayerFrmMain.APlayerExecute(Sender: TObject);
begin
  ShowPlayer;
end;

procedure TPlayerFrmMain.BtShowPlayerClick(Sender: TObject);
begin
  if Common.Url <> '' then
  TcHeader.SetActiveTabWithTransition(TiPlayer, TTabTransition.Slide) else
  TcHeader.SetActiveTabWithTransition(TiLogo, TTabTransition.Slide);
  //CreateFavoriteList;
end;

procedure TPlayerFrmMain.Circle1Click(Sender: TObject);
begin
  if Common.GetChannelState = 1 then
  Common.PauseChannel else
  Common.PlayChannel;
end;


procedure TPlayerFrmMain.EditItem(Channel: TChannel);
begin
  if not Assigned(PlayerFrmChannelsEdit) then
    PlayerFrmChannelsEdit:= TPlayerFrmChannelsEdit.Create(Application);

  PlayerFrmChannelsEdit.Channel := Channel;
  PlayerFrmChannelsEdit.Container.Parent := TiContent5;
  TcContent.SetActiveTabWithTransition(TiContent5, TTabTransition.Slide);
end;

procedure TPlayerFrmMain.FormCreate(Sender: TObject);
begin
  //Setup screents for default view
  TcHeader.TabPosition:= TTabPosition.None;
  TcBody.TabPosition:= TTabPosition.None;
  TcContent.TabPosition:= TTabPosition.None;
  TcBody.ActiveTab:= TiLogin;
  TcHeader.ActiveTab:= TiLogo;
  TcContent.ActiveTab:= TiContent1;
  //Initalizaction of BASS
  {$IF Defined(ANDROID)}
    BASS_Init(-1,44100,0, WindowHandleToPlatform(self.Handle), 0);
  {$ENDIF}

  {$IF Defined(WIN64)}
    BASS_Init(-1,44100,0, WindowHandleToPlatform(self.Handle).Wnd, NIL);
  {$ENDIF}

  //Create station list
  RefreshLists;
end;

procedure TPlayerFrmMain.GoHome;
begin
  TcContent.SetActiveTabWithTransition(TiContent2, TTabTransition.Slide);
end;

{
  Timer for update gui of the main form, for example,
  visibility of play/pause button durring playing channel
}
procedure TPlayerFrmMain.GuiUpdateTimer(Sender: TObject);
begin
    HeaderPlayer.Visible := Common.Url <> '';
    case Common.GetChannelState of
    1:begin
        ImPlay.Visible:= False;
        ImPause.Visible:= True;
      end;
    0,2,3:begin
        ImPlay.Visible:= True;
        ImPause.Visible:= False;
      end;
  end;

end;

procedure TPlayerFrmMain.Label1Click(Sender: TObject);
begin
  TcBody.ActiveTab:= TiLogin;
end;

{
  This OnClick procedure is attached to item in Station/Favorites
  ListBox. If use click that item, attached channel start play.
}
procedure TPlayerFrmMain.OpenPlayerClick(Sender: TObject);
var
  Cmp: TControl;
begin
  //Take data from frame
  Cmp := (Sender as TControl);

  with Common do
  begin
    Url := (Cmp.Parent as TFrmItem).LbUrl.Text;
    Title := (Cmp.Parent as TFrmItem).LbTitle.Text;
    LbRadioTitle.Text := Title;
  end;

  //Start play
  Common.PlayChannel;

  //Show header with player control
  TcHeader.SetActiveTabWithTransition(TiPlayer, TTabTransition.Slide);
end;

procedure TPlayerFrmMain.RefreshLists;
begin
  if not Assigned(FrmPlayer) then
  begin
    FrmPlayer := TFrmPlayer.Create(Application);
    FrmPlayer.Container.Parent := PlayerContainer;
  end;
  if Common.Url <> '' then
  TcHeader.SetActiveTabWithTransition(TiPlayer, TTabTransition.Slide) else
  TcHeader.SetActiveTabWithTransition(TiLogo, TTabTransition.Slide);
  TcContent.SetActiveTabWithTransition(TiContent1, TTabTransition.Slide);
end;

{
  Show player
}
procedure TPlayerFrmMain.ShowPlayer;
begin
  if not Assigned(FrmPlayer) then
  begin
    FrmPlayer := TFrmPlayer.Create(Application);
    FrmPlayer.Container.Parent := PlayerContainer;
  end;
  FrmPlayer.LbTitle.Text := Common.Title;
  FrmPlayer.Volume := Common.Volume;
  TcHeader.SetActiveTabWithTransition(TiLogo, TTabTransition.Slide);
  TcContent.SetActiveTabWithTransition(TiContent2, TTabTransition.Slide);
end;

procedure TPlayerFrmMain.SpeedButton5Click(Sender: TObject);
begin
 TcContent.SetActiveTabWithTransition(TiContent5, TTabTransition.Slide);
end;

procedure TPlayerFrmMain.SpeedButton6Click(Sender: TObject);
begin
  if Not Assigned(PlayerFrmChannels) then
  begin
    PlayerFrmChannels := TPlayerFrmChannels.Create(Application);
    PlayerFrmChannels.Container.Parent := TiContent1;
  end;

  BottomMenu.Size.Height := 0.0;
  FloatAnimation1.Start;
  TcBody.SetActiveTabWithTransition(TiPages, TTabTransition.Slide);

end;

end.
