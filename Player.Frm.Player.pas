unit Player.Frm.Player;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects, FMX.Effects,
  Bass, Player.Common, FMX.Edit;

type
  TFrmPlayer = class(TForm)
    Container: TLayout;
    Layout1: TLayout;
    Layout2: TLayout;
    GlowEffect1: TGlowEffect;
    Circle1: TCircle;
    GlowEffect2: TGlowEffect;
    Circle2: TCircle;
    LbTitle: TLabel;
    TimerGuiUpdate: TTimer;
    ArcVolume: TArcDial;
    Layout3: TLayout;
    Layout4: TLayout;
    Image1: TImage;
    Image2: TImage;
    Layout5: TLayout;
    Image3: TImage;
    Rectangle1: TRectangle;
    LbVolume: TLabel;
    TimerVisUpdate: TTimer;
    ImPlay: TImage;
    ImPause: TImage;
    GridPanelLayout1: TGridPanelLayout;
    procedure Circle2Click(Sender: TObject);
    procedure TimerGuiUpdateTimer(Sender: TObject);
    procedure ArcVolumeChange(Sender: TObject);
    procedure TimerVisUpdateTimer(Sender: TObject);
  private
    FChannel: TChannel;
    function GetArcVolume: Single;
    procedure SetArcVolume(Value: Single);
    procedure SetChannel(Value: TChannel);
  public
    property Volume: Single read GetArcVolume write SetArcVolume;
    property Channel: TChannel read FChannel write SetChannel;
  end;

var
  FrmPlayer : TFrmPlayer;

implementation

{$R *.fmx}


function TFrmPlayer.GetArcVolume: Single;
var
  Volume: Single;
begin

   Volume := ArcVolume.Value;// / 180.0;

   if (Volume <= 180) and (Volume >= 0.0) then
   begin
    Volume := 360.0 - Volume;
    Result := Volume / 360.0 ;
    Exit;
   end;

   if Volume < 0.0 then
    Volume := Volume * -1.0;

   Result := Volume / 360.0
end;

procedure TFrmPlayer.SetArcVolume(Value: Single);
var
  Volume: Single;
begin
  Volume := Value;
  if Volume <= 0.5 then
  begin
    Volume := Volume * 360.0;
    ArcVolume.Value := Volume * -1.0;
    Exit;
   end;


  if Volume > 0.5 then
  begin
    Volume := 360.0 - (Volume * 360.0);
    ArcVolume.Value := Volume;
  end;
end;


procedure TFrmPlayer.SetChannel(Value: TChannel);
begin
  FChannel := Value;
  LbTitle.Text := FChannel.Title;
  Common.Url := FChannel.Url;
  Common.PlayChannel;
end;

procedure TFrmPlayer.ArcVolumeChange(Sender: TObject);
begin
  Common.Volume := Volume;
  LbVolume.Text := Trunc(Volume * 100).ToString + '%';
end;

procedure TFrmPlayer.Circle2Click(Sender: TObject);
begin
  if Common.GetChannelState = 1 then
  Common.PauseChannel else
  Common.PlayChannel;
end;



procedure TFrmPlayer.TimerVisUpdateTimer(Sender: TObject);
var
  Level: Cardinal;
  Left, Right: Word;
begin
  Level := Common.GetChannelLevel;
  Left:= HiWord(Level);
  Right:= LoWord(Level);


end;

procedure TFrmPlayer.TimerGuiUpdateTimer(Sender: TObject);
begin
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

end.
