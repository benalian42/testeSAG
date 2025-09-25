CREATE OR REPLACE PROCEDURE SP_INSERIR_PESAGEM (
    P_ID_LOTE_FK IN NUMBER,
    P_DATA_PESAGEM IN DATE,
    P_PESO_MEDIO IN NUMBER,
    P_QUANTIDADE_PESADA IN NUMBER
)
IS
    V_QTD_INICIAL NUMBER;
BEGIN
    -- Validação no backend (camada extra de segurança)
    SELECT QUANTIDADE_INICIAL INTO V_QTD_INICIAL
    FROM TAB_LOTE_AVES
    WHERE ID_LOTE = P_ID_LOTE_FK;

    IF P_QUANTIDADE_PESADA > V_QTD_INICIAL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Quantidade pesada não pode ser maior que a quantidade inicial do lote.');
    END IF;

    -- Inserção dos dados
    INSERT INTO TAB_PESAGEM (ID_LOTE_FK, DATA_PESAGEM, PESO_MEDIO, QUANTIDADE_PESADA)
    VALUES (P_ID_LOTE_FK, P_DATA_PESAGEM, P_PESO_MEDIO, P_QUANTIDADE_PESADA);

    -- Lógica extra: Não foi pedido para atualizar um campo de peso médio geral,
    -- mas se fosse, o código viria aqui.
    -- Ex: UPDATE TAB_LOTE_AVES SET PESO_MEDIO_GERAL = ... WHERE ID_LOTE = P_ID_LOTE_FK;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE; -- Propaga o erro para a aplicação cliente (Lazarus)
END;
/