-- E-Commerce Sales & Customer Analytics
CREATE DATABASE IF NOT EXISTS ecommerce_analytics;
USE ecommerce_analytics;

CREATE TABLE orders (
 order_id VARCHAR(20) PRIMARY KEY,
 order_date DATE,
 city VARCHAR(50),
 category VARCHAR(50),
 channel VARCHAR(30),
 customer_segment VARCHAR(30),
 payment_method VARCHAR(30),
 quantity INT,
 unit_price DECIMAL(12,2),
 discount_pct DECIMAL(5,2),
 gross_sales DECIMAL(12,2),
 discount_amount DECIMAL(12,2),
 net_sales DECIMAL(12,2),
 cost DECIMAL(12,2),
 profit DECIMAL(12,2),
 profit_margin_pct DECIMAL(8,2),
 customer_rating DECIMAL(3,1),
 delivery_days INT
);

-- 1. Monthly revenue
SELECT DATE_FORMAT(order_date,'%Y-%m') AS month,
       ROUND(SUM(net_sales),2) AS revenue
FROM orders GROUP BY month ORDER BY month;

-- 2. Category performance
SELECT category,
       ROUND(SUM(net_sales),2) AS revenue,
       ROUND(SUM(profit),2) AS profit,
       ROUND(AVG(profit_margin_pct),2) AS avg_margin
FROM orders
GROUP BY category
ORDER BY revenue DESC;

-- 3. City performance
SELECT city, ROUND(SUM(net_sales),2) AS revenue,
       COUNT(*) AS orders
FROM orders
GROUP BY city ORDER BY revenue DESC;

-- 4. Channel performance
SELECT channel, ROUND(SUM(net_sales),2) revenue,
       ROUND(AVG(profit_margin_pct),2) margin
FROM orders GROUP BY channel ORDER BY revenue DESC;

-- 5. Customer segment
SELECT customer_segment, COUNT(*) orders,
       ROUND(SUM(net_sales),2) revenue,
       ROUND(AVG(customer_rating),2) rating
FROM orders GROUP BY customer_segment ORDER BY revenue DESC;

-- 6. Discount impact
SELECT discount_pct,
       COUNT(*) orders,
       ROUND(SUM(net_sales),2) revenue,
       ROUND(AVG(profit_margin_pct),2) margin
FROM orders GROUP BY discount_pct ORDER BY discount_pct;

-- 7. Low-margin categories
SELECT category, ROUND(AVG(profit_margin_pct),2) avg_margin
FROM orders
GROUP BY category
HAVING avg_margin < 25
ORDER BY avg_margin;

-- 8. Top 10 orders by profit
SELECT order_id, category, city, net_sales, profit
FROM orders ORDER BY profit DESC LIMIT 10;