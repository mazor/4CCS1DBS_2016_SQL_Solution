-- Part 2.4 update.sql
--
-- Submitted by: Coursework Solution
-- 

-- do not edit these lines -------------
USE bagelshoppe;
-- ------------------------------------

-- add your INSERT/UPDATE statements here

select * from BagelCard where customer_id = 3;

-- +------------------+-------------+-------------+
-- | id               | bagelpoints | customer_id |
-- +------------------+-------------+-------------+
-- | 3333333333333333 |         112 |           3 |
-- +------------------+-------------+-------------+

-- 1. Add enough bagels and drinks to push over the 150 threshold
-- (Create an Order Number 14 for 42.18 GBP)
INSERT INTO CustomerOrder VALUES (14, "2016-02-03", 3333333333333333, 3, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (14, 1, 38); -- 38 Plain Bagels at 1.11 each

-- 2. Update the BagelPoints total on Customer's BagelCard (use customer_id = 3)

-- Total cost from Bagels for Order Number 14
UPDATE BagelCard
SET bagelpoints = bagelpoints + FLOOR(
   	  -- Total the Bagels from Order Number 14
      (SELECT SUM(quantity*price) AS bagel_cost
       FROM Order_Contains_Bagel JOIN Bagel ON(Bagel.id = bagel_id)
       WHERE Order_Contains_Bagel.order_no = 14)

 	  -- Total the Drinks from Order Number 14 (no Drinks in this order)
      -- + (SELECT SUM(quantity*price)  AS drink_cost
      -- FROM Order_Contains_Drink JOIN Drink ON(Drink.id = drink_id)
      -- WHERE Order_Contains_Drink.order_no = 14) +

 	  -- Total the Filling from Order Number 14 (no Fillings in this order)
      -- + (SELECT SUM(quantity*price)  AS filling_cost
      -- FROM Bagel_Has_Filling JOIN BagelFilling ON(BagelFilling.id = filling_id)
      -- WHERE Bagel_Has_Filling.order_no = 14)
)
WHERE BagelCard.id = 3333333333333333;

-- Updated BagelCard.bagelpoints
-- +------------------+-------------+-------------+
-- | id               | bagelpoints | customer_id |
-- +------------------+-------------+-------------+
-- | 3333333333333333 |         154 |           3 |
-- +------------------+-------------+-------------+

-- 3. Update Order with appropriate discount (calculated from the BagelPoint total)
UPDATE CustomerOrder
SET discount = (SELECT 0.05 * FLOOR(bagelpoints / 50) AS discount
                FROM BagelCard
                WHERE BagelCard.id = 3333333333333333)
WHERE CustomerOrder.order_no = 14;

-- Updated CustomerOrder.discount
-- +----------+-------------+------------------+-------------+----------+------------+
-- | order_no | date_placed | bagelcard_id     | customer_id | discount | final_cost |
-- +----------+-------------+------------------+-------------+----------+------------+
-- |       14 | 2016-02-03  | 3333333333333333 |           3 |     0.15 |       0.00 |
-- +----------+-------------+------------------+-------------+----------+------------+


-- 4. Update Order with appropriate discount (calculated from the BagelPoint total)
-- (Note: Order only contains Bagels, so only total Bagels)
UPDATE CustomerOrder
SET final_cost = (1-discount) * (SELECT SUM(quantity*price) AS bagel_cost
       			                 FROM Order_Contains_Bagel JOIN Bagel ON(Bagel.id = bagel_id)
                                 WHERE Order_Contains_Bagel.order_no = 14)
WHERE CustomerOrder.order_no = 14;

-- Updated CustomerOrder.final_cost
-- +----------+-------------+------------------+-------------+----------+------------+
-- | order_no | date_placed | bagelcard_id     | customer_id | discount | final_cost |
-- +----------+-------------+------------------+-------------+----------+------------+
-- |       14 | 2016-02-03  | 3333333333333333 |           3 |     0.15 |      35.85 |
-- +----------+-------------+------------------+-------------+----------+------------+