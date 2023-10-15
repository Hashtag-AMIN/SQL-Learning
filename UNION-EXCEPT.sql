

-- 1
/*
تفاوت بین Union , Union All
را توضیح دهید و اینکه در چه شرایطی نتیجه آنها با هم برابر است و کدام باید به کار رود؟

دستور یونیون  و یونیون ال هردو به معنی اجتماع هستند و این کار را برای ما انجام میدهدند
و تفاوت آنها در این است که دستور یونیون یک distintc نیز اجرا میکند
یعنی پس از اجتماع تکراری ها را حذف میکند ولی دستور  UNION ALL  
تکراری هارا حذف نکرده و همه مقادیر را باهم اجتماع کرده و نمایش میدهد
درصورتی که در 2 جدولی که اجتماع میگیریم هیچ وجه اشتراکی وجود نداشته باشد
استفاده از 2 دستور یک خروجی میدهد


*/

-- 2
/*
کدی بنویسید که عددهای بین 1 تا 10 را ایجاد کند.
*/

--Desired output
n
-----------
1
2
3
4
5
6
7
8
9
10

(10 row(s) affected)

SELECT custid AS n
	FROM sales.customers
	WHERE custid < 6
UNION
SELECT custid AS n
	FROM sales.customers
	WHERE custid >= 6 AND custid < 11

-- 3
/*
کدی بنویسید که مشتری و فروشنده هایی را به صورت موازی نمایش دهد که در تاریخ 
January 2016 فروش داشتند
ولی در تاریخ February 2016
فعالیتی نداشتند
*/
-- Tables involved: TSQLV4 database, Orders table

--Desired output
custid      empid
----------- -----------
1           1
3           3
5           8
5           9
6           9
7           6
9           1
12          2
16          7
17          1
20          7
24          8
25          1
26          3
32          4
38          9
39          3
40          2
41          2
42          2
44          8
47          3
47          4
47          8
49          7
55          2
55          3
56          6
59          8
63          8
64          9
65          3
65          8
66          5
67          5
70          3
71          2
75          1
76          2
76          5
80          1
81          1
81          3
81          4
82          6
84          1
84          3
84          4
88          7
89          4

(50 row(s) affected)

SELECT custid,empid
FROM sales.orders
WHERE orderdate >= '20160101' AND orderdate <= '20160201'
EXCEPT
SELECT custid,empid
FROM sales.orders
WHERE orderdate >= '20160201' AND orderdate <= '20160301'


-- 4
/*
کدی بنویسید که مشتری و فروشنده را باهم نمایش دهد که در هر دوتاریخ 
january 2016 and February 2016
فروش داشتند
*/

--Desired output
custid      empid
----------- -----------
20          3
39          9
46          5
67          1
71          4

(5 row(s) affected)

SELECT custid,empid
FROM sales.orders
WHERE orderdate >= '20160101' AND orderdate <= '20160201'
INTERSECT
SELECT custid,empid
FROM sales.orders
WHERE orderdate >= '20160201' AND orderdate <= '20160301'


-- 5
/*
		January 2016 and February 2016 مشتریان و فروشندگانی که به صورت موازی در تاریخهای 
		فروش داشتند ولی در سال 2015 فعالیتی نداشتند
*/
-- Tables involved: TSQLV4 database, Orders table

--Desired output
custid      empid
----------- -----------
67          1
46          5

(2 row(s) affected)

-- 6 (Optional, Advanced)
SELECT country, region, city
FROM HR.Employees

UNION ALL

SELECT country, region, city
FROM Production.Suppliers;
/*
در کد بالا که نوشته شده باید گارانتی کنید که ابتدا ردیفهای جدول کارمندان برمیگردد
بعد ردیفهای جدول تامین کننده ها
 country, region, city و در هر بخشی داده ها براساس 
مرتب باشند
*/
-- Tables involved: TSQLV4 database, Employees and Suppliers tables

--Desired output
country         region          city
--------------- --------------- ---------------
UK              NULL            London
UK              NULL            London
UK              NULL            London
UK              NULL            London
USA             WA              Kirkland
USA             WA              Redmond
USA             WA              Seattle
USA             WA              Seattle
USA             WA              Tacoma
Australia       NSW             Sydney
Australia       Victoria        Melbourne
Brazil          NULL            Sao Paulo
Canada          Québec          Montréal
Canada          Québec          Ste-Hyacinthe
Denmark         NULL            Lyngby
Finland         NULL            Lappeenranta
France          NULL            Annecy
France          NULL            Montceau
France          NULL            Paris
Germany         NULL            Berlin
Germany         NULL            Cuxhaven
Germany         NULL            Frankfurt
Italy           NULL            Ravenna
Italy           NULL            Salerno
Japan           NULL            Osaka
Japan           NULL            Tokyo
Netherlands     NULL            Zaandam
Norway          NULL            Sandvika
Singapore       NULL            Singapore
Spain           Asturias        Oviedo
Sweden          NULL            Gِteborg
Sweden          NULL            Stockholm
UK              NULL            London
UK              NULL            Manchester
USA             LA              New Orleans
USA             MA              Boston
USA             MI              Ann Arbor
USA             OR              Bend

(38 row(s) affected)

--باتوجه به اینکه وقتی از دستور order
--قبل از دستور یونیون آل استفاده میکنیم خطای نوشتاری به ما داده و با
--اطلاعات و علم فعلی قادر به انجام اینکار نیستم

SELECT country, region, city
FROM HR.Employees
UNION ALL
SELECT country, region, city
FROM Production.Suppliers
ORDER BY country DESC, region, city 


SELECT country, region, city
FROM HR.Employees AS H
UNION ALL
SELECT country, region, city
FROM Production.Suppliers AS P
--ORDER BY H.country DESC ,region DESC,city DESC
--ORDER BY H.country ,H.region,H.city
