-- Tạo metric trước khi dựng dashboard
CREATE VIEW nguyen-project-409809.nguyen_thelook_data.vw_ecommerce_analyst AS(

With table_1 as(
with t1 as(
Select a.product_id, a.created_at, a.order_id, a.user_id, a.sale_price,
 b.category, b.cost
from bigquery-public-data.thelook_ecommerce.order_items as a
LEFT JOIN bigquery-public-data.thelook_ecommerce.products as b
ON a.product_id=b.id
where a.status= 'Complete'),
t2 as(
select FORMAT_DATETIME('%Y-%m', c.created_at) as Month,FORMAT_DATETIME('%Y', c.created_at) as Year, 
t1.order_id, t1.category, t1.sale_price, t1.cost
from t1
LEFT JOIN bigquery-public-data.thelook_ecommerce.orders as c
ON t1. order_id= c.order_id)
select Month, Year,
category as Product_category, 
SUM(sale_price) as TPV, 
LAG(SUM(sale_price)) OVER (PARTITION BY category ORDER BY Month) AS lag_TPV,
COUNT(distinct order_id) as TPO, 
LAG(COUNT(DISTINCT order_id)) OVER (PARTITION BY category ORDER BY Month) as lag_TPO,
SUM(cost) as Total_cost
from t2
group by Month, Year, Product_category
order by Product_category, Month)
SELECT Month, Year, Product_category, 
TPV, CONCAT(ROUND((TPV-lag_TPV)/lag_TPV*100,2),'%') as Revenue_growth,
TPO, CONCAT(ROUND((TPO-lag_TPO)/lag_TPO*100,2),'%') as Order_growth,
Total_cost, TPV-Total_cost as Total_profit,(TPV-Total_cost)/Total_cost as Profit_to_cost_ratio
from table_1
order by Product_category,Month DESC)

----customer cohort

with tb1 as(
select user_id, sale_price,
FORMAT_DATE('%Y-%m',created_at) as cohort_date,
first_date, 
(Extract(year from created_at) - Extract(year from first_date))*12+(Extract(month from created_at) - Extract(month from first_date)) +1 as index
from
(Select user_id,sale_price, created_at,
MIN(created_at) OVER(PARTITION BY user_id) as first_date
from bigquery-public-data.thelook_ecommerce.order_items
where status = 'Complete')),
tb2 as(
select cohort_date,index,
count(distinct user_id) as count,
Sum (sale_price) as revenue
from tb1
group by cohort_date, index),
customer_cohort as(
select cohort_date,
SUM(CASE WHEN index=1 then count else 0 end) as m1,
SUM(CASE WHEN index=2 then count else 0 end) as m2,
SUM(CASE WHEN index=3 then count else 0 end) as m3,
SUM(CASE WHEN index=4 then count else 0 end) as m4
from tb2
group by cohort_date
order by cohort_date),

---retention cohort
retention as(
select cohort_date,
(ROUND(100.00*m1/m1,2)) || '%' as m1,
(ROUND(100.00*m2/m1,2)) || '%' as m2,
(ROUND(100.00*m3/m1,2)) || '%' as m3,
(ROUND(100.00*m4/m1,2)) || '%' as m4
from customer_cohort)


--churn cohord
select cohort_date,
(100-ROUND(100.00*m1/m1,2)) || '%' as m1,
(100-ROUND(100.00*m2/m1,2)) || '%' as m2,
(100-ROUND(100.00*m3/m1,2)) || '%' as m3,
(100-ROUND(100.00*m4/m1,2)) || '%' as m4
from customer_cohort

----LINK SHEET:
https://docs.google.com/spreadsheets/d/1ls-055djtMPf7GZ8W6TZdxLbC9g3nrQFRHJCtlk7ySo/edit?usp=sharing

