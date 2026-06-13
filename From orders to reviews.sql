-- 1. Yearly revenue trend

select
extract(year from o.order_purchase_timestamp) as order_year,
round(sum(oi.price + oi.freight_value)) as total_revenue
from orders o
join order_items oi
on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by order_year
order by order_year;

--2. Monthly order volume

select
extract(year from order_purchase_timestamp) as order_year,
extract(month from order_purchase_timestamp) as order_month,
count(order_id) as total_orders
from orders
group by order_year, order_month
order by order_year, order_month;

--3. Percentage orders are delivered on time vs late 

select
case
when order_delivered_customer_date <= order_estimated_delivery_date
then 'on time'
else 'late'
end as delivery_status,
count(*) as total_orders,
round(
count(*) * 100.0 /
sum(count(*)) over (),2) as percentage
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null
group by delivery_status;

--4. Avg time from purchase to delivery

select avg(order_delivered_customer_date - order_purchase_timestamp)as avg_delivery_days
from orders
where order_status = 'delivered'
and order_delivered_customer_date is not null;

--5. Difference between estimated delivery days to actual avg delivery days per state

select c.customer_state,
    round(avg(extract(epoch from (o.order_estimated_delivery_date - o.order_purchase_timestamp)) / 86400),2) 
	as avg_estimated_days,

    round(avg(extract(epoch from (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400),2) 
	as avg_actual_days,

    round(avg(extract(epoch from (o.order_delivered_customer_date - o.order_estimated_delivery_date)) / 86400),2)
	as avg_difference_days

from orders o
join customers c
on o.customer_id = c.customer_id

where o.order_status = 'delivered'
and o.order_delivered_customer_date is not null

group by c.customer_state
order by avg_difference_days desc;

--6. % Share of one time buyers vs repeat buyer 

with customer_orders as(
select c.customer_unique_id,
count(o.order_id) as total_orders
from orders o
join customers c
on o.customer_id = c.customer_id
group by c.customer_unique_id)

select
case
when total_orders = 1 then 'one-time buyer'
else 'repeat buyer'
end as buyer_type,
count(*) as customers,
round(count(*) * 100.0 /sum(count(*)) over (),2) as percentage_share
from customer_orders
group by buyer_type;

--7. % share of revenue based on states

with state_revenue as(
select c.customer_state,
round(sum(oi.price)) as total_revenue
from orders o
join customers c
on o.customer_id = c.customer_id
join order_items oi
on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by c.customer_state)
select customer_state,
total_revenue,
round( total_revenue * 100.0 /sum(total_revenue) over ()) as revenue_share_percentage
from state_revenue
order by revenue_share_percentage desc;

--8. Revenue based on product category

select pct.product_category_name_english as product_category,
round(sum(oi.price)) as total_revenue
from order_items oi
join products p
on oi.product_id = p.product_id
join translations pct
on p.product_category_name = pct.product_category_name
group by pct.product_category_name_english
order by total_revenue desc;

--9. Top Sellers 

select s.seller_id,
s.seller_state,
round(sum(oi.price)) as total_revenue
from order_items oi
join sellers s
on oi.seller_id = s.seller_id
group by s.seller_id, s.seller_state
order by total_revenue desc
limit 10;

--10. Sellers with worst on time delivering rates

select s.seller_id,
count(distinct o.order_id) as total_orders,
round(100.0 * sum(
case
when o.order_delivered_customer_date > o.order_estimated_delivery_date
then 1
else 0
end) / count(distinct o.order_id),2) as late_delivery_percentage
from orders o
join order_items oi
on o.order_id = oi.order_id
join sellers s
on oi.seller_id = s.seller_id
where o.order_status = 'delivered'
group by s.seller_id
having count(distinct o.order_id) >= 20
order by late_delivery_percentage desc
limit 50;

--11. Distribution of review scores

select review_score,
count(*) as total_reviews,
round(count(*) * 100.0 / sum(count(*)) over ()) as percentage_share
from reviews
group by review_score
order by review_score;

-- 12. Revenue share based on product category

select
coalesce(t.product_category_name_english, p.product_category_name) as product_category,
round(sum(pay.payment_value)) as revenue,
round(sum(pay.payment_value) * 100.0 /
sum(sum(pay.payment_value)) over ()) as revenue_percentage
from order_items oi
join products p
on oi.product_id = p.product_id
join translations t
on p.product_category_name = t.product_category_name
join orders o
on oi.order_id = o.order_id
join payments pay
on o.order_id = pay.order_id
where o.order_status = 'delivered'
group by product_category
order by revenue desc;

--13. do late deliveries lead to lower review scores?

select
case
when o.order_delivered_customer_date <= o.order_estimated_delivery_date
then 'on time'
else 'late'
end as delivery_status,
round(avg(r.review_score), 2) as avg_review_score,
count(*) as total_reviews
from orders o
join reviews r
on o.order_id = r.order_id
where o.order_status = 'delivered'
group by delivery_status;

--14. Avg review based on product category

select pct.product_category_name_english as product_category,
round(avg(r.review_score), 2) as avg_review_score,
count(distinct o.order_id) as total_orders
from reviews r
join orders o
on r.order_id = o.order_id
join order_items oi
on o.order_id = oi.order_id
join products p
on oi.product_id = p.product_id
join translations pct
on p.product_category_name = pct.product_category_name
group by pct.product_category_name_english
having count(distinct o.order_id) >= 50
order by avg_review_score asc;

-- 15.Revenue lost due to cancellations

select round(sum(oi.price)) as revenue_lost
from orders o
join order_items oi
on o.order_id = oi.order_id
where o.order_status = 'canceled';
