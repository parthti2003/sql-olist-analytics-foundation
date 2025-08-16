# Olist Dataset Information

## Introduction

The Olist dataset is a comprehensive Brazilian e-commerce dataset that provides real commercial data from the Olist Store, a marketplace that connects small businesses to channels without hassle. This dataset offers valuable insights into e-commerce operations, customer behavior, and business performance across Brazil from 2016 to 2018.

## Main Tables Overview

### Core Business Tables

- **orders**: Central fact table containing order-level information including order ID, customer ID, status, timestamps, and delivery details
- **customers**: Dimension table with customer information including unique customer IDs, location (city, state), and geographic coordinates
- **order_items**: Fact table detailing individual items within orders, including product IDs, seller IDs, pricing, and shipping costs
- **products**: Dimension table containing product information including categories, dimensions, weight, and descriptive attributes
- **sellers**: Dimension table with seller information including seller IDs and geographic location data

### Transaction & Feedback Tables

- **order_payments**: Contains payment information for orders including payment types, installments, and values
- **order_reviews**: Customer review data including review scores, titles, comments, and timestamps
- **category_translation**: Translation table mapping Portuguese product category names to English equivalents

## Table Relationships for Analytics

### Primary Relationships
- **orders** serves as the central hub, connecting to customers (via customer_id) and linking to order_items (via order_id)
- **order_items** bridges orders to products (via product_id) and sellers (via seller_id)
- **order_payments** and **order_reviews** both link directly to orders (via order_id)
- **category_translation** provides readable category names for products (via product_category_name)

### Key Analytics Paths
1. Customer Journey: customers → orders → order_items → products
2. Seller Performance: sellers → order_items → orders → order_reviews
3. Product Analysis: products → order_items → orders → customers
4. Payment Analysis: orders → order_payments (with customer and geographic context)

## Database Structure Rationale

### Star Schema Design
The dataset follows a star schema pattern optimized for analytical queries:
- **orders** acts as the central fact table
- Dimension tables (customers, products, sellers) provide descriptive context
- Additional fact tables (order_items, order_payments, order_reviews) capture specific business events

### Key Business Relationships
- **One-to-Many**: customers → orders, sellers → order_items, products → order_items
- **Many-to-Many**: orders ↔ products (through order_items bridge table)
- **One-to-One**: orders → order_payments (in most cases)

This design enables efficient analysis of:
- Customer lifetime value and behavior patterns
- Product performance and category trends
- Seller metrics and geographic distribution
- Order fulfillment and delivery performance
- Review sentiment and rating analysis

## Data Source & Licensing

**Dataset Source**: Available on Kaggle at [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

**License**: This dataset is made available under the [CC BY-NC-SA 4.0 license](https://creativecommons.org/licenses/by-nc-sa/4.0/). Please ensure compliance with license terms when using this data for commercial purposes.

**Download Reminder**: Remember to download the complete dataset from Kaggle and place CSV files in the appropriate data directories before running analysis scripts.
