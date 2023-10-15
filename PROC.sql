--SELECT * FROM Sales.Customers

CREATE PROC singleshowcustomers
AS

	DECLARE @mincust AS INT = (SELECT MIN(custid) FROM Sales.Customers)
	DECLARE @maxcust AS INT = (SELECT MAX(custid) FROM Sales.Customers)
	DECLARE @counteridmin AS INT;
	DECLARE @counteridmax AS INT;

	SET @counteridmin = @mincust
	SET @counteridmax = @maxcust

	WHILE @counteridmin <= @counteridmax
	BEGIN
		SELECT *
		FROM Sales.Customers
		WHERE custid = @counteridmin

		SET @counteridmin += 1
	END;


EXEC singleshowcustomers;