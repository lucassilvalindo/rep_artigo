-- =====================================================================
-- ARTIGO TÉCNICO: DESNORMALIZAÇÃO EM BANCOS DE DADOS RELACIONAIS
-- Cenário 2: Modelo Analítico / OLAP (Tabela Achatada / Desnormalizada)
-- SGBD: PostgreSQL (Versão 15 ou superior)
-- =====================================================================

-- 1. Eliminação da tabela desnormalizada caso já exista
DROP TABLE IF EXISTS relatorio_vendas_desnormalizado CASCADE;

-- 2. Criação da Tabela Achatada (Desnormalizada)
-- Repare que aqui duplicamos propositadamente dados de clientes e produtos 
-- para evitar junções na hora de gerar relatórios consolidados.
CREATE TABLE relatorio_vendas_desnormalizado (
    id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL,
    data_pedido TIMESTAMP NOT NULL,
    -- Dados duplicados do Cliente (Redundância controlada)
    cliente_id INT NOT NULL,
    nome_cliente VARCHAR(100) NOT NULL,
    cidade_cliente VARCHAR(50) NOT NULL,
    estado_cliente VARCHAR(2) NOT NULL,
    -- Dados duplicados do Produto (Redundância controlada)
    produto_id INT NOT NULL,
    nome_produto VARCHAR(100) NOT NULL,
    categoria_produto VARCHAR(50) NOT NULL,
    -- Métricas da Transação
    quantidade INT NOT NULL,
    preco_praticado NUMERIC(10, 2) NOT NULL,
    valor_total_item NUMERIC(10, 2) NOT NULL
);

-- =====================================================================
-- POPULAÇÃO DA TABELA ACHATADA (Via Query de Inserção Consolidada)
-- Numa aplicação real, isto pode ser alimentado por um processo de ETL, 
-- uma trigger ou uma Visão Materializada (Materialized View).
-- =====================================================================

INSERT INTO relatorio_vendas_desnormalizado (
    pedido_id, 
    data_pedido, 
    cliente_id, 
    nome_cliente, 
    cidade_cliente, 
    estado_cliente, 
    produto_id, 
    nome_produto, 
    categoria_produto, 
    quantidade, 
    preco_praticado, 
    valor_total_item
)
SELECT 
    p.id,
    p.data_pedido,
    c.id,
    c.nome,
    c.cidade,
    c.estado,
    pr.id,
    pr.nome_produto,
    pr.categoria,
    ip.quantidade,
    ip.preco_praticado,
    (ip.quantidade * ip.preco_praticado)
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.id
JOIN itens_pedido ip ON p.id = ip.pedido_id
JOIN produtos pr ON ip.produto_id = pr.id;

-- =====================================================================
-- CONSULTA NO CENÁRIO DESNORMALIZADO (Sem JOINs!)
-- Muito mais rápida e simples para grandes volumes de dados em relatórios.
-- =====================================================================

SELECT 
    pedido_id,
    data_pedido,
    nome_cliente,
    cidade_cliente,
    estado_cliente,
    nome_produto,
    quantidade,
    valor_total_item
FROM relatorio_vendas_desnormalizado
WHERE estado_cliente = 'SP';

-- =====================================================================
-- O CUIDADO COM A CONSISTÊNCIA (O Preço da Desnormalização)
-- Se o cliente 'Ana Souza' mudar de cidade, na tabela normalizada atualizamos 
-- apenas 1 linha na tabela 'clientes'. Na tabela desnormalizada, se houver 
-- histórico duplicado, teremos de atualizar todas as ocorrências ou corremos 
-- o risco de ter dados inconsistentes (Anomalias de Atualização).
-- =====================================================================