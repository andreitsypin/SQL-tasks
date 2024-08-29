--скидка на распродаже
GO
CREATE PROCEDURE BLACK_FRIDAY @ID_cl INT
AS 
	BEGIN
		DECLARE @NUM_order INT = (SELECT ID FROM _Order WHERE ID_Client = @ID_cl)
		DECLARE @PR_ INT = (SELECT Price FROM Products_in_Shipment_Client WHERE ID_order = @NUM_order)
		IF (@PR_ > 10000)
			RETURN @PR_ * 0.75
		ELSE
			RETURN @PR_ * 0.85
	END

DECLARE @clch INT = 2
DECLARE @procch INT

EXEC @procch = BLACK_FRIDAY @clch
PRINT @procch

--вывод информации по заказу у клиента
GO
CREATE PROCEDURE full_ord @ID_CL INT, @inf_check NVARCHAR(20), @info NVARCHAR(200) OUTPUT
AS
	BEGIN
		BEGIN
			DECLARE @NUM_order INT = (SELECT ID FROM _Order WHERE ID_Client = @ID_cl)
			IF (@inf_check = 'Company')
				BEGIN
					DECLARE @com_id INT = (SELECT Company FROM Shipment_Client WHERE ID_order = @NUM_order)
					DECLARE @name_c NVARCHAR(50) = (SELECT Name FROM Delivery_company WHERE ID = @com_id)
					SET @info = 'Delivery company is ' + @name_c
				END
			IF (@inf_check = 'Employee')
				BEGIN
					DECLARE @emp_id INT = (SELECT Employee FROM Shipment_Client WHERE ID_order = @NUM_order)
					DECLARE @name_e NVARCHAR(50) = (SELECT Fullname FROM Staff WHERE ID = @emp_id)
					SET @info = 'The order was made ' + @name_e
				END		
			IF (@inf_check = 'Option')
				BEGIN
					DECLARE @name_o NVARCHAR(50) = (SELECT _Option FROM Shipment_Client WHERE ID_order = @NUM_order)
					SET @info = 'Option is ' + @name_o
				END
		END
	END

DROP PROCEDURE full_ord

DECLARE @CL INT = 1
DECLARE @C NVARCHAR(50) = 'Company'
DECLARE @full_check NVARCHAR(200)
EXEC full_ord @CL, @C, @full_check OUTPUT
PRINT @full_check

DECLARE @CL2 INT = 1
DECLARE @E NVARCHAR(50) = 'Employee'
DECLARE @full_check2 NVARCHAR(200)
EXEC full_ord @CL2, @E, @full_check2 OUTPUT
PRINT @full_check2

DECLARE @CL3 INT = 1
DECLARE @O NVARCHAR(50) = 'Option'
DECLARE @full_check3 NVARCHAR(200)
EXEC full_ord @CL3, @O, @full_check3 OUTPUT
PRINT @full_check3



--вывод работников, которые обработали хотя бы один заказ в следующие 30 дней от введенной даты
GO
CREATE PROCEDURE Work_Emp @Date_plus DATE, @empl NVARCHAR(1500) OUTPUT
AS
	BEGIN
		DECLARE @r_date DATE = DATEADD(day, 30, @Date_plus)
		DECLARE @check_date DATE
		DECLARE curs CURSOR LOCAL SCROLL FOR
		SELECT Date
		FROM _Order

		OPEN curs
		FETCH curs INTO @check_date
		WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE @ddate Date = (SELECT TOP 1 Date FROM _Order)
				IF (@ddate > @Date_plus AND @ddate < @r_date)
				DECLARE @id_ch INT = (SELECT TOP 1 Employee FROM _Order WHERE Date = @ddate)
				DECLARE @name NVARCHAR(50) = (SELECT TOP 1 Fullname FROM Staff WHERE ID = @id_ch)
					SET @empl = @name
				FETCH NEXT FROM curs INTO @check_date
			END
	END

DROP PROCEDURE Work_Emp

DECLARE @datecc date = '2022-08-01'
DECLARE @res_ch NVARCHAR(1500)

EXEC Work_Emp @datecc, @res_ch OUTPUT
PRINT @res_ch

--снижение цен от производителя
GO
CREATE PROCEDURE Sup_date @brand_i NVARCHAR(20)
AS 
	BEGIN
		DECLARE @qua INT = (SELECT Quantity FROM Products WHERE Brand = @brand_i)
		IF (@qua < 25 AND @qua > 15)
			UPDATE Products
			SET Price = Price * 0.85
			WHERE Brand = @brand_i
		IF (@qua <= 15)
			UPDATE Products
			SET Price = Price * 0.75
			WHERE Brand = @brand_i
	END

SELECT * FROM Products

DECLARE @a NVARCHAR(20) = 'Nike'
EXEC Sup_date @a


--вычисление наценки

GO
CREATE PROCEDURE pr_plus @id_w INT
AS
	BEGIN
		DECLARE @pr INT = (SELECT Product FROM Products_in_Shipment WHERE ID_waybill = @id_w)
		DECLARE @pricee INT = (SELECT Price FROM Products_in_Shipment WHERE ID_waybill = @id_w)
		DECLARE @qua INT = (SELECT Quantity FROM Products_in_Shipment WHERE ID_waybill = @id_w)
		DECLARE @type INT = (SELECT Type FROM Products WHERE ID = @pr)
		IF (@type = 1)
			RETURN (@pricee / @qua) * 1.12
		IF (@type = 2)
			RETURN (@pricee / @qua) * 1.10
		IF (@type = 3)
			RETURN (@pricee / @qua) * 1.15
		IF (@type = 4)
			RETURN (@pricee / @qua) * 1.20
		IF (@type = 5)
			RETURN (@pricee / @qua) * 1.15
		IF (@type = 6)
			RETURN (@pricee / @qua) * 1.18
		IF (@type = 7)
			RETURN (@pricee / @qua) * 1.22
		IF (@type = 8)
			RETURN (@pricee / @qua) * 1.08
	END

DECLARE @check_var INT = 6
DECLARE @res INT
EXEC @res = pr_plus @check_var
PRINT @res