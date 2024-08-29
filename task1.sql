USE Warehouse;
GO

ALTER DATABASE [Warehouse]
COLLATE Cyrillic_General_100_CI_AI;
GO

CREATE TABLE Staff(
ID int IDENTITY(1,1) PRIMARY KEY,
Fullname nvarchar(50) NOT NULL,
Birthdate date NOT NULL,
keyStaffDem int not null,
Passport bigint NOT NULL,
Email nvarchar(30) NOT NULL,
gender bit not null,
Phone_number bigint NOT NULL,
INN bigint NOT NULL,
Address nvarchar(70) NOT NULL,
Position nvarchar(30) NOT NULL,
Salary int NOT NULL
)

CREATE TABLE Client(
ID int IDENTITY(1,1) PRIMARY KEY,
Fullname nvarchar(50) NOT NULL,
Birthdate date NOT NULL,
Passport bigint NOT NULL,
Address int NOT NULL,
Email nvarchar(30) NOT NULL,
Phone_number bigint NOT NULL,
INN bigint NOT NULL,
Login nvarchar(30) NOT NULL,
Password nvarchar(30) NOT NULL
)

CREATE TABLE Payment_option(
ID int IDENTITY(1,1) PRIMARY KEY,
_Option nvarchar(10) NOT NULL
)

CREATE TABLE _Order(
ID int IDENTITY(1,1) PRIMARY KEY,
keyOrderAlt nvarchar(30) not null,
keyDate bigint not null,
keyGeography int not null,
ID_Client int NOT NULL,
Date date NOT NULL,
Waybill_number bigint NOT NULL,
Track_number bigint NOT NULL,
Employee int NOT NULL,
Payment int NOT NULL,
FOREIGN KEY(ID_Client) REFERENCES Client(ID),
FOREIGN KEY(Payment) REFERENCES Payment_option(ID),
FOREIGN KEY(Employee) REFERENCES Staff(ID)
)

CREATE TABLE Delivery_company(
ID int IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(50) NOT NULL,
INN bigint NOT NULL,
Email nvarchar(30) NOT NULL,
FAX bigint NOT NULL,
Phone_number bigint NOT NULL,
Legal_address nvarchar(100) NOT NULL
)

CREATE TABLE Supplier(
ID int IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(50) NOT NULL,
INN bigint NOT NULL,
Email nvarchar(30) NOT NULL,
FAX bigint NOT NULL,
Phone_number bigint NOT NULL,
Legal_address nvarchar(70) NOT NULL
)

CREATE TABLE Manufacturer(
ID int IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(50) NOT NULL,
INN bigint NOT NULL,
Email nvarchar(30) NOT NULL,
FAX bigint NOT NULL,
Phone_number bigint NOT NULL,
Legal_address nvarchar(70) NOT NULL
)

CREATE TABLE Product_type(
ID int IDENTITY(1,1) PRIMARY KEY,
Name nvarchar(20) NOT NULL,
Description nvarchar(1000) NOT NULL,
)

CREATE TABLE Products(
ID int IDENTITY(1,1) PRIMARY KEY,
Type int NOT NULL,
Brand nvarchar(20) NOT NULL,
Manufacturer int NOT NULL,
Measure_unit nvarchar(10) NOT NULL,
Price int NOT NULL,
Quantity int NOT NULL,
FOREIGN KEY(Type) REFERENCES Product_type(ID),
FOREIGN KEY(Manufacturer) REFERENCES Manufacturer(ID)
)

CREATE TABLE Shipment_Supplier(
ID int IDENTITY(1,1) PRIMARY KEY,
Date date NOT NULL,
Company int NOT NULL,
Employee int NOT NULL,
FOREIGN KEY(Company) REFERENCES Supplier(ID),
FOREIGN KEY(Employee) REFERENCES Staff(ID)
)

CREATE TABLE Products_in_Shipment(
ID_waybill int NOT NULL,
Price int NOT NULL,
Product int NOT NULL,
Quantity int NOT NULL,
FOREIGN KEY(Product) REFERENCES Products(ID),
FOREIGN KEY(ID_waybill) REFERENCES Shipment_Supplier(ID)
)

CREATE TABLE Shipment_Client(
ID int IDENTITY(1,1) PRIMARY KEY,
Date date NOT NULL,
Company int NOT NULL,
Employee nvarchar(30) NOT NULL,
ID_order int NOT NULL,
_Option nvarchar(50) NOT NULL,
FOREIGN KEY(Company) REFERENCES Delivery_company(ID),
FOREIGN KEY(ID_order) REFERENCES _Order(ID)
)

CREATE TABLE Products_in_Shipment_Client(
Price int NOT NULL,
Product int NOT NULL,
Quantity int NOT NULL,
ID_order int NOT NULL,
personalDiscount int not null,
seasonalDiscount int not null,
TAX int not null,
FOREIGN KEY(Product) REFERENCES Products(ID),
FOREIGN KEY(ID_order) REFERENCES _Order(ID)
)

CREATE TABLE _Admin(
	ID int IDENTITY(1,1) not null,
	login_user varchar(50) not null,
	password_user varchar(50) not null
)

INSERT _Admin
	(login_user, password_user)
VALUES 
	('admin', 'admin');

SELECT * FROM _Admin

INSERT Client 
	(Fullname, Birthdate, Passport, Address, Email, Phone_number, INN, Login, Password)
VALUES
	('Харьков Ростислав	Викторович', '1996-02-03', 4352649876, 2, 'rostislav1996@rambler.ru', +79657507338,  190190777152, 'rostislav1996', 'fd8e43fc5'),
	('Распопов Георгий Феоктистович', '1963-05-07', 4160228958, 1, 'georgiy6092@rambler.ru', +79227573438, 827139862920, 'georgiy6092', 'deee23f61'),
	('Земцовский Артем Антонович',	'1983-03-16',	4036699184, 3,	'artem.zemcovskiy@ya.ru',	+7973515162,  673199814479, 'artem.zemcovskiy', '4c92ffbd3'),
	('Кравец Валентин Константинович', '1970-10-27', 4176560030, 4,	'valentin2345@outlook.com',	+79126666436, 300030693777, 'valentin2345', '1e27334b5'),
	('Каримова Ольга Леонидовна', '1991-12-23', 4841741084, 4, 'olga1991@mail.ru', +79572242010, 403202713723, 'olga1991', 'bda23ec96'),
	('Толбугин Юрин	Сергеевич',	'1980-10-27',	4068518041, 1, 'yurin1980@yandex.ru',	+79429386022, 561447833944,	'yurin1980', 'ff47874b7'),
	('Горлова Ника Давидович',	'1968-10-15',	4979382913, 5, 'nika1968@ya.ru', +79626563258, 407989541074,	'nika1968',	'5d675c1be'),
	('Сериков Денис	Давидович',	'1988-12-23',	4187701688, 2,'denis.serikov@gmail.com',	+79287214445, 359057321686, 'denis.serikov', '49188a577');

INSERT Staff 
	(Fullname, Birthdate, keyStaffDem, Passport, email, gender, Phone_number, INN, Address, Position, Salary)
VALUES
	('Юханцев Кирилл Юринович',	'1973-03-09', 2,	4182322847, 'rostislav1996@rambler.ru', 1,	+79169236244, 747888742405,	'Россия, г. Реутов, Максима Горького ул., д. 22 кв.37', 'Кладовщик-комплектовщик', 30000),
	('Сысоев Егор Кузьмич',	'1988-10-27', 1,	4864751965, 'georgiy6092@rambler.ru', 0,	+79767274013, 502480253239,	'Россия, г. Мытищи, Дружная ул., д. 25 кв.175', 'Кладовщик-комплектовщик', 30000),
	('Сухарников Гавриил Афанасьевич', '1991-10-07', 3,  4827405088, 'artem.zemcovskiy@ya.ru', 0, +79635673413, 843639159870, 'Россия, г. Одинцово, Белорусская ул., д. 20 кв.27', 'Заведующий складом', 50000),
	('Щавлева Афанасия Кирилловна',	'1972-10-04', 3,	4559899642, 'valentin2345@outlook.com',	1, +79636506868, 960043709316,	'Россия, г. Ногинск, Пионерская ул., д. 5 кв.103', 'Кладовщик-комплектовщик', 30000),
	('Порошина	Карина	Федоровна',	'1960-02-27', 4,	4131526353, 'olga1991@mail.ru',	1, +79486609463, 353263623258,	'Россия, г. Рубцовск, Солнечная ул., д. 14 кв.157', 'Старший кладовщик', 45000),
	('Белолипецкая Антонина	Трофимовна', '1992-03-28', 2,  4857670701, 'yurin1980@yandex.ru', 1, +79443011229, 484313733037, 'Россия, г. Махачкала, Интернациональная ул., д. 11 кв.99', 'Старший кладовщик', 45000),
	('Дрёмин Константин	Аркадьевич', '1990-08-22', 5, 4330770626, 'nika1968@ya.ru', 0, +79309295446, 382965819001, 'Россия, г. Мытищи, Новоселов ул., д. 5 кв.117', 'Водитель подгрузчика', 40000),
	('Лебединцев Яков Семенович', '1960-10-17', 5, 4393232286, 'denis.serikov@gmail.com', 1, +79719815847,	722292998300, 'Россия, г. Нальчик, Кирова ул., д. 13 кв.24', 'Водитель подгрузчика', 40000);

INSERT Payment_option
	(_Option)
VALUES
	('Mastercard'),
	('VISA'),
	('Maestro'),
	('QIWI'),
	('PayPal'),
	('AmazonPay'),
	('QIWI'),
	('WebMoney');

INSERT Supplier
	(Name, INN, Email, FAX, Phone_number, Legal_address)
VALUES
	('Deserunt', 427084503694,	'deserunt@example.com',	35222069086, 8127175121, '796150, Самарская область, город Лотошино, пл. Гоголя, 69'),
	('Veniam', 516842978801, 'veniam@example.org',	8127257818,	88002801802, '135070, Липецкая область, город Коломна, пр. Славы, 71'),
	('Omnis', 366963054700, 'omnis@example.org', 35222429816, 4954474833, '742247, Томская область, город Ногинск, ул. Ломоносова, 17'),
	('Provident', 589638049224,	'provident@example.net', 88002159296, 8123180492, '763536, Вологодская область, город Воскресенск, спуск Бухарестская, 36'),
	('Voluptatem', 450583522345, 'voluptatem@example.net',	4953044305,	+79221705389, '660337, Ивановская область, город Щёлково, въезд Ломоносова, 39'),
	('Nobis', 285075367402,	'nobis@example.org', 88005237682, 35222219364,	'278688, Ярославская область, город Ногинск, въезд Ладыгина, 48');

INSERT Manufacturer
	(Name, INN, Email, FAX, Phone_number, Legal_address)
VALUES
	('Ipsum', 308736280651,	'ipsum@example.org', 4953741216, 35222813934, '821917, Костромская область, город Талдом, пл. Гоголя, 52'),
	('Perferendis',	360694701414, 'perferendis@example.org', 8128432695, +79220962414, '019065, Ивановская область, город Истра, шоссе Балканская, 68'),
	('Dolor', 323094752239,	'dolor@example.org', 8129857222, 4959776822, '961162, Свердловская область, город Видное, проезд Сталина, 27'),
	('Consectetur',	558768246418, 'consectetur@example.net', 4958416640, 35222628407, '996330, Псковская область, город Воскресенск, наб. Космонавтов, 25'),
	('Impedit',	681805893428, 'impedit@example.org', 88003810582, 8123216456, '597080, Томская область, город Воскресенск, наб. Космонавтов, 91'),
	('Quaerat',	583832346239,	'quaerat@example.org', 4952291039, +79224332193, '189097, Орловская область, город Домодедово, въезд Сталина, 98');

INSERT Delivery_company
	(Name, INN, Email, FAX, Phone_number, Legal_address)
VALUES
	('Repellendus',	430722324353,'repellendus@gmail.com', 179977196, 8129177545, '529061, Ульяновская область, город Наро-Фоминск, спуск Будапештсткая, 68'),
	('Itaque',	663137899641, 'itaque@example.com', 137656188, 8125569671, '396964, Ростовская область, город Талдом, шоссе Бухарестская, 98'),
	('Maxime',	572101531020, 'Maxime@hotmail.com', 245103086, 88004825013,	'256655, Новгородская область, город Одинцово, пл. Космонавтов, 40'),
	('Nihil',	586926214337, 'nihil!mail.ru', 351249289, 35222043591, '027438, Астраханская область, город Клин, бульвар Гоголя, 91'),
	('Officiis', 431057352134, 'officiis@hotmail.ru', 233217730, 88009680931,	'626103, Читинская область, город Видное, спуск Чехова, 18'),
	('Magnam',	586772987276, 'magnam@mail.ru', 158025944, 8122617902, '808302, Новосибирская область, город Орехово-Зуево, спуск Будапештсткая, 64');

INSERT Product_type
	(Name, Description)
VALUES
	('Футболка', 'Предмет нательной одежды для обоих полов, обычно не имеющий пуговиц, воротника и карманов, с короткими рукавами, закрывающий туловище, часть рук и верх бёдер, надевается через голову.'),
	('Кофта', 'Кофта — верхняя часть женского костюма.Кофта стала основой для появления остальных предметов плечевой вязаной одежды — свитеров, пуловеров, джемперов и жакетов.'),
	('Рубашка', 'Рубашка — вид одежды, относящийся к верхнему нательному белью. Исторически рубашка относится именно к нательному белью, однако с 1960-х годов может носиться самостоятельно, не покрываясь иной одеждой.'),
	('Куртка', 'Куртка - это одежда для верхней части тела, обычно доходящая ниже бедер. Куртка обычно имеет рукава и застегивается спереди или немного сбоку. Куртка, как правило, легче, плотнее прилегает и менее изолирует, чем пальто, которое является верхней одеждой.'),
	('Джемпер', 'Джемпер — трикотажная плечевая одежда без застёжек или с застёжкой вверху, покрывающая туловище и частично бёдра, надеваемая через голову.'),
	('Шорты', 'Шорты  — разновидность укороченной одежды для ног - брюк, джинсов, штанов. Шорты могут служить в качестве элемента спортивной одежды, пляжной одежды, одежды для отдыха, деталью униформы, а также частью национального костюма.'),
	('Джинсы', 'Джинсы - это разновидность брюк или брюк, обычно сшитых из джинсовой ткани или комбинезона. Часто термин "джинсы" относится к определенному стилю брюк, называемых "синими джинсами", которые были изобретены Джейкобом У. Дэвисом в партнерстве с Levi Strauss & Co.'),
	('Брюки', 'Брю́ки — предмет верхней одежды, покрывающий нижнюю часть туловища и обе ноги по отдельности с помощью штанин.В классическом варианте брюки внизу достигают щиколоток или верхней части стопы. Традиционно носятся на талии, хотя многие современные модели имеют заниженную посадку и носятся на бёдрах.');

INSERT Products
	(Type, Brand, Manufacturer, Measure_unit, Price, Quantity)
VALUES
	(1, 'Levis', 3, 'штук', 3330, 22),
	(5, 'Terranova', 5, 'штук', 2000, 13),
	(3, 'Dave Raball', 1, 'штук', 3440, 30),
	(7, 'Abercrombie & Fitch', 2, 'штук', 2700, 17),
	(2, 'Janoff.', 5, 'штук', 3000, 15),
	(6, 'Adidas', 6, 'штук', 4200, 18),
	(1, 'Nike', 4, 'штук', 2300, 12);

INSERT Shipment_Supplier
	(Date, Company, Employee)
VALUES
	('2022-01-30', 5, 1),
	('2022-09-16', 5, 5),
	('2022-08-19', 6, 1),
	('2022-09-10', 1, 4),
	('2022-10-02', 1, 4),
	('2022-07-29', 5, 6),
	('2022-08-03', 1, 1),
	('2022-07-11', 3, 7);

INSERT Products_in_Shipment
	(ID_waybill, Price, Product, Quantity)
VALUES
	(6,	14000,	4,	19),
	(4,	15000,	2,	14),
	(1,	21500,	2,	18),
	(3,	6500,	6,	17),
	(3,	12000,	1,	15),
	(1,	11200,	5,	12),
	(7,	10700,	3,	25),
	(3,	17900,	1,	17);

INSERT _Order
	(keyOrderAlt, keyDate, keyGeography, ID_Client, Date, Waybill_number, Track_number, Payment, Employee)
VALUES
	('81282582957937254239', 20220101, 1, 2,	'2022-08-21', 27468754, 91634527, 1, 4),
	('98125962399224179417', 20150101, 2, 6,	'2022-07-26', 32239687, 33468523, 6, 3),
	('27826741866466971787', 20120101, 4, 4,	'2022-07-28', 38370207, 36274801, 3, 4),
	('94332714357476796123', 20201001, 5, 5,	'2022-07-06', 23091706,	34060127, 4, 8),
	('85969449831474849496', 20060413, 1, 3,	'2022-09-21', 22721595,	49907641, 7, 3),
	('65438189979939211832', 20260712, 2, 1,    '2022-09-22', 36185693, 38966144, 3, 6),
	('65319699652936964631', 20110303, 2, 7,	'2022-08-19', 34566408,	40571709, 1, 2),
	('39979218295749298395', 20121121, 3, 3,	'2022-07-19', 35842291,	47105890, 3, 1),
	('19299317466712789283', 20170530, 4, 4,	'2022-08-01', 21904842,	41591916, 2, 5);

INSERT Shipment_Client
	(Date, Company, Employee, ID_order, _Option)
VALUES
	('2022-09-06', 4, 8, 6, 'Пункт самовывоза'),
	('2022-08-17', 3, 4, 2, 'Курьер'),
	('2022-09-17', 2, 8, 5, 'Курьер'),
	('2022-09-16', 2, 5, 3, 'Пункт самовывоза'),
	('2022-09-12', 1, 6, 8, 'Курьер'),
	('2022-09-15', 5, 4, 8, 'Пункт самовывоза');

INSERT Products_in_Shipment_Client
	(Price, Product, Quantity, ID_order, personalDiscount, seasonalDiscount, TAX)
VALUES
	(19300,	3,	5,	5, 12, 25, 13),
	(7200,	1,	3,	2, 7, 25, 13),
	(15900,	5,	4,	7, 35, 5, 13),
	(9400,	2,	1,	7, 5, 20, 13),
	(10100,	4,	4,	1, 22, 20, 13),
	(4700,	1,	3,	2, 23, 15, 13),
	(13200,	3,	2,	4, 15, 15, 13);


select _Order.ID, _Order.keyOrderAlt, _Order.keyDAte, _Order.Payment, _Order.ID_client, _Order.keyGeography, _Order.Employee,
	   Client.Address,
	   Staff.keyStaffDem,
	   Products_in_Shipment_Client.Product, Products_in_Shipment_Client.Price, Products_in_Shipment_Client.Quantity, Products_in_Shipment_Client.personalDiscount,
	   Products_in_Shipment_Client.seasonalDiscount, Products_in_Shipment_Client.TAX
from _Order
	 inner join Client on Client.ID = _Order.ID_Client 
	 inner join Staff on Staff.ID = _Order.Employee
	 inner join Products_in_Shipment_Client on Products_in_Shipment_Client.ID_order = _Order.ID



SELECT * FROM Products_in_Shipment_Client

SELECT * FROM  _Order

DELETE Products_in_Shipment
WHERE price < 10000

SELECT * FROM Products_in_Shipment