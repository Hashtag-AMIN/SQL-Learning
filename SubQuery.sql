
-- 1 
/*
کدی بنویسید که تمام فروش های مربوط به آخرین روز فعالیت در جدول فروش را نمایش دهد.
*/
-- Tables involved: TSQLV4 database, Orders table

--Desired output
orderid     orderdate   custid      empid
----------- ----------- ----------- -----------
11077       2016-05-06  65          1
11076       2016-05-06  9           4
11075       2016-05-06  68          8
11074       2016-05-06  73          7

--(4 row(s) affected)

SELECT orderid,orderdate,custid,empid
FROM Sales.orders AS SO
WHERE SO.orderdate IN 
		(SELECT MAX(O.orderdate)
		FROM Sales.orders AS O)

-- 2 (Optional, Advanced)
/*
	تمام فروش های مربوط به مشتری که بیشترین تعداد فروش را دارد.
	ممکن است بیش از یک مشتری با تعداد فروشهای یکسان باشند
*/
-- Tables involved: TSQLV4 database, Orders table

-- Desired output:
custid      orderid     orderdate  empid
----------- ----------- ---------- -----------
71          10324       2014-10-08 9
71          10393       2014-12-25 1
71          10398       2014-12-30 2
71          10440       2015-02-10 4
71          10452       2015-02-20 8
71          10510       2015-04-18 6
71          10555       2015-06-02 6
71          10603       2015-07-18 8
71          10607       2015-07-22 5
71          10612       2015-07-28 1
71          10627       2015-08-11 8
71          10657       2015-09-04 2
71          10678       2015-09-23 7
71          10700       2015-10-10 3
71          10711       2015-10-21 5
71          10713       2015-10-22 1
71          10714       2015-10-22 5
71          10722       2015-10-29 8
71          10748       2015-11-20 3
71          10757       2015-11-27 6
71          10815       2016-01-05 2
71          10847       2016-01-22 4
71          10882       2016-02-11 4
71          10894       2016-02-18 1
71          10941       2016-03-11 7
71          10983       2016-03-27 2
71          10984       2016-03-30 1
71          11002       2016-04-06 4
71          11030       2016-04-17 7
71          11031       2016-04-17 6
71          11064       2016-05-01 1

31 row(s) affected)


SELECT custid,orderid,orderdate,empid
FROM Sales.orders
WHERE custid IN
	(SELECT TOP(1) O.custid
	FROM Sales.orders AS O
	GROUP BY O.custid
	ORDER BY COUNT(O.orderid) DESC)


-- 3
/*
لیست فروشنده هایی  که فروش در روزMay 1st, 2016 
یا بعد از آن نداشتند
*/
-- Tables involved: TSQLV4 database, Employees and Orders tables

-- Desired output:
empid       FirstName  lastname
----------- ---------- --------------------
3           Judy       Lew
5           Sven       Mortensen
6           Paul       Suurs
9           Patricia   Doyle

(4 row(s) affected)

SELECT empid,FirstName,lastname
FROM HR.Employees 
WHERE empid NOT IN
		(SELECT empid
		FROM Sales.Orders
		WHERE orderdate >= '20160501')

-- 4
/*
لیست کشورهایی که مشتریان ما در آنجا هستند ولی کارمندان در آنجا نیستند
*/
-- Tables involved: TSQLV4 database, Customers and Employees tables

-- Desired output:
country
---------------
Argentina
Austria
Belgium
Brazil
Canada
Denmark
Finland
France
Germany
Ireland
Italy
Mexico
Norway
Poland
Portugal
Spain
Sweden
Switzerland
Venezuela


--(19 row(s) affected)

SELECT C.country
FROM sales.Customers AS C
WHERE C.country NOT IN
	(SELECT C.country
FROM sales.Customers AS C
INNER JOIN
	 HR.Employees AS E
		ON C.country = E.country)
GROUP BY C.country


-- 5
/*
برای هر مشتری تمام فروشهای مربوط به آن مشتری در آخرین روزی که خرید انجام داده است.
*/
-- Tables involved: TSQLV4 database, Orders table
*/
-- Desired output:
custid      orderid     orderdate   empid
----------- ----------- ----------- -----------
1           11011       2016-04-09  3
2           10926       2016-03-04  4
3           10856       2016-01-28  3
4           11016       2016-04-10  9
5           10924       2016-03-04  3
...
87          11025       2016-04-15  6
88          10935       2016-03-09  4
89          11066       2016-05-01  7
90          11005       2016-04-07  2
91          11044       2016-04-23  4

(90 row(s) affected)

SELECT custid,orderid,orderdate,empid
FROM sales.orders AS SO
WHERE orderdate IN
	(SELECT MAX(orderdate)
	FROM sales.orders AS O
	WHERE SO.custid = O.custid
	GROUP BY custid)
ORDER BY custid

-- 6
/*
لیست مشتریانی که در سال 2015 خرید داشتند نه در سال 2016
*/
-- Tables involved: TSQLV4 database, Customers and Orders tables

-- Desired output:
custid      companyname
----------- ----------------------------------------
21          Customer KIDPX
23          Customer WVFAF
33          Customer FVXPQ
36          Customer LVJSO
43          Customer UISOJ
51          Customer PVDZC
85          Customer ENQZT

(7 row(s) affected)


SELECT  SC.custid,SC.companyname
FROM Sales.customers AS SC
WHERE  SC.custid IN
	(SELECT SO.custid
	 FROM sales.orders AS SO
	 WHERE SO.orderdate >= '20150101' AND SO.orderdate <= '20151231' AND 
	 SO.custid = SC.custid AND NOT EXISTS
	 (SELECT SO.orderdate
	 FROM sales.orders AS SO
	 WHERE SO.orderdate >= '20160101' AND SO.orderdate <= '20161231' AND 
	 SO.custid = SC.custid))
GROUP BY companyname,custid

SELECT * FROM Sales.customers
SELECT * FROM Sales.orders

-- 7 (Optional, Advanced)
/*
لیست مشتریانی که کالای شماره 12 را خریداری کردند
*/
-- Tables involved: TSQLV4 database,
-- Customers, Orders and OrderDetails tables

-- Desired output:
custid      companyname
----------- ----------------------------------------
48          Customer DVFMB
39          Customer GLLAG
71          Customer LCOUJ
65          Customer NYUHS
44          Customer OXFRU
51          Customer PVDZC
86          Customer SNXOJ
20          Customer THHDP
90          Customer XBBVR
46          Customer XPNIK
31          Customer YJCBX
87          Customer ZHYOS

(12 row(s) affected)

SELECT sc.custid,sc.companyname
FROM sales.Customers AS SC
	WHERE sc.custid IN (
		SELECT so.custid
		FROM sales.Orders AS SO
			WHERE sc.custid = so.custid AND so.orderid IN (
				SELECT SOD.orderid
				FROM sales.OrderDetails AS SOD
					WHERE SOD.productid = 12 ))
ORDER BY companyname


\-- 8 (Optional, Advanced)
/*
مقدار فیلد qty به صورت مانده در ردیف به ازای هر مشتری و هر ماه با Subquery حساب شود/.
*/
-- Tables involved: TSQLV4 database, Sales.CustOrders view

-- Desired output:
custid      ordermonth              qty         runqty
----------- ----------------------- ----------- -----------
1           2015-08-01 00:00:00.000 38          38
1           2015-10-01 00:00:00.000 41          79
1           2016-01-01 00:00:00.000 17          96
1           2016-03-01 00:00:00.000 18          114
1           2016-04-01 00:00:00.000 60          174
2           2014-09-01 00:00:00.000 6           6
2           2015-08-01 00:00:00.000 18          24
2           2015-11-01 00:00:00.000 10          34
2           2016-03-01 00:00:00.000 29          63
3           2014-11-01 00:00:00.000 24          24
3           2015-04-01 00:00:00.000 30          54
3           2015-05-01 00:00:00.000 80          134
3           2015-06-01 00:00:00.000 83          217
3           2015-09-01 00:00:00.000 102         319
3           2016-01-01 00:00:00.000 40          359
...

(636 row(s) affected)



SELECT SC.custid,CAST(SC.ordermonth AS DATETIME) AS ordermonth ,SC.qty,
			(SELECT SUM(qty)
			--(SET qty +=qty) AS runqty
				FROM Sales.CustOrders AS SC1
				WHERE SC.custid = SC1.custid
				--GROUP BY SC1.custid
						) AS runqty
	FROM Sales.CustOrders AS SC
	ORDER BY custid 

OVERWRITE :

--@runqty AS runqty
--DECLARE @runqty AS INT = 0
--SET @runqty = @runqty + SC.qty

DECLARE @runqty AS INT = 0
SELECT custid,ordermonth,qty,CAST(@runqty = runqty + qty ) AS runqty
FROM Sales.CustOrders
order by custid 
(SELECT (SC1.qty + SC1.qty)
 FROM Sales.CustOrders AS SC1
 WHERE SC1.custid = SC.custid)




-- 9
/*
تفاوت بین IN و Exists را شرح دهید
*/
/* وقتی به null برمیخوره باهاش مثل یک مقدار False رفتار میکنه.ولی وقتی In به یک مقدار null برخورد میکنه باهاش مثل یک مقدار not Unknown برخورد میکنه و هیچ رفتاری نشون نمیده به همین خاطر هیچ رکوردی رو برنمیگردونه.
این دو دستور نیز در این مورد از لحاظ Plan شبیه هم میباشند و در Performance هیچ تفاوتی باهم ندارند.
*/

-- 10 (Optional, Advanced)
/*
به ازای هر سفارش ، تعداد روزهای فاصله بین خرید های قبلی هر مشتری حساب شود. میتوان براساس فیلد OrderDate و OrderID مرتب سازی کرد.
*/
-- use orderdate as the primary sort element and orderid as the tiebreaker.
-- Tables involved: TSQLV4 database, Sales.Orders table

-- Desired output:
custid      orderdate  orderid     diff
----------- ---------- ----------- -----------
1           2015-08-25 10643       NULL
1           2015-10-03 10692       39
1           2015-10-13 10702       10
1           2016-01-15 10835       94
1           2016-03-16 10952       61
1           2016-04-09 11011       24
2           2014-09-18 10308       NULL
2           2015-08-08 10625       324
2           2015-11-28 10759       112
2           2016-03-04 10926       97
...

(830 row(s) affected)


SELECT SO1.custid,SO1.orderdate,SO1.orderid,(SELECT DATEDIFF(DAY,MIN(SO.orderdate),SO1.orderdate)
											 FROM Sales.Orders AS SO
											 WHERE SO1.custid = SO.custid) AS diff
FROM Sales.Orders AS SO1
ORDER BY SO1.custid,SO1.OrderDate,SO1.Orderid