CREATE DATABASE IF NOT EXISTS ExcurLab;
USE ExcurLab;
select database();

create table Teach (
id_teach int NOT NULL AUTO_INCREMENT PRIMARY KEY,
name_teach varchar(20) NOT NULL,
sur_teach varchar(20), 
secondName_teach varchar(20)
); 

create table Typ (
id_type int NOT NULL AUTO_INCREMENT PRIMARY KEY, 
name_type varchar(30) not null
);

create table Excur (
id_excur int NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_teach int NOT NULL, 
id_type int NOT NULL,
constraint fk_teach foreign key (id_teach) references Teach (id_teach) 
ON DELETE RESTRICT 
ON UPDATE CASCADE,
constraint fk_type foreign key (id_type) references Typ (id_type) 
ON DELETE RESTRICT 
ON UPDATE CASCADE,
name_excur varchar(30) NOT NULL,
price float
);

create table Student (
id_stud int NOT NULL AUTO_INCREMENT PRIMARY KEY,
name_stud varchar(20) not null,
sur_stud varchar (20) not null, 
secondName_stud varchar (20) not null
);

create table Excur_Stud (
id_stud int not null,
id_excur int not null,
primary key (id_stud, id_excur),
constraint fk_stud foreign key (id_stud) references Student (id_stud)
ON DELETE CASCADE
ON UPDATE CASCADE, 
constraint fk_excur foreign key (id_excur) references Excur (id_excur)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

create table Discip (
id_disc int NOT NULL AUTO_INCREMENT PRIMARY KEY, 
name_disc varchar(30) not null
);

create table Excur_Discip(
id_disc int not null,
id_excur int not null,
primary key (id_disc, id_excur), 
constraint fk_disc foreign key (id_disc) references Discip (id_disc)
ON DELETE RESTRICT
ON UPDATE RESTRICT, 
constraint fk_excur_dis foreign key (id_excur) references Excur (id_excur)
ON DELETE RESTRICT
ON UPDATE RESTRICT
);
 
-- вероятность необходимости изменений или удалений первичного ключа мала, как следсвие, 
-- чтобы избежать нарушения целостности, ограничиваем


INSERT INTO Teach (id_teach, name_teach, sur_teach, secondName_teach) 
values (1, 'Валерий', 'Понев','Александрович'),
(2, 'Юлия', 'Иванова','Валерьевна'),
(3, 'Иван', 'Каранев','Алексеевич'),
(4, 'Анастасия', 'Гореко','Ивановна'),
(5, 'Борис', 'Бегов','Викторович'),
(6, 'Александра', 'Угова','Александровна');

update `excurlab`.`Teach` set `sur_teach` = 'Понева' where (`id_teach`= '2');
update `excurlab`.`Teach` set `name_teach` = 'Лео' where (`id_teach`= '5');

INSERT INTO Typ (id_type, name_type) 
values (1, 'Развлекательный'),
(2, 'Обраовательный'),
(3, 'Производственный'),
(4, 'Искусствоведческий'),
(5, 'Исторический');

insert into Excur (id_excur, id_teach, id_type, name_excur, price)
values (1, 1, 3, 'Завод Петрохолод', 1500),
(2, 2, 5, 'Музей истории религии', 700),
(3, 4, 4, 'Русский музей', 650),
(4, 5, 2, 'Музей связи', 500),
(5, 6, 5, 'Эрмитаж', 800),
(6, 1, 5, 'Исаакиевский собор', 600);
insert into Excur (id_excur, id_teach, id_type, name_excur, price)
values (7, 1, 5, 'Кунсткамера', 300);


insert into Student (id_stud, name_stud, sur_stud, secondName_stud)
values (1, 'Игорь', 'Лавров', 'Петович'),
(2, 'Марина', 'Говрилова', 'Ивановна'),
(3, 'Кирилл', 'Вощев', 'Александрович'),
(4, 'Игорь', 'Лавров', 'Петович'),
(5, 'София', 'Шарова', 'Кирилловна'),
(6, 'Ангелина', 'Сапожникова', 'Владимировна'),
(7, 'Александр', 'Свистов', 'Алексеевич');

insert into Excur_Stud (id_excur, id_stud)
values (1, 1), (1, 2), (1, 3), (1,4),
(2, 1), (2, 3), (2, 6),
(3, 1), (3, 5), 
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5),
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5), (5, 6), 
(6, 1), (6, 3), (6, 5), (6, 4);
insert into Excur_Stud (id_excur, id_stud)
values (7, 1), (7, 2), (7, 3);


insert into Discip (id_disc, name_disc)
values (1, 'История'), 
(2, 'Биология'), 
(3, 'Культурология'), 
(4, 'Физика');


insert into Excur_Discip (id_disc, id_excur)
values (1, 2), (1, 4), (1, 3), (1, 5), (1, 6), (1, 1),
(2, 2), (2, 5), 
(3,2), (3, 3), (3, 5), (3, 6), 
(4, 4);
insert into Excur_Discip (id_disc, id_excur)
values (2, 1), (2, 7);
insert into Excur_Discip (id_disc, id_excur)
values (1, 7);


insert into Discip (id_disc, name_disc)
values (5, 'Информатика');
delete from Discip where (id_disc = 5);


--             Запрос А              --
--  Экскурсии на заводы (слово «завод» в любом месте названия) --
select * from excur where name_excur like '%завод%';

--             Запрос Б              --
--	Экскурсии, относящиеся к биологии и истории --
select distinct excur.id_excur, excur.name_excur from excur
inner join excur_discip on excur_discip.id_excur = excur.id_excur
inner join discip in discip.id_disc = excur_discip.id_disc
inner join excur_discip as excur_discip2 on excur_discip2.id_excur = excur.id_excur
inner join discip as discip2 on discip2.id_disc = excur_discip2.id_disc
where discip.name_disc='История' and discip2.name_disc = 'Биология';

--             Запрос В              --
--     Учащиеся, которые не ездили за экскурсии --
select student.* from student
left join excur_stud on excur_stud.id_stud = student.id_stud
where excur_stud.id_excur is null;

--             Запрос Г              --
-- учащиеся, которые не ездили в музей истории религии, но ездил в Кунсткамеру  --
--            запрос с not in        --
select student.id_stud , student.name_stud, student.secondName_stud, student.sur_stud from student
 join excur_stud on student.id_stud = excur_stud.id_stud
 join excur on excur_stud.id_excur = excur.id_excur
where excur.name_excur = "Кунсткамера" and student.id_stud not in 

(select student.id_stud from student
 join excur_stud on student.id_stud = excur_stud.id_stud
 join excur on excur_stud.id_excur = excur.id_excur
where excur.name_excur = "Музей истории религии") ;


--          текст запроса с except           --
select student.id_stud from student
left join excur_stud on student.id_stud = excur_stud.id_stud
left join excur on excur_stud.id_excur = excur.id_excur
where excur.name_excur = "Кунсткамера" and student.id_stud except 

(select student.id_stud from student
left join excur_stud on student.id_stud = excur_stud.id_stud
left join excur on excur_stud.id_excur = excur.id_excur
where excur.name_excur = "Музей истории религии");


--           запрос с left/right join       --
 select student.id_stud, student.name_stud from student
 join excur_stud on student.id_stud = excur_stud.id_stud
 join excur on excur_stud.id_excur = excur.id_excur
 left join
(select student.id_stud as student1 from student
join excur_stud on student.id_stud = excur_stud.id_stud
join excur on excur_stud.id_excur = excur.id_excur
where excur.name_excur = "Музей истории религии")
dop on student.id_stud = student1
where excur.name_excur = "Кунсткамера" and student1 is null;

 --           Запрос Д          --
-- учитель, отвечавший за наибольшее число экскурсий --
 select t.id_teach, t.name_teach, t.sur_teach, t.secondName_teach, count(ex.id_teach) as max_teach from teach as t
 left join excur as ex on t.id_teach = ex.id_teach group by t.id_teach 
 having max_teach = ( select max(cnt) from 
 ( select count(excur.id_teach) as cnt from teach as t
 left join excur on t.id_teach = excur.id_teach group by t.id_teach) q);
 
 --          Запрос Е         --
-- самые дешевые экскурсии --
 --       запрос с min        --
 select* from excur where price = (SELECT min(price) from excur);
 
 --      запрос с all         --
 select * from excur as ex where price <= all
 (select price from excur as ex1);
 
 --        Запрос Ж           --
-- учащийся, который был на всех экскурсиях --
 select student.* from student
 where not exists (select *from excur where not exists
 (select *from excur_stud as exs
 where student.id_stud = exs.id_stud and excur.id_excur = exs.id_excur));

--                          добавление + пополнение справочника

delimiter //
create procedure ins_excur_3 (name_typ varchar(30), name_t varchar(20),
sur_t varchar(20), secondName_t varchar(20), 
name_ex varchar(30), price_ex float)
begin
declare new_t_id integer;
declare new_typ_id integer;
declare new_ex_id integer;
if not exists (select * from typ where name_type=name_typ)
	then
    insert into typ (name_type) values (name_typ);
    select last_insert_id() into new_typ_id;
    else
    select id_type into new_typ_id from typ where name_type=name_typ;
end if;
if not exists (select * from teach 
where name_teach=name_t and sur_teach=sur_t and secondName_teach=secondName_t)
	then 
    insert into teach (name_teach, sur_teach, secondName_teach)
    values (name_t, sur_t, secondName_t);
    select last_insert_id() into new_t_id;
    else
    select id_teach into new_t_id from teach where
    name_t=name_teach and sur_t=sur_teach and secondName_t=secondName_t;
end if;
insert into excur (id_excur, id_teach, id_type, name_excur, price)
values (new_ex_id, new_t_id, new_typ_id, name_ex, price_ex);
set new_ex_id = (select  LAST_INSERT_ID());
-- select last_insert_id() into new_ex_id;
end;// 
delimiter ;
call ins_excur_3 ('Природоведческий', 'Иван','Иванов','Иванович','Павловск', 1000);
-- call ins_excur_proba ('Природоведческий', 'Иван','Иванов','Иванович','Пушкин',1200);


--                   удаление с очисткой справочника

delimiter //
create procedure del_excur_ (del_ex_id integer)
begin
declare del_typ_id integer;
declare del_teach_id integer;
select id_type into del_typ_id from excur where id_excur=del_ex_id;
select id_teach into del_teach_id from excur where id_excur=del_ex_id;
-- select id_type ,id_teach into del_typ_id, del_teach_id from excur where id_excur=del_ex_id;
delete from excur where id_excur=del_ex_id;
if not exists (select * from excur where id_type=del_typ_id)
then delete from typ where id_type=del_typ_id;
end if; 
if not exists (select * from excur where id_teach=del_teach_id)
then delete from teach where id_teach=del_teach_id;
end if; 
end;// 
delimiter ;

call del_excur_(12);

--                       каскадное удаление

delimiter //
create procedure del_student_ (del_stud_id integer)
begin
delete from excur_stud where id_stud = del_stud_id;
delete from student where id_stud = del_stud_id;
end;// 
delimiter ;

call del_student_ (6);

--                      вычисление и возврат значения агрегатной функции

delimiter //
create procedure count_excur (out cnt_ex int)
begin
select ifnull(count(id_excur),0) into cnt_ex from excur;
end;// 
delimiter ;

call count_excur (@cnt);
select @cnt;

--                          Формирование статистики во временной таблице

delimiter //
create procedure statistics_()
begin
create temporary table if not exists tab_stat(
id_stat int auto_increment primary key,
ex_quan int null,
disc_quan int null,
teach_quan int null,
stud_quan int null,
avg_price float null
);
insert into tab_stat (ex_quan, avg_price)
select count(id_excur), avg(price) from excur;
update tab_stat set disc_quan=(select count(id_disc) from discip);
update tab_stat set teach_quan=(select count(id_teach) from teach);
update tab_stat set stud_quan=(select count(id_stud) from student);
select*from tab_stat;
drop table tab_stat;
end;// 
delimiter ;

SET SQL_SAFE_UPDATES = 0;
call statistics_();
SET SQL_SAFE_UPDATES = 1;


--                before delete -----

delimiter //
create trigger trigger_bef_del
before delete on discip for each row
begin
delete from excur_discip where id_disc=old.id_disc;
end//
delimiter ;

delete from discip where id_disc=4;

--                before insert ----------

delimiter //
create trigger trigger_bef_ins
before insert on typ for each row
begin
if exists (select * from typ where name_type=new.name_type)
	then 
    signal sqlstate '45000'
	set message_text = 'Тип с таким наименованием уже существует!';
end if;
end//
delimiter ;

insert into typ (name_type)
values ('Исторический');

--              before update ----------

delimiter //
create trigger tig_bef_up
before update on student for each row
begin 
if new.id_stud != old.id_stud
	then 
	set new.id_stud = old.id_stud;
end if;
end//
delimiter ;

update student set id_stud = 10, sur_stud='Иванова' where id_stud=5;

--              after delete -----

delimiter //
create trigger trig_aft_del
after delete on excur for each row 
begin
if not exists (select * from excur where id_type=old.id_type) then	
    delete from typ where typ.id_type=old.id_type;
elseif not exists (select * from excur where id_teach=old.id_teach) then
    delete from teach where teach.id_teach=old.id_teach;
end if;
delete from excur_stud where id_excur=old.id_excur;
delete from excur_discip where id_excur=old.id_excur;
end //
delimiter ;

drop trigger trig_aft_del;
delete from excur where id_excur=5;

--              after insert -------

ALTER TABLE Excur add stud_count int null;
delimiter //
create trigger trig_aft_ins
after insert on excur_stud for each row
begin 
if exists(select * from excur where stud_count is null 
			and id_excur=new.id_excur) then
	update excur set stud_count = 0 
	where stud_count is null and id_excur=new.id_excur;
end if;
update excur set excur.stud_count = excur.stud_count + 1 
	where excur.id_excur=new.id_excur;
end//
delimiter ;

insert into Excur (id_teach, id_type, name_excur, price)
values (4, 5, 'Музей-квартира Блока', 800);

insert into excur_stud(id_excur, id_stud) value(13, 3), (13, 5), (13, 1);

--               after update ----

delimiter //
create trigger trig_aft_up
after update on excur_stud for each row
begin 
if exists(select * from excur where stud_count is null 
			and id_excur=new.id_excur) then
	update excur set stud_count = 0 
	where stud_count is null and id_excur=new.id_excur;
end if;
if exists (select * from excur where stud_count is null
			and id_excur=old.id_excur) then
	update excur set stud_count = 0 
	where stud_count is null and id_excur=old.id_excur;
end if;
update excur set excur.stud_count = excur.stud_count + 1 
	where excur.id_excur=new.id_excur;
update excur set excur.stud_count = excur.stud_count - 1 
	where excur.id_excur=old.id_excur;
end//
delimiter ;

update excur_stud set id_excur=7 where id_stud=5 and id_excur=13;
