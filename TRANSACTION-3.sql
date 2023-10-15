
--For this request we can use snapshot mode becuase this option use tempdb

-- look like this :

ALTER DATABASE TSQLV4 SET ALLOW_SNAPSHOT_ISOLATION ON;

USE TSQLV4;

--Connection one (USER A) :

BEGIN TRAN

	UPDATE Sales.Orders
	SET shipregion = 'UNKNOWN'
	WHERE custid IN (84,76);


	SELECT orderid,custid,empid,orderdate,requireddate,shipname,shipcountry
	FROM Sales.Orders
		WHERE custid > 20;


--Connection two (USER B) :

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

BEGIN TRAN
	SELECT orderid,custid,empid,orderdate,requireddate,shipname,shipcountry,shipregion
	FROM Sales.Orders
		WHERE custid IN (84,76,14,68);


--Connection one (USER A) :

COMMIT TRAN;

--Connection two (USER B) :

ROLLBACK TRAN;

-- SET DEFUALT SETTING :

ALTER DATABASE TSQLV4 SET ALLOW_SNAPSHOT_ISOLATION OFF;

SET TRANSACTION ISOLATION LEVEL  READ COMMITTED;