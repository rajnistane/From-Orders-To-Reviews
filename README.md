# From-Orders-To-Reviews

## 🚛Project Overview
End-to-end analysis of real transactional Olist departmental-store marketplace dataset. Orders placed on Olist are fulfilled by independent sellers and shipped directed to customers across different location vis Olist's logistic partners. After delivery customers receive a satisfaction survey making the dataset span the entire customer journey.

## 📌Objective
To analyse and quantify bottlenecks from purchase to delivery to review, key factors driving revenue and limiting long-term growth.

##  🗂️Dataset Information

Source: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?select=olist_geolocation_dataset.csv

| Table Name           |      Rows | Columns | Most Important Columns                                                                                                      |
| -------------------- | --------: | ------: | --------------------------------------------------------------------------------------------------------------------------- |
| Customers            |    99,441 |       5 | customer_id, customer_unique_id, customer_city, customer_state                                                              |
| Orders               |    99,441 |       8 | order_id, customer_id, order_status, order_purchase_timestamp, order_delivered_customer_date, order_estimated_delivery_date |
| Order Items          |   112,650 |       7 | order_id, product_id, seller_id, price, freight_value                                                                       |
| Products             |    32,951 |       9 | product_id, product_category_name, product_weight_g, product_length_cm, product_height_cm, product_width_cm                 |
| Sellers              |     3,095 |       4 | seller_id, seller_city, seller_state                                                                                        |
| Payments             |   103,886 |       5 | order_id, payment_type, payment_installments, payment_value                                                                 |
| Reviews              |    99,224 |       7 | review_id, order_id, review_score, review_comment_message                                                                   |
| Geolocation          | 1,000,163 |       5 | geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state                          |
| Category Translation |        71 |       2 | product_category_name, product_category_name_english                                                                        |



## ⛓️Project Workflow


Understanding Dataset ---> Data Cleaning (Pandas) ---> Data Analysis (PostgreSQL) ---> EDA (Matplotlib) ---> Power BI Dashboard



##  🎯Business Questions

- How has annual revenue trended over time?
- What is the share of one-time buyers versus repeat buyers?
- What percentage of orders are delivered on time versus delayed?
- Do delayed deliveries lead to lower customer review scores?
- How is the revenue distributed over the states and sellers?
- Which product categories generate the most revenue?
- What is the revenue loss due to cancellation and product 
unavailability?


Note: This and further analyses were performed using PostgreSQL and are available in the SQL scripts and project ppt included in this repository.

## 💡Business Impact & Recommendations
Problems
- 96.88% of the customers are One-Time buyers while just 3.12% are repeat buyers making the business unsustainable in the long run.
- 8% of the orders are delivered late making the customers unsatisfied as the avg ratings of late delivered orders comes down to 2.57 compared to 4.29 out of 5 of On Time delivered orders. 
(Following sellers are the reason for the delayed orders)
- Around 63% of the revenue comes from just 3 states out of 27 states and about 40% from a single state, signalling a regional risk. 
- 5 of 71 product categories drive 40% of revenue, making the low rated categories go unaddressed.


Recommendations
- Improving customer retention should be the first priority post-purchase engagement and reducing friction for returning customers. 
- Sellers with the highest late delivery rates should be addressed through performance monitoring to improve delivery efficiency in order to increase the rating in turn increasing the revenue.
- The company must consider strengthening its presence in multiple states along with the top performing states by revenue to scale the business and decrease its regional dependency.
- Low rated product categories should be improved to drive more customers and diversify revenue beyond current top states.



What the business is doing well

- Revenue grew from BRL 6.9M in 2017 to BRL 8.4M in 2018, a 22% increase year-over-year, showing strong business growth.
- Customers rate their experience at an average of 4.09 out of 5, indicating the majority of buyers are satisfied with their purchases.
- 97.02% of orders are successfully delivered, with a cancellation rate and unavailable orders adding to just 1.24% of total orders placed reflecting reliable order fulfillment. 
- The business operates across all 27 Brazilian states, showing genuine national reach.



## 🤖Tech Stack
| Tool       | Purpose         |
| ---------- | --------------- |
| Python     | Data Cleaning   |
| Pandas     | Data Processing |
| PostgreSQL | SQL Analysis    |
| Matplotlib | EDA             |
| Power BI   | Dashboarding    |


## 📈Future Improvements

Product Recommendation System: Build a recommendation system that analyzes customer purchase history and buying patterns to suggest relevant products to improve customer retention and overall sales performance.

## Contact
Email: rajnistane9@gmail.com

Linkdin: https://www.linkedin.com/in/raj-nistane/
