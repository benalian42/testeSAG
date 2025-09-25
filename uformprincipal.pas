unit uFormPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, ExtCtrls,
  ComCtrls, StdCtrls, DBCtrls, DB, uDataModule, uModels, Buttons, Spin;

type
  { TFormPrincipal }
  TFormPrincipal = class(TForm)
    DBGridLotes: TDBGrid;
    dsLotes: TDataSource;
    GroupBoxSaude: TGroupBox;
    PageControlDetalhes: TPageControl;
    PainelDireito: TPanel;
    PainelEsquerdo: TPanel;
    PanelIndicadorSaude: TPanel;
    LabelLotes: TLabel;
    TabPesagem: TTabSheet;
    LabelDataPesagem: TLabel;
    dtpDataPesagem: TDateTimePicker;
    LabelPesoMedio: TLabel;
    sePesoMedio: TSpinEdit;
    LabelQtdPesada: TLabel;
    seQtdPesada: TSpinEdit;
    btnSalvarPesagem: TButton;
    TabMortalidade: TTabSheet;
    LabelDataMortalidade: TLabel;
    dtpDataMortalidade: TDateTimePicker;
    LabelQtdMorta: TLabel;
    seQtdMorta: TSpinEdit;
    LabelObservacao: TLabel;
    memObservacao: TMemo;
    btnSalvarMortalidade: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSalvarMortalidadeClick(Sender: TObject);
    procedure btnSalvarPesagemClick(Sender: TObject);
  private
    procedure LimparCamposMortalidade;
    procedure LimparCamposPesagem;
    procedure AtualizarIndicadorSaude;
    procedure ZQryLotesAfterScroll(DataSet: TDataSet);
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.lfm}

{ TFormPrincipal }

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  dmDados.ZQryLotes.AfterScroll := ZQryLotesAfterScroll;
  try
    dmDados.Conectar;
    dmDados.ZQryLotes.Open;
    ZQryLotesAfterScroll(dmDados.ZQryLotes);
  except
    on E: Exception do
      ShowMessage('Erro ao conectar ao banco de dados: ' + E.Message);
  end;
end;

procedure TFormPrincipal.ZQryLotesAfterScroll(DataSet: TDataSet);
begin
  if dmDados.ZQryLotes.IsEmpty then
  begin
    PageControlDetalhes.Enabled := False;
    PanelIndicadorSaude.Color := clBtnFace;
    PanelIndicadorSaude.Caption := 'Nenhum Lote';
  end
  else
  begin
    PageControlDetalhes.Enabled := True;
    LimparCamposMortalidade;
    LimparCamposPesagem;
    AtualizarIndicadorSaude;
  end;
end;

procedure TFormPrincipal.AtualizarIndicadorSaude;
var
  Percentual: Double;
  IdLoteAtual: Integer;
begin
  if dmDados.ZQryLotes.IsEmpty then Exit;
  IdLoteAtual := dmDados.ZQryLotes.FieldByName('ID_LOTE').AsInteger;
  Percentual := dmDados.GetPercentualMortalidade(IdLoteAtual);
  PanelIndicadorSaude.Caption := FormatFloat('0.00' + '%', Percentual);
  if Percentual > 10 then
    PanelIndicadorSaude.Color := clRed
  else if Percentual >= 5 then
    PanelIndicadorSaude.Color := clYellow
  else
    PanelIndicadorSaude.Color := clGreen;
end;

procedure TFormPrincipal.btnSalvarMortalidadeClick(Sender: TObject);
var
  Mortalidade: TMortalidade;
begin
  if dmDados.ZQryLotes.IsEmpty then Exit;

  Mortalidade := TMortalidade.Create;
  try
    Mortalidade.IDLote := dmDados.ZQryLotes.FieldByName('ID_LOTE').AsInteger;
    Mortalidade.QuantidadeMorta := seQtdMorta.Value;
    Mortalidade.DataMortalidade := dtpDataMortalidade.DateTime;
    Mortalidade.Observacao := memObservacao.Lines.Text;

    if Mortalidade.QuantidadeMorta <= 0 then
    begin
      ShowMessage('A quantidade deve ser maior que zero.');
      seQtdMorta.SetFocus;
      Exit;
    end;

    dmDados.LancarMortalidade(Mortalidade);
    ShowMessage('Mortalidade registrada com sucesso!');
    LimparCamposMortalidade;
    AtualizarIndicadorSaude;
  except
    on E: Exception do
      ShowMessage(E.Message);
  finally
    Mortalidade.Free;
  end;
end;

procedure TFormPrincipal.btnSalvarPesagemClick(Sender: TObject);
var
 Pesagem: TPesagem;
begin
  if dmDados.ZQryLotes.IsEmpty then Exit;

  Pesagem := TPesagem.Create;
  try
    Pesagem.IDLote := dmDados.ZQryLotes.FieldByName('ID_LOTE').AsInteger;
    Pesagem.QuantidadePesada := seQtdPesada.Value;
    Pesagem.DataPesagem := dtpDataPesagem.DateTime;
    Pesagem.PesoMedio := sePesoMedio.Value;

    if Pesagem.QuantidadePesada <= 0 then
    begin
      ShowMessage('A quantidade pesada deve ser maior que zero.');
      seQtdPesada.SetFocus;
      Exit;
    end;

    dmDados.LancarPesagem(Pesagem);
    ShowMessage('Pesagem registrada com sucesso!');
    LimparCamposPesagem;
  except
    on E: Exception do
      ShowMessage(E.Message);
  finally
    Pesagem.Free;
  end;
end;

procedure TFormPrincipal.LimparCamposMortalidade;
begin
  dtpDataMortalidade.Date := Now;
  seQtdMorta.Value := 0;
  memObservacao.Clear;
end;

procedure TFormPrincipal.LimparCamposPesagem;
begin
  dtpDataPesagem.Date := Now;
  sePesoMedio.Value := 0;
  seQtdPesada.Value := 0;
end;

end.
