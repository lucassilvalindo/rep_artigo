
-- Exemplo de banco de dados normalizado
-- Dados fictícios para fins de estudo

CREATE TABLE Clientes (
    cliente_id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL
);

CREATE TABLE Produtos (
    produto_id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    preco REAL NOT NULL
);

CREATE TABLE Pedidos (
    pedido_id INTEGER PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    FOREIGN KEY (cliente_id),
    REFERENCES Clientes(cliente_id)
);

CREATE TABLE ItensPedido (
    pedido_id INTEGER NOT NULL,
    produto_id INTEGER NOT NULL,
    quantidade INTEGER NOT NULL,
    PRIMARY KEY (pedido_id, produto_id),
    FOREIGN KEY (pedido_id)
    REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (produto_id),
    REFERENCES Produtos(produto_id)
);

-- Inserindo dados fictícios
INSERT INTO Clientes VALUES (1, 'Ana');
INSERT INTO Produtos VALUES (1, 'Teclado', 80.00);
INSERT INTO Pedidos VALUES (1, 1);
INSERT INTO ItensPedido VALUES (1, 1, 2);