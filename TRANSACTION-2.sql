

--For this request , we can use READ UNCOMMITTED is better

-- look like this :


SET TRANSACTION ISOLATION LEVEL  READ UNCOMMITTED;

USE TSQLV4;

--Connection one (USER A) :

SET TRANSACTION ISOLATION LEVEL  READ UNCOMMITTED;

BEGIN TRAN

	SELECT orderid,custid,empid,orderdate,requireddate,shipname,shipcountry
	FROM Sales.Orders --OR WITH(READUNCOMMITTED)
		WHERE custid > 20;


	UPDATE Sales.Orders
	SET shipregion = 'UNKNOWN'
	WHERE custid IN (84,76);

--Connection two (USER B) :

SET TRANSACTION ISOLATION LEVEL  READ UNCOMMITTED;

BEGIN TRAN
	SELECT orderid,custid,empid,orderdate,requireddate,shipname,shipcountry,shipregion
	FROM Sales.Orders --OR WITH(NOLOCK)
		WHERE custid IN (84,76,14,68);

--Connection one (USER A) :

ROLLBACK TRAN;

--Connection two (USER B) :

COMMIT TRAN;

-- SET DEFUALT SETTING :

SET TRANSACTION ISOLATION LEVEL  READ COMMITTED;
