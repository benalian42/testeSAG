CREATE OR REPLACE PACKAGE BODY PKG_GERENCIA_AVES AS

    -- (A procedure PRC_INSERIR_LOTE continua a mesma)
    PROCEDURE PRC_INSERIR_LOTE(...) IS ... END;

    PROCEDURE PRC_REGISTRAR_PESAGEM(
        p_id_lote           IN TAB_PESAGEM.ID_LOTE_FK%TYPE,
        p_data_pesagem      IN TAB_PESAGEM.DATA_PESAGEM%TYPE,
        p_peso_medio        IN TAB_PESAGEM.PESO_MEDIO%TYPES,
        p_quantidade_pesada IN TAB_PESAGEM.QUANTIDADE_PESADA%TYPE
    ) IS
        v_qtde_inicial NUMBER;
    BEGIN
        -- Validação 1: A quantidade pesada não pode ser maior que a inicial
        SELECT QUANTIDADE_INICIAL INTO v_qtde_inicial FROM TAB_LOTE_AVES WHERE ID_LOTE = p_id_lote;
        IF p_quantidade_pesada > v_qtde_inicial THEN
            RAISE_APPLICATION_ERROR(-20001, 'A quantidade de aves pesadas (' || p_quantidade_pesada || ') não pode exceder a quantidade inicial do lote (' || v_qtde_inicial || ').');
        END IF;

        -- Insere o registro de pesagem
        INSERT INTO TAB_PESAGEM (ID_LOTE_FK, DATA_PESAGEM, PESO_MEDIO, QUANTIDADE_PESADA)
        VALUES (p_id_lote, p_data_pesagem, p_peso_medio, p_quantidade_pesada);

        -- Atualiza o campo de peso médio atual do lote com o último peso registrado
        -- (Esta é uma interpretação da regra de negócio)
        UPDATE TAB_LOTE_AVES
        SET PESO_MEDIO_ATUAL = p_peso_medio
        WHERE ID_LOTE = p_id_lote;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE; -- Propaga o erro para a aplicação cliente (Lazarus)
    END PRC_REGISTRAR_PESAGEM;


    PROCEDURE PRC_REGISTRAR_MORTALIDADE(
        p_id_lote               IN TAB_MORTALIDADE.ID_LOTE_FK%TYPE,
        p_data_mortalidade      IN TAB_MORTALIDADE.DATA_MORTALIDADE%TYPE,
        p_quantidade_morta      IN TAB_MORTALIDADE.QUANTIDADE_MORTA%TYPE,
        p_observacao            IN TAB_MORTALIDADE.OBSERVACAO%TYPE DEFAULT NULL,
        p_perc_mortalidade_out  OUT NUMBER -- Parâmetro de SAÍDA
    ) IS
        v_qtde_inicial NUMBER;
        v_total_mortas_anterior NUMBER;
    BEGIN
        -- Busca dados do lote
        SELECT QUANTIDADE_INICIAL INTO v_qtde_inicial FROM TAB_LOTE_AVES WHERE ID_LOTE = p_id_lote;
        SELECT NVL(SUM(QUANTIDADE_MORTA), 0) INTO v_total_mortas_anterior FROM TAB_MORTALIDADE WHERE ID_LOTE_FK = p_id_lote;

        -- Validação 2: A soma das mortalidades não pode ultrapassar a quantidade inicial
        IF (v_total_mortas_anterior + p_quantidade_morta) > v_qtde_inicial THEN
            RAISE_APPLICATION_ERROR(-20002, 'A mortalidade acumulada (' || (v_total_mortas_anterior + p_quantidade_morta) || ') excederia a quantidade inicial do lote (' || v_qtde_inicial || ').');
        END IF;

        -- Insere o novo registro
        INSERT INTO TAB_MORTALIDADE (ID_LOTE_FK, DATA_MORTALIDADE, QUANTIDADE_MORTA, OBSERVACAO)
        VALUES (p_id_lote, p_data_mortalidade, p_quantidade_morta, p_observacao);

        -- Calcula o percentual de mortalidade e o atribui ao parâmetro de saída
        p_perc_mortalidade_out := ((v_total_mortas_anterior + p_quantidade_morta) / v_qtde_inicial) * 100;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END PRC_REGISTRAR_MORTALIDADE;

    -- (A procedure PRC_RELATORIO_LOTE continua a mesma)
    PROCEDURE PRC_RELATORIO_LOTE(...) IS ... END;

END PKG_GERENCIA_AVES;
/