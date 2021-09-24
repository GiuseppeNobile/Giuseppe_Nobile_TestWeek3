create database Pizzeria;

--CREAZIONE TABELLE
create table Pizza(
	CodPizza int identity(1,1) not null primary key,
	NomePizza varchar(20) not null,
	Prezzo decimal(4,2) not null
);

create table Ingrediente(
	CodIngrediente int identity(1,1) not null primary key,
	NomeIngrediente varchar(30) not null,
	Costo decimal(4,2) not null	
);

create table PizzaIngrediente(
	IDPizza int,
	IDIngrediente int,
	constraint FK_PIZZA foreign key (IDPizza) references Pizza(CodPizza),
	constraint FK_INGREDIENTE foreign key (IDIngrediente) references Ingrediente(CodIngrediente),
);

--INSERIMENTO VALORI
insert into Pizza values('Margherita', 5.0);
insert into Pizza values('Bufala', 7.0);
insert into Pizza values('Diavola', 6.0);
insert into Pizza values('Quattro Stagioni', 6.50);
insert into Pizza values('Porcini', 7.0);
insert into Pizza values('Dioniso', 8.0);
insert into Pizza values('Ortolana', 8.0);
insert into Pizza values('Patate e Salsiccia', 6.0);
insert into Pizza values('Pomodorini', 6.0);
insert into Pizza values('Quattro Formaggi', 7.50);
insert into Pizza values('Caprese', 7.50);
insert into Pizza values('Zeus', 7.50);

insert into Ingrediente values('pomodoro', 5.0);
insert into Ingrediente values('mozzarella', 4.3);
insert into Ingrediente values('mozzarella di bufala', 6.0);
insert into Ingrediente values('spianata piccante', 7.1);
insert into Ingrediente values('funghi', 5.55);
insert into Ingrediente values('carciofi', 3.24);
insert into Ingrediente values('cotto', 2.11);
insert into Ingrediente values('olive', 3.0);
insert into Ingrediente values('funghi porcini', 6.2);
insert into Ingrediente values('stracchino', 3.4);
insert into Ingrediente values('speck', 2.22);
insert into Ingrediente values('rucola', 4.0);
insert into Ingrediente values('grana', 3.45);
insert into Ingrediente values('verdure di stagione', 6.8);
insert into Ingrediente values('salsiccia', 7.8);
insert into Ingrediente values('pomodorini', 4.55);
insert into Ingrediente values('ricotta', 5.66);
insert into Ingrediente values('provola', 8.0);
insert into Ingrediente values('gorgonzola', 6.78);
insert into Ingrediente values('pomodoro fresco', 5.60);
insert into Ingrediente values('basilico', 4.33);
insert into Ingrediente values('bresaola', 3.12);
insert into Ingrediente values('rucola', 3.56);
insert into Ingrediente values('patate', 4.67);

insert into PizzaIngrediente values(1,1);
insert into PizzaIngrediente values(1,2);
insert into PizzaIngrediente values(2,1);
insert into PizzaIngrediente values(2,3);
insert into PizzaIngrediente values(3,1);
insert into PizzaIngrediente values(3,2);
insert into PizzaIngrediente values(3,4);
insert into PizzaIngrediente values(4,1);
insert into PizzaIngrediente values(4,2);
insert into PizzaIngrediente values(4,5);
insert into PizzaIngrediente values(4,6);
insert into PizzaIngrediente values(4,7);
insert into PizzaIngrediente values(4,8);
insert into PizzaIngrediente values(5,1);
insert into PizzaIngrediente values(5,2);
insert into PizzaIngrediente values(5,9);
insert into PizzaIngrediente values(6,1);
insert into PizzaIngrediente values(6,2);
insert into PizzaIngrediente values(6,10);
insert into PizzaIngrediente values(6,11);
insert into PizzaIngrediente values(6,12);
insert into PizzaIngrediente values(6,13);
insert into PizzaIngrediente values(7,1);
insert into PizzaIngrediente values(7,2);
insert into PizzaIngrediente values(7,14);
insert into PizzaIngrediente values(8,2);
insert into PizzaIngrediente values(8,24);
insert into PizzaIngrediente values(8,15);
insert into PizzaIngrediente values(9,2);
insert into PizzaIngrediente values(9,16);
insert into PizzaIngrediente values(9,17);
insert into PizzaIngrediente values(10,2);
insert into PizzaIngrediente values(10,18);
insert into PizzaIngrediente values(10,19);
insert into PizzaIngrediente values(10,13);
insert into PizzaIngrediente values(11,2);
insert into PizzaIngrediente values(11,20);
insert into PizzaIngrediente values(11,21);
insert into PizzaIngrediente values(12,2);
insert into PizzaIngrediente values(12,22);
insert into PizzaIngrediente values(12,23);

--QUERY
--tutte le pizze con prezzo superiore a 6 euro
select * from Pizza
where Prezzo > 6.0;

--pizza più costosa
select * from Pizza
where Prezzo in
(select max(Prezzo) from Pizza);

--tutte le pizza bianche
select NomePizza from Pizza
where NomePizza not in
(select NomePizza from Pizza
join PizzaIngrediente on CodPizza = IDPizza
join Ingrediente on CodIngrediente = IDIngrediente
where NomeIngrediente = 'pomodoro');

--le pizze che contengono funghi
select * from Pizza
join PizzaIngrediente on CodPizza = IDPizza
join Ingrediente on CodIngrediente = IDIngrediente
where NomeIngrediente in ('funghi', 'funghi porcini');


--PROCEDURES
--inserimento di una nuova pizza
create procedure InserisciPizza
@NomeP varchar(20),
@PrezzoP decimal(4,2)
as
insert into Pizza(NomePizza,Prezzo) values(@NomeP, @PrezzoP)
go;

--execute InserisciPizza @NomeP = 'Pizza Nuova', @PrezzoP = 5.44;


--assegna ingrediente a una pizza
create procedure AssegnaIngrediente
@NomeP varchar(20),
@NomeI varchar(30)
as
	declare @IDP int
	declare @IDI int

	select @IDP = IDPizza from PizzaIngrediente
	join Pizza on CodPizza = IDPizza
	where @NomeP = NomePizza
		
	select @IDI = IDIngrediente from PizzaIngrediente
	join Ingrediente on CodIngrediente= IDIngrediente
	where @NomeI = NomeIngrediente
	
	insert into PizzaIngrediente(IDPizza,IDIngrediente) values(@IDP, @IDI)
go;

--execute AssegnaIngrediente @NomeP = 'Pizza Nuova', @NomeI = 'mozzarella';


--aggiornamento del prezzo di una pizza
create procedure AggiornamentoPrezzoPizza
@NomeP varchar(20),
@NewPrezzo decimal(4,2)
as
update Pizza set Prezzo = @NewPrezzo where NomePizza = @NomeP
go;

--execute AggiornamentoPrezzoPizza @NomeP = 'Pizza Nuova', @NewPrezzo = 4.55;


--eliminazione ingrediente da una pizza
create procedure EliminaIngredienteDaPizza
@NomeP varchar(20),
@NomeI varchar(30)
as
	declare @IDP int
	declare @IDI int

	select @IDP = IDPizza 
	from PizzaIngrediente
	join Pizza on CodPizza = IDPizza
	where @NomeP = NomePizza

	select @IDI = IDIngrediente
	from PizzaIngrediente
	join Ingrediente on CodIngrediente = IDIngrediente
	where @NomeI = NomeIngrediente

	delete from PizzaIngrediente where @IDP = IDPizza and @IDI = IDIngrediente
go;

--incremento del 10% del prezzo delle pizze contenenti un ingrediente
create procedure IncrementoPrezzoPizza
@NomeI varchar(30)
as
	select @NomeI = NomeIngrediente
	from Ingrediente
	join PizzaIngrediente ON IDIngrediente = CodIngrediente
	join Pizza on CodPizza = IDPizza

	update Pizza set Prezzo = (Prezzo *(10/100)) 
	
go;

--FUNZIONI
--tabella listino pizze in ordine alfabetico
create function listinoPizze()
returns Table
as 
	return
	(select NomePizza, Prezzo from Pizza);
	


-- tabella listino pizze contenenti un ingrediente
create function listinoPizzeUnIngrediente(@NomeI varchar(30))
returns table
as 
	return
	(select CodPizza, NomePizza, Prezzo from Pizza
	join PizzaIngrediente on CodPizza = IDPizza
	join Ingrediente on CodIngrediente = IDIngrediente
	where @NomeI = NomeIngrediente);

-- tabella listino pizze che non contengono un certo ingrediente
create function listinoPizzeSenzaIngrediente(@NomeI varchar(30))
returns table
as 
	return
	(select CodPizza, NomePizza, Prezzo from Pizza
	join PizzaIngrediente on CodPizza = IDPizza
	join Ingrediente on CodIngrediente = IDIngrediente
	where @NomeI <> NomeIngrediente);



--VIEW
create view MenuPizzeria(NomePizza, Prezzo, Ingredienti)
as
select NomePizza as Pizza, Prezzo, STRING_AGG(NomeIngrediente, ', ') as Ingredienti from Pizza
join PizzaIngrediente on CodPizza = IDPizza
join Ingrediente on CodIngrediente = IDIngrediente;
