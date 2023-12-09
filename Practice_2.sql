--EX1
SELECT DISTINCT CITY FROM STATION
WHERE ID%2 =0;

--EX2
SELECT COUNT(CITY) - COUNT(DISTINCT CITY) FROM STATION;

--EX3-nay e tra mang ra ham replace - mySQL dùng CEIL thay vi dung CEILING nhu PostgreSQL
SELECT 
CEIL(AVG(Salary)-AVG(REPLACE(Salary,'0','')))
FROM  EMPLOYEES
  
--EX4
SELECT 
ROUND(CAST(SUM(item_count * order_occurrences)/sum(order_occurrences)
AS DECIMAL),1) 
FROM items_per_order;

--EX5
SELECT candidate_id FROM candidates
where skill in ('Python','Tableau', 'PostgreSQL')
group by(candidate_id)
having count(skill)=3;

--EX6
SELECT user_id, 
Date(max(post_date))-date(min(post_date)) as days_between
FROM posts
where post_date >= '2021-01-01' AND post_date <'2022-01-01'
group by user_id
having count(post_id) >=2;

--EX7
SELECT card_name,
max(issued_amount)-min(issued_amount) as difference
FROM monthly_cards_issued
group by card_name
order by difference desc;

--EX8
SELECT manufacturer,  
count(drug) as drug_count,
abs(sum(total_sales-cogs)) as total_loss
FROM pharmacy_sales
where (total_sales-cogs) <0 
group by manufacturer
order by total_loss desc;

--EX9
select * from Cinema
where id%2=1 and description <> 'boring'
order by rating desc;

--EX10
select teacher_id,
count(distinct subject_id) as cnt
from Teacher
group by teacher_id;

--EX11
select user_id,
count(follower_id) as followers_count
from Followers
group by user_id
order by user_id;

--EX12
select class from Courses
group by class
having count(class) >=5;


