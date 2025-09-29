# Brazilian E-Commerce (Olist) Data Analysis

## Project Overview

This project presents a  SQL analysis of the Brazilian e-commerce public dataset from Olist. The dataset contains information on over 100,000 orders from September 2016 to August 2018. The analysis transforms raw operational data into  business intelligence, providing insights into sales performance, customer behavior, geographic trends and operational efficiency.

## Business Objectives

The analysis addresses the following crusial business questions:

- **Data Quality & Integrity:** Is the data complete, consistent and reliable for analysis?
- **Customer Understanding:** Who are our customers, what do they buy and how often do they shop?
- **Sales Performance:** What are the top-selling products and categories? What are the revenue trends over time?
- **Operational Efficiency:** How efficient is our order fulfillment and delivery process? Are there significant delays?
- **Geographic Expansion:** Which regions and cities present the highest potential for growth?
- **Customer Retention:** What is the rate of repeat customers and how can we improve customer loyalty?
- **Seller Performance:** Which sellers are the most reliable and high-performing?

## Dataset

The Olist dataset consists of 8 CSV files representing a relational database structure. The project utilises the following tables:

- `olist_orders_dataset`: Core order information (status, timestamps)
- `olist_order_items_dataset`: Items purchased within each order
- `olist_order_payments_dataset`: Payment details for each order
- `olist_order_reviews_dataset`: Customer reviews and scores
- `olist_products_dataset`: Product information and categories
- `olist_sellers_dataset`: Seller information
- `olist_order_customer_dataset`: Customer demographic data
- `olist_geolocation_dataset`: Zip code coordinates for geographic mapping

## Tools & Technologies

- **SQL:** Primary language for data analysis, transformation and aggregation
- **PostgreSQL:** Database management system used for this analysis (syntax is largely standard SQL and portable to other systems)
- **SQL Techniques:** Common Table Expressions (CTEs), Window Functions, Joins, Aggregation, Data Quality Checks, Conditional Logic (CASE statements)

## Analysis Structure

The analysis is organized into 13 logical phases:

1. **Data Quality Checks:** Validation of data completeness, identification of orphaned records and handling of invalid entries
2. **Dataset Exploration:** High-level overview of order status distribution, payment methods and review scores
3. **Temporal Analysis:** Examination of monthly sales trends, seasonal patterns and growth rates
4. **Geographic Analysis:** Breakdown of sales and customers by state and city
5. **Delivery Performance Analysis:** Metrics on delivery times, delay rates and regional performance
6. **Customer Behavior Analysis:** Customer segmentation, repeat purchase behavior, RFM analysis and purchase timing patterns
7. **Seller Performance Analysis:** Evaluation of sellers based on revenue, volume and customer ratings
8. **Product Analysis:** Performance of product categories, impact of product dimensions and return rates
9. **Customer & Market Intelligence:** Advanced analysis including cohort retention, market basket analysis and price sensitivity
10. **Revenue Analysis:** Detailed breakdown of revenue streams and payment installment trends
11. **Operational Efficiency Metrics:** Analysis of order fulfillment timelines and seller efficiency
12. **Forecasting & Performance Optimization:** Data preparation for forecasting and seller reward program proposals
13. **Core Metrics & Business Highlights:** Summary of Key Performance Indicators (KPIs) and top performers

## Key Insights

- **High Performance:** The platform maintains a 99.99% order fulfillment rate with an average customer review score of 4.09/5
- **Customer Base:** 97% of customers are one-time buyers, indicating significant opportunity for improved retention strategies
- **Revenue Drivers:** Health & Beauty is the top revenue-generating category, with credit cards representing 73.9% of transactions
- **Geographic Concentration:** Sao Paulo (SP) dominates with approximately 41% of all customers and 40,489 orders
- **Operational Efficiency:** Most orders arrive 11 days earlier than promised, though delivery performance varies significantly by region
- **Peak Season:** November 2017 was the highest-grossing month (BRL 1.15M), likely driven by Black Friday and holiday shopping

## Implementation Guide

1. **Database Setup:** Create a PostgreSQL database and execute the provided `CREATE TABLE` statements to establish the schema
2. **Data Import:** Load the corresponding CSV files from the Olist dataset into the created tables
3. **Analysis Execution:** Run the SQL queries sequentially, following the steps outlined in the script. Each section is clearly marked with relevant observations

## License

This project analyses publicly available data from Kaggle. Please refer to the original Olist dataset licensing terms for commercial usage restrictions.

## Acknowledgments

Data provided by Olist through Kaggle's Brazilian E-Commerce Public Dataset. This analysis is intended for educational and research purposes, demonstrating comprehensive SQL-based business intelligence techniques applied to real-world e-commerce data.

## Connect to me

Feel free to reach out to me  via email muthominicholus22@gmail.com or through my website https://nicholusmuthomi.website/