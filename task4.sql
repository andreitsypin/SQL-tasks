
CREATE VIEW FIRST_VIEW AS
SELECT Client.Fullname AS Client, Client.Phone_number AS ClientPhone, Staff.Fullname AS Employee, Staff.Phone_number AS StaffPhone, _Order.Date AS CreatedDate, _Order.Track_number
FROM Client
	JOIN _Order ON _Order.ID_Client = Client.ID
	JOIN Staff ON _Order.Employee = Staff.ID
WHERE _Order.Date > '2022-08-01'

SELECT * FROM FIRST_VIEW
DROP VIEW FIRST_VIEW

CREATE VIEW SECOND_VIEW AS
SELECT Shipment_Client.Date, Shipment_Client._Option, Delivery_company.Name
FROM Delivery_company
	 JOIN Shipment_Client ON Delivery_company.ID = Shipment_Client.Company

SELECT * FROM SECOND_VIEW
DROP VIEW SECOND_VIEW

CREATE VIEW THIRD_VIEW AS
SELECT Product_type.Name, Products.Brand, Products.Quantity
FROM Product_type
	JOIN Products ON Products.Type = Product_type.ID

SELECT * FROM THIRD_VIEW
DROP VIEW THIRD_VIEW

--#2
--#2.1
CREATE VIEW CHECK_VIEW_1 AS
SELECT ID_Client, Date, Waybill_number, Track_number, Payment, Employee
FROM _Order
WHERE Date > '2022-07-19'

INSERT INTO CHECK_VIEW_1
	(ID_Client, Date, Waybill_number, Track_number, Payment, Employee)
VALUES
	(7, '2022-07-01', 87325987, 32452376, 3, 5)

SELECT * FROM CHECK_VIEW_1
DROP VIEW CHECK_VIEW_1

CREATE VIEW CHECK_VIEW_2 AS
SELECT ID_Client, Date, Waybill_number, Track_number, Payment, Employee
FROM _Order
WHERE Date > '2022-07-19'
WITH CHECK OPTION

INSERT INTO CHECK_VIEW_2
	(ID_Client, Date, Waybill_number, Track_number, Payment, Employee)
VALUES
	(7,'2022-07-01', 87325987, 32452376, 3, 5)

SELECT * FROM CHECK_VIEW_2
DROP VIEW CHECK_VIEW_2

--#2.2

CREATE VIEW CHECK_VIEW_1_1 AS
SELECT ID_waybill, Price, Product, Quantity
FROM Products_in_Shipment
WHERE Quantity > 16

INSERT INTO CHECK_VIEW_1_1
	(ID_waybill, Price, Product, Quantity)
VALUES
	(3, 20000, 4, 15)

SELECT * FROM CHECK_VIEW_1_1
DROP VIEW CHECK_VIEW_1_1


CREATE VIEW CHECK_VIEW_2_1 AS
SELECT ID_waybill, Price, Product, Quantity
FROM Products_in_Shipment
WHERE Quantity > 16
WITH CHECK OPTION

INSERT INTO CHECK_VIEW_2_1
	(ID_waybill, Price, Product, Quantity)
VALUES
	(3, 20000, 4, 15)

SELECT * FROM CHECK_VIEW_2_1
DROP VIEW CHECK_VIEW_2_1

--#3

SET NUMERIC_ROUNDABORT OFF; 
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;

--#3.1
CREATE VIEW Salary_Staff WITH SCHEMABINDING AS
SELECT Fullname, Position, Salary
FROM dbo.Staff_copy st
WHERE st.Salary = 30000;

DROP VIEW Salary_Staff

SELECT * FROM Salary_Staff

CREATE UNIQUE CLUSTERED INDEX Salary_Index_View
ON Salary_Staff (Fullname, Position, Salary)

DROP INDEX Salary_Index_View ON Salary_Staff

SELECT * FROM Salary_Staff WITH (noexpand)
