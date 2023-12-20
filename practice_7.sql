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
with t1 as
(SELECT user_id, tweet_date, tweet_count,
lag(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date) as rolling_1,
lag(tweet_count,2) OVER(PARTITION BY user_id ORDER BY tweet_date) as rolling_2
FROM tweets)
select user_id, tweet_date,
Case 
when  rolling_1 is not null and rolling_2 is not null then round((tweet_count+rolling_1+rolling_2)/3.0, 2) 
when rolling_1 is  null and rolling_2 is null then round((tweet_count+COALESCE(rolling_1,0)+COALESCE(rolling_2,0))/1.0, 2)
ELSE round((tweet_count+COALESCE(rolling_1,0)+COALESCE(rolling_2,0))/2.0, 2) 
END as rolling_avg_3d
from t1

--ex6_
WITH t1 AS (
SELECT *,
LAG(transaction_timestamp) OVER (PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp) AS prev_time
FROM transactions)

SELECT COUNT(*) AS payment_count
FROM t1
Where EXTRACT(minute from transaction_timestamp-prev_time)*60 + EXTRACT(second from transaction_timestamp-prev_time)<60*10

 --ex7
with t1 as
(SELECT category, product, SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT(year from transaction_date) = 2022 
GROUP BY category, product),
t2 as
(SELECT category, product, total_spend, 
ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_spend DESC) as rank_2
FROM t1)
select category, product, total_spend from t2
where rank_2 <=2,

--ex8
with top10 AS
(select song_id, rank
from global_song_rank
where rank<=10),
count_name as
(SELECT artists.artist_name,count(top10.song_id) as count
FROM songs
JOIN artists
ON artists.artist_id = songs.artist_id
JOIN top10
ON songs.song_id= top10.song_id
group by artists.artist_name),
rank_name as
(select artist_name, 
DENSE_RANK() OVER( ORDER BY count desc) as artist_rank
from count_name)
select artist_name, artist_rank
from rank_name
where artist_rank<=5;



