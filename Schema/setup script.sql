-- =====================
-- MySQL Global Settings
-- =====================
-- Enable local infile
SET GLOBAL local_infile = 1;

-- Check secure_file_priv directory
SHOW VARIABLES LIKE 'secure_file_priv';

-- =====================
-- Database Reset
-- =====================
DROP DATABASE IF EXISTS brazil_ecommerce;
CREATE DATABASE brazil_ecommerce;
USE brazil_ecommerce;

-- =====================
-- Table Creation
-- =====================
CREATE TABLE customers (
    customer_id CHAR(32) PRIMARY KEY,
    customer_unique_id CHAR(32),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- FIXED: Maximum precision for geolocation coordinates to prevent any truncation
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(15,10),  -- Maximum precision for coordinates
    geolocation_lng DECIMAL(15,10),  -- Maximum precision for coordinates
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2),
    -- FIXED: Added composite index instead of primary key to handle duplicates
    INDEX idx_geo_zip (geolocation_zip_code_prefix),
    INDEX idx_geo_coords (geolocation_lat, geolocation_lng)
);

CREATE TABLE orders (
    order_id CHAR(32) PRIMARY KEY,
    customer_id CHAR(32),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id CHAR(32) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE sellers (
    seller_id CHAR(32) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

CREATE TABLE order_items (
    order_id CHAR(32),
    order_item_id INT,
    product_id CHAR(32),
    seller_id CHAR(32),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

CREATE TABLE order_payments (
    order_id CHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE order_reviews (
    review_id CHAR(32) PRIMARY KEY,
    order_id CHAR(32),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

-- =====================
-- Data Loading with Enhanced Error Handling
-- =====================

-- Disable foreign key checks temporarily for faster loading
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Customers - Handle potential duplicates
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
IGNORE INTO TABLE customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- 2. Geolocation - Handle duplicates and ensure precision
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv'
IGNORE INTO TABLE geolocation
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- 3. Orders - Handle duplicates and null values properly
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
IGNORE INTO TABLE orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@order_id, @customer_id, @order_status, @purchase, @approved, @carrier, @customer, @estimated)
SET
order_id = NULLIF(@order_id, ''),
customer_id = NULLIF(@customer_id, ''),
order_status = NULLIF(@order_status, ''),
order_purchase_timestamp = NULLIF(@purchase, ''),
order_approved_at = NULLIF(@approved, ''),
order_delivered_carrier_date = NULLIF(@carrier, ''),
order_delivered_customer_date = NULLIF(@customer, ''),
order_estimated_delivery_date = NULLIF(@estimated, '');

-- 4. Products - Handle duplicates
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
IGNORE INTO TABLE products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@pid, @cat, @nlen, @dlen, @photos, @weight, @len, @height, @width)
SET
product_id = NULLIF(@pid, ''),
product_category_name = NULLIF(@cat, ''),
product_name_lenght = NULLIF(@nlen, ''),
product_description_lenght = NULLIF(@dlen, ''),
product_photos_qty = NULLIF(@photos, ''),
product_weight_g = NULLIF(@weight, ''),
product_length_cm = NULLIF(@len, ''),
product_height_cm = NULLIF(@height, ''),
product_width_cm = NULLIF(@width, '');

-- 5. Sellers - Handle duplicates
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv'
IGNORE INTO TABLE sellers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- 6. Order Items - Handle duplicates on composite primary key
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
IGNORE INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@oid, @itemid, @pid, @sid, @ship, @price, @freight)
SET
order_id = NULLIF(@oid, ''),
order_item_id = NULLIF(@itemid, ''),
product_id = NULLIF(@pid, ''),
seller_id = NULLIF(@sid, ''),
shipping_limit_date = NULLIF(@ship, ''),
price = NULLIF(@price, ''),
freight_value = NULLIF(@freight, '');

-- 7. Order Payments - Handle duplicates on composite primary key
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv'
IGNORE INTO TABLE order_payments
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@oid, @seq, @ptype, @inst, @pvalue)
SET
order_id = NULLIF(@oid, ''),
payment_sequential = NULLIF(@seq, ''),
payment_type = NULLIF(@ptype, ''),
payment_installments = NULLIF(@inst, ''),
payment_value = NULLIF(@pvalue, '');

-- 8. Order Reviews - Handle duplicate review_id gracefully
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv'
IGNORE INTO TABLE order_reviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@rid, @oid, @score, @title, @msg, @creation, @answer)
SET
review_id = NULLIF(@rid, ''),
order_id = NULLIF(@oid, ''),
review_score = NULLIF(@score, ''),
review_comment_title = NULLIF(@title, ''),
review_comment_message = NULLIF(@msg, ''),
review_creation_date = NULLIF(@creation, ''),
review_answer_timestamp = NULLIF(@answer, '');

-- 9. Product Category Name Translation - Handle duplicates
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv'
IGNORE INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- =====================
-- Comprehensive Data Quality Verification
-- =====================
-- Check record counts
SELECT 'customers' as table_name, COUNT(*) as record_count FROM customers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'product_category_name_translation', COUNT(*) FROM product_category_name_translation;

