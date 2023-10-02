unit Player.Frm.Channels.Edit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects, Player.Common,
  Fmx.TabControl, Fmx.DialogService, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TPlayerFrmChannelsEdit = class(TForm)
    Container: TLayout;
    LbTitle: TLabel;
    EdTitle: TEdit;
    EdUrl: TEdit;
    LbUrl: TLabel;
    GpBottom: TGridPanelLayout;
    BtCancel: TSpeedButton;
    BtDelete: TSpeedButton;
    BtSave: TSpeedButton;
    GlowEffect1: TGlowEffect;
    GlowEffect2: TGlowEffect;
    StyleBook1: TStyleBook;
    procedure BtSaveClick(Sender: TObject);
    procedure BtDeleteClick(Sender: TObject);
    procedure BtCancelClick(Sender: TObject);
  private
    FChannel: TChannel;
    procedure SetChannel(Channel: TChannel);
  public
    property Channel : TChannel read FChannel write SetChannel;
  end;

var
  PlayerFrmChannelsEdit: TPlayerFrmChannelsEdit;

implementation

uses
  Player.Frm.Main,
  Player.Frm.Channels;

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}

{ TPlayerFrmChannelsEdit }

procedure TPlayerFrmChannelsEdit.BtCancelClick(Sender: TObject);
begin
  PlayerFrmMain.TcContent.SetActiveTabWithTransition(PlayerFrmMain.TiContent1, TTabTransition.Slide);
end;

procedure TPlayerFrmChannelsEdit.BtDeleteClick(Sender: TObject);
begin
  TDialogService.MessageDialog('Delete channel?', TMsgDlgType.mtConfirmation,
    FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, 0,
    procedure(const AResult: TModalResult)
    begin

      //Delete channel if Yes
      if AResult = mrYes then
      begin
        with TFDQuery.Create(Application) do
        begin
          Connection := Common.Connection;
          SQL.Add('DELETE FROM PLAYLIST Where Id=:Id');
          ParamByName('Id').AsInteger := Channel.Id;
          ExecSQL;
          Free;
        end;
        PlayerFrmMain.GoHome;
      end;


    end);
end;

procedure TPlayerFrmChannelsEdit.BtSaveClick(Sender: TObject);
var
  NewChannel: TChannel;
begin

  with NewChannel do
  begin
    Id := FChannel.Id;
    Title := EdTitle.Text;
    Url := EdUrl.Text;
    Favorite := 0;
  end;

  if Common.AddEditChannel(NewChannel) then
  begin
    PlayerFrmChannels.Refresh;
    PlayerFrmMain.GoHome;
  end;
end;

procedure TPlayerFrmChannelsEdit.SetChannel(Channel: TChannel);
begin
  FChannel := Channel;
  EdTitle.Text := FChannel.Title;
  EdUrl.Text := FChannel.Url;
end;



end.
