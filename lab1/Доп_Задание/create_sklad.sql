CREATE TABLE if not exists Категория
(
    ID                     SERIAL primary key,
    Наименование_категории varchar(255)
);

CREATE TABLE if not exists Овощ
(
    ID           SERIAL primary key,
    Категория    int not null,
    Наименование varchar(255),
    Сорт         varchar(255),
    Цена         int,
    CONSTRAINT fk_категория_овоща FOREIGN KEY (Категория) REFERENCES Категория (ID)
);

CREATE TABLE if not exists Складская_ячейка
(
    ID           SERIAL primary key,
    ID_овоща     int,
    ID_склада    int,
    Колво_овощей bigint,
    CONSTRAINT fk_овощ_ячейки FOREIGN KEY (ID_овоща) REFERENCES Овощ (ID),
    CONSTRAINT fk_склад_ячейки FOREIGN KEY (ID_склада) REFERENCES Склад (ID)
);

CREATE TABLE if not exists Склад
(
    ID              SERIAL primary key,
    Название_склада varchar(255),
    Адрес           varchar(255),
    Вместимость     varchar(255)
);

CREATE TABLE if not exists Поставщик
(
    ID                    SERIAL primary key,
    ИНН                   varchar(12) not null unique,
    Наименование_компании varchar(255),
    Телефон               varchar(30),
    Контактное_лицо       varchar(255),
    CONSTRAINT fk_ИНН_Поставщика FOREIGN KEY (ИНН) REFERENCES ИНН (ИНН)
);

CREATE TABLE if not exists Заказчик
(
    ID                    SERIAL primary key,
    ИНН                   varchar(12) not null unique,
    Наименование_компании varchar(255),
    Телефон               varchar(30),
    Контактное_лицо       varchar(255),
    Адрес                 varchar(255),
    CONSTRAINT fk_ИНН_Заказчика FOREIGN KEY (ИНН) REFERENCES ИНН (ИНН)
);

CREATE TABLE if not exists ИНН
(
    ИНН varchar(12) primary key
);

CREATE TABLE if not exists Поставка
(
    ID_Поставщика int,
    ID_Овоща      int,
    PRIMARY KEY (ID_Поставщика, ID_Овоща),
    CONSTRAINT fk_Поставщик FOREIGN KEY (ID_Поставщика) REFERENCES Поставщик (ID),
    CONSTRAINT fk_Овощ FOREIGN KEY (ID_Овоща) REFERENCES Овощ (ID)
);

CREATE TABLE if not exists Заказ
(
    ID_Заказчика int,
    ID_Овоща      int,
    PRIMARY KEY (ID_Заказчика, ID_Овоща),
    CONSTRAINT fk_Заказчик FOREIGN KEY (ID_Заказчика) REFERENCES Заказчик (ID),
    CONSTRAINT fk_Овощ FOREIGN KEY (ID_Овоща) REFERENCES Овощ (ID)
);

