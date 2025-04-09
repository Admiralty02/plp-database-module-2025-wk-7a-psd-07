--QUESTION ONE
WITH SplitProducts AS (
    SELECT
        OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
    FROM
        ProductDetails,
        (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) AS numbers
    WHERE
        SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1) <> ''
)
SELECT
    OrderID,
    CustomerName,
    Product
FROM
    SplitProducts;

--QUESTION TWO

-- Create a new table for Customers
CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Insert customer data into the Customers table
INSERT INTO Customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM (
    WITH SplitProducts AS (
        SELECT
            OrderID,
            CustomerName,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
        FROM
            OrderDetails, 
            (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) AS numbers
        WHERE
            SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1) <> ''
    )
    SELECT
        OrderID,
        CustomerName,
        Product
    FROM
        SplitProducts
) AS TransformedTable;

-- Create a new table for OrderProducts
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(255),
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Customers(OrderID)
);

INSERT INTO OrderProducts (OrderID, Product)
SELECT
    OrderID,
    Product
FROM (
    WITH SplitProducts AS (
        SELECT
            OrderID,
            CustomerName,
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
        FROM
            OrderDetails, 
            (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) AS numbers
        WHERE
            SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1) <> ''
    )
    SELECT
        OrderID,
        CustomerName,
        Product
    FROM
        SplitProducts
) AS TransformedTable;

-- The original table can now be dropped or kept as a view, if needed.

-- Example Queries to see the results
SELECT * FROM Customers;
SELECT * FROM OrderProducts;
