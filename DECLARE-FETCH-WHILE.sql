

DECLARE @orders_of_cust_table AS TABLE
(
	custid			INT,
	orderdate		DATE,
	orderid			INT,
	empid			INT
	)

DECLARE
	@custid_input AS INT = 17, -- -- INSERT YOUR CUSTOMER ID HERE TO SEE ORDERS
	@custid_cur AS INT,
	@orderdate_cur AS DATE,
	@orderid_cur AS INT,
	@empid_cur AS INT;

DECLARE CUR CURSOR READ_ONLY FOR
	SELECT c.custid,o.orderdate,o.orderid,o.empid
	FROM sales.Customers AS C
		INNER JOIN sales.Orders AS O
			ON c.custid = o.custid
		WHERE c.custid = @custid_input
	ORDER BY c.custid;

OPEN CUR;

FETCH NEXT FROM CUR INTO @custid_cur,@orderdate_cur,@orderid_cur,@empid_cur;

WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @orders_of_cust_table VALUES(@custid_cur,@orderdate_cur,@orderid_cur,@empid_cur);

		FETCH NEXT FROM CUR INTO @custid_cur,@orderdate_cur,@orderid_cur,@empid_cur;
	END;

CLOSE CUR;

DEALLOCATE CUR;

SELECT *
FROM @orders_of_cust_table
