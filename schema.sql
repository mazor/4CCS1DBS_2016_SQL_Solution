-- Part 2.1 schema.sql
--
-- Submitted by: Coursework Solution
-- 

-- do not edit these lines -------------
CREATE SCHEMA IF NOT EXISTS bagelshoppe;
USE bagelshoppe;
-- ------------------------------------

-- edit your schema here ---------------


CREATE TABLE Customer (
  
  id INT PRIMARY KEY AUTO_INCREMENT,
 
   name VARCHAR(255) NOT NULL,
  
  title VARCHAR(16) DEFAULT '',

    dob DATE NOT NULL,
 
   address VARCHAR(255) NOT NULL,

    emailaddress VARCHAR(255) NOT NULL
);




CREATE TABLE BagelCard (
    
id BIGINT(16) PRIMARY KEY AUTO_INCREMENT,

    bagelpoints INT UNSIGNED DEFAULT 0,
  
  customer_id INT NOT NULL,
    
FOREIGN KEY (customer_id) REFERENCES Customer(id)
   
             ON DELETE RESTRICT ON UPDATE CASCADE
);



CREATE TABLE Drink (
  
  id INT PRIMARY KEY AUTO_INCREMENT,
   
 price DECIMAL(4,2) NOT NULL,
  
  description VARCHAR(64) NOT NULL,
  
  size CHAR(10) NOT NULL CHECK(size="Jumbo" OR 
      
                           size="Large" OR 
 
                                size="Medium" OR 
                      
           size="Small")
);

CREATE TABLE Bagel (
    id INT PRIMARY KEY AUTO_INCREMENT,
    price DECIMAL(4,2) NOT NULL,
    description VARCHAR(64) NOT NULL,
    has_nuts BOOLEAN NOT NULL
);

CREATE TABLE BagelFilling (
    id INT PRIMARY KEY AUTO_INCREMENT,
    price DECIMAL(4,2) NOT NULL,
    description VARCHAR(64) NOT NULL
);


CREATE TABLE CustomerOrder ( -- Order is a reserved word in SQL
    order_no INT PRIMARY KEY AUTO_INCREMENT,
    date_placed DATE,
    bagelcard_id BIGINT,
    customer_id INT,
    discount DECIMAL(2,2) DEFAULT 0,
    final_cost DECIMAL(6,2) NOT NULL,
    FOREIGN KEY (bagelcard_id) REFERENCES BagelCard(id)
                ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer(id)
                ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Order_Contains_Bagel (
    order_no INT,
    bagel_id INT,
    quantity INT UNSIGNED DEFAULT 1,
    PRIMARY KEY(order_no, bagel_id),
    FOREIGN KEY (order_no) REFERENCES CustomerOrder(order_no)
                ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (bagel_id) REFERENCES Bagel(id)
                ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Order_Contains_Drink (
    order_no INT,
    drink_id INT,
    quantity INT UNSIGNED DEFAULT 1,
    PRIMARY KEY(order_no, drink_id),
    FOREIGN KEY (order_no) REFERENCES CustomerOrder(order_no)
                ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (drink_id) REFERENCES Drink(id)
                ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Bagel_Has_Filling (
    order_no INT,
    bagel_id INT,
    filling_id INT,
    quantity INT UNSIGNED DEFAULT 1,    
    PRIMARY KEY(order_no, bagel_id, filling_id),
    FOREIGN KEY (order_no) REFERENCES CustomerOrder(order_no)
                ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (bagel_id) REFERENCES Bagel(id)
                ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (filling_id) REFERENCES BagelFilling(id)
                ON DELETE RESTRICT ON UPDATE CASCADE
);
