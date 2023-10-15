
-- 1 
-- فروش هایی که در تاریخ June 2015 
-- قرار دارند نمایش دهد
-- جداول مورد نیاز: TSQLV4 database, Sales.Orders table

-- Desired output:
orderid     orderdate  custid      empid
----------- ---------- ----------- -----------
10555       2015-06-02 71          6
10556       2015-06-03 73          2
10557       2015-06-03 44          9
10558       2015-06-04 4           1
10559       2015-06-05 7           6
10560       2015-06-06 25          8
10561       2015-06-06 24          2
10562       2015-06-09 66          1
10563       2015-06-10 67          2
10564       2015-06-10 65          4
...

(30 row(s) affected)

SELECT	orderid,orderdate,custid,empid
FROM	Sales.Orders
WHERE '2015' = YEAR(orderdate) AND '06' = MONTH(orderdate)
-- 2 
/*
فروشهایی که در آخرین روز هر ماه قرار دارند نمایش دهد
*/

-- جداول مورد نظر: Sales.Orders table

-- Desired output:
orderid     orderdate  custid      empid
----------- ---------- ----------- -----------
10269       2014-07-31 89          5
10317       2014-09-30 48          6
10343       2014-10-31 44          4
10399       2014-12-31 83          8
10432       2015-01-31 75          3
10460       2015-02-28 24          8
10461       2015-02-28 46          1
10490       2015-03-31 35          7
10491       2015-03-31 28          8
10522       2015-04-30 44          4
...

(26 row(s) affected)

SELECT	orderid,orderdate,custid,empid
FROM	Sales.Orders
WHERE orderdate = EOMONTH(orderdate)

-- 3 
/*
مشتریانی را نمایش دهد که در فامیلیی آنها حرف e 
دوبار یا بیشتر تکرار شده 
*/
-- جداول مورد نیاز: HR.Employees table

-- Desired output:
empid       firstname  lastname
----------- ---------- --------------------
4           Yael       Peled
5           Sven       Mortensen

(2 row(s) affected)

SELECT empid,firstname,lastname
FROM HR.Employees
WHERE lastname LIKE N'%[e]%[e]%'

--OR 

SELECT empid,firstname,lastname
FROM HR.Employees
where LEN(lastname) - len(replace(lastname,'e','')) >=2

-- 4 
/*
فروشهایی با مقدار total (qty*Unitprice)
بزرگتر از 10000 را نمایش دهد.
و بر اساس total Value
مرتب سازی شود
*/
-- جداول مورد نیاز: Sales.OrderDetails table

-- Desired output:
orderid     totalvalue
----------- ---------------------
10865       17250.00
11030       16321.90
10981       15810.00
10372       12281.20
10424       11493.20
10817       11490.70
10889       11380.00
10417       11283.20
10897       10835.24
10353       10741.60
10515       10588.50
10479       10495.60
10540       10191.70
10691       10164.80

(14 row(s) affected)

SELECT orderid, SUM((Unitprice*qty)) AS [total value]
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM((Unitprice*qty)) > 10000
ORDER BY [total value] DESC

-- 5
/*
 بر روی جدول Hr.Employees
 کدی بنویسید که نام خانوادگی آنها با حروف کوچک شروع شده است . 
*/

-- Desired output:
empid       lastname
----------- --------------------

(0 row(s) affected)

SELECT empid,lastname
FROM Hr.Employees
WHERE lastname LIKE N'[^A-Z]%'

--OR
SELECT empid,lastname
FROM Hr.Employees
where  SUBSTRING(lastname,1,1)=LOWER(SUBSTRING(lastname,1,1)) COLLATE latin1_general_cs_as

-- 6
/*
تفاوت بین دو کد زیر را بیان کنید
*/


-- Query 1
SELECT empid, COUNT(*) AS numorders
FROM Sales.Orders
WHERE orderdate < '20160501'
GROUP BY empid;

-- Query 2
SELECT empid, COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY empid
HAVING MAX(orderdate) < '20160501';

--در کد بالا یا شماره 1 ابتدا فیلتر را اعمال کرده و بعد به گروه بندی بر اساس ای دی کارکنان
--گروه بندی شده است و نکته اصلی این است که سمت چپ شرط دسخوش تغییرات نشده است
--ولی درکد دوم ابتدا بر اساس ای دی کارکنان گروه بندی شده و سپس شرط اجرا میشود و در شرط نیز 
--سمت چپ شرط تغییر پیدا میکند که در دیتا و اطلاعات بالا بازده کمتری خواهد داشت

-- 7 
/*
سه کشور با میزان بزرگترین میزان حمل و نقل در سال 2015 
*/
-- جدول مورد نیاز: Sales.Orders table

-- Desired output:
shipcountry     avgfreight
--------------- ---------------------
Austria         178.3642
Switzerland     117.1775
Sweden          105.16

(3 row(s) affected)

SELECT 	TOP(3) shipcountry,
		AVG(freight) AS avgfreight
FROM Sales.Orders
WHERE  2015 = YEAR(orderdate)
GROUP BY shipcountry
ORDER BY avgfreight DESC


-- 8
/*
برای هر مشتری براساس عنوان آنها جنسیت آنها را ببیان کنید.
*/
-- Ms., Mrs. - Female, Mr. - Male, Dr. - Unknown
-- جدول مورد نیاز: HR.Employees table

-- Desired output:
empid       firstname  lastname             titleofcourtesy           gender
----------- ---------- -------------------- ------------------------- -------
1           Sara       Davis                Ms.                       Female
2           Don        Funk                 Dr.                       Unknown
3           Judy       Lew                  Ms.                       Female
4           Yael       Peled                Mrs.                      Female
5           Sven       Mortensen            Mr.                       Male
6           Paul       Suurs                Mr.                       Male
7           Russell    King                 Mr.                       Male
8           Maria      Cameron              Ms.                       Female
9           Patricia   Doyle                Ms.                       Female

(9 row(s) affected)

SELECT  empid,
		firstname,
		lastname,
		titleofcourtesy,
		CASE titleofcourtesy
		WHEN 'Ms.' THEN 'Female'
		WHEN 'Mrs.'THEN 'Female'
		WHEN 'Mr.' THEN 'Male'
		ELSE 'Unknown'
		END AS gender
FROM HR.Employees




-- 9
/*
برای هر مشتری شماره مشتری و Region
آن برگردد. بر اساس Region 
نیز مرتب سازی شود و مقادیر Null
در آخر لیست قرار بگیرند.
*/
-- جدول مورد نیاز: Sales.Customers table

-- Desired output:
custid      region
----------- ---------------
55          AK
10          BC
42          BC
45          CA
37          Co. Cork
33          DF
71          ID
38          Isle of Wight
46          Lara
78          MT
...
1           NULL
2           NULL
3           NULL
4           NULL
5           NULL
6           NULL
7           NULL
8           NULL
9           NULL
11          NULL
...
(91 row(s) affected)


SELECT custid,region
FROM Sales.Customers
ORDER BY 
	CASE	
		WHEN region IS NULL THEN 1
			ELSE 0 
			END, 
		region,custid


