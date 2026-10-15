-- =====================================================================
-- ARTIGO TÉCNICO: DESNORMALIZAÇÃO EM BANCOS DE DADOS RELACIONAIS
-- Cenário 1: Modelo Transacional (OLTP) Altamente Normalizado
-- SGBD: PostgreSQL (Versão 15 ou superior)
-- =====================================================================

-- 1. Eliminação de tabelas caso já existam (para testes limpos do zero)
DROP TABLE IF EXISTS itens_pedido CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS produtos CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;

-- 2. Tabela de Clientes
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado VARCHAR(2) NOT NULL
);

-- 3. Tabela de Produtos
CREATE TABLE produtos (
    id SERIAL PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    preco_unitario NUMERIC(10, 2) NOT NULL
);

-- 4. Tabela de Pedidos (Cabeçalho)
CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES clientes(id),
    data_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(20) NOT NULL
);

-- 5. Tabela de Itens do Pedido (Detalhe / Relação N:N entre Pedidos e Produtos)
CREATE TABLE itens_pedido (
    id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
    produto_id INT NOT NULL REFERENCES produtos(id),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_praticado NUMERIC(10, 2) NOT NULL -- Histórico do preço no momento da venda
);

-- =====================================================================
-- INSERÇÃO DE DADOS FICTÍCIOS PARA TESTES (Evitando dados reais)[cite: 8]
-- =====================================================================

INSERT INTO clientes (nome, email, cidade, estado) VALUES
('Ana Souza', 'ana.souza@ficticio.com', 'São Paulo', 'SP'),
('Carlos Lima', 'carlos.lima@ficticio.com', 'Campinas', 'SP'),
('Beatriz Costa', 'beatriz.costa@ficticio.com', 'Rio de Janeiro', 'RJ');

INSERT INTO produtos (nome_produto, categoria, preco_unitario) VALUES
('Teclado Mecânico RGB', 'Periféricos', 250.00),
('Rato Gamer Wireless', 'Periféricos', 120.00),
('Monitor 27 Polegadas', 'Monitores', 1400.00),
('Cadeira Ergonómica', 'Mobiliário', 950.00);

INSERT INTO pedidos (cliente_id, data_pedido, status_pedido) VALUES
(1, '2026-06-10 14:30:00', 'Concluído'),
(2, '2026-06-11 09:15:00', 'Processando'),
(3, '2026-06-12 16:45:00', 'Concluído');

INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_praticado) VALUES
(1, 1, 1, 250.00), -- Ana comprou 1 Teclado
(1, 2, 2, 120.00), -- Ana comprou 2 Ratos
(2, 3, 1, 1400.00),-- Carlos comprou 1 Monitor
(3, 4, 1, 950.00); -- Beatriz comprou 1 Cadeira

-- =====================================================================
-- CONSULTA DE RELATÓRIO (O Custo dos Múltiplos JOINs no OLTP)[cite: 4]
-- Esta consulta cruza 4 tabelas para gerar um relatório analítico de vendas.
-- Em bases de dados com milhões de registos, este custo de junção torna-se pesado.
-- =====================================================================

SELECT 
    p.id AS pedido_id,
    p.data_pedido,
    c.nome AS cliente,
    c.cidade,
    c.estado,
    pr.nome_produto,
    pr.categoria,
    ip.quantidade,
    ip.preco_praticado,
    (ip.quantidade * ip.preco_praticado) AS valor_total_item
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.id
JOIN itens_pedido ip ON p.id = ip.pedido_id
JOIN produtos pr ON ip.produto_id = pr.id;