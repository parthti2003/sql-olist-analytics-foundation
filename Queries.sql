-- 1. Aggregation & Grouping 
use brazil_ecommerce;
-- Top 10 best-selling products by total quantity sold

SELECT 
    p.product_id,
    p.product_category_name,
    SUM(oi.price) AS total_sales
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_category_name
ORDER BY total_sales DESC
LIMIT 10;


-- Products with lowest average customer review ratings

SELECT 
    oi.product_id,
    COALESCE(t.product_category_name_english, p.product_category_name) AS category_name,
    ROUND(AVG(r.review_score), 2) AS avg_rating
FROM order_items oi
JOIN order_reviews r 
    ON oi.order_id = r.order_id
JOIN products p 
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY oi.product_id, category_name
HAVING COUNT(r.review_id) > 5
ORDER BY avg_rating ASC
LIMIT 10;

-- Total sales and order counts per product category

SELECT 
    COALESCE(t.product_category_name_english, p.product_category_name, 'Unknown') AS category_name,
    ROUND(SUM(oi.price), 2) AS total_sales,
    COUNT(DISTINCT oi.order_id) AS order_counts
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY category_name
ORDER BY total_sales DESC;

-- Sales variation by customer city/state for top categories

WITH top_categories AS (
    SELECT p.product_category_name
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
    ORDER BY SUM(oi.price) DESC
    LIMIT 5
)
SELECT
    p.product_category_name,
    c.customer_city,
    c.customer_state,
    SUM(oi.price) AS total_sales,
    COUNT(DISTINCT oi.order_id) AS order_count
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE p.product_category_name IN (SELECT product_category_name FROM top_categories)
GROUP BY p.product_category_name, c.customer_city, c.customer_state
ORDER BY p.product_category_name, total_sales DESC;

-- Distribution of order statuses

select count(order_id) as distibution , order_status from orders
group by order_status;

-- Payment types generating most revenue and order counts

select count(order_id) order_count, payment_type, sum(payment_value) revenue from order_payments
group by payment_type
order by revenue desc;

-- Top 5 product categories in canceled orders

select count(p.product_category_name) cancelled_count , p.product_category_name from orders
join order_items using(order_id)
join products p using(product_id)
where order_status = "canceled"
group by product_category_name
order by cancelled_count desc
limit 5;

-- Products with unusually high return/cancellation rates

SELECT 
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) AS canceled_orders,
    ROUND(SUM(CASE WHEN o.order_status = 'canceled' THEN 1 ELSE 0 END) / COUNT(DISTINCT oi.order_id), 3) AS cancellation_rate
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
HAVING total_orders > 10  -- to exclude categories with very few orders
ORDER BY cancellation_rate DESC
LIMIT 5;

-- 2. Customer & Seller Analysis 

-- Top 10 customers by lifetime value

select customer_id,sum(payment_value) total_spend, customer_city from order_payments op
join orders o using(order_id)
join customers c using(customer_id)
group by customer_id
order by total_spend desc 
limit 10;

-- Average number of orders per customer

SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
ORDER BY order_count DESC;

-- Repeat customers & percentage of total customers
 
SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;
-- they do not exists

-- Customers who ordered from multiple sellers

select customer_id,count(distinct seller_id) as distinct_seller from orders o join order_items oi using(order_id)
group by customer_id
having distinct_seller > 1;

-- Customers with highest average order values
-- As we know that distinct customer_id count = distinct order_id count we can write this

select customer_id,sum(payment_value) total_spend, customer_city from order_payments op
join orders o using(order_id)
join customers c using(customer_id)
group by customer_id
order by total_spend desc 
limit 10;

-- Sellers with fastest average delivery times

SELECT 
    oi.seller_id,
    AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_delivery_days
FROM orders o
JOIN order_items oi USING(order_id)
WHERE o.order_status = 'delivered' 
GROUP BY oi.seller_id
ORDER BY avg_delivery_days ASC
LIMIT 10;

-- Average delivery time differences between states

SELECT 
    c.customer_state,
    AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_delivery_days
FROM orders o
JOIN customers c USING(customer_id)
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY avg_delivery_days;


-- Sellers with highest volume of orders in different regions

WITH ranked_sellers AS (
  SELECT
    c.customer_state,
    oi.seller_id,
    COUNT(*) AS order_volume,
    ROW_NUMBER() OVER (PARTITION BY c.customer_state ORDER BY COUNT(*) DESC) AS rnk
  FROM order_items oi
  JOIN orders o USING(order_id)
  JOIN customers c USING(customer_id)
  GROUP BY c.customer_state, oi.seller_id
)
SELECT customer_state, seller_id, order_volume
FROM ranked_sellers
WHERE rnk = 1;

-- 3. Trend, Temporal & Cohort Analysis (Advanced)

-- Monthly trend of total sales over the years

select month(order_purchase_timestamp) month, year(order_purchase_timestamp) year, sum(payment_value) from orders
join order_payments using(order_id)
group by year,month
order by year,month;

-- Trends in review scores over time for top-selling products

WITH top_selling_product AS (
  SELECT 
    product_category_name, 
    COUNT(product_id) AS sales
  FROM order_items oi
  JOIN products p USING(product_id)
  GROUP BY product_category_name
  ORDER BY sales DESC
  LIMIT 5
),
review_with_time AS (
  SELECT 
    p.product_category_name,
    YEAR(r.review_answer_timestamp) AS review_year,
    MONTH(r.review_answer_timestamp) AS review_month,
    r.review_score
  FROM order_reviews r
  JOIN order_items oi USING(order_id)
  JOIN products p USING(product_id)
  JOIN top_selling_product tsp ON p.product_category_name = tsp.product_category_name
)
SELECT 
  product_category_name,
  review_year,
  review_month,
  AVG(review_score) AS avg_review_score
FROM review_with_time
GROUP BY product_category_name, review_year, review_month
ORDER BY product_category_name, review_year, review_month;

-- Average payment value by payment type and customer segment

SELECT 
    op.payment_type,
    c.customer_state AS customer_segment,
    AVG(op.payment_value) AS avg_payment_value
FROM order_payments op
JOIN orders o ON op.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY 
    op.payment_type,
    c.customer_state
ORDER BY 
    op.payment_type,
    avg_payment_value DESC;

-- Average time between order purchase and delivery per seller

select seller_id, 
avg(datediff(order_delivered_customer_date,order_purchase_timestamp)) avgtime_taken 
from orders o 
join order_items oi using(order_id)
group by seller_id
having avg(datediff(order_delivered_customer_date,order_purchase_timestamp)) is not null
order by avgtime_taken;

-- 4. Correlation & Insight (Expert)

-- Correlation between review scores and product sales volume

WITH sales_volume AS (
  SELECT 
    product_id,
    COUNT(*) AS sales_volume
  FROM order_items
  GROUP BY product_id
),
avg_review_score AS (
  SELECT 
    oi.product_id,
    AVG(orv.review_score) AS avg_review_score
  FROM order_reviews orv
  JOIN order_items oi ON orv.order_id = oi.order_id
  GROUP BY oi.product_id
)
SELECT 
  sv.product_id,
  sv.sales_volume,
  ars.avg_review_score
FROM sales_volume sv
JOIN avg_review_score ars ON sv.product_id = ars.product_id
ORDER BY sv.sales_volume DESC;

-- Detect potential fraudulent orders based on payment anomalies or order patterns

WITH order_payment_stats AS (
  SELECT 
    order_id,
    COUNT(*) AS payment_count,
    SUM(payment_value) AS total_payment,
    MAX(payment_value) AS max_payment,
    MIN(payment_value) AS min_payment,
    ANY_VALUE(payment_type) AS payment_type -- Assuming payment_type consistent per order
  FROM order_payments
  GROUP BY order_id
),
fraud_candidates AS (
  SELECT 
    o.order_id,
    o.customer_id,
    ops.payment_count,
    ops.total_payment,
    ops.max_payment,
    ops.min_payment,
    ops.payment_type,
    o.order_purchase_timestamp
  FROM orders o
  JOIN order_payment_stats ops ON o.order_id = ops.order_id
  WHERE 
    ops.payment_count > 1 -- Multiple payments per order, unusual pattern
    OR ops.total_payment > 10000 -- High payment threshold, customize as needed
    OR ops.payment_type NOT IN ('credit_card', 'boleto', 'voucher') -- Unusual payment type
)
SELECT * FROM fraud_candidates
ORDER BY order_purchase_timestamp DESC
LIMIT 100;


-- Regional performance of product categories (states/cities)

SELECT 
  c.customer_state,
  p.product_category_name,
  COUNT(oi.order_id) AS total_orders,
  SUM(oi.price) AS total_sales_value
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY 
  c.customer_state,
  p.product_category_name
ORDER BY 
  c.customer_state,
  total_sales_value DESC;
