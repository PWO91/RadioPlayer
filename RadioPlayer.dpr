program RadioPlayer;

uses
  System.StartUpCopy,
  FMX.Forms,
  Player.Frm.Player in 'Player.Frm.Player.pas' {FrmPlayer},
  Player.Common in 'Player.Common.pas' {Common: TDataModule},
  Player.Frm.Main in 'Player.Frm.Main.pas' {PlayerFrmMain},
  Bass in 'BASS\Core\Bass.pas',
  BassEnc in 'BASS\Add-ons\BassEnc.pas',
  BassEnc_FLAC in 'BASS\Add-ons\BassEnc_FLAC.pas',
  BassEnc_MP3 in 'BASS\Add-ons\BassEnc_MP3.pas',
  BassEnc_OGG in 'BASS\Add-ons\BassEnc_OGG.pas',
  BassEnc_OPUS in 'BASS\Add-ons\BassEnc_OPUS.pas',
  BassFLAC in 'BASS\Add-ons\BassFLAC.pas',
  BassOPUS in 'BASS\Add-ons\BassOPUS.pas',
  Player.Frm.News in 'Player.Frm.News.pas' {FrmPlayerNews},
  Player.Frm.News.Item in 'Player.Frm.News.Item.pas' {PlayerFrmNewsItem},
  Player.Frm.Channels in 'Player.Frm.Channels.pas' {PlayerFrmChannels},
  Player.Frm.Channels.Item in 'Player.Frm.Channels.Item.pas' {PlayerFrmChannelsItem},
  Player.Frm.Channels.Edit in 'Player.Frm.Channels.Edit.pas' {PlayerFrmChannelsEdit},
  Tests in 'DUnit\Tests.pas',
  Player.Frm.Favorites in 'Player.Frm.Favorites.pas' {FrmPlayerFavorites};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCommon, Common);
  Application.CreateForm(TPlayerFrmMain, PlayerFrmMain);
  Application.Run;
end.
