unit Player.Frm.News.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Effects, FMX.Layouts;

type
  TPlayerFrmNewsItem = class(TForm)
    Rectangle1: TRectangle;
    Image1: TImage;
    Label1: TLabel;
    GlowEffect1: TGlowEffect;
    Layout1: TLayout;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PlayerFrmNewsItem: TPlayerFrmNewsItem;

implementation

{$R *.fmx}

end.
