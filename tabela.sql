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

insert into categorias (nome) VALUES
('Perifericos'),
('Monitores'),
('Hardware')

insert into clientes(nome,email,cpf)VALUES
('Victor', 'vitor@teste', '00011122233'),
('Matheus','matheus@teste','0011133322')
('Noah Navarro', 'Noah.Navarro@email.com', '12345678901')

insert into produtos (categorias_id , nome, preco, quantidade_estoque) VALUES
(1, 'Teclado LogiTech' , 120.00,100),
(1, 'MousePad Philips' , 39.99, 500),
(2, 'Monitor Philips 24p 244hz' , 899.90,10),
(2, 'Monitor AOC 27p 75hz' , 999.99,150),
(2, 'Monitor Mancer 17p 240hz', 500.00, 600),
(3, 'Placa Mae Asus A520' , 450.90,300),
(3, 'Memoria Ram DDR4 Redragon 8GB' , 500,700),
(3, 'SSD 1TB Mancer' , 800.50,49)

insert into pedidos (clientes_id, status ) VALUES
(1, 'PAGO'),
(1, 'ENVIADO'),
(2, 'CANCELADO'),
(2, 'PAGO'),
(2, 'PENDENTE'),
(3, 'CANCELADO'),
(3, 'PENDENTE'),
(3, 'ENVIADO')

insert into itens_pedido (pedidos_id, produtos_id ,quantidade, preco_unitario ) VALUES
(1,1,3,200),
(15, 2, 3, 1500),
(16, 3, 4, 1000),
(17, 1, 3, 750.50),
(18, 2, 3, 597),
(19, 3, 3, 300),
(20, 1, 3, 497),
(21, 2, 3, 111.99),
(22, 3, 3, 601)

select
	p.nome as produto,
	c.nome as categorias,
	p.preco,
	p.quantidade_estoque
	
	from produtos p
	join categorias c on c.id = p.categorias_id
	order by p.preco desc;

select
pedidos.id,
clientes.nome,
SUM(item.quantidade * item.preco_unitario) as valor_total_pedido

from
pedidos
join
clientes on pedidos.clientes_id = clientes.id
join
itens_pedido item on pedidos.id = item.pedidos_id

group by pedidos.id, clientes.nome
order by pedidos.id;
