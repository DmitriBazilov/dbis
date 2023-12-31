INSERT INTO Location (Name)
VALUES ('машина');
INSERT INTO Location (Name)
VALUES ('под сиденьем');

INSERT INTO Person (name, location_id)
values ('Дженнаро',
        (SELECT ID FROM Location WHERE Name = 'машина'));

INSERT INTO State (state, person_id)
values ('изуродованная нога',
        (SELECT id FROM Person WHERE Name = 'Дженнаро'));

INSERT INTO Thought (thought, person_id)
values ('во что завернуть изуродованную ногу',
        (SELECT (id) FROM person WHERE name = 'Дженнаро'));

INSERT INTO Object (Name, Description, Location_ID)
values ('мешок', 'холщовый с инструментами',
        (SELECT ID FROM Location WHERE Name = 'под сиденьем'));
INSERT INTO Object (Name, Description, Location_ID)
values ('диск', 'колесный',
        (SELECT ID FROM Location WHERE Name = 'под сиденьем'));
INSERT INTO Object (Name, Description, Location_ID)
values ('коробка', 'из-под карт',
        (SELECT ID FROM Location WHERE Name = 'под сиденьем'));

INSERT INTO action (description)
values ('заглянул под сиденье');

INSERT INTO insight
VALUES ((SELECT (id) from thought where thought.thought = 'во что завернуть изуродованную ногу'),
        (SELECT (id) from action where description = 'заглянул под сиденье'));