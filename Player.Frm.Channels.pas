unit Player.Frm.Channels;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.ListBox,
  StrUtils,
  System.Generics.Collections;

type
  TPlayerFrmChannels = class(TForm)
    HeaderSearch: TRectangle;
    EdSearchStation: TEdit;
    ImgSearch: TImage;
    LbSearch: TLabel;
    LbStations: TListBox;
    Container: TLayout;
    BtAdd: TButton;
    procedure FormCreate(Sender: TObject);
    procedure EdSearchStationChange(Sender: TObject);
    procedure BtAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Refresh(Filter: String = '');
  end;

var
  PlayerFrmChannels: TPlayerFrmChannels;

implementation

uses
  Player.Frm.Main,
  Player.Common,
  Player.Frm.Channels.Item;
{$R *.fmx}

{ TPlayerFrmChannels }

procedure TPlayerFrmChannels.BtAddClick(Sender: TObject);
begin
  PlayerFrmMain.AddItem;
end;

{
  @param(Filter filter for listing)
  This method is use to generate list of channels from database on main page
}

procedure TPlayerFrmChannels.EdSearchStationChange(Sender: TObject);
begin
  Refresh(EdSearchStation.Text);
end;

procedure TPlayerFrmChannels.FormCreate(Sender: TObject);
begin
  Refresh;
end;

procedure TPlayerFrmChannels.Refresh(Filter: String);
var
  Channel: TPChannel;
begin
  Common.ClearListBox(LbStations);

  for Channel in Common.GetStations(Filter) do
    Common.AddChannelToListBox(Channel, LbStations);
end;

end.
