
--INSERT TRIGGER

CREATE TRIGGER Insert_Products
ON Products
AFTER INSERT
AS 
	BEGIN 
		DECLARE @Type_ins INT = (SELECT Type FROM inserted)
		DECLARE @Brand_ins NVARCHAR(20) = (SELECT Brand FROM inserted)
		DECLARE @Manuf_ins INT = (SELECT Manufacturer FROM inserted)
		DECLARE @Measure_ins NVARCHAR(10) = (SELECT Measure_unit FROM inserted)
		DECLARE @Price_ins INT = (SELECT Price FROM inserted)
		DECLARE @Quantity_ins INT = (SELECT Quantity FROM inserted)
		IF (@Type_ins = 1 AND @Manuf_ins = 5 AND @Price_ins != 2000)
			BEGIN
				ROLLBACK TRAN
				RAISERROR ('Ошибка заполнения: неверная цена футболки от данного производителя', 1, 1)
				PRINT @Brand_ins
				PRINT @Measure_ins
				DECLARE @new_price INT = 2000
				INSERT Products
					(Type, Brand, Manufacturer, Measure_unit, Price, Quantity)
				VALUES
					(@Type_ins, @Brand_ins, @Manuf_ins, @Measure_ins, @new_price, @Quantity_ins)
			END
	END

INSERT Products
	(Type, Brand, Manufacturer, Measure_unit, Price, Quantity)
VALUES
	(1, 'Janoff.', 5, 'штук', 3000, 22);

SELECT * FROM Products

DROP TRIGGER Insert_Products
--UPDATE TRIGGER

CREATE TRIGGER Order_Update
ON _Order
AFTER UPDATE
AS
	BEGIN
		DECLARE @ID_ins INT = (SELECT ID FROM inserted)
		DECLARE @Date_ins DATE = (SELECT Date FROM inserted)
		IF (@Date_ins < GETDATE())
			BEGIN
				ROLLBACK TRAN
				RAISERROR ('Ошибка обновления: невозможно установить прошедшую дату', 2, 1)
			END
		ELSE
			UPDATE Shipment_Client 
			SET Date = DATEADD(day, 10, @Date_ins)
			WHERE ID_order = @ID_ins
	END

UPDATE _Order SET Date = '2022-10-10' WHERE ID_Client = 1

UPDATE _Order SET Date = '2022-12-28' WHERE ID_Client = 1
SELECT * FROM _Order
SELECT * FROM Shipment_Client

DROP TRIGGER Order_Update
--DELETE TRIGGER

CREATE TRIGGER PIS_Delete
ON Products_in_Shipment
AFTER DELETE
AS
	BEGIN
		DECLARE @IDway_del INT = (SELECT ID_waybill FROM deleted)
		DECLARE @Quan_del INT = (SELECT Quantity FROM deleted)
		DECLARE @IDPR_del INT = (SELECT Product FROM deleted)
		IF (@IDway_del = 7)
			BEGIN
				ROLLBACK TRAN
				RAISERROR ('Ошибка удаления', 3, 1)
			END
		ELSE
			UPDATE Products 
			SET Quantity = Quantity + @Quan_del
			WHERE ID = @IDPR_del
	END

SELECT * FROM Products_in_Shipment
SELECT * FROM Products

DELETE FROM Products_in_Shipment WHERE ID_waybill = 7

DELETE FROM Products_in_Shipment WHERE ID_waybill = 4

SELECT * FROM Products_in_Shipment
SELECT * FROM Products

DROP TRIGGER PIS_Delete


CREATE VIEW Order_Payment
AS
	SELECT _Order.ID_Client, _Order.Date, _Order.Waybill_number, _Order.Track_number, 
		   _Order.Payment, _Order.Employee, Payment_option.ID, Payment_option._Option, Client.Fullname, Client.Birthdate, Client.Passport, Client.Address,
		   Client.Email, Client.Phone_number, Client.INN, Client.Login, Client.Password
	FROM _Order
		INNER JOIN	Payment_option ON _Order.Payment = Payment_option.ID
		INNER JOIN Client ON _Order.ID_Client = Client.ID

SELECT * FROM Order_Payment
DROP VIEW Order_Payment
--
CREATE TRIGGER Trigger_View_1
ON Order_Payment
INSTEAD OF INSERT
AS
	BEGIN
		DECLARE @IDCl_ins INT = (SELECT ID_Client FROM inserted)
		DECLARE @Date_ins DATE = (SELECT Date FROM inserted)
		DECLARE @IDway_ins INT = (SELECT Waybill_number FROM inserted)
		DECLARE @IDtra_ins INT = (SELECT Track_number FROM inserted)
		DECLARE @Pay_ins INT = (SELECT ID FROM inserted)
		DECLARE @IEmp_ins INT = (SELECT Employee FROM inserted)
		DECLARE @N_I NVARCHAR(100) = (SELECT Fullname FROM inserted)
		DECLARE @BDate_ins DATE = (SELECT Birthdate FROM inserted)
		DECLARE @Pass_ins BIGINT = (SELECT Passport FROM inserted)
		DECLARE @Add_ins NVARCHAR(200) = (SELECT Address FROM inserted)
		DECLARE @Em_ins NVARCHAR(200) = (SELECT Email FROM inserted)
		DECLARE @phnum_ins BIGINT = (SELECT Phone_number FROM inserted)
		DECLARE @inn BIGINT = (SELECT INN FROM inserted)
		DECLARE @log_ins NVARCHAR(100) = (SELECT Login FROM inserted)
		DECLARE @passw_ins NVARCHAR(100) = (SELECT Password FROM inserted)
		BEGIN
			INSERT INTO Client
				(Fullname, Birthdate, Passport, Address, Email, Phone_number, INN, Login, Password)
			VALUES
				(@N_I, @BDate_ins, @Pass_ins, @Add_ins, @Em_ins, @phnum_ins, @inn, @log_ins, @passw_ins)
			INSERT INTO _Order
				(ID_Client, Date, Waybill_number, Track_number, Payment, Employee)
			VALUES
				((SELECT MAX(ID) FROM Client), @Date_ins, @IDway_ins, @IDtra_ins, @Pay_ins, @IEmp_ins)
		END
	END

DROP TRIGGER Trigger_View_1

INSERT INTO Order_Payment
VALUES
	(6,	'2022-09-20', 32934217, 35328523, 6, 3, 5, 'PayPal', 
	 'Каримова Евгения Леонидовна', '1991-12-23', 4841741084, 'Россия, г. Омск, Школьный пер., д.13 кв.175', 'olga1991@mail.ru',
	 +79572242010, 403202713723, 'olga1991', 'bda23ec96')

SELECT * FROM Order_Payment
SELECT * FROM Client
SELECT * FROM _Order

--

CREATE TRIGGER Trigger_View_2
ON Order_Payment
INSTEAD OF UPDATE
AS
	BEGIN
		DECLARE @new_way INT = (SELECT Waybill_number FROM inserted)
		DECLARE @IDCL_ins INT = (SELECT ID_Client FROM inserted)
		BEGIN
			UPDATE _Order 
			SET Waybill_number = @new_way
			WHERE ID_Client = @IDCL_ins
		END
	END

UPDATE Order_Payment SET Waybill_number = 11111111 WHERE ID_client = 2

SELECT * FROM Order_Payment
SELECT * FROM _Order

--

CREATE TRIGGER Trigger_View_3
ON Order_Payment
INSTEAD OF DELETE
AS
	BEGIN
		DECLARE @idpay_ins INT = (SELECT ID FROM deleted)
		BEGIN
			DELETE FROM _Order WHERE Payment = @idpay_ins
		END
	END

DELETE FROM Order_Payment WHERE _Option = 'VISA'

SELECT * FROM Order_Payment
SELECT * FROM _Order
		INNER JOIN	Payment_option ON _Order.Payment = Payment_option.ID

