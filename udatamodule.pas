unit uDataModule;

interface

uses
  SysUtils, Classes, ZConnection, ZDataset, ZStoredProc, uModels;

type
  TdmDados = class(TDataModule)
    ZConnectionOracle: TZConnection;
    ZQryLotes: TZQuery;
    ZProcPesagem: ZStoredProc;
    ZProcMortalidade: ZStoredProc;
    ZQryAux: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  public
    procedure Conectar;
    procedure Desconectar;
    function LancarPesagem(const APesagem: TPesagem): Boolean;
    function LancarMortalidade(const AMortalidade: TMortalidade): Double;
    function GetPercentualMortalidade(const AID_LOTE: Integer): Double;
  end;

var
  dmDados: TdmDados;

implementation

{$R *.lfm}

{ TdmDados }

procedure TdmDados.DataModuleCreate(Sender: TObject);
begin
  ZConnectionOracle.HostName := 'localhost';
  ZConnectionOracle.Port := 1521;
  ZConnectionOracle.Database := 'XE'; // ou seu SID / Service Name
  ZConnectionOracle.User := 'system'; // seu usuário
  ZConnectionOracle.Password := 'oracle'; // sua senha
  ZConnectionOracle.Protocol := 'oracle';
  ZConnectionOracle.Connected := False;
end;

procedure TdmDados.DataModuleDestroy(Sender: TObject);
begin
  Desconectar;
end;

procedure TdmDados.Conectar;
begin
  if not ZConnectionOracle.Connected then
    ZConnectionOracle.Connect;
end;

procedure TdmDados.Desconectar;
begin
  if ZConnectionOracle.Connected then
    ZConnectionOracle.Disconnect;
end;

function TdmDados.LancarPesagem(const APesagem: TPesagem): Boolean;
begin
  Result := False;
  try
    with ZProcPesagem do
    begin
      ParamByName('P_ID_LOTE_FK').AsInteger := APesagem.IDLote;
      ParamByName('P_DATA_PESAGEM').AsDateTime := APesagem.DataPesagem;
      ParamByName('P_PESO_MEDIO').AsFloat := APesagem.PesoMedio;
      ParamByName('P_QUANTIDADE_PESADA').AsInteger := APesagem.QuantidadePesada;
      ExecProc;
    end;
    Result := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao lançar pesagem: ' + E.Message);
  end;
end;

function TdmDados.LancarMortalidade(const AMortalidade: TMortalidade): Double;
begin
  Result := -1;
  try
    with ZProcMortalidade do
    begin
      ParamByName('P_ID_LOTE_FK').AsInteger := AMortalidade.IDLote;
      ParamByName('P_DATA_MORTALIDADE').AsDateTime := AMortalidade.DataMortalidade;
      ParamByName('P_QUANTIDADE_MORTA').AsInteger := AMortalidade.QuantidadeMorta;
      ParamByName('P_OBSERVACAO').AsString := AMortalidade.Observacao;
      ExecProc;
      Result := ParamByName('P_PERCENTUAL_MORTALIDADE').AsFloat;
    end;
  except
    on E: Exception do
      raise Exception.Create('Erro ao lançar mortalidade: ' + E.Message);
  end;
end;

function TdmDados.GetPercentualMortalidade(const AID_LOTE: Integer): Double;
begin
  Result := 0;
  try
    ZQryAux.SQL.Text := 'SELECT FN_GET_PERCENTUAL_MORTALIDADE(:IDLOTE) AS PERC FROM DUAL';
    ZQryAux.ParamByName('IDLOTE').AsInteger := AID_LOTE;
    ZQryAux.Open;
    if not ZQryAux.IsEmpty then
      Result := ZQryAux.FieldByName('PERC').AsFloat;
  finally
    ZQryAux.Close;
  end;
end;

end.
