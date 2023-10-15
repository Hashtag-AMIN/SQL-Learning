﻿-- 1
-- 1-1
/*
کدی بنویسید که برای هر مشتری 5 کپی از آن را ایجاد کند
*/
-- جداول مورد نیاز: TSQLV4 database, Employees and Nums tables

--Desired output
empid       firstname  lastname             n
----------- ---------- -------------------- -----------
1           Sara       Davis                1
2           Don        Funk                 1
3           Judy       Lew                  1
4           Yael       Peled                1
5           Sven       Mortensen            1
6           Paul       Suurs                1
7           Russell    King                 1
8           Maria      Cameron              1
9           Patricia   Doyle                1
1           Sara       Davis                2
2           Don        Funk                 2
3           Judy       Lew                  2
4           Yael       Peled                2
5           Sven       Mortensen            2
6           Paul       Suurs                2
7           Russell    King                 2
8           Maria      Cameron              2
9           Patricia   Doyle                2
1           Sara       Davis                3
2           Don        Funk                 3
3           Judy       Lew                  3
4           Yael       Peled                3
5           Sven       Mortensen            3
6           Paul       Suurs                3
7           Russell    King                 3
8           Maria      Cameron              3
9           Patricia   Doyle                3
1           Sara       Davis                4
2           Don        Funk                 4
3           Judy       Lew                  4
4           Yael       Peled                4
5           Sven       Mortensen            4
6           Paul       Suurs                4
7           Russell    King                 4
8           Maria      Cameron              4
9           Patricia   Doyle                4
1           Sara       Davis                5
2           Don        Funk                 5
3           Judy       Lew                  5
4           Yael       Peled                5
5           Sven       Mortensen            5
6           Paul       Suurs                5
7           Russell    King                 5
8           Maria      Cameron              5
9           Patricia   Doyle                5

(45 row(s) affected)

------------

SELECT TOP(45) E.empid,E.firstname,E.lastname,N.n
FROM HR.Employees AS E
	CROSS JOIN Nums AS N
ORDER BY n
-------------------
OR
-------------------
SELECT E.empid,E.firstname,E.lastname,N.n
FROM HR.Employees AS E
	CROSS JOIN Nums AS N
	WHERE n <= 5
ORDER BY n


-- 1-2 (Optional, Advanced)
/*
کدی بنویسید به ازای هر مشتری و هر روز یک ردیف برگرداند و روز آن بین 
June 12, 2016 – June 16 2016.
باشد. 
*/
-- جداول مورد نیاز: TSQLV4 database, Employees and Nums tables

--Desired output
empid       dt
----------- -----------
1           2016-06-12 
1           2016-06-13 
1           2016-06-14 
1           2016-06-15 
1           2016-06-16 
2           2016-06-12 
2           2016-06-13 
2           2016-06-14 
2           2016-06-15 
2           2016-06-16 
3           2016-06-12 
3           2016-06-13 
3           2016-06-14 
3           2016-06-15 
3           2016-06-16 
4           2016-06-12 
4           2016-06-13 
4           2016-06-14 
4           2016-06-15 
4           2016-06-16 
5           2016-06-12 
5           2016-06-13 
5           2016-06-14 
5           2016-06-15 
5           2016-06-16 
6           2016-06-12 
6           2016-06-13 
6           2016-06-14 
6           2016-06-15 
6           2016-06-16 
7           2016-06-12 
7           2016-06-13 
7           2016-06-14 
7           2016-06-15 
7           2016-06-16 
8           2016-06-12 
8           2016-06-13 
8           2016-06-14 
8           2016-06-15 
8           2016-06-16 
9           2016-06-12 
9           2016-06-13 
9           2016-06-14 
9           2016-06-15 
9           2016-06-16 

(45 row(s) affected)

---------------------------

CREATE TABLE Jdate(
	datefield DATE)

INSERT INTO jdate
	VALUES
	('2016-06-12'),
	('2016-06-13'),
	('2016-06-14'),
	('2016-06-15'),
	('2016-06-16');

SELECT N.n , D.datefield AS dt
FROM Nums AS N
	CROSS JOIN Jdate AS D
	WHERE N.n < 10
ORDER BY N.n




-- 2
/*
در کد زیر چه خطایی وجود دارد ، آنرا اصلاح کنید.
*/
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  INNER JOIN Sales.Orders AS O
    ON C.custid = O.custid;

-- 3
/*
مشتریان US برگردانده شود
و برای هر مشتری ماکزیمم تعداد سفارشات و جمع مقادیر نیز نمایش داده شود/
*/
-- جداول مورد نیاز: TSQLV4 database, Customers, Orders and OrderDetails tables

--Desired output
custid      numorders   totalqty
----------- ----------- -----------
32          11          345
36          5           122
43          2           20
45          4           181
48          8           134
55          10          603
65          18          1383
71          31          4958
75          9           327
77          4           46
78          3           59
82          3           89
89          14          1063

(13 row(s) affected)

SELECT  SC.custid ,
		COUNT(DISTINCT SOD.orderid) AS numorders,
		SUM(SOD.qty) AS totalqty
FROM Sales.Customers AS SC
INNER JOIN Sales.orders AS SO
	ON SC.custid = SO.custid
		INNER JOIN Sales.OrderDetails AS SOD
			ON SO.orderid = SOD.orderid
			WHERE country = 'USA'
		GROUP BY SC.custid

-- 4
/*
هر مشتری و تمام فروشهای آن نیز برگردانده شود. و همچنین شامل مشتری هایی باشد که هیچ فروشی ندارند.
*/
-- جداول مورد نیاز: TSQLV4 database, Customers and Orders tables

-- Desired output
custid      companyname     orderid     orderdate
----------- --------------- ----------- -----------
85          Customer ENQZT  10248       2014-07-04 
79          Customer FAPSM  10249       2014-07-05 
34          Customer IBVRG  10250       2014-07-08 
84          Customer NRCSK  10251       2014-07-08 
...
73          Customer JMIKW  11074       2016-05-06 
68          Customer CCKOT  11075       2016-05-06 
9           Customer RTXGC  11076       2016-05-06 
65          Customer NYUHS  11077       2016-05-06 
22          Customer DTDMN  NULL        NULL
57          Customer WVAXS  NULL        NULL

(832 row(s) affected)

SELECT SC.custid, SC.companyname, SO.orderid,SO.orderdate
FROM Sales.Customers AS SC
	LEFT OUTER JOIN Sales.Orders AS SO
		ON SC.custid = SO.custid


-- 5
/*
مشتریانی برگردانده شود که هیچ فروشی ندارند
*/
-- جداول مورد نیاز: TSQLV4 database, Customers and Orders tables

-- Desired output
custid      companyname
----------- ---------------
22          Customer DTDMN
57          Customer WVAXS

(2 row(s) affected)

SELECT SC.custid, SC.companyname, SO.orderid,SO.orderdate
FROM Sales.Customers AS SC
	LEFT OUTER JOIN Sales.Orders AS SO
		ON SC.custid = SO.custid
		WHERE SO.orderid IS NULL
-- 6
/*
 مشتریان با فروشهای آنها که در تاریخ Feb 12, 2016
 رخ داده است
*/
-- جداول مورد نیاز: TSQLV4 database, Customers and Orders tables

-- Desired output
custid      companyname     orderid     orderdate
----------- --------------- ----------- ----------
48          Customer DVFMB  10883       2016-02-12
45          Customer QXPPT  10884       2016-02-12
76          Customer SFOGW  10885       2016-02-12

(3 row(s) affected

SELECT SC.custid, SC.companyname, SO.orderid,SO.orderdate
FROM Sales.Customers AS SC
	LEFT OUTER JOIN Sales.Orders AS SO
		ON SC.custid = SO.custid
		WHERE SO.orderdate = N'2016-02-12'


-- 7 (Optional, Advanced)
/*
 قرار داردFebruary 12, 2016 کدی بنویسید که تمام مشتریان را بیاورد و فقط آنهایی فروش و تاریخشان نمایش داده شود که در تاریخ 
*/


-- جداول مورد نیاز: TSQLV4 database, Customers and Orders tables

-- Desired output

custid      companyname     orderid     orderdate
----------- --------------- ----------- ----------
72          Customer AHPOP  NULL        NULL
58          Customer AHXHT  NULL        NULL
25          Customer AZJED  NULL        NULL
18          Customer BSVAR  NULL        NULL
91          Customer CCFIZ  NULL        NULL
68          Customer CCKOT  NULL        NULL
49          Customer CQRAA  NULL        NULL
24          Customer CYZTN  NULL        NULL
22          Customer DTDMN  NULL        NULL
48          Customer DVFMB  10883       2016-02-12
10          Customer EEALV  NULL        NULL
40          Customer EFFTC  NULL        NULL
85          Customer ENQZT  NULL        NULL
82          Customer EYHKM  NULL        NULL
79          Customer FAPSM  NULL        NULL
...
51          Customer PVDZC  NULL        NULL
52          Customer PZNLA  NULL        NULL
56          Customer QNIVZ  NULL        NULL
8           Customer QUHWH  NULL        NULL
67          Customer QVEPD  NULL        NULL
45          Customer QXPPT  10884       2016-02-12
7           Customer QXVLA  NULL        NULL
60          Customer QZURI  NULL        NULL
19          Customer RFNQC  NULL        NULL
9           Customer RTXGC  NULL        NULL
76          Customer SFOGW  10885       2016-02-12
69          Customer SIUIH  NULL        NULL
86          Customer SNXOJ  NULL        NULL
88          Customer SRQVM  NULL        NULL
54          Customer TDKEG  NULL        NULL
20          Customer THHDP  NULL        NULL
...

(91 row(s) affected)

SELECT SC.custid, SC.companyname,SO.orderid,SO.orderdate,
	CASE
		WHEN SO.orderdate  IN ('20160212') THEN SO.orderid
		ELSE NULL
		END AS orderid1,
	CASE 
		WHEN SO.orderdate IN ('20160212') THEN '20160212'
		ELSE NULL
		END AS orderdate1
FROM Sales.Customers AS SC
	LEFT OUTER JOIN Sales.Orders AS SO
		ON SC.custid = SO.custid

-- 8 (Optional, Advanced)
/*
توضیح دهید چرا کد زیر برای تمرین شماره 7 مناسب نیست.
*/
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON O.custid = C.custid
WHERE O.orderdate = '20160212'
   OR O.orderid IS NULL;

   -- به دلیل اینکه این کد فقط مشتریانی را نمایش میدهد که در تاریخ مدنظر سفارش داده
   --یا کلا سفارشی نداشته اند و لیست مشتریان که مدنظر است را نمایش نمیدهد و دلیل آن نیز 
   --شرط موجود در WHERE  است.