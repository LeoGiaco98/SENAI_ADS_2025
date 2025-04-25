create database gestao_de_vendas;
create table cliente (
cliente_id char(4) primary key,
nome varchar(100),
cpf char(11),
email varchar(100),
telefone varchar(15)
);
create table produto (
produto_id int primary key,
nome varchar(100),
preco decimal(10, 2),
estoque int
);
create table vendedor (
vendedor_id int primary key,
nome varchar(100),
email varchar(100),
salario decimal(10, 2)
); 
create table venda(
venda_id int primary key,
cliente_id int,
vendedor_id int,
data_venda date,
total decimal(10, 2),
foreign key (cliente_id) references cliente (cliente_id),
foreign key (vendedor_id) references vendedor (vendedor_id)
);
create table item_venda (
item_id int primary key,
venda_id int,
produto_id int,
quantidade int,
preco_unitario decimal(10, 2),
foreign key (venda_id) references venda (venda_id),
foreign key (produto_id) references produto(produto_id)
);

insert into cliente (cliente_id, nome, cpf, email, telefone) 
values (
1, 
'BENTO JOAO RAMOS', 
'77651875036',
'bentojoaoramos@cteep.com.br',
'65988538275'),
(
2,
'ISABELLY LAIS COSTA',
'14244451404',
'isabelly.lais.costa@imoveisvillani.com.br',
'66981499599'
),
(
3,
'TERESINHA CARLA MELO',
'02692376072',
'teresinha.carla.melo@dpi.ig.br',
'47983380056'
);