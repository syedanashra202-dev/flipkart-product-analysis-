
-- =====================================================
-- PROJECT: Flipkart Product Listings Analysis
-- TOOL: MySQL
-- DATASET: 8,000 product listings
-- =====================================================

USE flipkart_analysis;

-- 1. Total number of product listings
SELECT COUNT(*) AS total_products
FROM products;

-- 2. Check for duplicate product IDs
SELECT product_id, COUNT(*) AS id_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- 3. Product distribution by category
SELECT
    category,
    COUNT(*) AS product_count
FROM products
GROUP BY category
ORDER BY product_count DESC;

-- 4. Average selling price, discount, and rating by category
SELECT
    category,
    COUNT(*) AS product_count,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(AVG(discount_percent), 2) AS avg_discount_percent,
    ROUND(AVG(rating), 2) AS avg_rating
FROM products
GROUP BY category
ORDER BY avg_selling_price DESC;

-- 5. Compare MRP and selling price by category
SELECT
    category,
    ROUND(AVG(mrp), 2) AS avg_mrp,
    ROUND(AVG(selling_price), 2) AS avg_selling_price,
    ROUND(AVG(mrp - selling_price), 2) AS avg_price_reduction,
    ROUND(
        AVG((mrp - selling_price) / NULLIF(mrp, 0)) * 100,
        2
    ) AS calculated_discount_percent
FROM products
GROUP BY category
ORDER BY calculated_discount_percent DESC;

-- 6. Brands with at least 20 product listings
SELECT
    brand,
    COUNT(*) AS product_count,
    ROUND(AVG(rating), 2) AS avg_rating,
    SUM(review_count) AS total_reviews
FROM products
GROUP BY brand
HAVING COUNT(*) >= 20
ORDER BY avg_rating DESC, total_reviews DESC
LIMIT 10;

-- 7. Highly rated products with at least 100 reviews
SELECT
    product_id,
    product_name,
    category,
    brand,
    selling_price,
    rating,
    review_count
FROM products
WHERE rating >= 4.5
  AND review_count >= 100
ORDER BY rating DESC, review_count DESC
LIMIT 15;

-- 8. Stock availability
SELECT
    in_stock,
    COUNT(*) AS product_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM products), 2)
        AS percentage
FROM products
GROUP BY in_stock;

-- 9. Seller listing and stock performance
SELECT
    seller,
    COUNT(*) AS total_listings,
    SUM(CASE WHEN in_stock = 'Yes' THEN 1 ELSE 0 END)
        AS in_stock_count,
    ROUND(
        SUM(CASE WHEN in_stock = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS in_stock_percentage,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(discount_percent), 2) AS avg_discount_percent
FROM products
GROUP BY seller
ORDER BY in_stock_percentage DESC;

-- 10. Products with large discounts and good ratings
SELECT
    product_id,
    product_name,
    category,
    brand,
    mrp,
    selling_price,
    discount_percent,
    rating,
    review_count
FROM products
WHERE discount_percent >= 40
  AND rating >= 4.0
ORDER BY discount_percent DESC, rating DESC
LIMIT 20;


