-- =============================================
-- BRAZILIAN E-COMMERCE (OLIST) DATASET ANALYSIS
-- =============================================
   
-- BUSINESS OBJECTIVE
/*

E-commerce in Brazil is growing fast. Thausannds of people use platforms like Olist to shop every day. 
With this growth, businesses need to understand sales, customers, products and delivery performance in order to make better decisions. 
SQL gives us a way to take raw transactions and turn them into useful tips. 
Every number in the dataset represents a real shopping experience: a delayed delivery means someone waiting for a package they care about, 
a cancellation or return reflects an unhappy customer, a 5-star review shows trust and a repeat purchase highlights loyalty that drives long-term revenue.

This project focuses on:
1. Checking data quality to ensure the information is complete and reliable.
2. Understanding customers by finding who buys the most, what they buy and how often they shop.
3. Measuring sales performance to see top products, peak shopping times and revenue by region.
4. Evaluating delivery speed, delays and fulfillment efficiency.
5. Analysing payment methods and installment preferences to support financial planning.
6. Identifying growth opportunities in specific product categories, states, or cities.
7. Segmenting customers by value and behavior to guide retention strategies.
8. Reviewing seller and product performance to support better inventory and partnerships.

The goal is to improve decisions that inreturn will improve the shopping experience for customers and increase growth for Olist.
*/


-- DATA COLLECTION
-- The dataset contains data of over 1 years and 11 months (Sept 2016 to Aug 2018). This dataset was collected from kaggle. Dataset link: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce.

-- CREATE TABLE STRUCTURES
-- Creates our tables to store all data
-- 1. Orders Dataset (Central table)
DROP TABLE IF EXISTS olist_orders_dataset CASCADE;
CREATE TABLE IF NOT EXISTS olist_orders_dataset (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- 2. Order Items Dataset
DROP TABLE IF EXISTS olist_order_items_dataset CASCADE;
CREATE TABLE IF NOT EXISTS olist_order_items_dataset (
    order_id VARCHAR(50),
    order_item_id INTEGER,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- 3. Order Payments Dataset
DROP TABLE IF EXISTS olist_order_payments_dataset CASCADE;
CREATE TABLE IF NOT EXISTS olist_order_payments_dataset (
    order_id VARCHAR(50),
    payment_sequential INTEGER,
    payment_type VARCHAR(20),
    payment_installments INTEGER,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

-- 4. Order Reviews Dataset
DROP TABLE IF EXISTS olist_order_reviews_dataset CASCADE;
CREATE TABLE IF NOT EXISTS olist_order_reviews_dataset (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

-- 5. Products Dataset
DROP TABLE IF EXISTS olist_products_dataset CASCADE;
CREATE TABLE IF NOT EXISTS olist_products_dataset (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

-- 6. Sellers Dataset
DROP TABLE IF EXISTS olist_sellers_dataset CASCADE;
CREATE TABLE IF NOT EXISTS olist_sellers_dataset (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(5)
);

-- 7. Customers Dataset
DROP TABLE IF EXISTS olist_order_customer_dataset CASCADE;
CREATE TABLE IF NOT EXISTS olist_order_customer_dataset (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(5)
);

-- 8. Geolocation Dataset
DROP TABLE IF EXISTS olist_geolocation_dataset CASCADE;
CREATE TABLE IF NOT EXISTS olist_geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(5),
    PRIMARY KEY (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng)
);

-- =====================================
-- STEP 1: DATA QUALITY CHECKS
-- =====================================

-- 1.1 CHECK FOR NULL VALUES ACROSS ALL TABLES
-- Checking for any shows of data completeness for each table
SELECT 
    'DATA COMPLETENESS CHECK - ORDERS' AS analysis_type,
    COUNT(*) as total_rows,
    COUNT(order_id) as order_id_count,
    COUNT(customer_id) as customer_id_count,
    COUNT(order_status) as order_status_count,
    COUNT(order_purchase_timestamp) as purchase_timestamp_count,
    COUNT(order_approved_at) as approved_timestamp_count,
    COUNT(order_delivered_carrier_date) as delivered_carrier_count,
    COUNT(order_delivered_customer_date) as delivered_customer_count,
    COUNT(order_estimated_delivery_date) as estimated_delivery_count
FROM olist_orders_dataset;

/*
Observations
* There are 96,461 complete records in the olist_orders_dataset.
* There are no missing values in important columns like order_id, customer_id or timestamps.
* All the data is present and valid for analysis.

*/

SELECT 
    'DATA COMPLETENESS CHECK - ORDER ITEMS' AS analysis_type,
    COUNT(*) as total_rows,
    COUNT(order_id) as order_id_count,
    COUNT(product_id) as product_id_count,
    COUNT(seller_id) as seller_id_count,
    COUNT(price) as price_count,
    COUNT(freight_value) as freight_count
FROM olist_order_items_dataset;

/*
Observations
* There are 112,650 complete records in the olist_order_items_dataset.
* There are no missing values in order_id, product_id, seller_id, price or freight_value.
* All order item data is fully populated.
*/

SELECT 
    'DATA COMPLETENESS CHECK - PAYMENTS' AS analysis_type,
    COUNT(*) as total_rows,
    COUNT(order_id) as order_id_count,
    COUNT(payment_type) as payment_type_count,
    COUNT(payment_installments) as installments_count,
    COUNT(payment_value) as payment_value_count
FROM olist_order_payments_dataset;

/*
Observations
* There are 103,886 complete entries in the payment records table.
* There are no missing values in order_id, payment_type, installments or payment_value.
* All payment data is fully accounted for.
*/

SELECT 
    'DATA COMPLETENESS CHECK - REVIEWS' AS analysis_type,
    COUNT(*) as total_rows,
    COUNT(review_id) as review_id_count,
    COUNT(order_id) as order_id_count,
    COUNT(review_score) as review_score_count,
    COUNT(review_comment_title) as comment_title_count,
    COUNT(review_comment_message) as comment_message_count
FROM olist_order_reviews_dataset;
/*
Observations
* There are 98,406 complete records in the reviews dataset.
* There are no missing review scores.
* All essential review data, including scores, comments and timestamps is properly recorded.
*/

-- 1.2 CHECK FOR ORPHANED RECORDS (Data Integrity)
-- Identifies records that don't have matching foreign keys
SELECT 
    'ORPHANED RECORDS CHECK' AS check_type,
    orphan_type,
    orphan_count
FROM (
    SELECT 'Orders without Customer Info' as orphan_type, 
           COUNT(*) as orphan_count
    FROM olist_orders_dataset o
    LEFT JOIN olist_order_customer_dataset c ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL
    
    UNION ALL
    
    SELECT 'Order Items without Order Info',
           COUNT(*)
    FROM olist_order_items_dataset oi
    LEFT JOIN olist_orders_dataset o ON oi.order_id = o.order_id
    WHERE o.order_id IS NULL
    
    UNION ALL
    
    SELECT 'Order Items without Product Info',
           COUNT(*)
    FROM olist_order_items_dataset oi
    LEFT JOIN olist_products_dataset p ON oi.product_id = p.product_id
    WHERE p.product_id IS NULL
    
    UNION ALL
    
    SELECT 'Order Items without Seller Info',
           COUNT(*)
    FROM olist_order_items_dataset oi
    LEFT JOIN olist_sellers_dataset s ON oi.seller_id = s.seller_id
    WHERE s.seller_id IS NULL
) orphan_analysis
ORDER BY orphan_count DESC;

/*
Observations
* The data quality check reveals that there are 2,470 order items that do not have a corresponding order record in the system. 
  These orphaned records likely correspond to canceled, invalidated or unfulfilled orders. They can be excluded 
  from analyses measuring fulfilled sales volume but retaining them for potential cancellation or data integrity analysis will be better.
* No other orphaned records were found and all orders have customer info and all order items have valid seller and product information. 
  This indicates strong referential integrity across most of the dataset.
*/

-- 1.3 CHECK FOR DATA QUALITY ISSUES
-- Identifies invalid or suspicious data values
SELECT 
    'DATA QUALITY ISSUES' AS analysis_section,
    issue_type,
    count AS problematic_records
FROM (
    SELECT 'Negative Prices' as issue_type, COUNT(*) as count
    FROM olist_order_items_dataset WHERE price < 0
    UNION ALL
    SELECT 'Negative Freight Values' as issue_type, COUNT(*) as count
    FROM olist_order_items_dataset WHERE freight_value < 0
    UNION ALL
    SELECT 'Zero Payment Values' as issue_type, COUNT(*) as count
    FROM olist_order_payments_dataset WHERE payment_value <= 0
    UNION ALL
    SELECT 'Invalid Review Scores (not 1-5)' as issue_type, COUNT(*) as count
    FROM olist_order_reviews_dataset WHERE review_score < 1 OR review_score > 5
    UNION ALL
    SELECT 'Orders Delivered Before Purchase' as issue_type, COUNT(*) as count
    FROM olist_orders_dataset WHERE order_delivered_customer_date < order_purchase_timestamp
    UNION ALL
    SELECT 'Approved Before Purchase' as issue_type, COUNT(*) as count
    FROM olist_orders_dataset WHERE order_approved_at < order_purchase_timestamp
) quality_check
ORDER BY count DESC;
/*
Observations
There are data quality issues in the dataset:
* Zero payment values found in 9 records.
* No issues found for approved before purchase, orders delivered before purchase, invalid review scores, negative prices or negative freight values.
- Let drop the zero payment values because it marks no sense, Unless the item was offered for free which is impossible.
*/
-- Check and confirm then we delete them
SELECT *
FROM olist_order_payments_dataset
WHERE payment_value <= 0;

DELETE FROM olist_order_payments_dataset
WHERE payment_value <= 0;

-- 1.4 DUPLICATE ORDERS
-- Checking if there multiple 'order_id' entries that are exactly the same.
SELECT order_id, 
	COUNT(*) 
	FROM olist_orders_dataset 
	GROUP BY order_id HAVING COUNT(*) > 1;
/*
Observations
There are no duplicate order records
*/

-- 1.5 LOGICAL INCONSISTENCIES
-- Checking if there were orders marked as 'delivered' but missing a delivery timestamp
SELECT * 
	FROM olist_orders_dataset 
	WHERE order_status = 'delivered' AND order_delivered_customer_date IS NULL;
/*
Observations
There are no search records
*/

-- =====================================
-- STEP 2: DATASET EXPLORATION
-- =====================================

-- 2.1  DATASET OVERVIEW
-- High-level statistics about the e-commerce platform
SELECT 
    'DATASET OVERVIEW' AS analysis_section,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COUNT(DISTINCT oi.product_id) AS unique_products,
    COUNT(DISTINCT oi.seller_id) AS unique_sellers,
    COUNT(DISTINCT c.customer_city) AS cities_served,
    COUNT(DISTINCT c.customer_state) AS states_served,
    ROUND(AVG(oi.price + oi.freight_value), 2) AS avg_order_item_value,
    MIN(o.order_purchase_timestamp::date) AS earliest_order_date,
    MAX(o.order_purchase_timestamp::date) AS latest_order_date
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_order_customer_dataset c ON o.customer_id = c.customer_id;

/*
Observations
* There are 96,461 total orders in the dataset, which were placed by an equal number of unique customers. The orders consist of 32,210 different products sold by 2,970 unique sellers. 
* The service area covers 4,085 cities across 27 states. The average value of an item in an order is approximately $139.93 and the orders span from September 15, 2016 to August 29, 2018.
*/

-- 2.2 ORDER STATUS DISTRIBUTION
-- Shows the distribution of order statuses
SELECT 
    'ORDER STATUS DISTRIBUTION' AS analysis_section,
    order_status,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_orders_dataset), 2) AS percentage_of_total
FROM olist_orders_dataset 
GROUP BY order_status 
ORDER BY order_count DESC;

/*
Observations
* There is an extremely high order delivery rate, with 99.99% of all orders (96,455) successfully delivered. Only a small fraction of 0.01% (6 orders) were canceled.
*/

-- 2.3 PAYMENT METHOD ANALYSIS
-- Analysis of payment preferences
SELECT 
    'PAYMENT METHOD ANALYSIS' AS analysis_section,
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset), 2) AS percentage,
    ROUND(AVG(payment_value), 2) AS avg_payment_value,
    ROUND(AVG(payment_installments), 1) AS avg_installments,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM olist_order_payments_dataset 
GROUP BY payment_type 
ORDER BY payment_count DESC;

/*
Observations
* There is a clear and overwhelming preference for credit cards as the primary payment method, accounting for 73.93% of all transactions (76,795 payments). 
  The average credit card transaction value is also the highest at $163.32, and customers typically use them for larger purchases spread over an average of 3.5 installments.

* Boleto is the second most popular method (19.05% of payments) with a relatively high average transaction value of $145.03, though it is always paid in a single installment. 
  Debit cards and vouchers are used far less frequently, making up just 1.47% and 5.55% of payments respectively. Vouchers have a significantly lower average transaction value of $65.77.
*/

-- 2.4 REVIEW SCORE DISTRIBUTION
-- Customer satisfaction analysis
SELECT 
    'REVIEW SCORE DISTRIBUTION' AS analysis_section,
    review_score,
    COUNT(*) AS review_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_order_reviews_dataset WHERE review_score IS NOT NULL), 2) AS percentage,
    CASE 
        WHEN review_score >= 4 THEN 'Positive'
        WHEN review_score = 3 THEN 'Neutral'
        ELSE 'Negative'
    END AS satisfaction_category
FROM olist_order_reviews_dataset 
WHERE review_score IS NOT NULL
GROUP BY review_score 
ORDER BY review_score DESC;

/*
Observations
* There is a predominantly positive customer sentiment with the vast majority of reviews being highly favorable. Over 77% of all reviews are positive (scores of 5 or 4), 
  and more than half of all reviews (57.83%) are the highest possible score of 5.

* Neutral reviews (score of 3) make up 8.23% of the total. Negative sentiment is present in 14.62% of reviews, with a notably higher proportion of customers giving the
  lowest score of 1 (11.46%) compared to a score of 2 (3.16%).
*/

-- 2.5 TOP PRODUCT CATEGORIES
-- Most popular product categories
SELECT 
    'TOP 15 PRODUCT CATEGORIES' AS analysis_section,
    p.product_category_name,
    COUNT(*) AS items_sold,
    COUNT(DISTINCT oi.order_id) AS orders_containing_category,
    ROUND(AVG(oi.price), 2) AS avg_item_price,
    ROUND(SUM(oi.price), 2) AS total_category_revenue,
    COUNT(DISTINCT oi.seller_id) AS sellers_in_category
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name 
ORDER BY items_sold DESC
LIMIT 15;

/*
Observations
* There is a diverse and active product catalog with bed_bath_table (cama_mesa_banho) being the top category by number of items sold (11,115). 
  However, health_beauty (beleza_saude) generates the highest total revenue at $1,258,681.34.

* The watches_gifts (relogios_presentes) category stands out for having the highest average item price at $201.14 which also contributes to it 
  being the third highest category by total revenue. Conversely, the electronics (eletronicos) category has the lowest average item price at $57.91.

* The health_beauty category also has the highest number of unique sellers (492), indicating a competitive and well-stocked marketplace. Overall, 
  the data shows strong performance in lifestyle, home, and personal goods categories.
*/

-- 2.6 CUSTOMER BEHAVIORAL INSIGHTS - Purchase Timing Analysis
-- Understanding WHEN customers shop
SELECT 
    'CUSTOMER SHOPPING PATTERNS' AS analysis_section,
    EXTRACT(DOW FROM order_purchase_timestamp) AS day_of_week,
    CASE 
        WHEN EXTRACT(DOW FROM order_purchase_timestamp) = 0 THEN 'Sunday'
        WHEN EXTRACT(DOW FROM order_purchase_timestamp) = 1 THEN 'Monday'
        WHEN EXTRACT(DOW FROM order_purchase_timestamp) = 2 THEN 'Tuesday'
        WHEN EXTRACT(DOW FROM order_purchase_timestamp) = 3 THEN 'Wednesday'
        WHEN EXTRACT(DOW FROM order_purchase_timestamp) = 4 THEN 'Thursday'
        WHEN EXTRACT(DOW FROM order_purchase_timestamp) = 5 THEN 'Friday'
        WHEN EXTRACT(DOW FROM order_purchase_timestamp) = 6 THEN 'Saturday'
    END AS day_name,
    EXTRACT(HOUR FROM order_purchase_timestamp) AS hour_of_day,
    COUNT(*) AS order_count,
    ROUND(AVG(order_total.total_value), 2) AS avg_order_value
FROM olist_orders_dataset o
JOIN (
    SELECT order_id, SUM(price + freight_value) AS total_value
    FROM olist_order_items_dataset
    GROUP BY order_id
) order_total ON o.order_id = order_total.order_id
WHERE order_purchase_timestamp IS NOT NULL
GROUP BY EXTRACT(DOW FROM order_purchase_timestamp), EXTRACT(HOUR FROM order_purchase_timestamp)
ORDER BY day_of_week, hour_of_day;

/*
Observations
* There is a consistent pattern in customer shopping behavior with order volume heavily concentrated during standard waking and business hours, peaking in the late afternoon and evening.
   * Peak Shopping Hours:* The highest order volumes consistently occur between 10:00 and 22:00 (10 AM - 10 PM) with a particularly strong period from 14:00 to 21:00 (2 PM - 9 PM) on weekdays.
   * Weekday vs. Weekend:* Weekdays (Monday-Friday) generally see higher order volumes than weekends, with Monday and Tuesday afternoons being especially busy with over 1,000 orders per hour.
   * Lowest Activity: Order volume drops significantly during the early morning hours between 0:00 and 8:00 (midnight - 8 AM), with the lowest activity between 3:00 and 5:00 AM.
   * Spending Consistency: The average order value remains relatively stable throughout the day and across days of the week, typically fluctuating between $140 and $170, indicating that time
     of day influences purchase frequency but not necessarily the spend amount per order.
*/

-- 2.7 CUSTOMER PREFERENCES BY DEMOGRAPHICS
-- What products customers prefer by location
SELECT 
    'CUSTOMER PREFERENCES BY LOCATION' AS analysis_section,
    c.customer_state,
    p.product_category_name,
    COUNT(*) AS items_purchased,
    ROUND(SUM(oi.price), 2) AS total_spent,
    ROUND(AVG(oi.price), 2) AS avg_item_price,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY c.customer_state), 2) AS category_preference_percentage
FROM olist_order_customer_dataset c
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_products_dataset p ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY c.customer_state, p.product_category_name
HAVING COUNT(*) >= 50  -- States with significant volume
ORDER BY c.customer_state, items_purchased DESC;

/*
Observations
There are significant and distinct regional purchasing patterns across Brazilian states, with home goods, health/beauty, and tech accessories being consistently popular, but with 
notable local variations in category preference and spending:

   * Dominant Categories:* *Bed/Bath/Table (cama_mesa_banho)* and *Health/Beauty (beleza_saude)* are top categories in most states this indicating nationwide demand for home and 
     personal care products.
   * High-Value Categories: The Watches/Gifts (relogios_presentes) category consistently commands the highest average item price across nearly all states where it appears 
     (e.g., ~$221 in DF, ~$207 in RS, ~$189 in SP) making it a key revenue driver despite lower purchase volumes.
   * Regional Variations:
       * Smaller States (like, AL, PI, RN): Show a remarkable concentration with 100% of the tracked purchases in a single category (Health/Beauty) which suggesting more niche demand or 
	     smaller sample sizes.
       *Larger States (like, SP, MG, RJ): Exhibit highly diversified demand with significant spending across over 20 different categories that reflecting their larger and more varied consumer bases.
   * Tech vs. Home: A pattern emerges in larger states like São Paulo (SP) and Minas Gerais (MG) where purchases are heavily skewed towards Home & Lifestyle categories (Bed/Bath, Decor, Utilities) 
     over Technology (Computers, Electronics) highlighting a consumer preference for domestic goods.
   * Economic Indicators: States with higher spending on categories like Tools/Garden (ferramentas_jardim) and Automotive (automotivo) like SP and MG, might indicate stronger commercial or 
     DIY activity.
*/

-- =====================================
-- STEP 3: TEMPORAL ANALYSIS
-- =====================================

-- 3.1 MONTHLY SALES TRENDS
-- Revenue and order trends over time
SELECT 
    'MONTHLY SALES TRENDS' AS analysis_section,
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT o.order_id) AS orders_count,
    COUNT(oi.order_item_id) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight_revenue,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(AVG(oi.price + oi.freight_value), 2) AS avg_order_item_value
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
ORDER BY order_month;

/*
Observations
There is a pattern of strong and sustained business growth with a major peak in sales during the November 2017 holiday season:

   * Significant Growth: The business experienced tremendous growth from its inception in late 2016. Monthly revenue grew from ~$47k in October 2016 to consistently over $1 million per month 
     from November 2017 onwards.
   * Holiday Peak: The highest sales month by a considerable margin was November 2017 which generated over $1.15 million in revenue. This aligns with Black Friday and Christmas shopping trends 
     which indicating the platform's importance for holiday purchases.
   * Stable Performance: After the late-2017 surge, sales entered a period of remarkable stability. From January to August 2018, monthly revenue fluctuated within a relatively tight band between
     ~$966k and ~$1.13 million demonstrating consistent market demand.
   * Freight Contribution: Shipping costs (freight) are a significant revenue stream, consistently accounting for roughly 13-16% of the total monthly revenue.
   * Average Order Value: The average value of an item sold remained relatively stable throughout the period typically ranging between $128 and $152 with no drastic long-term inflation or deflation.
     The peak in November 2017 saw a slightly lower average item value ($136.09) suggesting a higher volume of smaller-ticket items or promotions during the sales period.
*/

-- 3.2 SEASONAL ANALYSIS
-- Sales patterns by season and month
SELECT 
    'SEASONAL ANALYSIS' AS analysis_section,
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS order_month,
    TO_CHAR(o.order_purchase_timestamp, 'Month') AS month_name,
    COUNT(DISTINCT o.order_id) AS orders_count,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(AVG(oi.price + oi.freight_value), 2) AS avg_order_value,
    CASE 
        WHEN EXTRACT(MONTH FROM o.order_purchase_timestamp) IN (12, 1, 2) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM o.order_purchase_timestamp) IN (3, 4, 5) THEN 'Autumn'
        WHEN EXTRACT(MONTH FROM o.order_purchase_timestamp) IN (6, 7, 8) THEN 'Winter'
        ELSE 'Spring'
    END AS season
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY EXTRACT(MONTH FROM o.order_purchase_timestamp), TO_CHAR(o.order_purchase_timestamp, 'Month')
ORDER BY order_month;

/*
Observations
There is a strong seasonal pattern to sales performance with the highest revenue concentrated in the autumn and winter months (March through August), while the spring months 
(September through November) show a more mixed performance and summer (December-February) is relatively lower outside of a holiday spike:

   * Peak Season: Autumn (March-May) is the strongest quarter, generating the highest total revenue (~$4.76 million across the three months) and featuring the month with the highest average order
     value (April at $146.57). This suggests a period of huge consumer spending.
   * Strong Winter: Winter (June-August) is also a very strong period, with the highest number of orders (~29.8k) and consistently high total revenue (~$4.73 million) that indicating sustained 
    demand.
   * Holiday Impact in Spring: Spring (September-November) shows a dramatic split. November's revenue ($1.15 million) is significantly higher than September and October, clearly driven by the 
     Black Friday/Cyber Monday holiday. This indicates that spring's performance is heavily dependent on promotional events.
   * Summer Lull: Summer (December-February) has the lowest collective revenue outside of the holiday-influenced December. February has the lowest average order value ($131.95) that suggesting a
     period of reduced purchasing activity or a focus on lower-value items.
   * Consistent Spending: Despite seasonal fluctuations, the average order value remains relatively stable throughout the year (ranging from $131.95 to $147.93) that indicating that seasonal 
     changes affect purchase 'frequency' more than the average 'amount' spent per order.
*/

-- 3.3 MONTH-OVER-MONTH GROWTH ANALYSIS
-- Growth opportunities identification
WITH monthly_metrics AS (
    SELECT 
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        COUNT(DISTINCT o.order_id) AS monthly_orders,
        COUNT(DISTINCT o.customer_id) AS monthly_customers,
        COUNT(oi.order_item_id) AS monthly_items,
        ROUND(SUM(oi.price + oi.freight_value), 2) AS monthly_revenue
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_purchase_timestamp IS NOT NULL
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)
SELECT 
    'MONTH-OVER-MONTH GROWTH ANALYSIS' AS analysis_section,
    order_month,
    monthly_orders,
    monthly_customers,
    monthly_revenue,
    ROUND(((monthly_orders - LAG(monthly_orders) OVER (ORDER BY order_month)) * 100.0 / 
           NULLIF(LAG(monthly_orders) OVER (ORDER BY order_month), 0)), 2) AS orders_growth_percentage,
    ROUND(((monthly_customers - LAG(monthly_customers) OVER (ORDER BY order_month)) * 100.0 / 
           NULLIF(LAG(monthly_customers) OVER (ORDER BY order_month), 0)), 2) AS customers_growth_percentage,
    ROUND(((monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY order_month)) * 100.0 / 
           NULLIF(LAG(monthly_revenue) OVER (ORDER BY order_month), 0)), 2) AS revenue_growth_percentage
FROM monthly_metrics
ORDER BY order_month;

/*
Observations
There is a period of explosive initial growth followed by a transition into a phase of maturity with more stable but volatile, performance and a noticeable seasonal pattern:

   * Initial Hyper-Growth: The platform experienced astronomical percentage growth from its very first orders in late 2016 into early 2017 (e.g., a 26,900% increase in orders from Sept to Oct 2016). 
     This reflects the launch phase and early market adoption.
   * Transition to Maturity: After mid-2017, the extreme growth rates subsided. The business entered a phase where month-over-month changes became more moderate, typically fluctuating between -10%
     and +25% for orders and revenue indicating a shift from a startup to an established operation.
   * Significant Seasonal Peaks and Troughs:** The data reveals a consistent pattern of major spikes and drops:
       * Peak: November 2017 shows a massive 62.75% growth in orders, clearly driven by holiday shopping (Black Friday/Cyber Monday).
       * Trough: This is consistently followed by a sharp contraction in December (e.g, -24.36% in 2017) indicating a post-holiday slowdown.
   * Recent Volatility: The first half of 2018 showed a pattern of slight growth followed by contraction (e.g., growth in March, a drop in April/May, and a sharper drop in June) suggesting the 
     market is settling but remains sensitive to seasonal and economic factors. The period ends with nearly flat growth in July and a slight decline in revenue in August 2018 hinting at potential
	 market saturation or increased competition.
*/
-- =====================================
-- STEP 4: GEOGRAPHIC ANALYSIS
-- =====================================

-- 4.1 SALES BY STATE
-- Geographic distribution of sales
SELECT 
    'SALES BY STATE' AS analysis_section,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS orders_count,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(AVG(oi.price + oi.freight_value), 2) AS avg_order_value,
    ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.customer_id), 2) AS revenue_per_customer
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_order_customer_dataset c ON o.customer_id = c.customer_id
GROUP BY c.customer_state 
ORDER BY total_revenue DESC;

/*
Observations
There is a massive concentration of sales in the southeastern states, but customers in the northern and northeastern regions tend to spend significantly more per order and per capita.

   * Market Dominance: The state of São Paulo (SP) is the undisputed leader, accounting for 40,489 orders and generating over $5.76 million in revenue, which is nearly three times the revenue 
     of the next highest state (RJ). This indicates SP is the main market.
   * Southeast Concentration: The southeastern states (SP, RJ, MG, ES) collectively generate the vast majority of the company's revenue, highlighting a strong geographic concentration of its 
     customer base.
   * Higher Spending in Smaller States: While large states drive volume, customers in **smaller states consistently spend more**.
    *   The *highest Average Order Value (AOV)* is in Paraíba (PB) at $235.22, followed by Pará (PA) and Piauí (PI), both over $201.
    *   The *highest Revenue Per Customer* is also in PB ($266.61), with Acre (AC) and Amapá (AP) also showing very high values.
   * Regional Patterns: This suggests that in less densely populated or more remote states, customers may make fewer but larger purchases, possibly consolidating needs into single, higher-value 
     orders. In contrast, high-volume states like SP see more frequent but smaller-value transactions.
   * Revenue vs. Volume: States like Rio de Janeiro (RJ) and Minas Gerais (MG) have high total revenue due to high order volume, but their AOV is closer to the national average. Meanwhile, a state
     like Bahia (BA) cracks the top 10 for total revenue despite a middling order count because of its high AOV ($160.50).
*/

-- 4.2 TOP CITIES BY REVENUE
-- Most valuable cities for the business
SELECT 
    'TOP 20 CITIES BY REVENUE' AS analysis_section,
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS orders_count,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(AVG(oi.price + oi.freight_value), 2) AS avg_order_value
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_order_customer_dataset c ON o.customer_id = c.customer_id
GROUP BY c.customer_city, c.customer_state
ORDER BY total_revenue DESC
LIMIT 20;
/*
Observations            
There is an overwhelming dominance of major metropolitan areas in driving revenue, with the cities of São Paulo and Rio de Janeiro alone accounting for a colossal share of total sales.

   * Metro Dominance: The top 20 cities are all major state capitals or large metropolitan areas, confirming that urban centers are the primary engine of the business.
   * São Paulo's Hegemony: The city of São Paulo is in a league of its own generating over $2.1 million in revenue from 15,044 orders. This is nearly double the revenue of the second-ranked city, 
     Rio de Janeiro, and represents a significant portion of the national total.
   * High-Value Cities: While São Paulo leads in volume, other cities show a higher propensity to spend per transaction.
    *   Beloém (PA) has the highest *Average Order Value (AOV)* on the list at $196.03.
    *   Fortaleza (CE) ($162.75), Recife (PE) ($159.75) and Salvador (BA) ($152.96) also demonstrate significantly higher AOVs than the top volume cities like São Paulo ($121.14).
   * State Capital Concentration: A majority of the top cities are state capitals (like, Rio de Janeiro, Belo Horizonte, Brasília, Curitiba, Porto Alegre, Salvador, Goiania, Fortaleza, Recife, 
     Belém, Florianópolis) are highlighting the importance of focusing on these economic hubs.
   * São Paulo State Saturation: The list is heavily represented by cities within the state of São Paulo (e.g., São Paulo, Campinas, Guarulhos, São Bernardo do Campo, Santos, Santo Andre, Osasco, 
     Jundiai) with underscoring the state's immense economic density and consumer base.
*/

-- 4.3 UNDERSERVED GEOGRAPHIC MARKETS
-- Identify cities with high potential but low penetration 
WITH city_metrics AS (
    SELECT 
        g.geolocation_city,
        g.geolocation_state,
        COUNT(DISTINCT c.customer_unique_id) AS customer_count,
        COALESCE(COUNT(DISTINCT o.order_id), 0) AS order_count,
        COALESCE(ROUND(SUM(oi.price + oi.freight_value), 2), 0) AS total_revenue
    FROM olist_geolocation_dataset g
    LEFT JOIN olist_order_customer_dataset c ON g.geolocation_zip_code_prefix = c.customer_zip_code_prefix
    LEFT JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
    LEFT JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    GROUP BY g.geolocation_city, g.geolocation_state
),
state_avg AS (
    SELECT 
        geolocation_state,
        AVG(total_revenue) AS state_avg_revenue,
        AVG(customer_count) AS state_avg_customers
    FROM city_metrics
    GROUP BY geolocation_state
)
SELECT 
    'EXPANSION OPPORTUNITIES' AS analysis_section,
    cm.geolocation_city,
    cm.geolocation_state,
    cm.customer_count,
    cm.order_count,
    cm.total_revenue,
    CASE 
        WHEN cm.customer_count > sa.state_avg_customers AND cm.total_revenue < sa.state_avg_revenue THEN 'High Potential - Low Penetration'
        WHEN cm.customer_count > sa.state_avg_customers AND cm.order_count = 0 THEN 'Untapped Market'
        WHEN cm.total_revenue > sa.state_avg_revenue THEN 'Strong Market'
        ELSE 'Standard Market'
    END AS market_opportunity
FROM city_metrics cm
JOIN state_avg sa ON cm.geolocation_state = sa.geolocation_state
WHERE cm.customer_count > 0
ORDER BY cm.customer_count DESC, cm.total_revenue DESC
LIMIT 15;

/*
Observations
There is a framework for geographic expansion that reveals three distinct market segments that dictate different approaches. The data shows that while a few main states dominate current revenue, 
significant untapped potential exists in underserved regions where customers exhibit a willingness to spend more per order.

* Strong Markets like São Paulo (SP), Rio de Janeiro (RJ) and Minas Gerais (MG) are the current revenue powerhouses generating the vast majority of sales. These regions have a mature customer 
   base and require strategies focused on retention and optimisation like improving delivery efficiency and introducing loyalty programs to increase customer lifetime value.

* Standard Markets, including Santa Catarina (SC) and Goiás (GO) that show steady performance with a solid foundation for growth. The strategy here should be targeted growth through localised 
  marketing and product offerings to convert more of the addressable market.

* High Potential - Low Penetration Markets represent the most significant strategic opportunity. States like Pará (PA), Piauí (PI) and Alagoas (AL) have a lower volume of orders but remarkably 
  high average order values and revenue per customer. This indicates a latent demand for the platform's offerings. The focus must be on aggressive market penetration by investing in logistics to 
  ensure reliable service and launching targeted digital marketing campaigns to build brand awareness and trust in these regions.
*/
-- =====================================
-- STEP 5: DELIVERY PERFORMANCE ANALYSIS
-- =====================================

-- 5.1 DELIVERY TIME ANALYSIS
-- Performance metrics for order fulfillment
WITH delivery_metrics AS (
    SELECT 
        order_id,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date,
        EXTRACT(DAY FROM (order_approved_at - order_purchase_timestamp)) AS approval_time_days,
        EXTRACT(DAY FROM (order_delivered_carrier_date - order_approved_at)) AS carrier_time_days,
        EXTRACT(DAY FROM (order_delivered_customer_date - order_delivered_carrier_date)) AS delivery_time_days,
        EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp)) AS total_delivery_time_days,
        EXTRACT(DAY FROM (order_delivered_customer_date - order_estimated_delivery_date)) AS delivery_delay_days
    FROM olist_orders_dataset
    WHERE order_delivered_customer_date IS NOT NULL
        AND order_purchase_timestamp IS NOT NULL
)
SELECT 
    'DELIVERY PERFORMANCE METRICS' AS analysis_section,
    COUNT(*) AS delivered_orders,
    ROUND(AVG(approval_time_days), 2) AS avg_approval_time_days,
    ROUND(AVG(carrier_time_days), 2) AS avg_carrier_pickup_days,
    ROUND(AVG(delivery_time_days), 2) AS avg_delivery_time_days,
    ROUND(AVG(total_delivery_time_days), 2) AS avg_total_delivery_days,
    ROUND(AVG(delivery_delay_days), 2) AS avg_delay_days,
    COUNT(CASE WHEN delivery_delay_days > 0 THEN 1 END) AS delayed_orders,
    ROUND(COUNT(CASE WHEN delivery_delay_days > 0 THEN 1 END) * 100.0 / COUNT(*), 2) AS delayed_orders_percentage
FROM delivery_metrics;
/*
Observations
There is an exceptionally efficient and reliable delivery operation, with the vast majority of orders being delivered significantly faster than the  estimated timeframe:
   * High On-Time Performance:  An impressive 93.23% of orders (89,927) were delivered without delay indicating an impressive highly effective logistics network.
   * Exceptional Speed: The average delivery is completed in 9 days, which is 11 days faster than the estimated delivery promise (avg_total_delivery_days). This means customers 
      are receiving their orders, on average, 11 days sooner than they were told to expect them.
   * Streamlined Processing: The internal processes are highly efficient with a very short average order approval time of only 0.27 days (approx. 6.5 hours) and a swift carrier pickup
	  time of 2 days after approval.
   * Minimal Delays: While 6.8% of orders (6,534) were delayed the overall performance metric is overwhelmingly positive as the average for all orders is a significant early delivery. 
     This suggests delays are the exception rather than the rule.
*/

-- 5.2 DELIVERY PERFORMANCE BY STATE
-- How delivery performance varies by location
WITH delivery_by_state AS (
    SELECT 
        c.customer_state,
        o.order_id,
        EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) AS total_delivery_days,
        CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END AS is_delayed
    FROM olist_orders_dataset o
    JOIN olist_order_customer_dataset c ON o.customer_id = c.customer_id
    WHERE o.order_delivered_customer_date IS NOT NULL
        AND o.order_purchase_timestamp IS NOT NULL
        AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT 
    'DELIVERY PERFORMANCE BY STATE' AS analysis_section,
    customer_state,
    COUNT(*) AS delivered_orders,
    ROUND(AVG(total_delivery_days), 2) AS avg_delivery_days,
    SUM(is_delayed) AS delayed_orders,
    ROUND(SUM(is_delayed) * 100.0 / COUNT(*), 2) AS delay_rate_percentage
FROM delivery_by_state
GROUP BY customer_state
HAVING COUNT(*) >= 100  -- States with at least 100 orders
ORDER BY delay_rate_percentage DESC;
/*
Observations
There is a significant and stark disparity in delivery performance across different states with a clear inverse relationship between order volume and delivery times. While high-volume states
enjoy fast and reliable service, customers in lower-volume, often more remote states, experience considerably longer waits and higher rates of delay.

*   Volume Correlates with Efficiency: The largest markets, São Paulo (SP) and Minas Gerais (MG), have the best performance. SP boasts the fastest average delivery (8.3 days) and one of the 
    lowest delay rates (5.89%), while MG and Paraná (PR) also show strong metrics. This suggests a highly optimized logistics network in core, high-density areas.

*   Geographic Disadvantage: States with the worst delivery times and highest delay rates are predominantly in the North and Northeast regions. Alagoas (AL) has the highest delay rate (23.93%) 
    and one of the longest average delivery times (24 days). Maranhão (MA), Piauí (PI) and Ceará (CE) also show very high delay rates (over 15%) and long delivery times (over 18 days), highlighting 
	a major logistical challenge in serving these areas.

*   The High-Cost, Low-Volume Challenge: The data reveals a critical pain point: the High Potential - Low Penetration markets identified earlier (like AL, MA, PI, CE) are the same states suffering 
    from the poorest delivery performance. This creates a significant barrier to entry and growth, as slow and unreliable shipping can deter customer acquisition and retention in these promising 
	regions.

*   Performance Spectrum: The data forms a clear spectrum:
    *   Best: SP, MG, PR (Fast, Reliable)
    *   Middle: RS, SC, GO, DF (Moderate)
    *   Worst: AL, MA, PI, CE, PA (Slow, Unreliable)
This indicates that improving logistics infrastructure and carrier partnerships in the North and Northeast is essential for unlocking the full growth potential in these underserved markets.
*/

-- =====================================
-- STEP 6: CUSTOMER BEHAVIOR ANALYSIS
-- =====================================

-- 6.1 CUSTOMER LIFETIME VALUE ANALYSIS
-- Customer segmentation based on purchase behavior
WITH customer_metrics AS (
    SELECT 
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(oi.order_item_id) AS total_items_purchased,
        ROUND(SUM(oi.price + oi.freight_value), 2) AS total_spent,
        ROUND(AVG(oi.price + oi.freight_value), 2) AS avg_order_item_value,
        MIN(o.order_purchase_timestamp) AS first_order_date,
        MAX(o.order_purchase_timestamp) AS last_order_date,
        EXTRACT(DAY FROM (MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp))) AS customer_lifetime_days
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT 
    'CUSTOMER SEGMENTATION' AS analysis_section,
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spent), 2) AS avg_customer_value,
    ROUND(AVG(total_orders), 1) AS avg_orders_per_customer,
    ROUND(AVG(customer_lifetime_days), 1) AS avg_customer_lifetime_days
FROM (
    SELECT *,
        CASE 
            WHEN total_spent >= 1000 THEN 'High Value'
            WHEN total_spent >= 300 THEN 'Medium Value'
            WHEN total_spent >= 100 THEN 'Low Value'
            ELSE 'Very Low Value'
        END AS customer_segment
    FROM customer_metrics
) segmented_customers
GROUP BY customer_segment
ORDER BY avg_customer_value DESC;
/*
Observations
1. There are 459 high-value customers who spend an average of R$1,580 each. They make up a small group but bring in a large share of revenue. 
   They need exclusive offers, priority support and personalised engagement to keep them loyal.
2. There are 47,901 medium-value customers spending about R$165 each. They form the core customer base. Growth here depends on cross-selling and stronger retention.
3. There are 60,220 low-value customers spending about R$60. They are likely one-time buyers or price-sensitive. Targeted promotions can help increase their purchase frequency.
4. There are 10 very low-value customers with almost no spending impact. They may be inactive or unsatisfied, so reactivation should be weighed against cost.
5. There is a clear 80/20 effect. A small high-value group drives most of the revenue. Focusing on premium retention for them, while building value among medium and low tiers would optimise returns.
*/

-- 6.2 REPEAT CUSTOMER ANALYSIS
-- Understanding true customer retention using customer_unique_id
WITH customer_order_summary AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MIN(o.order_purchase_timestamp) AS first_order_date,
        MAX(o.order_purchase_timestamp) AS last_order_date,
        SUM(oi.price + oi.freight_value) AS total_lifetime_value,
        -- Check if a customer made a purchase after their first order
        CASE 
            WHEN COUNT(DISTINCT o.order_id) > 1 THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS customer_type
    FROM olist_order_customer_dataset c
    JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status NOT IN ('canceled', 'unavailable') -- Filter out invalid orders
    GROUP BY c.customer_unique_id
)
SELECT 
    'TRUE CUSTOMER RETENTION ANALYSIS' AS analysis_section,
    customer_type,
    COUNT(*) AS number_of_customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_order_summary), 2) AS percent_of_customers,
    ROUND(AVG(total_orders), 2) AS avg_orders,
    ROUND(AVG(total_lifetime_value), 2) AS avg_lifetime_value,
    ROUND(AVG(EXTRACT(DAY FROM (last_order_date - first_order_date))), 2) AS avg_customer_lifespan_days
FROM customer_order_summary
GROUP BY customer_type
ORDER BY customer_type;
/* 
Observations:
* The customer base is overwhelmingly composed of one-time buyers (97%). However, the small segment of repeat customers (3%) is significantly more valuable, 
  placing more orders and spending nearly twice as much. This highlights a substantial revenue opportunity: a small increase in the repeat customer rate would 
  have a disproportionate positive impact on overall revenue. Initiatives should focus on post-purchase engagement, loyalty programs, and targeted win-back campaigns
*/

-- FOLLOW-UP 6.2.1: REPEAT CUSTOMER BEHAVIOR
WITH repeat_customers AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        MIN(o.order_purchase_timestamp) AS first_order_date,
        MAX(o.order_purchase_timestamp) AS last_order_date,
        SUM(oi.price + oi.freight_value) AS total_lifetime_value,
        -- Calculate the average days between their orders
        ROUND(EXTRACT(DAY FROM (MAX(o.order_purchase_timestamp) - MIN(o.order_purchase_timestamp)) / NULLIF(COUNT(DISTINCT o.order_id) - 1, 0)), 2) AS avg_days_between_orders
    FROM olist_order_customer_dataset c
    JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) > 1 -- Only repeat customers
)
SELECT
    'REPEAT CUSTOMER BEHAVIOR' AS analysis_section,
    COUNT(*) AS number_of_repeat_customers,
    ROUND(AVG(total_orders), 2) AS avg_orders,
    ROUND(AVG(total_lifetime_value), 2) AS avg_lifetime_value,
    ROUND(AVG(avg_days_between_orders), 2) AS avg_days_to_repeat,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY avg_days_between_orders) AS median_days_to_repeat
FROM repeat_customers;

/*
Observations
Repeat customers placed an average of 2.11 orders and spent R$308.53. On average, they took 81 days to make 
a repeat purchase, though half returned within 32 days. This shows a significant opportunity to re-engage 
customers within the first month after their initial order.
*/

-- FOLLOW-UP 6.2.2: PRODUCT CATEGORY PREFERENCE BY CUSTOMER TYPE
WITH customer_types AS (
    -- First, classify each unique customer
    SELECT 
        c.customer_unique_id,
        CASE WHEN COUNT(DISTINCT o.order_id) > 1 THEN 'Repeat' ELSE 'One-Time' END AS customer_type
    FROM olist_order_customer_dataset c
    JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
category_sales AS (
    -- Then, get every product category each customer bought
    SELECT 
        ct.customer_unique_id,
        ct.customer_type,
        p.product_category_name
    FROM customer_types ct
    JOIN olist_order_customer_dataset c ON ct.customer_unique_id = c.customer_unique_id
    JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    JOIN olist_products_dataset p ON oi.product_id = p.product_id
    WHERE o.order_status = 'delivered'
    AND p.product_category_name IS NOT NULL
)
SELECT 
    'PRODUCT PREFERENCE: REPEAT vs ONE-TIME CUSTOMERS' AS analysis_section,
    product_category_name,
    COUNT(DISTINCT CASE WHEN customer_type = 'Repeat' THEN customer_unique_id END) AS repeat_customers,
    COUNT(DISTINCT CASE WHEN customer_type = 'One-Time' THEN customer_unique_id END) AS one_time_customers,
    ROUND(COUNT(DISTINCT CASE WHEN customer_type = 'Repeat' THEN customer_unique_id END) * 100.0 / COUNT(DISTINCT customer_unique_id), 2) AS percent_repeat_buyers
FROM category_sales
GROUP BY product_category_name
HAVING COUNT(DISTINCT customer_unique_id) >= 100 -- Filter for significant categories
ORDER BY percent_repeat_buyers DESC;
/*
Observations
Household appliances (eletrodomesticos) have the highest rate of repeat buyers at 10.5%, followed by men's fashion. 
This indicates that customers are more likely to repurchase practical and everyday items. Categories like books and 
electronics have much lower repeat purchase rates, suggesting they are more often one-time buys.
*/

-- FOLLOW-UP 6.2.3: GEOGRAPHY OF LOYALTY
WITH customer_types AS (
    SELECT 
        c.customer_unique_id,
        c.customer_state,
        c.customer_city,
        CASE WHEN COUNT(DISTINCT o.order_id) > 1 THEN 'Repeat' ELSE 'One-Time' END AS customer_type
    FROM olist_order_customer_dataset c
    JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id, c.customer_state, c.customer_city
)
SELECT 
    'GEOGRAPHY OF CUSTOMER LOYALTY' AS analysis_section,
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS total_customers,
    COUNT(DISTINCT CASE WHEN customer_type = 'Repeat' THEN customer_unique_id END) AS repeat_customers,
    ROUND(COUNT(DISTINCT CASE WHEN customer_type = 'Repeat' THEN customer_unique_id END) * 100.0 / COUNT(DISTINCT customer_unique_id), 2) AS repeat_customer_rate
FROM customer_types
GROUP BY customer_state
HAVING COUNT(DISTINCT customer_unique_id) >= 100 -- Only states with meaningful data
ORDER BY repeat_customer_rate DESC;
/*
Observations
The state of Rondônia (RO) has the highest repeat customer rate at 3.9%, though it has a small total customer base. 
Larger states like Rio de Janeiro (RJ) and São Paulo (SP) also show strong loyalty with rates around 3%. 
In contrast, states like Ceará (CE) have a much lower repeat customer rate of 1.5%, indicating less customer retention in that region.
*/

-- FOLLOW-UP 6.2.4: SATISFACTION BY CUSTOMER TYPE
WITH customer_types AS (
    SELECT 
        c.customer_unique_id,
        CASE WHEN COUNT(DISTINCT o.order_id) > 1 THEN 'Repeat' ELSE 'One-Time' END AS customer_type
    FROM olist_order_customer_dataset c
    JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT 
    'REVIEW SCORES BY CUSTOMER TYPE' AS analysis_section,
    ct.customer_type,
    COUNT(r.review_id) AS number_of_reviews,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    MODE() WITHIN GROUP (ORDER BY r.review_score) AS mode_review_score
FROM customer_types ct
JOIN olist_order_customer_dataset c ON ct.customer_unique_id = c.customer_unique_id
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
GROUP BY ct.customer_type;
/*
Observation
Repeat customers give slightly higher average review scores (4.24) compared to one-time customers (4.15). 
Both groups most commonly give a perfect 5-star rating. This suggests that returning customers are generally more satisfied with their purchases.
*/

-- 6.3 CUSTOMER ACQUISITION CHANNELS ANALYSIS
-- Analyse if certain cities/states have higher customer acquisition rates over time
WITH monthly_first_orders AS (
    SELECT 
        DATE_TRUNC('month', order_purchase_timestamp) AS month,
        COUNT(DISTINCT customer_id) AS total_customers
    FROM olist_orders_dataset
    GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
)

SELECT 
    'CUSTOMER ACQUISITION TRENDS BY STATE' AS analysis_section,
    c.customer_state,
    DATE_TRUNC('month', MIN(o.order_purchase_timestamp)) AS first_order_month,
    COUNT(DISTINCT o.customer_id) AS new_customers,
    ROUND(COUNT(DISTINCT o.customer_id) * 100.0 / mfo.total_customers, 2) AS percentage_of_total
FROM olist_orders_dataset o
JOIN olist_order_customer_dataset c ON o.customer_id = c.customer_id
JOIN monthly_first_orders mfo ON DATE_TRUNC('month', o.order_purchase_timestamp) = mfo.month
GROUP BY c.customer_state, DATE_TRUNC('month', o.order_purchase_timestamp), mfo.total_customers
ORDER BY first_order_month, new_customers DESC;
/*
Observations
1. There is clear dominance from São Paulo which brings 38–49% of monthly new customers peaking at 49.82% in August 2018.
2. There are strong secondary markets in Rio de Janeiro and Minas Gerais each contributing 11–14% monthly with stable demand.
3. There are emerging states like Paraná, Rio Grande do Suland Santa Catarina, showing steady 3–6% monthly growth. These are good targets for focused marketing.
4. There are low-activity states in the North and Northeast, such as Acre, Roraimaand Amapá, which rarely exceed 0.1% of signups. These need localised strategies or better logistics.
5. There is a need to maintain São Paulo’s lead, support Rio and Minas Gerais, expand growth in the southern statesand evaluate barriers limiting adoption in the North and Northeast.
*/

-- 6.4 CUSTOMER DEMOGRAPHIC ANALYSIS
-- Understand customer geographic distribution and density.
SELECT 
    'CUSTOMER DEMOGRAPHIC ANALYSIS' AS analysis_title,
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,
    ROUND(COUNT(DISTINCT customer_unique_id) * 100.0 / 
          (SELECT COUNT(DISTINCT customer_unique_id) FROM olist_order_customer_dataset), 2) AS percentage_of_total,
    COUNT(DISTINCT customer_city) AS cities_with_customers,
    ROUND(COUNT(DISTINCT customer_unique_id) * 1.0 / COUNT(DISTINCT customer_city), 2) AS customers_per_city
FROM olist_order_customer_dataset
GROUP BY customer_state
ORDER BY unique_customers DESC;
/*
Observations
1. There is clear dominance from São Paulo with 41.94% of all customers and 64 per city, showing strong urban demand.
2. There is high penetration in Rio de Janeiro with 12.89% of customers and 83 per city, indicating dense markets.
3. There is a broad spread in Minas Gerais with 11.72% of customers but only 15 per city, pointing to wider distribution across smaller towns.
4. There is extreme density in Distrito Federal with 345 customers per city, though it accounts for only 2.16% of the total.
5. There are weak markets in the North, where states like Amazonas, Acre, Amapáand Roraima each hold below 0.2% with very sparse distribution.
*/
-- 6.5 CUSTOMER PURCHASE TIME PATTERNS
-- Understand when customers prefer to shop

SELECT 
    EXTRACT(HOUR FROM order_purchase_timestamp) AS hour_of_day,
    COUNT(DISTINCT order_id) AS orders_count,
    ROUND(COUNT(DISTINCT order_id) * 100.0 / 
          (SELECT COUNT(*) FROM olist_orders_dataset), 2) AS percentage_of_total
FROM olist_orders_dataset
GROUP BY hour_of_day
ORDER BY hour_of_day;

/*
Observations
1. There are clear order peaks between 10 AM and 5 PM, with 6–7% of daily orders each hour. The highest point is 4 PM at 6.71%.
2. There is a sharp overnight drop, with the lowest activity at 4 AM at 0.21%.
3. There is steady growth in the early morning from 6–9 AM, reaching 4.82% by 9 AM.
4. There is strong evening activity from 7–11 PM, averaging 5–6% of daily orders per hour.
*/

-- 6.6 CUSTOMER PERSONALIZATION DATA
-- Recommend products customers will actually love
WITH customer_category_preferences AS (
    SELECT 
        o.customer_id,
        p.product_category_name,
        COUNT(*) AS purchases_in_category,
        ROUND(AVG(oi.price), 2) AS avg_spend_per_item,
        ROUND(AVG(r.review_score), 2) AS avg_satisfaction
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    JOIN olist_products_dataset p ON oi.product_id = p.product_id
    LEFT JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
    WHERE p.product_category_name IS NOT NULL
    GROUP BY o.customer_id, p.product_category_name
),
customer_top_categories AS (
    SELECT 
        customer_id,
        product_category_name,
        purchases_in_category,
        avg_spend_per_item,
        avg_satisfaction,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY purchases_in_category DESC, avg_satisfaction DESC) as category_rank
    FROM customer_category_preferences
)
SELECT 
    'CUSTOMER PERSONALIZATION INSIGHTS' AS analysis_section,
    customer_id,
    product_category_name AS preferred_category,
    purchases_in_category,
    avg_spend_per_item,
    avg_satisfaction,
    CASE 
        WHEN avg_satisfaction >= 4.5 AND purchases_in_category >= 3 THEN 'Highly Engaged'
        WHEN avg_satisfaction >= 4.0 AND purchases_in_category >= 2 THEN 'Satisfied Repeat'
        WHEN purchases_in_category >= 3 THEN 'Frequent Buyer'
        ELSE 'Occasional Buyer'
    END AS engagement_level
FROM customer_top_categories
WHERE category_rank <= 3  -- Top 3 categories per customer
ORDER BY customer_id, category_rank;
/*
Observations
1. There are clear differences in product preferences. Bed/bath and health/beauty appear most often, while some customers choose niche categories like garden tools.
2. There are wide spending patterns. Average item prices range from R$15 to R$1,107, with most falling between R$50 and R$150. 
   One customer spent R$1,107 on a gaming PC, showing the presence of high-value niche buyers.
*/

-- =====================================
-- STEP 7: SELLER PERFORMANCE ANALYSIS
-- =====================================

-- 7.1 TOP PERFORMING SELLERS
-- Seller performance metrics
SELECT 
    'TOP PERFORMING SELLERS' AS analysis_section,
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS orders_fulfilled,
    COUNT(oi.order_item_id) AS items_sold,
    COUNT(DISTINCT oi.product_id) AS unique_products_sold,
    ROUND(SUM(oi.price), 2) AS total_product_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    COUNT(r.review_id) AS total_reviews_received
FROM olist_sellers_dataset s
JOIN olist_order_items_dataset oi ON s.seller_id = oi.seller_id
JOIN olist_orders_dataset o ON oi.order_id = o.order_id
LEFT JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
GROUP BY s.seller_id, s.seller_city, s.seller_state
HAVING COUNT(oi.order_item_id) >= 50  -- Sellers with at least 50 items sold
ORDER BY total_product_revenue DESC
LIMIT 20;
/*
Observations
1. There is a top revenue seller in Guariba, SP, earning R$226,987 from 1,148 sales with an average price of R$197.72.
2. There is premium pricing from a seller in Lauro de Freitas, BA, averaging R$544.85 per item but with lower volume at 400 sales.
3. There are volume leaders in São Paulo, where the top seller reached 1,819 orders.
4. There are strong customer ratings overall, with most sellers scoring above 4.0 out of 5.0.
*/

-- 7.2 SELLER GEOGRAPHIC DISTRIBUTION
-- Where sellers are located vs their performance
SELECT 
    'SELLER GEOGRAPHIC ANALYSIS' AS analysis_section,
    s.seller_state,
    COUNT(DISTINCT s.seller_id) AS number_of_sellers,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price,
    ROUND(SUM(oi.price) / COUNT(DISTINCT s.seller_id), 2) AS revenue_per_seller
FROM olist_sellers_dataset s
JOIN olist_order_items_dataset oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY total_revenue DESC;
/*
Observations
1. There is strong seller concentration in São Paulo with 18,849 sellers generating R$8.75M at an average of R$108.95 per item.
2. There is premium pricing in Rio de Janeiro, where sellers average R$175.17 per item despite fewer participants at 171 sellers.
3. There is standout performance in Bahia, with revenue per seller at R$15,029.56 and premium pricing of R$444.11 per item.
4. There are low-activity states like Amazonas, Acreand Pará, each with fewer than five sellers and minimal presence.

*/
-- =====================================
-- STEP 8: PRODUCT ANALYSIS
-- =====================================

-- 8.1 PRODUCT PERFORMANCE METRICS
-- Detailed product analysis
SELECT 
    'PRODUCT PERFORMANCE ANALYSIS' AS analysis_section,
    p.product_category_name,
    COUNT(DISTINCT oi.product_id) AS unique_products,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_product_price,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_cost,
    ROUND(AVG(p.product_weight_g), 2) AS avg_product_weight_g,
    ROUND(AVG(r.review_score), 2) AS avg_category_rating,
    COUNT(r.review_id) AS total_reviews
FROM olist_products_dataset p
JOIN olist_order_items_dataset oi ON p.product_id = oi.product_id
JOIN olist_orders_dataset o ON oi.order_id = o.order_id
LEFT JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;
/*
Observations
1. There are clear revenue leaders by category. Health and beauty leads with R$1.23M from 9,483 items at an average of R$130.16. 
   Watches and gifts follow with R$1.17M and the highest average price at R$198.90. Bed and bath rank third with R$1.03M from 11,039 items.
2. There are premium categories like musical instruments averaging R$283.13 and portable appliances averaging R$638.21. These command the highest prices.
3. There is strong sales volume in bed and bath along with health categories.
4. There is high customer satisfaction in books with an average rating of 4.51 and flowers at 4.42.
5. There is a freight cost challenge, as office furniture is the heaviest at 11,345g and the most expensive to ship at R$40.14.
6. There is a need to expand inventory in high-value categories like watches and musical instruments, optimise logistics for heavy goodsand promote highly rated categories to strengthen satisfaction.
*/
-- 8.2 PRODUCT DIMENSION ANALYSIS
-- How product dimensions affect sales and shipping
SELECT 
    'PRODUCT DIMENSION IMPACT' AS analysis_section,
    size_category,
    COUNT(*) AS products_count,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(freight_value), 2) AS avg_freight,
    ROUND(AVG(review_score), 2) AS avg_rating
FROM (
    SELECT 
        p.*,
        oi.price,
        oi.freight_value,
        r.review_score,
        CASE 
            WHEN (p.product_length_cm * p.product_height_cm * p.product_width_cm) <= 1000 THEN 'Small'
            WHEN (p.product_length_cm * p.product_height_cm * p.product_width_cm) <= 10000 THEN 'Medium'
            WHEN (p.product_length_cm * p.product_height_cm * p.product_width_cm) <= 50000 THEN 'Large'
            ELSE 'Extra Large'
        END AS size_category
    FROM olist_products_dataset p
    JOIN olist_order_items_dataset oi ON p.product_id = oi.product_id
    JOIN olist_orders_dataset o ON oi.order_id = o.order_id
    LEFT JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
    WHERE p.product_length_cm IS NOT NULL 
        AND p.product_height_cm IS NOT NULL 
        AND p.product_width_cm IS NOT NULL
) sized_products
GROUP BY size_category
ORDER BY avg_price DESC;
/*
Observations
1. There are clear differences by product size. Extra large products average R$280.51 with R$47.12 freight, but have the lowest rating at 3.94. Medium products dominate 
   with 60,579 items, averaging R$100.19, freight of R$16.81 and higher satisfaction at 4.12. Small products are cheapest at R$54.34 with the lowest freight at R$14.60.
2. There is a trade-off. Larger items bring higher revenue per unit but lower satisfaction, while medium products give the best balance of price, freight and customer rating.
*/
--8.3 PRODUCT RETURN RATE ANALYSIS
-- Analse which product categories have the highest return rates
SELECT 
    'PRODUCT RETURN RATES BY CATEGORY' AS analysis_section,
    p.product_category_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN o.order_status = 'canceled' OR o.order_status = 'unavailable' THEN o.order_id END) AS canceled_orders,
    ROUND(COUNT(DISTINCT CASE WHEN o.order_status = 'canceled' OR o.order_status = 'unavailable' THEN o.order_id END) * 100.0 / 
        COUNT(DISTINCT o.order_id), 2) AS return_rate_percentage,
    ROUND(AVG(oi.price), 2) AS avg_product_price
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_products_dataset p ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(DISTINCT o.order_id) >= 50
ORDER BY return_rate_percentage DESC
LIMIT 15;
/*
Observations
1. There are extremely low return rates across all categories, ranging from 0.00% to 0.06%. Perfumery is the highest at 0.06% with 2 returns from 3,088 orders.
   Sports and leisure show only 0.01% returns from 7,528 orders. Baby products and home goods record 0.00%.
2. There is no sign of major return issues. Product quality and descriptions appear accurate.
*/
-- 8.4 INVENTORY PLANNING INSIGHTS
-- Help with inventory planning and marketing strategies
WITH product_velocity AS (
    SELECT 
        p.product_category_name,
        p.product_id,
        COUNT(oi.order_item_id) AS total_sold,
        ROUND(AVG(oi.price), 2) AS avg_price,
        COUNT(DISTINCT DATE_TRUNC('month', o.order_purchase_timestamp)) AS months_active,
        ROUND(COUNT(oi.order_item_id) / NULLIF(COUNT(DISTINCT DATE_TRUNC('month', o.order_purchase_timestamp)), 0), 2) AS monthly_velocity,
        MIN(o.order_purchase_timestamp) AS first_sale,
        MAX(o.order_purchase_timestamp) AS last_sale,
        ROUND(AVG(r.review_score), 2) AS avg_rating
    FROM olist_products_dataset p
    JOIN olist_order_items_dataset oi ON p.product_id = oi.product_id
    JOIN olist_orders_dataset o ON oi.order_id = o.order_id
    LEFT JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
    WHERE p.product_category_name IS NOT NULL
        AND o.order_purchase_timestamp IS NOT NULL
    GROUP BY p.product_category_name, p.product_id
)
SELECT 
    'INVENTORY OPTIMISATION INSIGHTS' AS analysis_section,
    product_category_name,
    COUNT(*) AS products_in_category,
    ROUND(AVG(monthly_velocity), 2) AS avg_monthly_sales_velocity,
    ROUND(AVG(total_sold), 0) AS avg_total_sold_per_product,
    ROUND(AVG(avg_price), 2) AS avg_category_price,
    ROUND(AVG(avg_rating), 2) AS avg_category_rating,
    CASE 
        WHEN AVG(monthly_velocity) >= 10 THEN 'Fast Moving'
        WHEN AVG(monthly_velocity) >= 5 THEN 'Medium Velocity'
        WHEN AVG(monthly_velocity) >= 1 THEN 'Slow Moving'
        ELSE 'Very Slow Moving'
    END AS inventory_classification
FROM product_velocity
WHERE months_active >= 3  -- Products active for at least 3 months
GROUP BY product_category_name
ORDER BY avg_monthly_sales_velocity DESC;
/*
Observations
1. There is slow sales velocity across all categories, with products moving only 1.0 to 4.83 units per month. PCs rank highest at 4.83 sales, but their average price of R$1,138 keeps them slow-moving.
2. There is stronger unit volume in garden tools, averaging 31 sales per product, but still below medium or fast thresholds.
3. There is a pricing issue, as higher prices limit sales volume across categories.
4. There is a need to run promotions on PCs and garden tools to test demand response and to review inventory for categories selling fewer than 10 units per month.
*/
-- =====================================
-- STEP 9:  CUSTOMER & MARKET INTELLIGENCE
-- =====================================

-- 9.1 RFM ANALYSIS (Recency, Frequency, Monetary)
-- Customer segmentation
WITH rfm_calculation AS (
    SELECT 
        customer_id,
        (CURRENT_DATE - MAX(order_purchase_timestamp::date)) AS recency_days,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(total_order_value) AS monetary_value
    FROM (
        SELECT 
            o.customer_id,
            o.order_id,
            o.order_purchase_timestamp,
            SUM(oi.price + oi.freight_value) AS total_order_value
        FROM olist_orders_dataset o
        JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
        GROUP BY o.customer_id, o.order_id, o.order_purchase_timestamp
    ) customer_orders
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT 
        customer_id,
        recency_days,
        frequency,
        monetary_value,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary_value ASC) AS monetary_score
    FROM rfm_calculation
)
SELECT 
    'RFM CUSTOMER SEGMENTATION' AS analysis_section,
    CASE 
        WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
        WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'Loyal Customers'
        WHEN recency_score >= 4 AND frequency_score <= 2 THEN 'New Customers'
        WHEN recency_score >= 3 AND frequency_score <= 3 AND monetary_score <= 3 THEN 'Potential Loyalists'
        WHEN recency_score >= 3 AND frequency_score <= 2 THEN 'Promising'
        WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'Need Attention'
        WHEN recency_score <= 2 AND frequency_score <= 2 AND monetary_score >= 4 THEN 'Cannot Lose Them'
        WHEN recency_score <= 2 AND frequency_score <= 2 AND monetary_score <= 2 THEN 'Hibernating'
        ELSE 'Others'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(recency_days), 1) AS avg_recency_days,
    ROUND(AVG(frequency), 1) AS avg_frequency,
    ROUND(AVG(monetary_value), 2) AS avg_monetary_value
FROM rfm_scores
GROUP BY customer_segment
ORDER BY avg_monetary_value DESC;
/*
Observations
1. There are 15,903 champion customers who spend the most at R$295 on average, with recent activity at 2,622 days.
2. There are 22,615 customers in the “need attention” group, averaging R$235 but inactive for 2,926 days.
3. There are 19,358 loyal customers with steady spending at R$172.
4. There are 15,970 hibernating customers with low spending at R$55 and long inactivity.
*/

-- 9.2 COHORT ANALYSIS
-- Customer retention analysis by registration month
WITH customer_cohorts AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort_month,
        MIN(order_purchase_timestamp) AS first_order_date
    FROM olist_orders_dataset
    GROUP BY customer_id
),
customer_activities AS (
    SELECT 
        c.customer_id,
        c.cohort_month,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS activity_month,
        EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', o.order_purchase_timestamp), c.cohort_month)) AS period_number
    FROM customer_cohorts c
    JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
)
SELECT 
    'COHORT RETENTION ANALYSIS' AS analysis_section,
    cohort_month,
    period_number,
    COUNT(DISTINCT customer_id) AS customers_in_period,
    ROUND(COUNT(DISTINCT customer_id) * 100.0 / 
          FIRST_VALUE(COUNT(DISTINCT customer_id)) OVER (
              PARTITION BY cohort_month ORDER BY period_number
          ), 2) AS retention_rate
FROM customer_activities
WHERE cohort_month >= '2017-01-01'
GROUP BY cohort_month, period_number
ORDER BY cohort_month, period_number;
/*
Observations
1. There is 100% retention in month 0 across all cohorts, meaning every customer makes only the initial purchase.
2. There is peak acquisition in November 2017 with 7,288 new customers.
3. There is steady growth in new customers, ranging from 748 in January 2017 to 7,003 in March 2018.
*/
-- 9.3 MARKET BASKET ANALYSIS
-- Products frequently bought together
WITH order_products AS (
    SELECT 
        oi1.order_id,
        oi1.product_id AS product_a,
        oi2.product_id AS product_b,
        p1.product_category_name AS category_a,
        p2.product_category_name AS category_b
    FROM olist_order_items_dataset oi1
    JOIN olist_order_items_dataset oi2 ON oi1.order_id = oi2.order_id 
        AND oi1.product_id < oi2.product_id
    JOIN olist_products_dataset p1 ON oi1.product_id = p1.product_id
    JOIN olist_products_dataset p2 ON oi2.product_id = p2.product_id
    WHERE p1.product_category_name IS NOT NULL 
        AND p2.product_category_name IS NOT NULL
)
SELECT 
    'MARKET BASKET ANALYSIS - CATEGORIES' AS analysis_section,
    category_a,
    category_b,
    COUNT(*) AS times_bought_together,
    ROUND(COUNT(*) * 100.0 / (
        SELECT COUNT(DISTINCT order_id) 
        FROM olist_order_items_dataset oi
        JOIN olist_products_dataset p ON oi.product_id = p.product_id
        WHERE p.product_category_name IN (op.category_a, op.category_b)
    ), 3) AS co_occurrence_rate
FROM order_products op
GROUP BY category_a, category_b
HAVING COUNT(*) >= 10
ORDER BY times_bought_together DESC
LIMIT 20;
/*
Observations
1. There are strong self-pairings in purchases. Bed and bath items lead with 1,147 pairings at 12.18%. Home decor follows with 555 pairings at 8.61%and health and beauty at 347 pairings at 3.93%.
2. There are high pairing rates within categories. Construction tools reach 13.77% when bought togetherand office furniture pairs at 9.35%.
3. There is weak cross-category activity. Bed and bath with home decor show only 0.45% and bed and bath with health and beauty show 0.36%.
*/

-- 9.4 PRICE SENSITIVITY ANALYSIS
-- Create promotions that genuinely help shoppers save money
WITH price_segments AS (
    SELECT 
        p.product_category_name,
        oi.price,
        COUNT(*) AS sales_count,
        ROUND(AVG(r.review_score), 2) AS avg_rating,
        CASE 
            WHEN oi.price <= 50 THEN 'Budget (≤50)'
            WHEN oi.price <= 100 THEN 'Economy (51-100)'
            WHEN oi.price <= 200 THEN 'Mid-range (101-200)'
            WHEN oi.price <= 500 THEN 'Premium (201-500)'
            ELSE 'Luxury (>500)'
        END AS price_segment
    FROM olist_order_items_dataset oi
    JOIN olist_products_dataset p ON oi.product_id = p.product_id
    JOIN olist_orders_dataset o ON oi.order_id = o.order_id
    LEFT JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
    WHERE p.product_category_name IS NOT NULL
    GROUP BY p.product_category_name, oi.price,
        CASE 
            WHEN oi.price <= 50 THEN 'Budget (≤50)'
            WHEN oi.price <= 100 THEN 'Economy (51-100)'
            WHEN oi.price <= 200 THEN 'Mid-range (101-200)'
            WHEN oi.price <= 500 THEN 'Premium (201-500)'
            ELSE 'Luxury (>500)'
        END
)
SELECT 
    'PRICE SENSITIVITY ANALYSIS' AS analysis_section,
    product_category_name,
    price_segment,
    SUM(sales_count) AS total_sales,
    ROUND(AVG(avg_rating), 2) AS segment_avg_rating,
    ROUND(SUM(sales_count) * 100.0 / SUM(SUM(sales_count)) OVER (PARTITION BY product_category_name), 2) AS sales_percentage_in_category,
    CASE 
        WHEN ROUND(SUM(sales_count) * 100.0 / SUM(SUM(sales_count)) OVER (PARTITION BY product_category_name), 2) >= 40 THEN 'Sweet Spot'
        WHEN ROUND(SUM(sales_count) * 100.0 / SUM(SUM(sales_count)) OVER (PARTITION BY product_category_name), 2) >= 25 THEN 'Strong Segment'
        WHEN ROUND(SUM(sales_count) * 100.0 / SUM(SUM(sales_count)) OVER (PARTITION BY product_category_name), 2) >= 15 THEN 'Viable Segment'
        ELSE 'Niche Segment'
    END AS pricing_opportunity
FROM price_segments
GROUP BY product_category_name, price_segment
HAVING SUM(sales_count) >= 10
ORDER BY product_category_name, total_sales DESC;

/*
1. There is strong dominance of budget products priced at R$50 or less. In the general category, 40.99% of sales fall here, showing that most customers are price-sensitive.
2. There is smaller but valuable demand in premium and luxury segments. In agro_industria_e_comercio, premium products make up 39.32% of sales with a 4.08 rating, showing willingness
   to pay more for quality.
3. There are clear category trends. Food and beverages rely heavily on budget items, with 70.41% of sales in this segment. Electronics are also budget-driven at 74.64%, though luxury
   products hold the highest ratings at 4.38. Home goods lean toward economy and mid-range pricing, with 36.33% of sales in economy.
4. There is a need to focus on budget and economy products for volume while watching premium and luxury items as niche markets with loyal buyers.
*/
-- =====================================
-- STEP 10: REVENUE ANALYSIS
-- =====================================

-- 10.1 REVENUE BREAKDOWN ANALYSIS
--  Revenue analysis
SELECT 
    'REVENUE BREAKDOWN ANALYSIS' AS analysis_section,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS total_product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight_revenue,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_gross_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_per_item,
    ROUND(AVG(order_total.order_value), 2) AS avg_order_value,
    ROUND(SUM(oi.freight_value) / SUM(oi.price + oi.freight_value) * 100, 2) AS freight_percentage_of_revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN (
    SELECT 
        order_id,
        SUM(price + freight_value) AS order_value
    FROM olist_order_items_dataset
    GROUP BY order_id
) order_total ON o.order_id = order_total.order_id;
/*
Observations
- The total revenue is 15,416,994.83, combining product revenue (13,219,045.68) and freight revenue (2,197,949.15).
- Freight contribution for 19.95% of total revenue. This is significant and suggests shipping costs impact pricing strategies.
- The average order value is 119.98, indicating moderate spending per transaction.
Insight
- Optimising freight costs could improve profitability while maintaining competitive pricing.
*/
-- 10.2 PAYMENT INSTALLMENT ANALYSIS
-- How installment payments affect business
SELECT 
    'PAYMENT INSTALLMENT ANALYSIS' AS analysis_section,
    CASE 
        WHEN payment_installments = 1 THEN '1 installment (Cash)'
        WHEN payment_installments <= 3 THEN '2-3 installments'
        WHEN payment_installments <= 6 THEN '4-6 installments'
        WHEN payment_installments <= 12 THEN '7-12 installments'
        ELSE '13+ installments'
    END AS installment_range,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS avg_payment_value,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset), 2) AS percentage_of_payments
FROM olist_order_payments_dataset
GROUP BY installment_range
ORDER BY avg_payment_value DESC;
/*
Observations
1. There is a split in payment behavior. Single-installment payments dominate at 50.58% with an average of 112.42. Installment plans from 2 to 12 payments make up 49.42%.
2. There is a clear link between more installments and higher order values. Payments with 13 or more installments average 413.72 but are rare at 0.18%. 
   Installments of 7 to 12 are more common at 11.57% and carry high averages of 333.29.
*/
-- =====================================
-- STEP 11: OPERATIONAL EFFICIENCY METRICS
-- =====================================

-- 11.1 ORDER FULFILLMENT EFFICIENCY
-- Order processing metrics
WITH order_processing AS (
    SELECT 
        o.order_id,
        o.order_status,
        o.order_purchase_timestamp,
        o.order_approved_at,
        o.order_delivered_carrier_date,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
        COALESCE(EXTRACT(EPOCH FROM (o.order_approved_at - o.order_purchase_timestamp))/3600, 0) AS approval_hours,
        COALESCE(EXTRACT(EPOCH FROM (o.order_delivered_carrier_date - o.order_approved_at))/3600, 0) AS processing_hours,
        COALESCE(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_delivered_carrier_date))/3600, 0) AS shipping_hours,
        COALESCE(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))/3600, 0) AS total_fulfillment_hours
    FROM olist_orders_dataset o
    WHERE o.order_status = 'delivered'
)
SELECT 
    'ORDER FULFILLMENT EFFICIENCY' AS analysis_section,
    COUNT(*) AS delivered_orders,
    ROUND(AVG(approval_hours), 2) AS avg_approval_hours,
    ROUND(AVG(processing_hours), 2) AS avg_processing_hours,
    ROUND(AVG(shipping_hours), 2) AS avg_shipping_hours,
    ROUND(AVG(total_fulfillment_hours), 2) AS avg_total_fulfillment_hours,
    ROUND(AVG(total_fulfillment_hours)/24, 2) AS avg_total_fulfillment_days,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_fulfillment_hours) AS median_fulfillment_hours,
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_fulfillment_hours) AS p90_fulfillment_hours
FROM order_processing;
/*
Observations
1. There is an average of 10.28 hours to approve an order.
2. There is a longer wait in processing at 67.18 hoursand shipping takes the most time at 223.98 hours.
3. There is a total fulfillment time of 301.38 hours on average, equal to 12.56 days. The median is 245.18 hours, while 10% of orders stretch to 554.33 hours, over 23 days.
4. There is a clear finding that shipping is the longest stageand a share of orders face extreme delays.
*/

-- 11.2 SELLER EFFICIENCY ANALYSIS
-- Which sellers are most efficient at fulfillment
WITH seller_efficiency AS (
    SELECT 
        s.seller_id,
        s.seller_state,
        COUNT(DISTINCT o.order_id) AS orders_handled,
        AVG(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))) AS avg_delivery_days,
        COUNT(CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1 END) AS on_time_deliveries,
        ROUND(AVG(r.review_score), 2) AS avg_review_score,
        ROUND(SUM(oi.price), 2) AS total_revenue
    FROM olist_sellers_dataset s
    JOIN olist_order_items_dataset oi ON s.seller_id = oi.seller_id
    JOIN olist_orders_dataset o ON oi.order_id = o.order_id
    LEFT JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
        AND o.order_delivered_customer_date IS NOT NULL
        AND o.order_estimated_delivery_date IS NOT NULL
    GROUP BY s.seller_id, s.seller_state
    HAVING COUNT(DISTINCT o.order_id) >= 20
)
SELECT 
    'SELLER EFFICIENCY RANKING' AS analysis_section,
    seller_id,
    seller_state,
    orders_handled,
    avg_delivery_days,
    ROUND(on_time_deliveries * 100.0 / orders_handled, 2) AS on_time_delivery_rate,
    avg_review_score,
    total_revenue,
    CASE 
        WHEN avg_delivery_days <= 10 AND (on_time_deliveries * 100.0 / orders_handled) >= 90 THEN 'Excellent'
        WHEN avg_delivery_days <= 15 AND (on_time_deliveries * 100.0 / orders_handled) >= 80 THEN 'Good'
        WHEN avg_delivery_days <= 20 AND (on_time_deliveries * 100.0 / orders_handled) >= 70 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS efficiency_rating
FROM seller_efficiency
ORDER BY on_time_delivery_rate DESC, avg_delivery_days ASC
LIMIT 25;
/*
Observations
1. There are clear performance highlights, with the top seller in SP managing 910 orders and reaching a 141.98% on-time rate. 
   With an excellent efficiency rating for sellers who deliver in less than 10 days and achieve above 150% on-time rate.
2. There are delivery times averaging between 7.5 and 14.8 days. There are wide differences in on-time delivery rates, from 136.36% to 254.55%.
3. There is a strong revenue link, with the highest seller in SP earning 138,323.76. There is an average revenue range of 4,000 to 8,000 for sellers rated excellent.
4. There are clear state differences, with SP leading in efficiency. There is steady performance from MG and PR sellers.
*/
-- 11.3 CUSTOMER SERVICE PERFORMANCE
-- Identify disappointed customers and service improvement areas
WITH review_analysis AS (
    SELECT 
        r.order_id,
        r.review_score,
        LENGTH(COALESCE(r.review_comment_message, '')) AS comment_length,
        CASE 
            WHEN r.review_score <= 2 THEN 'Dissatisfied'
            WHEN r.review_score = 3 THEN 'Neutral'
            ELSE 'Satisfied'
        END AS satisfaction_level,
        p.product_category_name,
        c.customer_state,
        EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_estimated_delivery_date)) AS delivery_delay_days
    FROM olist_order_reviews_dataset r
    JOIN olist_orders_dataset o ON r.order_id = o.order_id
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    JOIN olist_products_dataset p ON oi.product_id = p.product_id
    JOIN olist_order_customer_dataset c ON o.customer_id = c.customer_id
    WHERE r.review_score IS NOT NULL
)
SELECT 
    'CUSTOMER SERVICE INSIGHTS' AS analysis_section,
    satisfaction_level,
    product_category_name,
    COUNT(*) AS review_count,
    ROUND(AVG(delivery_delay_days), 2) AS avg_delivery_delay,
    ROUND(AVG(comment_length), 0) AS avg_comment_length,
    COUNT(CASE WHEN comment_length > 100 THEN 1 END) AS detailed_feedback_count,
    ROUND(COUNT(CASE WHEN comment_length > 100 THEN 1 END) * 100.0 / COUNT(*), 2) AS detailed_feedback_percentage
FROM review_analysis
WHERE product_category_name IS NOT NULL
GROUP BY satisfaction_level, product_category_name
HAVING COUNT(*) >= 20
ORDER BY satisfaction_level, review_count DESC;
/*
Observations
Dissatisfaction Drivers
* Bed/bath generates most negative reviews (1,968).
* Furniture suffers longest delivery delays (-8.01 days).
* Electronics attracts most detailed complaints (40.39% of negatives).

Satisfied Customer Trends:
* Bed/bath also leads in positive reviews (7,766).
* Faster delivery linked to satisfaction (-11 to -13 days early).
* Positive reviews are shorter (17–22 words on average).

*/
-- =========================================
-- STEP 12: FORECASTING & PERFORMANCE OPTIMISATION
-- =========================================

-- 12.1 SEASONAL DEMAND FORECASTING DATA
-- Data prepared for demand forecasting models
SELECT 
    'SEASONAL DEMAND PATTERNS' AS analysis_section,
    DATE_TRUNC('week', o.order_purchase_timestamp) AS order_week,
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month_number,
    EXTRACT(DOW FROM o.order_purchase_timestamp) AS day_of_week,
    p.product_category_name,
    COUNT(oi.order_item_id) AS items_sold,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS unique_orders
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_products_dataset p ON oi.product_id = p.product_id
WHERE o.order_purchase_timestamp IS NOT NULL
    AND p.product_category_name IS NOT NULL
GROUP BY DATE_TRUNC('week', o.order_purchase_timestamp), 
         EXTRACT(MONTH FROM o.order_purchase_timestamp),
         EXTRACT(DOW FROM o.order_purchase_timestamp),
         p.product_category_name
ORDER BY order_week, product_category_name
LIMIT 200;
/*
Observations
Observations for Seasonal Demand Patterns reveals;
1. Early Sales Volume
* September and October 2016 show low activity, usually 1–3 items per category per week.
* Health/beauty and home decor categories appear most often.

2. Revenue by Category
* High-value items like consoles/games and watches/gifts drive strong revenue per item.
* Low-value categories like telephony show smaller average transactions.

3. Weekly Trends
* Some weeks, such as October 3, 2016, show activity spikes across multiple categories.
* Sales are stronger on weekdays, especially Tuesdays, than weekends for several categories.

4. Seasonal Spikes
* Early 2017 activity increases, likely tied to post-holiday and New Year demand.
* Categories like garden tools and sports/leisure show growth during this period.

Inshoort:
Sales began slow in late 2016, expanded in early 2017 and varied by both category and weekday. High-value products generated more revenue despite lower sales volume.
*/

-- 12.2 SELLER MARKETPLACE HEALTH
-- Reward best sellers who provide excellent service
WITH seller_performance_matrix AS (
    SELECT 
        s.seller_id,
        s.seller_state,
        COUNT(DISTINCT oi.order_id) AS orders_fulfilled,
        COUNT(DISTINCT oi.product_id) AS product_variety,
        ROUND(AVG(oi.price), 2) AS avg_product_price,
        ROUND(SUM(oi.price), 2) AS total_revenue,
        ROUND(AVG(r.review_score), 2) AS avg_customer_rating,
        COUNT(r.review_id) AS total_reviews,
        ROUND(AVG(EXTRACT(DAY FROM (o.order_delivered_customer_date - o.order_purchase_timestamp))), 2) AS avg_fulfillment_days,
        COUNT(CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1 END) AS on_time_deliveries,
        ROUND(COUNT(CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 1 END) * 100.0 / 
              COUNT(CASE WHEN o.order_delivered_customer_date IS NOT NULL AND o.order_estimated_delivery_date IS NOT NULL THEN 1 END), 2) AS on_time_percentage
    FROM olist_sellers_dataset s
    JOIN olist_order_items_dataset oi ON s.seller_id = oi.seller_id
    JOIN olist_orders_dataset o ON oi.order_id = o.order_id
    LEFT JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
    GROUP BY s.seller_id, s.seller_state
    HAVING COUNT(DISTINCT oi.order_id) >= 10
)
SELECT 
    'SELLER REWARD PROGRAM CANDIDATES' AS analysis_section,
    seller_id,
    seller_state,
    orders_fulfilled,
    product_variety,
    total_revenue,
    avg_customer_rating,
    on_time_percentage,
    avg_fulfillment_days,
    CASE 
        WHEN avg_customer_rating >= 4.5 AND on_time_percentage >= 90 AND total_revenue >= 10000 THEN 'Diamond Seller'
        WHEN avg_customer_rating >= 4.0 AND on_time_percentage >= 85 AND total_revenue >= 5000 THEN 'Gold Seller'
        WHEN avg_customer_rating >= 3.5 AND on_time_percentage >= 80 AND total_revenue >= 2000 THEN 'Silver Seller'
        ELSE 'Standard Seller'
    END AS seller_tier,
    CASE 
        WHEN avg_customer_rating >= 4.5 AND on_time_percentage >= 90 THEN 'Featured Placement + Commission Discount'
        WHEN avg_customer_rating >= 4.0 AND on_time_percentage >= 85 THEN 'Priority Support + Marketing Credits'
        WHEN avg_customer_rating >= 3.5 AND on_time_percentage >= 80 THEN 'Performance Dashboard Access'
        ELSE 'Training Program Invitation'
    END AS recommended_reward
FROM seller_performance_matrix
ORDER BY total_revenue DESC, avg_customer_rating DESC
LIMIT 100;
/*
Observations
Top Performers
* There is a highest revenue seller who generated 226,987 BRL from 1,124 orders.
* There are sellers from SP (São Paulo) dominating the list, showing strong market presence.

Seller Tiers
* There are many Gold Sellers with ratings above 4.0 and on-time delivery between 88 and 97 percent.
* There are rare Diamond Sellers with ratings above 4.45 and perfect delivery.

Delivery Efficiency
* There are fastest sellers delivering in 6 to 10 days.
* There are slower sellers taking more than 15 days, which reduces satisfaction.

Revenue vs. Volume
* There are sellers achieving high revenue with fewer orders, such as 217,940 BRL from 348 orders.
* There are others depending on high order volume, with 1,772 orders for 198,631 BRL.

Regional Insight
* There are SP sellers leading in both revenue and order volume.
* There are BA sellers with high revenue per order, showing premium pricing.

Improvement Areas
* There are Standard Sellers needing training due to ratings below 3.5 or delayed delivery.
* There are Silver Sellers close to Gold, needing small improvements in ratings or delivery speed.
*/
-- ===========================================
-- STEP 13: CORE METRICS & BUSINESS HIGHLIGHTS
-- ===========================================

-- 13.1 KEY PERFORMANCE INDICATORS (KPIs)
-- Essential business metrics dashboard
SELECT 
    'KEY PERFORMANCE INDICATORS' AS analysis_section,
    kpi_name,
    kpi_value
FROM (
    SELECT 'Total Revenue (BRL)' as kpi_name, 
           ROUND(SUM(oi.price + oi.freight_value), 2)::VARCHAR as kpi_value
    FROM olist_order_items_dataset oi
    UNION ALL
    SELECT 'Total Orders', 
           COUNT(DISTINCT order_id)::VARCHAR
    FROM olist_orders_dataset
    UNION ALL
    SELECT 'Total Customers',
           COUNT(DISTINCT customer_id)::VARCHAR
    FROM olist_orders_dataset
    UNION ALL
    SELECT 'Total Products Sold',
           COUNT(*)::VARCHAR
    FROM olist_order_items_dataset
    UNION ALL
    SELECT 'Average Order Value (BRL)',
           ROUND(AVG(order_total), 2)::VARCHAR
    FROM (
        SELECT SUM(price + freight_value) as order_total
        FROM olist_order_items_dataset
        GROUP BY order_id
    ) avg_calc
    UNION ALL
    SELECT 'Customer Satisfaction (Avg Rating)',
           ROUND(AVG(review_score), 2)::VARCHAR
    FROM olist_order_reviews_dataset
    WHERE review_score IS NOT NULL
    UNION ALL
    SELECT 'Order Fulfillment Rate (%)',
           ROUND(COUNT(CASE WHEN order_status = 'delivered' THEN 1 END) * 100.0 / COUNT(*), 2)::VARCHAR
    FROM olist_orders_dataset
) kpis;
/*
Observations
Customer Satisfaction
- Average rating is 4.09 showing strong customer happiness.
Order Fulfillment
- 99.99% of orders are fulfilled, showing near-perfect operational efficiency.
Sales Performance
- Total revenue is 15.8M BRL from 96,461 orders.
- Average order value is 160.58 BRL.
Customer Base
- 96,461 unique customers, matching total orders.
*/
-- 13.2 TOP PERFORMERS SUMMARY
-- Best performing entities across different dimensions
SELECT 
    'TOP PERFORMERS SUMMARY' AS analysis_section,
    performance_category,
    entity_name,
    performance_metric
FROM (
    -- Top Product Category by Revenue
    SELECT 
        'Top Product Category (Revenue)' as performance_category,
        p.product_category_name as entity_name,
        CONCAT('BRL ', ROUND(SUM(oi.price), 2)) as performance_metric,
        SUM(oi.price) as sort_value
    FROM olist_order_items_dataset oi
    JOIN olist_products_dataset p ON oi.product_id = p.product_id
    WHERE p.product_category_name IS NOT NULL
    GROUP BY p.product_category_name
    ORDER BY SUM(oi.price) DESC
    LIMIT 1
) top_category

UNION ALL

SELECT 
    'TOP PERFORMERS SUMMARY' AS analysis_section,
    performance_category,
    entity_name,
    performance_metric
FROM (
    -- Top State by Orders
    SELECT 
        'Top State (Orders)' as performance_category,
        c.customer_state as entity_name,
        CONCAT(COUNT(DISTINCT o.order_id), ' orders') as performance_metric
    FROM olist_orders_dataset o
    JOIN olist_order_customer_dataset c ON o.customer_id = c.customer_id
    GROUP BY c.customer_state
    ORDER BY COUNT(DISTINCT o.order_id) DESC
    LIMIT 1
) top_state

UNION ALL

SELECT 
    'TOP PERFORMERS SUMMARY' AS analysis_section,
    performance_category,
    entity_name,
    performance_metric
FROM (
    -- Best Payment Method
    SELECT 
        'Most Popular Payment Method' as performance_category,
        payment_type as entity_name,
        CONCAT(COUNT(*), ' transactions (', 
               ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM olist_order_payments_dataset), 1), '%)') as performance_metric
    FROM olist_order_payments_dataset
    GROUP BY payment_type
    ORDER BY COUNT(*) DESC
    LIMIT 1
) top_payment

UNION ALL

SELECT 
    'TOP PERFORMERS SUMMARY' AS analysis_section,
    performance_category,
    entity_name,
    performance_metric
FROM (
    -- Peak Sales Month
    SELECT 
        'Peak Sales Month' as performance_category,
        TO_CHAR(order_month, 'Month YYYY') as entity_name,
        CONCAT('BRL ', ROUND(total_revenue, 2)) as performance_metric
    FROM (
        SELECT 
            DATE_TRUNC('month', o.order_purchase_timestamp) as order_month,
            SUM(oi.price + oi.freight_value) as total_revenue
        FROM olist_orders_dataset o
        JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
        WHERE o.order_purchase_timestamp IS NOT NULL
        GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
        ORDER BY total_revenue DESC
        LIMIT 1
    ) peak_month
) top_month;
/*
Observations
Top Product Category
- Health and beauty (beleza_saude) generated the highest revenue at 1.26M BRL.
Top State for Orders
- São Paulo (SP) leads with 40,489 orders, showing strong market demand.
Preferred Payment Method
- Credit cards dominate, making up 73.9% of transactions.
Peak Sales Month
- November 2017 had the highest sales (1.15M BRL), likely due to holiday shopping and blackfriday offers.
*/

-- ====================
-- CONCLUSION
-- ====================
/*
The project has revealed that Olist is a healthy, growing platform with exceptional order fulfillment rates (99.99%) and strong customer satisfaction (avg. 4.09/5 rating). 
Geographically, the market is dominated by the southeastern states, particularly São Paulo, which drives nearly half of all revenue, while the northern regions represent
significant untapped potential.
Important patterns revealed:
* Customer Behavior: The customer base is overwhelmingly composed of one-time buyers (97%), highlighting a major opportunity in improving retention and loyalty programs.

* Product Strategy: Revenue is driven by high-volume categories like health/beauty and bed/bath, with premium niches in watches/gifts and electronics offering high-value 
  opportunities.

* Operational Focus: While delivery is highly reliable, logistics efficiency varies significantly by region. Northern states experience longer delays, indicating a need 
  for localized logistics partnerships.

* Financial Model: Credit cards are the dominant payment method (73.9%), and offering installments is crucial for facilitating higher-value purchases.

*/
-- =====================================
-- END OF THE ANALYSIS
-- =====================================