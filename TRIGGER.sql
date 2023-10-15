SELECT * FROM Sales.Orders
SELECT * FROM sales.ordercheck

CREATE TABLE sales.ordercheck (
	orderdate	DATE		NOT NULL,
	custid		INT			NOT NULL
	)
GO;


CREATE TRIGGER orderdatecheck ON Sales.Orders
FOR INSERT ,UPDATE 
AS
	BEGIN TRAN;
		IF (SELECT YEAR(orderdate) FROM inserted) < '2020'
		BEGIN
		PRINT 10/0;
		END;
			ELSE
		BEGIN
	
			INSERT INTO sales.ordercheck(orderdate,custid)
				SELECT orderdate,custid FROM inserted
			END;
		COMMIT TRAN;


BEGIN TRY
	INSERT [Sales].[Orders] 
	([orderid], [custid], [empid], [orderdate], [requireddate], [shippeddate], [shipperid], [freight], [shipname], [shipaddress], [shipcity], [shipregion], [shippostalcode], [shipcountry]) 
	VALUES 
	(1209, 12, 8, CAST(N'2022-04-28' AS Date), CAST(N'2016-05-26' AS Date), NULL, 1, 0.3300, N'Destination QTHBC', N'Cerrito 6789', N'Buenos Aires', NULL, N'10134', N'Argentina')
	PRINT 'INSERT'
END TRY

BEGIN CATCH
	PRINT 'please check your date order (Less than 2020)'
END CATCH