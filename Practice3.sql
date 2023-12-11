--ex1
select Name
from STUDENTS 
Where Marks > 75
order by right(name, 3), id;

--ex2
select user_id, 
CONCAT (UPPER (LEFT (name,1)),lOWER(RIGHT(name,LENGTH (name)-1))) as name
from Users
order by user_id;

--EX3
SELECT manufacturer,
'$'||CEILING(SUM(total_sales)/1000000)||' '||'Million' as sale
FROM pharmacy_sales
group by manufacturer
order by Sum(total_sales) desc, manufacturer;

--EX4
SELECT Extract(month from submit_date) as mth,
product_id as product,
Round(AVG(stars),2) as avg_stars
FROM reviews
group by product_id, mth
order by mth, product;

--EX5
SELECT sender_id,
count(message_id) as message_count
FROM messages
where EXTRACT(month from sent_date)=8 and EXTRACT(year from sent_date)=2022
group by sender_id
order by message_count desc
limit 2;

--EX6
select tweet_id
from Tweets
where Length(content) >15;

--EX7
Select activity_date as day,
count(distinct user_id) as active_users
from Activity
where activity_date between '2019-06-28' and '2019-07-27' 
Group by activity_date
Having  count(user_id)>=1;

--EX8
select count(id) as number_employees
from employees
Where Extract(month from joining_date) between 1 and 7 and extract(year from joining_date)=2022;

--ex9
select POSITION('a'IN first_name)
from worker
where first_name = 'Amitah';

--ex10
select substring(title, length(winery)+2,4)
from winemag_p2
where country ='Macedonia';
