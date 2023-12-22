--ex1
with t1 as
(Select *,
Case
when order_date=customer_pref_delivery_date then 'immediate' else 'scheduled' end as col_1,
row_number() over(partition by customer_id order by order_date)  as first_order
from Delivery)
select 
round(cast(sum(case when col_1='immediate' and first_order=1 then 1 else 0 end)as decimal)/
sum(case when first_order =1 then 1 else 0 end)*100,2) as immediate_percentage
from t1;

--ex2
with t1 as
(select * ,event_date+1 as next_event_day
from Activity),
t2 as
(SELECT *,
LEAD(event_date) over(partition by player_id order by event_date) as next_date,
ROW_NUMBER() over(partition by player_id ORDER BY event_date) AS row_number
from t1)
select 
ROUND(CAST(COUNT(CASE WHEN next_date = next_event_day AND row_number = 1 THEN 1 END) as decimal) / (select COUNT(DISTINCT player_id) from Activity),2) AS fraction
from t2;

--ex3
select 
CASE
when id%2=1 and rank() over(order by id desc) =1 then id
WHEN id%2=1 then id+1 else id-1 end as id,student
from Seat
order by id;

--ex4_ submit wrong answer. 'RANGE BETWEEN INTERVAL '6 DAY' PRECEDING AND CURRENT ROW' cái này là em tìm hiểu thêm nhưng mà 
nếu dựa vào những kiến thức đã học thì làm như nào v ạ? Vì cái này không phải ngày nào cũng liên tiếp nhau
with t1 as
(select visited_on,
sum(amount) as amount
from Customer
group by visited_on),
t2 as
(SELECT visited_on, 
SUM(amount) OVER(ORDER BY visited_on RANGE BETWEEN INTERVAL '6 DAY' PRECEDING AND CURRENT ROW) AS amount
FROM t1)

SELECT visited_on, amount, ROUND(cast(amount/7 as decimal), 2) as average_amount
from t2
WHERE visited_on>= (select visited_on from Customer order by visited_on limit 1 )+6

--ex5
WITH t1 as
(Select tiv_2015, lat, lon, tiv_2016,
COUNT(*) OVER (PARTITION BY tiv_2015) as tiv_2015_count,
COUNT(*) OVER (PARTITION BY lat, lon) as location_count
from Insurance)

SELECT ROUND(CAST(SUM(tiv_2016)as decimal), 2) AS tiv_2016
from t1 
WHERE tiv_2015_count > 1 and location_count = 1;

--ex6
with t1 as
(select *,
DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC ) AS rank_salary
from Employee)
select Department.name as Department, t1.name as Employee, t1.Salary
from Department
JOIN t1
on t1. departmentid= Department.id
where rank_salary <=3;

  
--ex7
with t1 as
(select *,
sum(weight) over(order by turn) as sum 
from Queue),
t2 as
(select person_name,
rank() over(order by sum desc) as rank_sum
from t1
where sum<=1000)
select person_name
from t2
where rank_sum =1;

--ex8
with t1 as
(select *, 
ROW_NUMBER() over(partition by product_id order by change_date desc) as rank_date
from Products
where change_date<='2019-08-16'),
t2 as
(select product_id,  new_price as price
from t1 
where rank_date=1 ),
t3 as
(select Products.product_id, 10 as price
from Products 
where change_date > '2019-08-16' and product_id not in (select product_id from t2)  )
select distinct * from t2
union all
select distinct* from t3;



