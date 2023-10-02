unit Player.Frm.News;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.WebBrowser, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, Bass,
  FMX.ListBox;

type
  TFrmPlayerNews = class(TForm)
    Container: TLayout;
    LbNews: TListBox;
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure CreateNewsList;
  end;

var
  FrmPlayerNews: TFrmPlayerNews;

implementation

uses
  Player.Frm.News.Item,
  Player.Common;

{$R *.fmx}

procedure TFrmPlayerNews.CreateNewsList;
var
  Item: TPlayerFrmNewsItem;
  LbItem: TListBoxItem;
  i: Integer;
begin
  with Common do
  begin
    QNews.Close;
    QNews.Open;
    QNews.First;

    //Clear all components attached to ListBox
    for I := LbNews.ComponentCount-1 downto 0  do
      if LbNews.Components[i].ClassName = 'TListBoxItem' then
      begin
        FreeAndNil(LbNews.Components[i].Components[0]);
        FreeAndNil(LbNews.Components[i]);
      end;


    while not QNews.Eof do
    begin
      LbItem := TListBoxItem.Create(LbNews);
      LbItem.Name := 'NewsItem' + QNews.FieldByName('Id').AsString;
      LbItem.Text := '';
      Item:= TPlayerFrmNewsItem.Create(LbItem);
      Item.Name := 'Item' + QNews.FieldByName('Id').AsString;

      Item.Rectangle1.Parent := LbItem;
      LbItem.Width := Item.Width;
      LbItem.Height:= 93;


      LbNews.AddObject(LbItem);
      LbNews.ItemHeight:= Item.Height + 10;

      QNews.Next;
    end;
    QNews.Close;
  end;

end;

procedure TFrmPlayerNews.FormCreate(Sender: TObject);
begin
  CreateNewsList;
end;

end.
