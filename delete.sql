-- Part 2.5 delete.sql
--
-- Submitted by: Coursework Solution
-- 

-- do not edit these lines -------------
USE bagelshoppe;
-- -------------------------------------

-- add your DELETE statements here

-- Need to Clean up DB fro "bling@hotline.com":

--   Bagel_Has_Filling
DELETE FROM Bagel_Has_Filling
WHERE Bagel_Has_Filling.order_no IN (
	-- Orders for "bling@hotline.com"
	SELECT order_no 
	FROM CustomerOrder
	WHERE CustomerOrder.customer_id = (SELECT id 
	                   	               FROM Customer 
	                   	               WHERE emailaddress="bling@hotline.com")
);

--   Order_Contains_Bagel
DELETE FROM Order_Contains_Bagel
WHERE Order_Contains_Bagel.order_no IN (
	-- Orders for "bling@hotline.com"
	SELECT order_no 
	FROM CustomerOrder
	WHERE CustomerOrder.customer_id = (SELECT id 
	                   	               FROM Customer 
	                   	               WHERE emailaddress="bling@hotline.com")
);

--   Order_Contains_Drink
DELETE FROM Order_Contains_Drink
WHERE Order_Contains_Drink.order_no IN (
	-- Orders for "bling@hotline.com"
	SELECT order_no 
	FROM CustomerOrder
	WHERE CustomerOrder.customer_id = (SELECT id 
	                   	               FROM Customer 
	                   	               WHERE emailaddress="bling@hotline.com")
);

--   CustomerOrder
DELETE FROM CustomerOrder
WHERE CustomerOrder.customer_id = (SELECT id 
                   	               FROM Customer 
                   	               WHERE emailaddress="bling@hotline.com");

--   BagelCard
DELETE FROM BagelCard
WHERE BagelCard.customer_id = (SELECT id 
                   	           FROM Customer 
                   	           WHERE emailaddress="bling@hotline.com");

--   Customer 
-- (If FOREIGN KEYs have ON DELETE CASCADE correctly
--  then only requires the statement below)
DELETE FROM Customer WHERE emailaddress="bling@hotline.com";


--
-- ALTERNATIVE, 
--    Delete multiple rows
--

-- DELETE Customer.*, 
--        CustomerOrder.*,
--        BagelCard.*, 
--        Order_Contains_Bagel.*,
--        Order_Contains_Drink.*,
--        Bagel_Has_Filling.*
-- FROM Customer
-- INNER JOIN BagelCard
-- ON BagelCard.customer_id = Customer.id AND emailaddress="bling@hotline.com"
-- INNER JOIN CustomerOrder
-- ON CustomerOrder.bagelcard_id = BagelCard.id
-- INNER JOIN Order_Contains_Bagel
-- ON Order_Contains_Bagel.order_no = CustomerOrder.order_no
-- INNER JOIN Order_Contains_Drink
-- ON Order_Contains_Drink.order_no = CustomerOrder.order_no
-- INNER JOIN Bagel_Has_Filling
-- ON Bagel_Has_Filling.order_no = CustomerOrder.order_no


