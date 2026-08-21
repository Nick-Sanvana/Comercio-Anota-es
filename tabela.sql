CREATE TABLE clientes(
id serial PRIMARY key,
nome VARCHAR(150) NOT NULL,
email VARCHAR(150) not null,
cpf VARCHAR(11) UNIQUE not null,
data_cadrasto TIMESTAMP default current_timestamp

)

CREATE TABLE categorias(
id serial PRIMARY KEY,
nome VARCHAR (150) UNIQUE not NULL
)

CREATE TABLE produtos(
id serial PRIMARY key,
categorias_id int not null,
nome VARCHAR (100) not null,
preco NUMERIC(10,2) not null check (preco > 0),
quantidade_estoque int NOT null default 0 check (quantidade_estoque >= 0),

CONSTRAINT fk_produto_categoria
  FOREIGN key (categorias_id)
  REFERENCES categorias(id)
  on delete restrict

)

CREATE TABLE pedidos(
id serial PRIMARY key,
clientes_id INT not null,
data_pedido TIMESTAMP default current_timestamp,
status VARCHAR(20) default 'PENDENTE' CHECK (Status in ('PENDENTE','PAGO','ENVIADO','CANCELADO')),

CONSTRAINT fk_pedidos_clientes
FOREIGN key (clientes_id)
REFERENCES clientes(id)
on delete cascade

)

CREATE TABLE itens_pedidos(
pedido_id int not null,
produto_id int not null,
quantidade int not null check(quantidade > 0),
preco_unitario numeric(10,2) not null check(preco_unitario > 0),

primary key(pedido_id, produto_id),
CONSTRAINT fk_item_pedidos
FOREIGN key (pedido_id)
REFERENCES pedidos(id)
on delete cascade,

constraint fk_item_produtos
FOREIGN key (produto_id)
REFERENCES produtos(id)
on delete restrict

)
