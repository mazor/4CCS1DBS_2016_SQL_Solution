-- Part 2.3 select.sql
--
-- Submitted by: Coursework Solution
-- 

-- do not edit these lines -------------
USE bagelshoppe;
-- ------------------------------------

-- add your SELECT statements here for each section

-- 1. Total Sales.

SELECT SUM(final_cost) AS total_sales, 
       SUM((final_cost/(1-discount)) - final_cost) as total_discount 
FROM CustomerOrder 
WHERE date_placed >= "2016-01-01" AND date_placed < "2016-02-01";

-- +-------------+----------------+
-- | total_sales | total_discount |
-- +-------------+----------------+
-- |      148.69 |       8.045556 |
-- +-------------+----------------+

-- 2. Bagel Report 

SELECT description, IF(quantity IS NULL, 0, quantity) as quantity
FROM Bagel LEFT JOIN (
    SELECT bagel_id, SUM(quantity) AS quantity  
    FROM CustomerOrder NATURAL JOIN Order_Contains_Bagel 
    WHERE date_placed >= "2016-02-01" AND date_placed < "2016-03-01" 
    GROUP BY bagel_id
) AS bagels_sold ON (id = bagel_id);

-- +------------------+----------+
-- | description      | quantity |
-- +------------------+----------+
-- | Plain            |        0 |
-- | Everything       |        1 |
-- | Maple-nut        |       20 |
-- | Jalepino Cheddar |        0 |
-- | Kale-Chicken     |        1 |
-- +------------------+----------+

-- 3. Number 1 and 2


-- interpret total purchases a frequency of orders
SELECT title, name, emailaddress, COUNT(*) AS purchases
FROM Customer JOIN CustomerOrder 
ON (Customer.id = CustomerOrder.customer_id)
GROUP BY Customer.id
ORDER BY purchases DESC;

-- +-------+----------------+-----------------------+-----------+
-- | title | name           | emailaddress          | purchases |
-- +-------+----------------+-----------------------+-----------+
-- | Mr    | George Clooney | clooney@hollywood.com |         4 |
-- | Ms    | Rihanna        | rhianna@facebook.com  |         4 |
-- | Sir   | Drake          | bling@hotline.com     |         4 |
-- +-------+----------------+-----------------------+-----------+

-- or, if interpret sorting by sum of purchases
SELECT title, name, emailaddress, SUM(final_cost) AS purchases
FROM Customer JOIN CustomerOrder 
ON (Customer.id = CustomerOrder.customer_id)
GROUP BY Customer.id
ORDER BY  purchases DESC;

-- +-------+----------------+-----------------------+-----------+
-- | title | name           | emailaddress          | purchases |
-- +-------+----------------+-----------------------+-----------+
-- | Sir   | Drake          | bling@hotline.com     |    106.47 |
-- | Mr    | George Clooney | clooney@hollywood.com |     96.48 |
-- | Ms    | Rihanna        | rhianna@facebook.com  |     40.54 |
-- +-------+----------------+-----------------------+-----------+

-- 4. Receipt (for discounted order)

-- Choose an order with a discount

SELECT * FROM CustomerOrder WHERE discount > 0;
-- +----------+-------------+------------------+-------------+----------+------------+
-- | order_no | date_placed | bagelcard_id     | customer_id | discount | final_cost |
-- +----------+-------------+------------------+-------------+----------+------------+
-- |        6 | 2016-01-06  | 3333333333333333 |           3 |     0.10 |      72.41 |
-- |       10 | 2016-02-01  | 1111111111111111 |           1 |     0.05 |      74.48 |
-- +----------+-------------+------------------+-------------+----------+------------+

-- using order_no: 6
( 
    SELECT description, price, quantity, (price * quantity) AS total_price 
    FROM Bagel JOIN Order_Contains_Bagel ON (Bagel.id = Order_Contains_Bagel.bagel_id)
    WHERE order_no = 6
) UNION (
    SELECT description, price, quantity, (price * quantity) AS total_price 
    FROM BagelFilling JOIN Bagel_Has_Filling ON (BagelFilling.id = Bagel_Has_Filling.filling_id)
    WHERE order_no = 6
) UNION (
    SELECT description, price, quantity, (price * quantity) AS total_price 
    FROM Drink JOIN Order_Contains_Drink ON (Drink.id = Order_Contains_Drink.drink_id)
    WHERE order_no = 6
);

-- 5. Nut Alert!

-- Note: MySQL does not support ASSERTIONS
-- CREATE ASSERTION CHECK ( ...
SELECT NOT EXISTS (
    SELECT * 
    FROM ((Customer JOIN CustomerOrder
          ON (Customer.id = CustomerOrder.customer_id AND
              Customer.name = "Rihanna" AND
              Customer.dob = "1988-02-20"))
          JOIN Order_Contains_Bagel
          ON (CustomerOrder.order_no = Order_Contains_Bagel.order_no))
          JOIN Bagel
          ON (Bagel.id = Order_Contains_Bagel.bagel_id)
    WHERE (has_nuts = True)
) AS NUT_FREE;

-- Should be True (1)
-- +----------+
-- | NUT_FREE |
-- +----------+
-- |        1 |
-- +----------+

-- Place a Nutty Order - Rhianna buys a Maple-Nut bagel

INSERT INTO CustomerOrder VALUES (13, "2016-03-04", 2222222222222222, 2, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (13, 3, 1);

-- Test (same query as before)
SELECT NOT EXISTS (
    SELECT * 
    FROM ((Customer JOIN CustomerOrder 
          ON (Customer.id = CustomerOrder.customer_id AND 
              Customer.name = "Rihanna" AND 
              Customer.dob = "1988-02-20"))
          JOIN Order_Contains_Bagel
          ON (CustomerOrder.order_no = Order_Contains_Bagel.order_no))
          JOIN Bagel
          ON (Bagel.id = Order_Contains_Bagel.bagel_id)
    WHERE (has_nuts = True)
) AS NUT_FREE;

-- Should be False (0)
-- +----------+
-- | NUT_FREE |
-- +----------+
-- |        0 |
-- +----------+
