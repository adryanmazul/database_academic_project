CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    cpf CHAR(11) NOT NULL UNIQUE ,
    criado_em TIMESTAMP DEFAULT NOW() 
)

CREATE TABLE enderecos (
    id_endereco SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    rua VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep CHAR(8) NOT NULL,
    principal BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (cliente_id) REFERENCES clientes (id_cliente) ON DELETE CASCADE
)

CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria_pai_id INTEGER REFERENCES categorias (id_categoria)
)

CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    categoria_id INTEGER REFERENCES categorias (id_categoria) ON DELETE SET NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco NUMERIC(10, 2) NOT NULL CHECK (preco > 0),
    estoque INTEGER NOT NULL DEFAULT 0 CHECK (estoque >= 0),
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT NOW()
)

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes (id_cliente),
    endereco_id INTEGER REFERENCES enderecos (id_endereco),
    status VARCHAR(100) NOT NULL DEFAULT 'pendente' CHECK (status IN('pendente',
    'confirmado', 'enviado', 'entregue', 'cancelado')),
    total DECIMAL NOT NULL DEFAULT 0 CHECK (total >= 0),
    criado_em TIMESTAMP DEFAULT NOW(),
    atualizado_em TIMESTAMP DEFAULT NOW()
)

CREATE TABLE itens_pedidos (
    id_itens_pedidos SERIAL PRIMARY KEY,
    pedido_id INTEGER NOT NULL REFERENCES pedidos (id_pedido) ON DELETE CASCADE,
    produto_id INTEGER NOT NULL REFERENCES produtos (id_produto) ON DELETE RESTRICT,
    quantidade INTEGER NOT NULL CHECK (quantidade >= 1),
    preco_unitario NUMERIC(10, 2) NOT NULL CHECK (preco_unitario > 0),

    CONSTRAINT uq_item UNIQUE (pedido_id, produto_id)
)

CREATE TABLE pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    pedido_id INTEGER NOT NULL REFERENCES pedidos (id_pedido) ON DELETE RESTRICT,
    metodo VARCHAR(100) NOT NULL CHECK (metodo IN ('cartao_credito', 'cartao_debito', 'pix', 'boleto')),
    status VARCHAR(100) NOT NULL DEFAULT 'pendente' CHECK (status IN ('pendente', 'aprovado', 'recusado', 'estornado')),
    valor NUMERIC(10, 2) NOT NULL CHECK (valor > 0),
    pago_em TIMESTAMP
)