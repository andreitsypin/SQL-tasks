
/*Inner join*/
SELECT Date, Waybill_number, Payment, Employee, Fullname
FROM _Order
INNER JOIN Staff ON _Order.Employee = Staff.ID and  Staff.Salary = 30000

SELECT Shipment_client.Date, _Option, Waybill_number
FROM Shipment_Client
INNER JOIN _Order ON ID_order = ID_Client

/*Left join*/
SELECT Description, Price, Quantity
FROM Product_type
LEFT JOIN Products_in_Shipment_Client ON Product_type.ID = Products_in_Shipment_Client.Product

/*Right join*/
SELECT Brand, Quantity, Product_type.Name
FROM Products
RIGHT JOIN Product_type ON Products.Type = Product_type.ID

/*Full join*/
SELECT Date, _Option, Fullname, Birthdate
FROM Shipment_Client
FULL JOIN Staff ON  Shipment_Client.Employee = Staff.ID

/*Cross join*/
SELECT *
FROM Shipment_Supplier
CROSS JOIN Supplier

/*Cross apply*/
SELECT Date, Waybill_number, _Option
FROM _Order
CROSS APPLY (SELECT * FROM Payment_option WHERE Payment_option.ID = _Order.Payment) Payment_option

/*Self join*/
SELECT ft.Date, st._Option
FROM Shipment_Client AS ft
CROSS JOIN Shipment_Client AS st

/*UNION*/
SELECT Date, Employee FROM Shipment_Client
UNION 
SELECT Date, Employee FROM Shipment_Supplier

/*UNION ALL*/
SELECT Date, Employee FROM Shipment_Client
UNION ALL
SELECT Date, Employee FROM Shipment_Supplier

/*EXCEPT только те из первой таблицы, которых нет во второй*/
SELECT Date, Employee FROM Shipment_Client
EXCEPT
SELECT Date, Employee FROM Shipment_Supplier

/*INTERSECT одинаковые строки*/
SELECT Date, Employee FROM Shipment_Client
INTERSECT
SELECT Date, Employee FROM Shipment_Supplier

/*EXISTS проверка на наличие строк*/
SELECT Fullname, Birthdate 
FROM Staff
WHERE EXISTS (SELECT * FROM Shipment_Client)	

DELETE Shipment_Client

SELECT * FROM Shipment_Client

SELECT Fullname, Birthdate 
FROM Staff
WHERE EXISTS (SELECT * FROM Shipment_Client)

/*IN*/
SELECT Brand
FROM Products
WHERE Quantity IN (12, 13, 15)

/*ALL все значения подзапроса удовлетворяют условию*/
SELECT *
FROM Products_in_Shipment
WHERE Price > ALL (SELECT Price
					 FROM Products_in_Shipment
					 WHERE ID_waybill = 3)

/*SOME*/
SELECT *
FROM Products_in_Shipment
WHERE ID_waybill = 1 
	AND Price > SOME (SELECT Price
					 FROM Products_in_Shipment
					 WHERE ID_waybill = 3)

/*ANY true хотя бы одно выполняет условие*/
SELECT *
FROM Products_in_Shipment
WHERE Price > ANY (SELECT Price
					 FROM Products_in_Shipment
					 WHERE ID_waybill = 3)

/*BETWEEN*/
SELECT Brand
FROM Products
WHERE Price BETWEEN 2500 AND 4000

/*LIKE*/
SELECT *
FROM Client
WHERE Fullname LIKE '%Давидович'

/*CASE*/
SELECT Fullname,
	CASE WHEN Salary < 40000 THEN 'Работай лучше!'
	ELSE 'Можешь не работать' END AS Motivation
FROM Staff 

/*CAST*/
SELECT 'Средняя цена = '+ CAST(AVG(Price) AS CHAR(10)) 
FROM Products;

/*CONVERT*/
SELECT CONVERT(nvarchar, Date, 107)
FROM Shipment_Client

/*ISNULL*/
DECLARE @EXAMPLE nvarchar(10)
SET @EXAMPLE = NULL
SELECT ISNULL(@EXAMPLE, 'YEP') AS RESULT

SELECT ISNULL(Brand, 'YEP, IS NULL') AS RESULT
			  FROM Products
		      RIGHT JOIN Product_type ON Products.Type = Product_type.ID

/*NULLIF*/
SELECT AVG(NULLIF(Price, 0))
FROM Products

/*COALESCE*/
SELECT COALESCE(NULL, NULL, NULL, Fullname, NULL, 'SECOND NOT NULL') AS RESULT
FROM Client

/*CHOOSE*/
SELECT CHOOSE(2, Fullname, Password) AS NUM
FROM Client

/*IIF*/
SELECT IIF(Price < (SELECT Price
				    FROM Products_in_Shipment
					WHERE Quantity = 15), 'TRUE', 'FALSE') AS RESULT
FROM Products_in_Shipment

/*REPLACE*/
SELECT * FROM Staff
UPDATE Staff
SET Fullname = REPLACE(Fullname, '-', ' ');
SELECT * FROM Staff

/*SUBSTRING*/
SELECT Fullname, SUBSTRING(Fullname, 0, 10) AS RESULT
FROM Staff

/*STUFF*/
SELECT Fullname, STUFF(Fullname, 10, LEN(Fullname), '_' + Position) 
FROM Staff

/*STR*/
SELECT STR(Price) AS RESULT
FROM Products_in_Shipment_Client

/*UNICODE*/
SELECT UNICODE(SUBSTRING(Fullname, 1, 2)) AS RESULT
FROM Staff

/*LOWER*/
SELECT Fullname, LOWER(Fullname) AS LOWER_RESULT
FROM Client

/*UPPER*/
SELECT Fullname, UPPER(Fullname) AS UPPER_RESULT
FROM Client

/*DATEPART*/
SELECT DATEPART(day, Date) AS RESULT
FROM Shipment_Client

/*DATEADD*/
SELECT DATEADD(month, 2, Date) AS RESULT
FROM Shipment_Client

/*DATEDIFF*/
SELECT DATEDIFF(MINUTE, min(Date), max(Date))
FROM Shipment_Client

/*GETDATE()*/
SELECT GETDATE()

/*SYSDATETIMEOFFSET()*/
SELECT SYSDATETIMEOFFSET()

/*GROUP BY*/
SELECT ID_order,
	   SUM(Price) AS SUM_Price
FROM Products_in_Shipment_Client
GROUP BY ID_order

/*HAVING*/
SELECT ID_order,
	   SUM(Price) AS SUM_Price
FROM Products_in_Shipment_Client
GROUP BY ID_order
HAVING SUM(Price) > 12000