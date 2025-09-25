unit uModels;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes;

type
  { TClasseBase }
  TClasseBase = class
  private
    FID: Integer;
  public
    property ID: Integer read FID write FID;
  end;

  { TLote }
  TLote = class(TClasseBase)
  private
    FDescricao: string;
    FDataEntrada: TDateTime;
    FQuantidadeInicial: Integer;
  public
    constructor Create;
    property Descricao: string read FDescricao write FDescricao;
    property DataEntrada: TDateTime read FDataEntrada write FDataEntrada;
    property QuantidadeInicial: Integer read FQuantidadeInicial write FQuantidadeInicial;
  end;

  { TPesagem }
  TPesagem = class(TClasseBase)
  private
    FIDLote: Integer;
    FDataPesagem: TDateTime;
    FPesoMedio: Double;
    FQuantidadePesada: Integer;
  public
    constructor Create;
    property IDLote: Integer read FIDLote write FIDLote;
    property DataPesagem: TDateTime read FDataPesagem write FDataPesagem;
    property PesoMedio: Double read FPesoMedio write FPesoMedio;
    property QuantidadePesada: Integer read FQuantidadePesada write FQuantidadePesada;
  end;

  { TMortalidade }
  TMortalidade = class(TClasseBase)
  private
    FIDLote: Integer;
    FDataMortalidade: TDateTime;
    FQuantidadeMorta: Integer;
    FObservacao: string;
  public
    constructor Create;
    property IDLote: Integer read FIDLote write FIDLote;
    property DataMortalidade: TDateTime read FDataMortalidade write FDataMortalidade;
    property QuantidadeMorta: Integer read FQuantidadeMorta write FQuantidadeMorta;
    property Observacao: string read FObservacao write FObservacao;
  end;

implementation

{ TLote }
constructor TLote.Create;
begin
  inherited Create;
  FID := 0;
  FQuantidadeInicial := 0;
  FDataEntrada := 0;
end;

{ TPesagem }
constructor TPesagem.Create;
begin
  inherited Create;
  FID := 0;
  FIDLote := 0;
  FDataPesagem := 0;
  FPesoMedio := 0.0;
  FQuantidadePesada := 0;
end;

{ TMortalidade }
constructor TMortalidade.Create;
begin
  inherited Create;
  FID := 0;
  FIDLote := 0;
  FDataMortalidade := 0;
  FQuantidadeMorta := 0;
end;

end.
