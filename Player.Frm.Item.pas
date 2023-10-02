unit Player.Frm.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Ani, FMX.Controls.Presentation, FMX.Effects,
  FMX.Filter.Effects,
  Bass, Player.Common, Data.FMTBcd, Data.DB, Data.SqlExpr, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type

  TFrmItem = class(TFrame)
    Content: TRectangle;
    SpeedButton1: TSpeedButton;
    GlowEffect1: TGlowEffect;
    Image1: TImage;
    LbTitle: TLabel;
    Image2: TImage;
    Image3: TImage;
    LbUrl: TLabel;
    procedure Image1Click(Sender: TObject);
  private
    FTitle: String;
    FUrl: String;
    FId: Integer;
    procedure SetTitle(Title: String);
    function GetTitle: string;
    procedure SetUrl(Url: String);
    function GetUrl: string;
  public
    PanelOpened: Boolean;
    property Title: String read GetTitle write SetTitle;
    property Url: String read GetUrl write SetUrl;
    property Id: Integer read FId write FId;
    procedure SetFormData(Title, Url: String);
  end;

implementation

uses
  Player.Frm.Main;

{$R *.fmx}



{Getters and setters}
function TFrmItem.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TFrmItem.SetTitle(Title: String);
begin
  FTitle:= Title;
  lbTitle.Text := FTitle;
  Common.Title:= FTitle;
end;


function TFrmItem.GetUrl: string;
begin
  Result := FUrl;
end;

procedure TFrmItem.SetUrl(Url: String);
begin
  FUrl:= Url;
  LbUrl.Text := FUrl;
end;

procedure TFrmItem.SetFormData(Title, Url: String);
begin
  LbTitle.Text := Title;
  LbUrl.Text := Url;
  Common.Url := FUrl;
end;

procedure TFrmItem.Image1Click(Sender: TObject);
begin
  with TFDQuery.Create(Self) do
  begin
    Connection := Common.Connection;
    SQL.Add('UPDATE PLAYLIST SET Favorite=:Fav WHERE Id=:Id');
    ParamByName('Id').AsInteger := FId;
    if Image1.Opacity = 1.0 then
      ParamByName('Fav').AsInteger := 0 else
      ParamByName('Fav').AsInteger := 1;
    ExecSQL;
    Free;
  end;
  PlayerFrmMain.RefreshLists;
end;




end.
