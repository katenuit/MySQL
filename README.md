# MySQL
<a name="header1"></a>
## Содержание
 - [Физическая модель базы данных, находящаяся в третьей нормальной форме](#физическая-модель-базы-данных-находящаяся-в-третьей-нормальной-форме)
 - [Содержимое файла MySQL.sql](#в-прикрепленном-файле-mysql-можно-наблюдать)
    - [Создание БД и таблиц](#создание-базы-данных-excurlab-и-таблиц)
    - [Заполнение базы данных](#заполнение-базы-данных)
    - [Запросы к базе данных](#запросы-к-базе-данных)
      - [Запрос с not exists](#запрос-с-not-exists)
      - [Запрос с left join](#запрос-с-left-join)
      - [Запрос с min и all](#запрос-реализованный-двумя-способами-с-использованием-min-и-all)
    - [Процедура для добавления данных](#процедура-для-добавления-данных)
    - [Процедура каскадного удаления](#процедура-каскадного-удаления)
    - [Процедура вычисления и возврат значения агрегатной функции](#процедура-вычисления-и-возврат-значения-агрегатной-функции)
    - [Триггеры](#триггеры-для-всех-событий-insert-delete-update-до-и-после)
 - [Навигация по MySQL.sql](#навигация-по-mysqlsql)
 
## Физическая модель базы данных, находящаяся в третьей нормальной форме 

![db_schema](https://user-images.githubusercontent.com/99740986/229370782-3bd5bdce-4ae5-4425-8e81-f8632b88d511.jpg)
[*Back to top*](#header1)


## В прикрепленном файле MySQL можно наблюдать
### Создание базы данных ExcurLab и таблиц 
```SQL
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
```
[*Back to top*](#header1)


### Заполнение базы данных
``` SQL
INSERT INTO Teach (id_teach, name_teach, sur_teach, secondName_teach) 
values (1, 'Валерий', 'Понев','Александрович'),
(2, 'Юлия', 'Иванова','Валерьевна'),
(3, 'Иван', 'Каранев','Алексеевич'),
(4, 'Анастасия', 'Гореко','Ивановна'),
(5, 'Борис', 'Бегов','Викторович'),
(6, 'Александра', 'Угова','Александровна');
```
[*Back to top*](#header1)


### Запросы к базе данных 
#### Запрос с not exists
``` SQL
-- учащийся, который был на всех экскурсиях --
 select student.* from student
 where not exists (select *from excur where not exists
 (select *from excur_stud as exs
 where student.id_stud = exs.id_stud and excur.id_excur = exs.id_excur));
```

#### Запрос с left join
```SQL
-- учащиеся, которые не ездили в музей истории религии, но ездил в Кунсткамеру  --
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
```

#### Запрос реализованный двумя способами с использованием min и all
``` SQL
-- самые дешевые экскурсии --
 --       запрос с min        --
 select* from excur where price = (SELECT min(price) from excur);
 
 --      запрос с all         --
 select * from excur as ex where price <= all
 (select price from excur as ex1);
```

[*Back to top*](#header1)


### Процедура для добавления данных
``` SQL
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
```
[*Back to top*](#header1)

### Процедура каскадного удаления
При удалении записи о студенте, удаляется информация и об экскурсиях, которые он посещал.
``` SQL
delimiter //
create procedure del_student_ (del_stud_id integer)
begin
delete from excur_stud where id_stud = del_stud_id;
delete from student where id_stud = del_stud_id;
end;// 
delimiter ;
```
[*Back to top*](#header1)


### Процедура вычисления и возврат значения агрегатной функции
Выполняется возврат количества экскурсий.
``` SQL
--          вычисление и возврат значения агрегатной функции

delimiter //
create procedure count_excur (out cnt_ex int)
begin
select ifnull(count(id_excur),0) into cnt_ex from excur;
end;// 
delimiter ;

call count_excur (@cnt);
select @cnt;
```
[*Back to top*](#header1)


### Триггеры для всех событий (insert, delete, update) до и после
``` SQL 
--                before delete -----
delimiter //
create trigger trigger_bef_del
before delete on discip for each row
begin
delete from excur_discip where id_disc=old.id_disc;
end//
delimiter ;

delete from discip where id_disc=4;
```
[*Back to top*](#header1)


## Навигация по MySQL.sql
1) Строки 1-65 - создание БД
2) Строки 71-140 - заполнение БД
3) Строки 143-222 - запросы к БД (реализованные в трех вариантах: Not in, except, с использованием левого/правого соединения, запросы на max/min, запросы с помощью not exist)
4) Строки 224-335 - процедура вставки  с пополнением справочника и удаления с очисткой справочника, процедура каскадного удаления, процедура вычисления и возврат значения агрегатной функции, формирование статистики во временной таблице
5) Строки 337-443 - триггеры для всех событий (insert, delete, update) до и после 

[*Back to top*](#header1)
