--1.
select ("Н_ЛЮДИ"."ФАМИЛИЯ", "Н_ВЕДОМОСТИ"."ДАТА")
from "Н_ЛЮДИ"
         INNER JOIN "Н_ВЕДОМОСТИ" on "Н_ЛЮДИ"."ИД" = "Н_ВЕДОМОСТИ"."ЧЛВК_ИД"
WHERE "Н_ЛЮДИ"."ФАМИЛИЯ" = 'Ёлкин'
  AND "Н_ВЕДОМОСТИ"."ДАТА" > '2022-06-08'::timestamp;

--2.
select ("Н_ЛЮДИ"."ФАМИЛИЯ", "Н_ВЕДОМОСТИ"."ЧЛВК_ИД", "Н_СЕССИЯ"."ДАТА")
from "Н_ЛЮДИ"
         INNER JOIN "Н_ВЕДОМОСТИ" on "Н_ЛЮДИ"."ИД" = "Н_ВЕДОМОСТИ"."ЧЛВК_ИД"
         INNER JOIN "Н_СЕССИЯ" on "Н_ЛЮДИ"."ИД" = "Н_СЕССИЯ"."ЧЛВК_ИД"
WHERE "Н_ЛЮДИ"."ФАМИЛИЯ" < 'Александр'
  AND "Н_ВЕДОМОСТИ"."ЧЛВК_ИД" < 117219;

--3.
select count(*)
from "Н_УЧЕНИКИ"
         JOIN "Н_ЛЮДИ" on "Н_ЛЮДИ"."ИД" = "Н_УЧЕНИКИ"."ЧЛВК_ИД"
where "ГРУППА" = '3102'
  and date_part('year', age("Н_ЛЮДИ"."ДАТА_РОЖДЕНИЯ")) >= 25;

--4.
select НЛ."ИМЯ", count("ИМЯ")
from "Н_УЧЕНИКИ"
         JOIN "Н_ЛЮДИ" НЛ on "Н_УЧЕНИКИ"."ЧЛВК_ИД" = НЛ."ИД"
group by НЛ."ИМЯ"
having "ИМЯ" in (select "ИМЯ"
         from "Н_УЧЕНИКИ"
                  JOIN "Н_ЛЮДИ" НЛ on "Н_УЧЕНИКИ"."ЧЛВК_ИД" = НЛ."ИД"
                  JOIN "Н_ПЛАНЫ" НП on "Н_УЧЕНИКИ"."ПЛАН_ИД" = НП."ИД"
         where "ОТД_ИД" = 703
         group by "ИМЯ"
         having count("ИМЯ") > 50
); -- todo >50 ФКТиУ -> done

--4 subquery
select "ИМЯ", count("ИМЯ")
from "Н_УЧЕНИКИ"
         JOIN "Н_ЛЮДИ" НЛ on "Н_УЧЕНИКИ"."ЧЛВК_ИД" = НЛ."ИД"
         JOIN "Н_ПЛАНЫ" НП on "Н_УЧЕНИКИ"."ПЛАН_ИД" = НП."ИД"
where "ОТД_ИД" = 703
group by "ИМЯ"
having count("ИМЯ") > 50;

--5.
SELECT "ЧЛВК_ИД", "ФАМИЛИЯ", "ИМЯ", "ОТЧЕСТВО", AVG("ОЦЕНКА"::int) as "Ср_оценка"
FROM "Н_ВЕДОМОСТИ"
    JOIN "Н_УЧЕНИКИ" USING ("ЧЛВК_ИД")
    JOIN "Н_ЛЮДИ" ON "Н_ЛЮДИ"."ИД" = "Н_ВЕДОМОСТИ"."ЧЛВК_ИД"
WHERE "ГРУППА" = '4100' AND "ОЦЕНКА" ~ '^[0-9]$'
GROUP BY "ЧЛВК_ИД", "ФАМИЛИЯ", "ИМЯ", "ОТЧЕСТВО"
HAVING AVG("ОЦЕНКА"::int) >= (
    SELECT MIN("ОЦЕНКА"::int) FROM "Н_ВЕДОМОСТИ"
        JOIN "Н_УЧЕНИКИ" USING ("ЧЛВК_ИД")
    WHERE "ГРУППА" = '3100' AND "ОЦЕНКА" ~ '^[0-9]$'
);

--5. subquery
SELECT MIN("ОЦЕНКА"::int) FROM "Н_ВЕДОМОСТИ"
    JOIN "Н_УЧЕНИКИ" USING ("ЧЛВК_ИД")
WHERE "ГРУППА" = '3100' AND "ОЦЕНКА" ~ '^[0-9]$';

--6.
SELECT "ГРУППА", "ЧЛВК_ИД", "ФАМИЛИЯ", "ИМЯ", "ОТЧЕСТВО", "В_СВЯЗИ_С", "СОСТОЯНИЕ"
FROM "Н_ЛЮДИ"
         JOIN "Н_УЧЕНИКИ" ON "Н_ЛЮДИ"."ИД" = "Н_УЧЕНИКИ"."ЧЛВК_ИД"
         JOIN "Н_ПЛАНЫ" ON "Н_ПЛАНЫ"."ИД" = "Н_УЧЕНИКИ"."ПЛАН_ИД"
         JOIN "Н_ФОРМЫ_ОБУЧЕНИЯ" ON "Н_ПЛАНЫ"."ФО_ИД" = "Н_ФОРМЫ_ОБУЧЕНИЯ"."ИД"
         JOIN "Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ" ON "Н_ПЛАНЫ"."НАПС_ИД" = "Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ"."ИД"
         JOIN "Н_НАПР_СПЕЦ" ON "Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ"."НС_ИД" = "Н_НАПР_СПЕЦ"."ИД" AND "Н_НАПР_СПЕЦ"."КОД_НАПРСПЕЦ" = '230101'
WHERE "КУРС" = 1
    AND "Н_УЧЕНИКИ"."НАЧАЛО" > '2012-09-01'::timestamp
    AND "Н_ФОРМЫ_ОБУЧЕНИЯ"."НАИМЕНОВАНИЕ" IN (
        SELECT "Н_ФОРМЫ_ОБУЧЕНИЯ"."НАИМЕНОВАНИЕ" from "Н_ФОРМЫ_ОБУЧЕНИЯ"
        WHERE "Н_ФОРМЫ_ОБУЧЕНИЯ"."НАИМЕНОВАНИЕ" = 'Заочная'
            OR "Н_ФОРМЫ_ОБУЧЕНИЯ"."НАИМЕНОВАНИЕ" = 'Очная'
    );

--7.
select "ОТЧЕСТВО", "ДАТА_РОЖДЕНИЯ"
from "Н_УЧЕНИКИ"
         JOIN "Н_ЛЮДИ" НЛ on "Н_УЧЕНИКИ"."ЧЛВК_ИД" = НЛ."ИД"
group by "ОТЧЕСТВО", "ДАТА_РОЖДЕНИЯ" having count(*) = 1;