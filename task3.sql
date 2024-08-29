CREATE TABLE Staff_copy(
Fullname nvarchar(50) NOT NULL,
Birthdate date NOT NULL,
Passport bigint NOT NULL,
Phone_number bigint NOT NULL,
INN bigint NOT NULL,
Address nvarchar(70) NOT NULL,
Position nvarchar(30) NOT NULL,
Salary int NOT NULL
)

DELETE Staff_copy
SELECT * FROM Staff_copy

/*Кластерный*/

SELECT * 
FROM Staff_copy
WHERE Salary = 30000;

CREATE CLUSTERED INDEX Salary_Index
ON Staff_copy(Salary)

SELECT * 
FROM Staff_copy
WHERE Salary = 30000;

DROP INDEX Salary_Index ON Staff_copy

/*Составной*/

SELECT Position 
FROM Staff_copy
WHERE Salary = 30000 AND Position = 'Старший кладовщик';

CREATE INDEX Salary_Patronymic_Index
ON Staff_copy(Position, Salary)

SELECT position
FROM Staff_copy
WHERE Salary = 30000 AND Position = 'Старший кладовщик';

DROP INDEX Salary_Patronymic_Index ON Staff_copy

/*Покрывающий*/

SELECT * 
FROM Staff_copy
WHERE Salary = 35000;

CREATE INDEX Phone_Patronymic_Index
ON Staff_copy(Salary)
INCLUDE (Fullname, Birthdate, Passport, Phone_number, INN, Address, Position)

SELECT * 
FROM Staff_copy
WHERE Salary = 35000;

DROP INDEX Phone_Patronymic_Index ON Staff_copy

/*Уникальный*/

SELECT Phone_number, Salary, Birthdate
FROM Staff_copy
WHERE Phone_number = +79443011229 AND Salary > 30000 AND Salary < 35000 AND DATEPART(YEAR, Birthdate) BETWEEN 1980 AND 1990;

CREATE UNIQUE INDEX Patronymic_Salary_Year_UN_Index
ON Staff_copy(Phone_number, Salary, Birthdate)

SELECT Phone_number, Salary, Birthdate
FROM Staff_copy
WHERE Phone_number = +79443011229 AND Salary > 30000 AND Salary < 35000 AND DATEPART(YEAR, Birthdate) BETWEEN 1980 AND 1990;

DROP INDEX Patronymic_Salary_Year_UN_Index ON Staff_copy

/*Индекс со включенными столбцами*/

SELECT Fullname, Phone_number 
FROM Staff_copy
WHERE Salary = 35000;

CREATE INDEX Include_Index
ON Staff_copy(Salary, Position)
INCLUDE (Fullname, Phone_number)


SELECT Fullname, Phone_number 
FROM Staff_copy
WHERE Salary = 35000;

DROP INDEX Include_Index ON Staff_copy

/*Отфильтрованный индекс*/

SELECT Birthdate
FROM Staff_copy
WHERE Birthdate = '1978-11-21';

CREATE INDEX Date_Index
ON Staff_copy(Birthdate)
WHERE Birthdate > '1975-01-01' AND Birthdate < '1988-01-01';

SELECT Birthdate
FROM Staff_copy
WHERE Birthdate = '1978-11-21';

DROP INDEX Date_Index ON Staff_copy