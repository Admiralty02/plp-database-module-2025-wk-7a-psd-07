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
