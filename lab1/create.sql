CREATE TABLE if not exists Person
(
    ID   SERIAL PRIMARY KEY,
    Name VARCHAR(255)
);

CREATE TABLE if not exists Object
(
    ID   SERIAL PRIMARY KEY,
    Name VARCHAR(255),
    Description VARCHAR(255)
);

CREATE TABLE if not exists State
(
    ID    SERIAL PRIMARY KEY,
    State VARCHAR(255)
);

CREATE TABLE if not exists Thought
(
    ID      SERIAL PRIMARY KEY,
    Thought VARCHAR(255)
);

CREATE TABLE if not exists Location
(
    ID   SERIAL PRIMARY KEY,
    Name VARCHAR(255)
);

CREATE TABLE if not exists Action
(
    ID SERIAL PRIMARY KEY,
    Description VARCHAR(255)
);

CREATE TABLE if not exists Insight
(
    THOUGHT_ID INT REFERENCES Thought(ID),
    ACTION_ID INT REFERENCES Action(ID),
    PRIMARY KEY (THOUGHT_ID, ACTION_ID)
);

ALTER TABLE Thought
    ADD COLUMN if not exists Person_ID INT;

ALTER TABLE Thought
    add CONSTRAINT FK_Person_Thought
        FOREIGN KEY (Person_ID)
            REFERENCES Person(ID);


ALTER TABLE State
    ADD COLUMN if not exists Person_ID INT;

ALTER TABLE State
    ADD CONSTRAINT FK_Person_State
        FOREIGN KEY (Person_ID)
            REFERENCES Person(ID);

ALTER TABLE Person
    ADD COLUMN if not exists Location_ID INT;

ALTER TABLE Person
    ADD CONSTRAINT FK_Person_Location
        FOREIGN KEY (Location_ID)
            REFERENCES Location(ID);

ALTER TABLE Object
    ADD COLUMN if not exists Location_ID INT;

ALTER TABLE Object
    ADD CONSTRAINT FK_Object_Location
        FOREIGN KEY (Location_ID)
            REFERENCES Location(ID);
