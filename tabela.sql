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


--------------------------------------------------------------------------------------------------------------------

CREATE TABLE pacientes(
id serial PRIMARY key,
nome VARCHAR(150) NOT NULL,
email VARCHAR(150) not null,
cpf VARCHAR(11) UNIQUE not null,
data_nascimento varchar(8) not null,
data_cadrasto TIMESTAMP default current_timestamp

)

CREATE TABLE especialidades(
id serial PRIMARY key,
nome VARCHAR(150) NOT NULL

)

CREATE TABLE medicos(
id serial PRIMARY key,
especialidade_id int NOT NULL,
nome VARCHAR(150) not null,
crm VARCHAR(150) not null,
valor_consulta NUMERIC(10,2) not null check (valor_consulta > 0),

constraint fk_especialidade_id
foreign key (especialidade_id)
references especialidades(id)
on delete cascade

)

CREATE TABLE consultas(
id serial PRIMARY key,
medico_id int NOT NULL,
paciente_id int NOT NULL,
data_hora TIMESTAMP default current_timestamp,
status VARCHAR(20) default 'AGENDADA' CHECK (Status in ('AGENDADA','REALIZADA','CANCELADA')),

CONSTRAINT fk_medico_id
FOREIGN key (medico_id)
REFERENCES medicos(id)
on delete cascade,

constraint fk_paciente_id
FOREIGN key (paciente_id)
REFERENCES pacientes(id)
on delete restrict

)

CREATE TABLE exames_consulta (
id serial PRIMARY key,
consulta_id int NOT NULL,
nome_exame varchar(150) NOT NULL,
valor_exame NUMERIC(10,2) not null check (valor_exame >= 0),

constraint fk_consulta_id 	
FOREIGN key (consulta_id)
REFERENCES consultas(id)
on delete restrict

)

insert into especialidades (nome) VALUES 
('Cardiologia'),
('Pediatria'),
('Dermatologia')

insert into medicos (especialidade_id, nome, crm, valor_consulta) VALUES 
(1,'Fernando','12345','1')
(3,'Ronaldo','12245','35')
(2,'Juliano','12225','59')


insert into pacientes (nome, email, cpf, data_nascimento) VALUES 
('Marcus', 'marcus@gmail.com','11122233344',05112008),
('Priscila', 'Priscila@gmail.com','55566633344',01091967),
('Sandra', 'sandra@gmail.com','44422277742',03051942)
