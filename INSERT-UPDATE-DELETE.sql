
-- 1
/*
کد زیر را اجرا کنید
*/
USE TSQLV4;

DROP TABLE IF EXISTS dbo.Customers;

CREATE TABLE dbo.Customers
(
  custid      INT          NOT NULL PRIMARY KEY,
  companyname NVARCHAR(40) NOT NULL,
  country     NVARCHAR(15) NOT NULL,
  region      NVARCHAR(15) NULL,
  city        NVARCHAR(15) NOT NULL  
);

-- 1-1
/*
در جدول dbo.Customers
یک ردیف با مشخصات زیردرج کنید
-- custid:  100
-- companyname: Coho Winery
-- country:     USA
-- region:      WA
-- city:        Redmond

*/

INSERT INTO dbo.Customers(custid,companyname,country,region,city)
				  VALUES (100,'Coho Winery','USA','WA','Redmond')

-- 1-2
/*
تمام مشتریانی که دارای فروش هستند از جدول Sales.Customers
به جدول dbo.Customers 
اضافه کنید.
*/
 INSERT INTO dbo.Customers(custid,companyname,country,region,city)
  --VALUES (custid,companyname,country,region,city)
	SELECT sc.custid,sc.companyname,sc.country,sc.region,sc.city
	FROM Sales.Customers AS sc
	WHERE  EXISTS (
		SELECT * 
		FROM sales.orders AS so)

-- 1-3
/*
با استفاده از Select Into
یک جدول به نام Dbo.orders ساخته
و مقادیر آن را از جدول Sales.Orders در بازه زمانی 2014 تا 2016
بردارید
*/

SELECT *
INTO Dbo.orders
FROM Sales.Orders
WHERE orderdate >= '20140101' AND orderdate <= '20151231'


SELECT * FROM Dbo.orders
-- 2

/*
از جدول dbo.Orders 
سفارش هایی که در تاریخ قبل از آگوست 2014 قرار دارند پاک کرده و با استفاده از Output
مقدار Orderid,Orderdate
ردیف های حذف شده را نمایش دهید
*/

-- Desired output:
orderid     orderdate
----------- -----------
10248       2014-07-04 
10249       2014-07-05 
10250       2014-07-08 
10251       2014-07-08 
10252       2014-07-09 
10253       2014-07-10 
10254       2014-07-11 
10255       2014-07-12 
10256       2014-07-15 
10257       2014-07-16 
10258       2014-07-17 
10259       2014-07-18 
10260       2014-07-19 
10261       2014-07-19 
10262       2014-07-22 
10263       2014-07-23 
10264       2014-07-24 
10265       2014-07-25 
10266       2014-07-26 
10267       2014-07-29 
10268       2014-07-30 
10269       2014-07-31 

(22 row(s) affected)


--SELECT orderid,orderdate

DELETE FROM dbo.Orders
	OUTPUT
		deleted.orderid,
		deleted.orderdate
WHERE orderdate < '20140801'
-- 3
/*
از جدول dbo.orders
سفارشاتی را حذف کنید که توسط مشتریان از برزیل خریداری شده است
*/
--SELECT * 
DELETE FROM dbo.orders
WHERE EXISTS
	(SELECT *
	 FROM dbo.Customers AS dc
	 WHERE orders.custid = dc.custid AND dc.country = N'Brazil')


-- 4
/*

جدول dbo.Customers 
را بروز کنید و Region هایی که 
Null هستند را
به <None> تغییر دهید
و با استفاده از Output
مقادیر Custid , Old Region , New Region
را نمایش دهید
*/


-- Desired output:
custid      oldregion       newregion
----------- --------------- ---------------
1           NULL            <None>
2           NULL            <None>
3           NULL            <None>
4           NULL            <None>
5           NULL            <None>
6           NULL            <None>
7           NULL            <None>
8           NULL            <None>
9           NULL            <None>
11          NULL            <None>
12          NULL            <None>
13          NULL            <None>
14          NULL            <None>
16          NULL            <None>
17          NULL            <None>
18          NULL            <None>
19          NULL            <None>
20          NULL            <None>
23          NULL            <None>
24          NULL            <None>
25          NULL            <None>
26          NULL            <None>
27          NULL            <None>
28          NULL            <None>
29          NULL            <None>
30          NULL            <None>
39          NULL            <None>
40          NULL            <None>
41          NULL            <None>
44          NULL            <None>
49          NULL            <None>
50          NULL            <None>
52          NULL            <None>
53          NULL            <None>
54          NULL            <None>
56          NULL            <None>
58          NULL            <None>
59          NULL            <None>
60          NULL            <None>
63          NULL            <None>
64          NULL            <None>
66          NULL            <None>
68          NULL            <None>
69          NULL            <None>
70          NULL            <None>
72          NULL            <None>
73          NULL            <None>
74          NULL            <None>
76          NULL            <None>
79          NULL            <None>
80          NULL            <None>
83          NULL            <None>
84          NULL            <None>
85          NULL            <None>
86          NULL            <None>
87          NULL            <None>
90          NULL            <None>
91          NULL            <None>

(58 row(s) affected)



UPDATE dbo.Customers
	SET region = '<None>'
		OUTPUT
			inserted.custid,
			deleted.region AS oldregion,
			inserted.region AS newregion
WHERE region IS NULL


SELECT * FROM dbo.Customers