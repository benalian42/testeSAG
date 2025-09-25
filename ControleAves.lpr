program ControleAves;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces,
  Forms,
  uModels,        // <-- Adicionado para referência
  uDataModule,
  uFormPrincipal;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  // A ordem é crucial: O Data Module deve ser criado antes do formulário que o utiliza.
  Application.CreateForm(TdmDados, dmDados);
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
