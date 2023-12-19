--ex1
with t1 as
(SELECT EXTRACT(Year from transaction_date) as year, product_id, spend as curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id ORDER BY EXTRACT(Year from transaction_date)) as prev_year_spend
FROM user_transactions)
select year, product_id, curr_year_spend, prev_year_spend,
ROUND((curr_year_spend-prev_year_spend)/prev_year_spend*100,2) as yoy_rate
from t1;

--ex2


