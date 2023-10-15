
CREATE TABLE dbo.orders1
(
	orderid		INT			NOT NULL,
	orderdate	DATE		NOT NULL,
	empid		INT			NOT NULL,
	custid		VARCHAR(5)	NOT NULL,
	qty			INT			NOT NULL,
	CONSTRAINT PK_orders1 PRIMARY KEY(orderid)
	);

INSERT INTO dbo.orders1(orderid,orderdate,empid,custid,qty)
VALUES 
		(30001, '20140802', 3, 'A', 10),
		(10001, '20141224', 2, 'A', 12),
		(10005, '20141224', 1, 'B', 20),
		(40001, '20150109', 2, 'A', 40),
		(10006, '20150118', 1, 'C', 14),
		(20001, '20150212', 2, 'B', 12),
		(40005, '20160212', 3, 'A', 10),
		(20002, '20160216', 1, 'C', 20),
		(30003, '20160418', 2, 'B', 15),
		(30004, '20140418', 3, 'C', 22),
		(30007, '20160907', 3, 'D', 30);

-- 1
/*
یک کد بر روی جدول dbo.orders
بنویسید که به ازای هر فروش مشتری مقدار rank , Dense Rank
را محاسبه کند و براساس custid
دسته بندی کرده و براساس qty 
مرتب سازی کنید
*/

-- Desired output:
custid orderid     qty         rnk                  drnk
------ ----------- ----------- -------------------- --------------------
A      30001       10          1                    1
A      40005       10          1                    1
A      10001       12          3                    2
A      40001       40          4                    3
B      20001       12          1                    1
B      30003       15          2                    2
B      10005       20          3                    3
C      10006       14          1                    1
C      20002       20          2                    2
C      30004       22          3                    3
D      30007       30          1                    1

SELECT custid,orderid,qty,
RANK() OVER (PARTITION BY custid
			 ORDER BY qty) AS rnk,
DENSE_RANK() OVER (PARTITION BY custid
				   ORDER BY qty) AS drnk
FROM dbo.orders1

-- 2
/*
کد زیر بر روی ویو Sales.ORderValues
مقادیر واحد و شماره ردیف آن را بر میگرداند. ایا میتوانید یک راه حل جایگزین 
برای این جواب بدهید؟
*/
USE TSQLV4;

SELECT val, ROW_NUMBER() OVER(ORDER BY val) AS rownum
FROM Sales.OrderValues
GROUP BY val;


-- Desired output:
val       rownum
--------- -------
12.50     1
18.40     2
23.80     3
28.00     4
30.00     5
33.75     6
36.00     7
40.00     8
45.00     9
48.00     10
...
12615.05  793
15810.00  794
16387.50  795

(795 row(s) affected)

SELECT val, 
ROW_NUMBER() OVER(ORDER BY val) AS rownum,
RANK() OVER(ORDER BY val) AS rank,
DENSE_RANK() OVER(ORDER BY val) AS drank
	FROM Sales.OrderValues
	GROUP BY val;



-- 3
/*
یک کد بر روی جدول Dbo.orders 
 بنویسید که برای هر فروش مشتری:
 - اختلاف بین مقدار سفارش فعلی و مقدار سفارش قبلی همان مشتری را حساب کند
 - اختلاف بین مقدار سفارش فعلی و مقدار سفارش بعدی مشتری را حساب کند.
*/
-- Desired output:
custid orderid     qty         diffprev    diffnext
------ ----------- ----------- ----------- -----------
A      30001       10          NULL        -2
A      10001       12          2           -28
A      40001       40          28          30
A      40005       10          -30         NULL
B      10005       20          NULL        8
B      20001       12          -8          -3
B      30003       15          3           NULL
C      30004       22          NULL        8
C      10006       14          -8          -6
C      20002       20          6           NULL
D      30007       30          NULL        NULL

SELECT custid,orderid,qty,
	(qty - LAG (qty) OVER(PARTITION BY custid
				   ORDER BY orderdate)) AS diffprev,
	(qty - LEAD (qty) OVER(PARTITION BY custid
				   ORDER BY orderdate)) AS diffnext
FROM dbo.orders1

-- 4
/*
کدی بر روی جدول dbo.orders 
که برای هر کارمند یک ردیف برگرداند ، یک ستون برای هر سال سفارش و تعداد سفارش برای هر 
کارمند و در هر سال
*/
-- Tables involved: TSQLV4 database, dbo.Orders table

-- Desired output:
empid       cnt2014     cnt2015     cnt2016
----------- ----------- ----------- -----------
1           1           1           1
2           1           2           1
3           2           0           2

SELECT empid,[2014] AS cnt2014,[2015] AS cnt2015, [2016] AS cnt2016
FROM 
	(SELECT empid,CAST(YEAR(orderdate) AS INT) AS orderyear,qty
		FROM dbo.Orders1) AS D
	PIVOT(COUNT(qty) FOR orderyear IN([2014],[2015],[2016])) AS P;


SELECT *
FROM dbo.Orders1