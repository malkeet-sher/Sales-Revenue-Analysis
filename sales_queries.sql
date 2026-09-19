-- 1. Total Revenue
SELECT
    SUM(Revenue) AS Total_Revenue
FROM sales;

-- 2. Product-wise Revenue
SELECT
    Product,
    SUM(Revenue) AS Total_Revenue
FROM sales
GROUP BY Product
ORDER BY Total_Revenue DESC;

-- 3. Category-wise Revenue
SELECT
    Category,
    SUM(Revenue) AS Total_Revenue
FROM sales
GROUP BY Category
ORDER BY Total_Revenue DESC;

-- 4. Month-wise Revenue
SELECT
    SUBSTR(Date, 1, 7) AS Month,
    SUM(Revenue) AS Total_Revenue
FROM sales
GROUP BY Month
ORDER BY Month;

-- 5. Electronics Category Revenue
SELECT
    SUM(Revenue) AS Electronics_Revenue
FROM sales
WHERE Category = 'Electronics';

-- 6. Transactions with Revenue above 50,000
SELECT
    Product,
    Quantity,
    Revenue
FROM sales
WHERE Revenue > 50000
ORDER BY Revenue DESC;

-- 7. Products with Total Revenue above 50,000
SELECT
    Product,
    SUM(Revenue) AS Total_Revenue
FROM sales
GROUP BY Product
HAVING SUM(Revenue) > 50000
ORDER BY Total_Revenue DESC;

-- 8. Revenue Classification
SELECT
    Product,
    Revenue,
    CASE
        WHEN Revenue > 50000 THEN 'High'
        WHEN Revenue >= 20000 THEN 'Medium'
        ELSE 'Low'
    END AS Revenue_Level
FROM sales
ORDER BY Revenue DESC;

-- 9. Products with Revenue above 50,000 using CTE
WITH product_revenue AS (
    SELECT
        Product,
        SUM(Revenue) AS Total_Revenue
    FROM sales
    GROUP BY Product
)

SELECT
    Product,
    Total_Revenue
FROM product_revenue
WHERE Total_Revenue > 50000
ORDER BY Total_Revenue DESC;

-- 10. Total Number of Transactions
SELECT
    COUNT(*) AS Total_Transactions
FROM sales;

-- 11. Transaction Count by Product
SELECT
    Product,
    COUNT(*) AS Transaction_Count
FROM sales
GROUP BY Product
ORDER BY Transaction_Count DESC;

-- 11. Transaction Count by Product
SELECT
    Product,
    COUNT(*) AS Transaction_Count
FROM sales
GROUP BY Product
ORDER BY Transaction_Count DESC;

-- 12. Average Price by Product
SELECT
    Product,
    AVG(Price) AS Average_Price
FROM sales
GROUP BY Product
ORDER BY Average_Price DESC;

-- 13. Minimum and Maximum Price by Product
SELECT
    Product,
    MIN(Price) AS Minimum_Price,
    MAX(Price) AS Maximum_Price
FROM sales
GROUP BY Product
ORDER BY Product;

-- 14. List of Unique Products
SELECT DISTINCT
    Product
FROM sales
ORDER BY Product;

-- 15. List of Unique Categories
SELECT DISTINCT
    Category
FROM sales
ORDER BY Category;

-- 16. Top 3 Products by Revenue
SELECT
    Product,
    SUM(Revenue) AS Total_Revenue
FROM sales
GROUP BY Product
ORDER BY Total_Revenue DESC
LIMIT 3;

-- 17. Top 3 Products by Quantity Sold
SELECT
    Product,
    SUM(Quantity) AS Total_Quantity
FROM sales
GROUP BY Product
ORDER BY Total_Quantity DESC
LIMIT 3;

-- 18. Products with Revenue Above Average Product Revenue
SELECT
    Product,
    SUM(Revenue) AS Total_Revenue
FROM sales
GROUP BY Product
HAVING SUM(Revenue) > (
    SELECT AVG(Total_Revenue)
    FROM (
        SELECT
            Product,
            SUM(Revenue) AS Total_Revenue
        FROM sales
        GROUP BY Product
    )
)
ORDER BY Total_Revenue DESC;

-- 19. Create Products Table

CREATE TABLE IF NOT EXISTS products (
    Product TEXT PRIMARY KEY,
    Brand TEXT,
    Supplier TEXT
);

-- 20. Insert Product Information

INSERT OR REPLACE INTO products (Product, Brand, Supplier)
VALUES
    ('Laptop', 'Dell', 'Tech Supplier A'),
    ('Mouse', 'Logitech', 'Accessory Supplier B'),
    ('Keyboard', 'HP', 'Accessory Supplier B'),
    ('Monitor', 'Samsung', 'Tech Supplier A'),
    ('Headphones', 'Sony', 'Audio Supplier C');

 -- 21. Check Products Table

SELECT *
FROM products;

-- 22. INNER JOIN Sales with Products

SELECT
    s.Product,
    s.Quantity,
    s.Revenue,
    p.Brand,
    p.Supplier
FROM sales AS s
INNER JOIN products AS p
    ON s.Product = p.Product;

-- 23. LEFT JOIN Sales with Products

SELECT
    s.Product,
    s.Revenue,
    p.Brand,
    p.Supplier
FROM sales AS s
LEFT JOIN products AS p
    ON s.Product = p.Product;

-- 24. Revenue by Brand

SELECT
    p.Brand,
    SUM(s.Revenue) AS Total_Revenue
FROM sales AS s
INNER JOIN products AS p
    ON s.Product = p.Product
GROUP BY p.Brand
ORDER BY Total_Revenue DESC;

-- 25. Electronics Revenue by Brand

SELECT
    p.Brand,
    SUM(s.Revenue) AS Total_Revenue
FROM sales AS s
INNER JOIN products AS p
    ON s.Product = p.Product
WHERE s.Category = 'Electronics'
GROUP BY p.Brand
ORDER BY Total_Revenue DESC;

-- 26. Brands with Total Revenue Above 50,000

SELECT
    p.Brand,
    SUM(s.Revenue) AS Total_Revenue
FROM sales AS s
INNER JOIN products AS p
    ON s.Product = p.Product
GROUP BY p.Brand
HAVING SUM(s.Revenue) > 50000
ORDER BY Total_Revenue DESC;

-- 27. Product Revenue Ranking

SELECT
    Product,
    SUM(Revenue) AS Total_Revenue,
    RANK() OVER (
        ORDER BY SUM(Revenue) DESC
    ) AS Revenue_Rank
FROM sales
GROUP BY Product
ORDER BY Revenue_Rank;

-- 28. Compare Ranking Functions

WITH product_revenue AS (
    SELECT
        Product,
        SUM(Revenue) AS Total_Revenue
    FROM sales
    GROUP BY Product
)

SELECT
    Product,
    Total_Revenue,
    RANK() OVER (ORDER BY Total_Revenue DESC) AS Rank_Number,
    DENSE_RANK() OVER (ORDER BY Total_Revenue DESC) AS Dense_Rank,
    ROW_NUMBER() OVER (ORDER BY Total_Revenue DESC) AS Row_Number
FROM product_revenue
ORDER BY Total_Revenue DESC;

-- 29. Top 3 Products by Revenue using CTE and RANK

WITH product_rank AS (
    SELECT
        Product,
        SUM(Revenue) AS Total_Revenue,
        RANK() OVER (
            ORDER BY SUM(Revenue) DESC
        ) AS Revenue_Rank
    FROM sales
    GROUP BY Product
)

SELECT
    Product,
    Total_Revenue,
    Revenue_Rank
FROM product_rank
WHERE Revenue_Rank <= 3
ORDER BY Revenue_Rank;


