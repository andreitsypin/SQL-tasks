use Warehouse
go

--#9

/*Запрос с использованием автономных подзапросов*/
--Выводит сумму всех товаров в накладной поставщиков, количество которых больше среднего количества по накладной
select sum(Price)
from Products_in_Shipment
where Quantity > (select avg(Quantity)
				  from Products_in_Shipment)

select * from Products_in_Shipment

/*Создание запроса с использованием коррелированных подзапросов в предложении SELECT и WHERE*/
--Выводит тип товара из связанной таблицы для выбранных строк, а также выводит только товары с наценкой больше 100% (умножение на 2) по сравнению с поставкой
select * from Products_in_Shipment

select (select Name
		from Product_type
		where Product_type.ID = Products.Type) as Type,
		Brand,
		Price
from Products
where Price > (select (sum(Price) * 2 / sum(Quantity))
			   from Products_in_Shipment
			   where Products.ID = Products_in_Shipment.Product)

/*Запрос с использованием временных таблиц*/
--Создаём временную таблицу на основе таблицы заказов
--Запрос выдаёт дату и трэк-номер заказов, у которых дата создания заказа и накладной отличаются, т.е. товар отсутствовал на складе на момент заказа
select ID, Date, Waybill_number, Track_number
into #tempOrder
from _Order

--drop table #tempOrder
--select * from #tempOrder

--select * from Shipment_Client

--delete from Shipment_Client where ID > 2000

select Date, Track_number
from #tempOrder
where Date < (select Date
			  from Shipment_Client
			  where Shipment_Client.ID_order = #tempOrder.ID)

/*Запрос с использованием обобщенных табличных выражений (CTE)*/
--Запрос удаляет повторяющиеся строки из временной таблицы с использованием ОТВ(Узнаем все вакансии на складе)
select Position, Salary 
into #tempStaff
from Staff

select * from #tempStaff

with tempCTE
as
	(
	select ROW_NUMBER () over (
		   PARTITION BY Position
		   order by Position) as checkp,
	*
	from #tempStaff
	)
delete from tempCTE where checkp > 1

select * from #tempStaff
drop table #tempStaff

/*Слияние данных (INSERT, UPDATE) c помощью инструкции MERGE*/
--Слияние данных из тестовой таблицы и таблицы персонала, если запись уже есть, то умножаем на 1.1, иначе добавляем запись
select * from Staff

select *
into #tempTable
from Staff
where Salary = 30000

select * from #tempTable
drop table #tempTable

merge #tempTable
using Staff
on (#tempTable.ID = Staff.ID)
when matched then
	update set #tempTable.Salary = Staff.Salary * 1.1
when not matched then
	insert
		(Surname, Name, Patronymic, Birthdate, Passport, Phone_number, INN, Address, Position, Salary)
	values
		(Staff.Surname, Staff.Name, Staff.Patronymic, Staff.Birthdate, Staff.Passport, Staff.Phone_number, Staff.INN, Staff.Address, Staff.Position, Staff.Salary);

/*Запрос с использованием оператора PIVOT*/

SELECT 'AverageCost' AS Sorted_by_Type,   
  [1], [2], [3], [4], [5], [6], [7], [8]  
FROM  
(
  SELECT Price, Product   
  FROM Products_in_Shipment
) AS SourceTable  
PIVOT  
(  
  AVG(Price)  
  FOR Product IN ([0], [1], [2], [3], [4], [5], [6], [7], [8])  
) AS PivotTable;

select * from Products_in_Shipment

/*Запрос с использованием оператора UNPIVOT*/

select ID, Surname, Name, Patronymic, info
from Client
unpivot(
		info for col in ([Passport], [Phone_number], [INN])	
		) as UnpivotTable;

/*Запрос с использованием GROUP BY с операторами ROLLUP, CUBE и GROUPING SETS*/

--Rollup

select (select Name
		from Product_type
		where Product_type.ID = Products_in_Shipment_Client.Product) as Product,
	   Quantity, sum(Price) as sumPrice
from Products_in_Shipment_Client
group by
rollup (Product, Quantity)

--Cube

select (select Name
		from Product_type
		where Product_type.ID = Products_in_Shipment_Client.Product) as Product,
	   Quantity, sum(Price) as sumPrice
from Products_in_Shipment_Client
group by
cube (Product, Quantity)

--Grouping sets

select * from Products_in_Shipment_Client

select (select Name
		from Product_type
		where Product_type.ID = Products_in_Shipment_Client.Product) as Product,
	   Quantity, sum(Price) as sumPrice
from Products_in_Shipment_Client
group by
grouping sets (Product, Quantity, (Product, Quantity), ())

/*Секционирование с использованием OFFSET FETCH*/

select * 
from Products 
where Quantity > 15
order by Price
offset 1 rows fetch next 2 rows only

/*Запросы с использованием ранжирующих оконных функций. ROW_NUMBER() нумерация строк. Использовать для нумерации внутри групп. RANK(), DENSE_RANK(), NTILE()*/

--ROW_NUMBER()
--Без группировки по типу продукта
select (select Name
		from Product_type
		where Product_type.ID = Products_in_Shipment.Product) as Product,
		Price,
		Quantity,
		ROW_NUMBER () over (order by Price desc) as Rows
from Products_in_Shipment

--С группировкой по типу продукта
select (select Name
		from Product_type
		where Product_type.ID = Products_in_Shipment.Product) as Product,
		Price,
		Quantity,
		ROW_NUMBER () over (partition by Product order by Price desc) as Rows
from Products_in_Shipment

--RANK()
--#1
--Без группировки по должности
select Surname, 
	   Name,
	   Position,
	   Salary,
	   rank() over (order by Salary desc) as Rank
from Staff
--С группировкой по должности
select Surname, 
	   Name,
	   Position,
	   Salary,
	   rank() over (partition by Position order by Salary desc) as Rank
from Staff
--#2
--Без группировки по типу товара
select (select Name
		from Product_type
		where Product_type.ID = Products_in_Shipment.Product) as Product,
		Price,
		Quantity,
		rank() over (order by Quantity desc) as Rank
from Products_in_Shipment
--С группировкой по типу товара
select (select Name
		from Product_type
		where Product_type.ID = Products_in_Shipment.Product) as Product,
		Price,
		Quantity,
		rank() over (partition by Product order by Quantity desc) as Rank
from Products_in_Shipment

--DENSE_RANK
--Без группировки по должности
select Surname, 
	   Name,
	   Position,
	   Salary,
	   dense_rank() over (order by Salary desc) as Rank
from Staff
--С группировкой по должности
select Surname, 
	   Name,
	   Position,
	   Salary,
	   dense_rank() over (partition by Position order by Salary desc) as Rank
from Staff

--NTILE
select Date, 
	   (select Name
	    from Delivery_company
		where Delivery_company.ID = Shipment_Client.Company) as Company,
	   (select Surname
	    from Staff
		where Staff.ID = Shipment_Client.Employee) as Employee,
	   ID_order,
	   ntile(3) over (order by Date desc) as Сourier
from Shipment_Client
where _Option like 'К%'

/*Перенаправление ошибки в TRY/CATCH*/

begin try
	exec test
end try
begin catch
	select ERROR_NUMBER() as Номер,
		   ERROR_MESSAGE() as Сообщение,
		   ERROR_STATE() as Код_состояния,
		   ERROR_SEVERITY() as Степень_серьезности
end catch

/*Создание процедуры обработки ошибок в блоке CATCH с использованием функций ERROR*/

select * from Products_in_Shipment

begin try
	INSERT Products_in_Shipment
		(ID_waybill, Price, Product, Quantity)
	VALUES
		(2,	NULL, 3, 22);
end try
begin catch
	print 'Error ' + CONVERT(nvarchar, ERROR_NUMBER()) + ': ' + ERROR_MESSAGE()
	print 'Значение цены по умолчанию - 0'
	INSERT Products_in_Shipment
		(ID_waybill, Price, Product, Quantity)
	VALUES
		(2,	0, 3, 22);
end catch

--delete from Products_in_Shipment where Quantity = 22
select * from Products_in_Shipment

/*Использование THROW, чтобы передать сообщение об ошибке клиенту*/

begin try
	INSERT Products_in_Shipment
		(ID_waybill, Price, Product, Quantity)
	VALUES
		(2,	NULL, 3, 22);
end try
begin catch
	throw 55555, 'Значение не может быть NULL', 1;
	print 'Значение цены по умолчанию - 0'
end catch
----------------------------------------------------------------
begin try
	INSERT Products_in_Shipment
		(ID_waybill, Price, Product, Quantity)
	VALUES
		(2,	NULL, 3, 22);
end try
begin catch
	throw
	print 'Значение цены по умолчанию - 0'
end catch

/*Контроль транзакций с BEGIN и COMMIT*/

select * from _Order
select * from Shipment_Client
select * from Products_in_Shipment_Client

begin tran
	update Shipment_Client
	set _Option = 'Курьер'
	where ID_Order = 2

	insert _Order
		(ID_Client, Date, Waybill_number, Track_number, Payment, Employee)
	VALUES
		(1,	'2023-01-27', 111111, 4444444, 2, 1);

	delete from Products_in_Shipment_Client
	where ID_order = 4
commit tran

select * from _Order
select * from Shipment_Client
select * from Products_in_Shipment_Client

/*Использование XACT_ABORT*/

select * from Products_in_Shipment

set xact_abort off;

begin tran
	update Products_in_Shipment
	set Price = 44444
	where ID_waybill = 4
	
	INSERT Products
		(Type, Brand, Manufacturer, Measure_unit, Price, Quantity)
	VALUES
		(1, 'Levis', 3, 'штук', 3330, NULL)
commit tran

select * from Products_in_Shipment

/*Добавление логики обработки транзакций в блоке CATCH*/

begin try
	begin tran
	select (select Name
		from Product_type
		where Product_type.ID = Products_in_Shipment.Product) as Product,
		Price,
		Quantity,
		rank() over (order by Quantity desc) as Rank
	from Products_in_Shipment
end try
begin catch
	rollback tran
	select ERROR_NUMBER() as Номер,
		   ERROR_MESSAGE() as Сообщение
end catch
commit tran


begin try
begin tran
	INSERT Products_in_Shipment
		(ID_waybill, Price, Product, Quantity)
	VALUES
		(2,	NULL, 3, 22);
end try
begin catch
	rollback tran
	select ERROR_NUMBER() as Номер,
		   ERROR_MESSAGE() as Сообщение
	return
end catch
commit tran
