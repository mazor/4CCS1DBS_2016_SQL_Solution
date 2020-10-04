-- Part 2.2 insert.sql
--
-- Submitted by: Coursework Solution
-- 

-- do not edit these lines -------------
USE bagelshoppe;
-- ------------------------------------

-- add your INSERT statements here

-- create some Customers and BagelCards
INSERT INTO Customer VALUES (1, "George Clooney", "Mr", "1961-05-06", "8817 Lookout Mountain Ave., Los Angelos CA", "clooney@hollywood.com");
INSERT INTO BagelCard VALUES (1111111111111111, 0, 1);
INSERT INTO Customer VALUES (2, "Rihanna", "Ms", "1988-02-20", "932 Rivas Canyon Road, Pacific Palisades CA", "rhianna@facebook.com");
INSERT INTO BagelCard VALUES (2222222222222222, 0, 2);
INSERT INTO Customer VALUES (3, "Drake", "Sir", "1986-10-24", "5841 Round Meadow Rd, Hidden Hills, CA", "bling@hotline.com");
INSERT INTO BagelCard VALUES (3333333333333333, 0, 3);

-- create some Drank
INSERT INTO Drink VALUES (1, 0.59, "Coffee", "Small");
INSERT INTO Drink VALUES (2, 2.30, "Coffee", "Medium");
INSERT INTO Drink VALUES (3, 3.23, "Coffee", "Large");
INSERT INTO Drink VALUES (4, 4.76, "Coffee", "Jumbo");

-- create some Bagels
INSERT INTO Bagel VALUES (1, 1.11, "Plain", False);
INSERT INTO Bagel VALUES (2, 2.22, "Everything", False);
INSERT INTO Bagel VALUES (3, 3.33, "Maple-nut", True);
INSERT INTO Bagel VALUES (4, 4.11, "Jalepino Cheddar", False);
INSERT INTO Bagel VALUES (5, 5.32, "Kale-Chicken", False);

-- create BagelFilling
INSERT INTO BagelFilling VALUES (1, 0.89, "Cream Cheese");
INSERT INTO BagelFilling VALUES (2, 2.11, "Fried Egg");
INSERT INTO BagelFilling VALUES (3, 1.79, "Slice of American Cheese");

-- Order some Bagels
INSERT INTO CustomerOrder VALUES (1, "2016-01-01", 1111111111111111, 1, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (1, 1, 2);
INSERT INTO Order_Contains_Drink VALUES (1, 1, 1);
INSERT INTO Bagel_Has_Filling    VALUES (1, 1, 2, 1);

INSERT INTO CustomerOrder VALUES (2, "2016-01-02", 2222222222222222, 2, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (2, 2, 2);
INSERT INTO Order_Contains_Drink VALUES (2, 3, 3);
INSERT INTO Bagel_Has_Filling    VALUES (2, 2, 2, 1);

INSERT INTO CustomerOrder VALUES (3, "2016-01-03", 3333333333333333, 3, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (3, 4, 1);
INSERT INTO Order_Contains_Drink VALUES (3, 2, 1);
INSERT INTO Order_Contains_Drink VALUES (3, 1, 1);
INSERT INTO Order_Contains_Drink VALUES (3, 3, 4);
INSERT INTO Bagel_Has_Filling    VALUES (3, 4, 1, 1);
INSERT INTO Bagel_Has_Filling    VALUES (3, 2, 1, 1);

INSERT INTO CustomerOrder VALUES (4, "2016-01-04", 1111111111111111, 1, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (4, 5, 1);
INSERT INTO Order_Contains_Drink VALUES (4, 1, 1);

INSERT INTO CustomerOrder VALUES (5, "2016-01-05", 2222222222222222, 2, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (5, 4, 2);
INSERT INTO Order_Contains_Drink VALUES (5, 2, 1);

INSERT INTO CustomerOrder VALUES (6, "2016-01-06", 3333333333333333, 3, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (6, 1, 5);
INSERT INTO Order_Contains_Bagel VALUES (6, 2, 5);
INSERT INTO Order_Contains_Bagel VALUES (6, 3, 5);
INSERT INTO Order_Contains_Bagel VALUES (6, 4, 5);
INSERT INTO Order_Contains_Bagel VALUES (6, 5, 5);

INSERT INTO CustomerOrder VALUES (7, "2016-01-07", 1111111111111111, 1, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (7, 1, 1);
INSERT INTO Order_Contains_Bagel VALUES (7, 2, 1);
INSERT INTO Order_Contains_Bagel VALUES (7, 3, 2);
INSERT INTO Order_Contains_Drink VALUES (7, 1, 2);
INSERT INTO Order_Contains_Drink VALUES (7, 2, 3);

INSERT INTO CustomerOrder VALUES (8, "2016-01-08", 2222222222222222, 2, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (8, 1, 1);
INSERT INTO Order_Contains_Drink VALUES (8, 3, 1);
INSERT INTO Bagel_Has_Filling    VALUES (8, 1, 1, 1);

INSERT INTO CustomerOrder VALUES (9, "2016-01-09", 3333333333333333, 3, 0, 0);
INSERT INTO Order_Contains_Drink VALUES (9, 1, 1);

INSERT INTO CustomerOrder VALUES (10, "2016-02-01", 1111111111111111, 1, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (10, 3, 20);
INSERT INTO Order_Contains_Drink VALUES (10, 1, 20);

INSERT INTO CustomerOrder VALUES (11, "2016-02-02", 2222222222222222, 2, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (11, 5, 1);
INSERT INTO Order_Contains_Drink VALUES (11, 3, 1);

INSERT INTO CustomerOrder VALUES (12, "2016-02-03", 3333333333333333, 3, 0, 0);
INSERT INTO Order_Contains_Bagel VALUES (12, 2, 1);
INSERT INTO Order_Contains_Drink VALUES (12, 4, 1);
INSERT INTO Bagel_Has_Filling    VALUES (12, 2, 1, 1);
INSERT INTO Bagel_Has_Filling    VALUES (12, 2, 2, 1);
INSERT INTO Bagel_Has_Filling    VALUES (12, 2, 3, 1);


-- Views to calculate the total order 

CREATE VIEW Order_Bagel_Total_Costs AS
( -- total cost from Bagels
    SELECT order_no, SUM(quantity*price) as cost
    FROM Order_Contains_Bagel JOIN Bagel ON(Bagel.id = bagel_id)
    GROUP BY order_no
);

CREATE VIEW Order_Drink_Total_Costs AS
( -- total cost from Drinks
    SELECT order_no, SUM(quantity*price) as cost
    FROM Order_Contains_Drink JOIN Drink ON(Drink.id = drink_id)
    GROUP BY order_no
);

CREATE VIEW Order_BagelFilling_Total_Costs AS
( -- total cost from BagelFilling
    SELECT order_no, SUM(quantity*price) as cost
    FROM Bagel_Has_Filling JOIN BagelFilling ON(BagelFilling.id = filling_id)
    GROUP BY order_no
);

-- bagelpoints per order
SELECT CustomerOrder.order_no, total_cost, bagelcard_Id, floor(total_cost) as bagelpoints FROM (
    SELECT order_no, SUM(cost) AS total_cost
    FROM (
        (SELECT order_no, cost, "bagel" as item_type FROM Order_Bagel_Total_Costs)
        UNION
        (SELECT order_no, cost, "drink" as item_type FROM Order_Drink_Total_Costs)
        UNION
        (SELECT order_no, cost, "bagelfilling" as item_type FROM Order_BagelFilling_Total_Costs)
    ) AS tmp
    GROUP BY order_no
) AS total_orders NATURAL JOIN CustomerOrder;

-- +----------+------------+------------------+-------------+
-- | order_no | total_cost | bagelcard_Id     | bagelpoints |
-- +----------+------------+------------------+-------------+
-- |        1 |       4.92 | 1111111111111111 |           4 |
-- |        2 |      16.24 | 2222222222222222 |          16 |
-- |        3 |      21.70 | 3333333333333333 |          21 |
-- |        4 |       5.91 | 1111111111111111 |           5 |
-- |        5 |      10.52 | 2222222222222222 |          10 |
-- |        6 |      80.45 | 3333333333333333 |          80 |
-- |        7 |      11.17 | 1111111111111111 |          11 |
-- |        8 |       5.23 | 2222222222222222 |           5 |
-- |        9 |       0.59 | 3333333333333333 |           0 |
-- |       10 |      78.40 | 1111111111111111 |          78 |
-- |       11 |       8.55 | 2222222222222222 |           8 |
-- |       12 |      11.77 | 3333333333333333 |          11 |
-- +----------+------------+------------------+-------------+
-- 12 rows in set (0.00 sec)

UPDATE CustomerOrder SET discount = 0, final_cost =  4.92 WHERE order_no = 1;
UPDATE CustomerOrder SET discount = 0, final_cost = 16.24 WHERE order_no = 2;
UPDATE CustomerOrder SET discount = 0, final_cost = 21.70 WHERE order_no = 3;
UPDATE CustomerOrder SET discount = 0, final_cost =  5.91 WHERE order_no = 4;
UPDATE CustomerOrder SET discount = 0, final_cost = 10.52 WHERE order_no = 5;
UPDATE CustomerOrder SET discount = 0.1, final_cost = (1-discount)*80.45 WHERE order_no = 6;
UPDATE CustomerOrder SET discount = 0, final_cost = 11.17 WHERE order_no = 7;
UPDATE CustomerOrder SET discount = 0, final_cost = 5.23 WHERE order_no = 8;
UPDATE CustomerOrder SET discount = 0, final_cost = 0.59 WHERE order_no = 9;
UPDATE CustomerOrder SET discount = 0.05, final_cost = (1-discount)*78.40 WHERE order_no = 10;
UPDATE CustomerOrder SET discount = 0, final_cost = 8.55 WHERE order_no = 11;
UPDATE CustomerOrder SET discount = 0, final_cost = 11.77 WHERE order_no = 12;

-- bagelcard bagelpoints total
SELECT bagelcard_id, SUM(bagelpoints) FROM (
    SELECT CustomerOrder.order_no, total_cost, bagelcard_Id, floor(total_cost) as bagelpoints FROM (
        SELECT order_no, SUM(cost) AS total_cost
        FROM (
            (SELECT order_no, cost, "bagel" as item_type FROM Order_Bagel_Total_Costs)
            UNION
            (SELECT order_no, cost, "drink" as item_type FROM Order_Drink_Total_Costs)
            UNION
            (SELECT order_no, cost, "bagelfilling" as item_type FROM Order_BagelFilling_Total_Costs)
        ) AS tmp
        GROUP BY order_no
    ) AS total_orders NATURAL JOIN CustomerOrder) as tmp2
GROUP BY bagelcard_Id;

-- +------------------+------------------+
-- | bagelcard_id     | SUM(bagelpoints) |
-- +------------------+------------------+
-- | 1111111111111111 |               98 |
-- | 2222222222222222 |               39 |
-- | 3333333333333333 |              112 |
-- +------------------+------------------+
-- 3 rows in set (0.00 sec)

UPDATE BagelCard SET bagelpoints=98  WHERE id=1111111111111111;
UPDATE BagelCard SET bagelpoints=39  WHERE id=2222222222222222;
UPDATE BagelCard SET bagelpoints=112 WHERE id=3333333333333333;

