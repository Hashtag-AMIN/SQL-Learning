

-- SERIALIZABLE is a high level of ISOLATION and just one connection can use this

-- look like this :


--Connection one (USER A) :

USE TSQLV4;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN
	SELECT custid,companyname,address,city,country,phone
	FROM Sales.Customers
	WHERE custid > 2

--Connection two (USER B) :

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN

	SELECT custid,companyname,address,city,country
	FROM Sales.Customers
	WHERE custid > 4

--Connection one (USER A) :

COMMIT TRAN;

--Connection two (USER B) :

ROLLBACK TRAN;


-- SET DEFUALT SETTING :

SET TRANSACTION ISOLATION LEVEL  READ COMMITTED;
