unit Player.Frm.Favorites;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox,
  Player.Common;

type
  TFrmPlayerFavorites = class(TForm)
    LbStations: TListBox;
    Container: TLayout;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Refresh(Filter: String = '');
  end;

var
  FrmPlayerFavorites: TFrmPlayerFavorites;

implementation

{$R *.fmx}

{ TFrmPlayerFavorites }



procedure TFrmPlayerFavorites.FormCreate(Sender: TObject);
begin
  Refresh;
end;

procedure TFrmPlayerFavorites.Refresh(Filter: String);
var
  Channel: TPChannel;
begin
  Common.ClearListBox(LbStations);

  for Channel in Common.GetStations(Filter) do
    if Channel.Value.Favorite = 1 then
      Common.AddChannelToListBox(Channel, LbStations);
end;

end.
