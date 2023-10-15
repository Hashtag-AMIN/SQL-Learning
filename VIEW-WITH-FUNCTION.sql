


-- 1
/*
کد زیر سعی میکند فروشهایی که در اخرین روز ماه قرار دارد را فیلتر کند. ولی خطای زیر را دریافت میکند. دلیل خطا و راه حل معتبر جهت حل آن بفرمایید
*/
USE TSQLV4;
GO

SELECT orderid, orderdate, custid, empid,
  DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear
FROM Sales.Orders
WHERE orderdate <> endofyear;

----------------------------------------

SELECT orderid, orderdate, custid, empid,
  DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear
	FROM Sales.Orders
	WHERE orderdate = DATEFROMPARTS(YEAR(orderdate), 12, 31);

/*
Msg 207, Level 16, State 1, Line 233
Invalid column name 'endofyear'.

به این دلیل که دستور SELECT 
درآخر اجرا میشود و هنگامی که ما از این فیلد استفاده میکنیم هنوز تشکیل نشده است
*/

-- 2-1
 /*
به ازای هر فروشنده آخرین تاریخ سفارش را بدست بیاورید
*/

-- Tables involved: TSQLV4 database, Sales.Orders table

--Desired output
empid       maxorderdate
----------- -------------
3           2016-04-30
6           2016-04-23
9           2016-04-29
7           2016-05-06
1           2016-05-06
4           2016-05-06
2           2016-05-05
5           2016-04-22
8           2016-05-06

(9 row(s) affected)


SELECT empid,MAX(orderdate) AS  maxorderdate
	FROM Sales.Orders
	GROUP BY empid
	ORDER BY maxorderdate DESC


-- 2-2
/*
کد مرحله قبل را به در یک Derived Table نوشته و بواسطه یک جوین با جدول Orders مقادیر مربوط به Orders را برای اخرین تاریخ د ر فروشنده بدست بیاورید
*/
-- Tables involved: Sales.Orders

-- Desired output:
empid       orderdate   orderid     custid
----------- ----------- ----------- -----------
9           2016-04-29  11058       6
8           2016-05-06  11075       68
7           2016-05-06  11074       73
6           2016-04-23  11045       10
5           2016-04-22  11043       74
4           2016-05-06  11076       9
3           2016-04-30  11063       37
2           2016-05-05  11073       58
2           2016-05-05  11070       44
1           2016-05-06  11077       65

(10 row(s) affected)


WITH maxorderdate
AS (
	SELECT empid,MAX(orderdate) AS  maxorderdate
	FROM Sales.Orders
	GROUP BY empid)

SELECT so.empid,so.orderdate,so.orderid,so.custid
	FROM Sales.Orders AS so
		INNER JOIN maxorderdate AS mo
		ON so.orderdate = mo.maxorderdate AND so.empid = mo.empid


-- 3-1
/*
کدی بنویسید که به ازای هر مشتری براساس تاریخ فروش و شماره فروش یک شماره ردیف یا Row number به آن اختصاص دهد
*/
-- Tables involved: Sales.Orders

-- Desired output:
orderid     orderdate   custid      empid       rownum
----------- ----------- ----------- ----------- -------
10248       2014-07-04  85          5           1
10249       2014-07-05  79          6           2
10250       2014-07-08  34          4           3
10251       2014-07-08  84          3           4
10252       2014-07-09  76          4           5
10253       2014-07-10  34          3           6
10254       2014-07-11  14          5           7
10255       2014-07-12  68          9           8
10256       2014-07-15  88          3           9
10257       2014-07-16  35          4           10
...

(830 row(s) affected)


SELECT orderid,orderdate,custid,empid,
		ROW_NUMBER () OVER(ORDER BY orderdate,orderid) AS rownum
	FROM Sales.Orders
-- 3-2
/*
کدی بنویسید که نتیجه تمرین قبلی را ردیف های بین 11 تا 20 را برگرداند. کد تمرین قبلی را داخل یک CTE بنویسید.
*/
-- Tables involved: Sales.Orders

-- Desired output:
orderid     orderdate   custid      empid       rownum
----------- ----------- ----------- ----------- -------
10258       2014-07-17  20          1           11
10259       2014-07-18  13          4           12
10260       2014-07-19  56          4           13
10261       2014-07-19  61          4           14
10262       2014-07-22  65          8           15
10263       2014-07-23  20          9           16
10264       2014-07-24  24          6           17
10265       2014-07-25  7           2           18
10266       2014-07-26  87          3           19
10267       2014-07-29  25          4           20

(10 row(s) affected)

WITH ROW_NUM AS
(SELECT orderid,orderdate,custid,empid,
		ROW_NUMBER () OVER(ORDER BY orderdate,orderid) AS rownum
	FROM Sales.Orders
)

SELECT orderid,orderdate,custid,empid,rownum
	FROM ROW_NUM
	WHERE rownum >= 11 AND rownum <= 20

-- 4 (Optional, Advanced)
/*
یک کد بازگشتی بنویسید که زنجیره مدیران مربوط به کارمند شماره 9 را بدست بیاورد
*/

-- Tables involved: HR.Employees

-- Desired output:
empid       mgrid       firstname  lastname
----------- ----------- ---------- --------------------
9           5           Patricia   Doyle
5           2           Sven       Mortensen
2           1           Don        Funk
1           NULL        Sara       Davis


(4 row(s) affected)

WITH Emptable AS 
(	SELECT empid,mgrid,firstname,lastname
	FROM  HR.Employees
	WHERE empid = 9
	
	UNION ALL

	SELECT HE.empid,HE.mgrid,HE.firstname,HE.lastname
	FROM  Emptable AS ET
	INNER JOIN HR.Employees AS HE
		ON ET.mgrid = HE.empid
)
SELECT * 
FROM Emptable

-- 5-1
/*
یک View ایجاد کرده که برای هر فروشنده در هر سال جمع مقدار QTY را بدست بیاورد
*/
-- Tables involved: Sales.Orders and Sales.OrderDetails

-- Desired output when running:
-- SELECT * FROM  Sales.VEmpOrders ORDER BY empid, orderyear
empid       orderyear   qty
----------- ----------- -----------
1           2014        1620
1           2015        3877
1           2016        2315
2           2014        1085
2           2015        2604
2           2016        2366
3           2014        940
3           2015        4436
3           2016        2476
4           2014        2212
4           2015        5273
4           2016        2313
5           2014        778
5           2015        1471
5           2016        787
6           2014        963
6           2015        1738
6           2016        826
7           2014        485
7           2015        2292
7           2016        1877
8           2014        923
8           2015        2843
8           2016        2147
9           2014        575
9           2015        955
9           2016        1140

(27 row(s) affected)
 
ALTER VIEW Sales.VEmpOrders 
WITH ENCRYPTION ,SCHEMABINDING
AS 
SELECT SO.empid,YEAR(SO.orderdate) AS orderyear,SUM(qty) AS qty
	FROM Sales.Orders AS SO
	CROSS APPLY Sales.OrderDetails AS SOD
	WHERE SO.orderid = SOD.orderid
	GROUP BY SO.empid,SO.orderdate;
GO

SELECT empid,orderyear,SUM(qty)
	FROM Sales.VEmpOrders
	GROUP BY empid,orderyear
	ORDER BY empid, orderyear



-- 5-2 (Optional, Advanced)
/*
کدی بر روی Sales.VEmpOrders بنویسید که به ازای هر فروشنده و هر سال مقدار QTY به صورت محاسبه در ردیف ، حساب شود .
*/
-- Tables involved: TSQLV4 database, Sales.VEmpOrders view

-- Desired output:
empid       orderyear   qty         runqty
----------- ----------- ----------- -----------
1           2014        1620        1620
1           2015        3877        5497
1           2016        2315        7812
2           2014        1085        1085
2           2015        2604        3689
2           2016        2366        6055
3           2014        940         940
3           2015        4436        5376
3           2016        2476        7852
4           2014        2212        2212
4           2015        5273        7485
4           2016        2313        9798
5           2014        778         778
5           2015        1471        2249
5           2016        787         3036
6           2014        963         963
6           2015        1738        2701
6           2016        826         3527
7           2014        485         485
7           2015        2292        2777
7           2016        1877        4654
8           2014        923         923
8           2015        2843        3766
8           2016        2147        5913
9           2014        575         575
9           2015        955         1530
9           2016        1140        2670

(27 row(s) affected)

WITH SalesVEmpOrders
AS (
SELECT empid,orderyear,SUM(qty) AS qty
	FROM Sales.VEmpOrders
	GROUP BY empid,orderyear
	)
	

SELECT empid,orderyear,
	SUM (qty) OVER(PARTITION BY empid
					ORDER BY empid, orderyear
					ROWS BETWEEN UNBOUNDED PRECEDING
							AND CURRENT ROW) AS runqty
FROM SalesVEmpOrders


-- 6-1
/*
یک تابع Inline نوشته که یک مقدار ورودی supplier id (@supid AS INT), قبول کند و تعداد رکوردهای درخواستی هر محصول (@n AS INT) ، این تابع باید @n محصول با بیشترین قیمت که توسط Supplier ID خاص مشخص شده به ما بدهد.
*/
-- Tables involved: Production.Products

-- Desired output when issuing the following query:
-- SELECT * FROM Production.TopProducts(5, 2)

productid   productname                              unitprice
----------- ---------------------------------------- ---------------------
12          Product OSFNS                            38.00
11          Product QMVUN                            21.00

(2 row(s) affected)

CREATE FUNCTION Production.TopProducts(@supid AS INT,@n AS INT)
RETURNS TABLE
WITH ENCRYPTION
AS
RETURN
	SELECT TOP(@n)productid,productname,unitprice
	FROM Production.Products
	WHERE supplierid = @supid
	ORDER BY unitprice DESC

SELECT * FROM Production.TopProducts(5, 2)


-- 6-2
/*
به واسطه Cross Apply و تابعی که که در تمرین قثبل ایجاد شده برای هر تامین کننده دوتا گرانترین محصول را نمایش دهد
*/
-- return, for each supplier, the two most expensive products

-- Desired output 
supplierid  companyname     productid   productname     unitprice
----------- --------------- ----------- --------------- ----------
8           Supplier BWGYE  20          Product QHFFP   81.00
8           Supplier BWGYE  68          Product TBTBL   12.50
20          Supplier CIYNM  43          Product ZZZHR   46.00
20          Supplier CIYNM  44          Product VJIEO   19.45
23          Supplier ELCRN  49          Product FPYPN   20.00
23          Supplier ELCRN  76          Product JYGFE   18.00
5           Supplier EQPNC  12          Product OSFNS   38.00
5           Supplier EQPNC  11          Product QMVUN   21.00
...

(55 row(s) affected)

SELECT sc.supplierid,sc.companyname,pt.productid,pt.productname,pt.unitprice
FROM Production.Suppliers AS SC
	CROSS APPLY Production.TopProducts(SC.supplierid,2) AS PT


-- When you’re done, run the following code for cleanup:
DROP VIEW IF EXISTS Sales.VEmpOrders;
DROP FUNCTION IF EXISTS Production.TopProducts;

