insert into "Овощ" values (default, 'фрукт');
insert into "Овощ" values (1, 1, 'apple', 'red', 100);
insert into "Овощ" values (2, 1, 'apple', 'green', 100);
insert into "ИНН" values ('123456789123');
insert into "Поставщик" values (1, '123456789123', 'lol company', '88005553535', 'Putin');

insert into "Поставка" VALUES (1, 1, 10, '2024-1-1');
insert into "Поставка" VALUES (1, 2, 10, '2022-1-1');


select ("Телефон") from "Поставщик"
    where "ИНН" = '123456789123';

select ("Наименование", "Цена") from "Овощ"
    where "Цена" > 100 ORDER BY "Цена";


select * from "Поставка"
    where "Дата" > now();

select count(*) from "Поставка"
    where "id_Поставщика" in
        (select (id) from "Поставщик" where "Наименование_компании" like 'ITMO%');