--ex1
with t1 as
(SELECT EXTRACT(Year from transaction_date) as year, product_id, spend as curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id ORDER BY EXTRACT(Year from transaction_date)) as prev_year_spend
FROM user_transactions)
select year, product_id, curr_year_spend, prev_year_spend,
ROUND((curr_year_spend-prev_year_spend)/prev_year_spend*100,2) as yoy_rate
from t1;

--ex2
with t1 as
(SELECT card_name,issued_amount,
RANK() OVER (PARTITION BY card_name ORDER BY issue_year, issue_month) as rank_1
FROM monthly_cards_issued)
select card_name, issued_amount from t1
where rank_1=1
ORDER BY issued_amount desc

--ex3
WITH t1 as
(SELECT user_id, spend, transaction_date,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) as rank_1
FROM transactions)
select user_id, spend, transaction_date
from t1
where rank_1=3;

--ex4
with t1 as
(SELECT transaction_date, user_id, product_id,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date desc) as rank_1
FROM user_transactions)
SELECT transaction_date, user_id,
count( product_id) as  purchase_count
 from  t1
 where rank_1=1
 group by transaction_date, user_id;

--ex5

