unit Player.Frm.Channels.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Objects, FMX.Controls.Presentation, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Fmx.TabControl, Player.Common;

type
  TPlayerFrmChannelsItem = class(TForm)
    Container: TRectangle;
    BtFavorite: TSpeedButton;
    ImgFavorite: TImage;
    GlowEffect1: TGlowEffect;
    LbTitle: TLabel;
    imgSong: TImage;
    LbUrl: TLabel;
    BtSettings: TSpeedButton;
    ImgSettings: TImage;
    procedure ContainerClick(Sender: TObject);
    procedure BtFavoriteClick(Sender: TObject);
    procedure BtSettingsClick(Sender: TObject);
  private
    FChannel: TChannel;
    procedure SetChannel(Channel: TChannel);
  public
    property Channel: TChannel read FChannel write SetChannel;
  end;

var
  PlayerFrmChannelsItem: TPlayerFrmChannelsItem;

implementation

uses
  Player.Frm.Channels,
  Player.Frm.Favorites,
  Player.Frm.Main;

{$R *.fmx}

{Getters and setters}
procedure TPlayerFrmChannelsItem.BtSettingsClick(Sender: TObject);
begin
  PlayerFrmMain.EditItem(Channel);
end;

procedure TPlayerFrmChannelsItem.ContainerClick(Sender: TObject);
begin
  Common.Url := FChannel.Url;
  Common.Title := FChannel.Title;
  Common.PlayChannel;
  PlayerFrmMain.TcHeader.SetActiveTabWithTransition(PlayerFrmMain.TiPlayer, TTabTransition.Slide);
end;


procedure TPlayerFrmChannelsItem.SetChannel(Channel: TChannel);
begin
  FChannel := Channel;
  LbTitle.Text:= FChannel.Title;
  LbUrl.Text:= FChannel.Url;
end;

procedure TPlayerFrmChannelsItem.BtFavoriteClick(Sender: TObject);
begin
  Common.ToggleFavorite(FChannel);

  if Assigned(PlayerFrmChannels) then
    PlayerFrmChannels.Refresh;
  if Assigned(FrmPlayerFavorites) then
    FrmPlayerFavorites.Refresh;
end;


end.
