--EX1
with table1 as 
(SELECT company_id, count(title), count(distinct title)
FROM job_listings
GROUP BY company_id
having count(title)>count(distinct title))
select 
count(company_id) as duplicate_companies
from table1;

--EX2
with table1 as
(SELECT category, product, SUM(spend) as total_spend
FROM product_spend
where EXTRACT(year from transaction_date) =2022 AND category ='appliance' 
GROUP BY category, product
ORDER BY category, SUM(spend) desc
limit 2),
table2 as
(SELECT category, product, SUM(spend) as total_spend
FROM product_spend
where EXTRACT(year from transaction_date) =2022 AND category ='electronics' 
GROUP BY category, product
ORDER BY category, SUM(spend) desc
limit 2)
select category, product, total_spend
from table1
UNION ALL
SELECT category, product, total_spend
FROM table2;

--ex3_cau nay ko co dl k run dc a
with table1 as 
(SELECT policy_holder_id, count(case_id) as member_count
FROM callers
GROUP BY (policy_holder_id))
select member_count 
from table1
where member_count >=3;

--ex4_cau nay co lam roi

--ex5
with table1 as 
(SELECT user_id, count(event_type)
FROM user_actions
where extract(month from event_date)=6 and extract(year from event_date)=2022
group by user_id
having count(event_type) >=1 ),
table2 as 
(SELECT user_id, count(event_type)
FROM user_actions
where extract(month from event_date)=7 and extract(year from event_date)=2022
group by user_id
having count(event_type) >=1 )
select 7 as month, count(table1.user_id) as monthly_active_users
from table1
INNER JOIN table2
ON table1.user_id = table2.user_id;

--ex6_cau nay e run thay eccepted r ma sao submit no lai wrong answer nhi
with table1 as
(select 
TO_CHAR(trans_date, 'yyyy-mm') as month, country,
count(amount) as trans_count, sum(amount) as trans_total_amount
from Transactions
group by TO_CHAR(trans_date, 'yyyy-mm'), country),
table2 as
(select 
TO_CHAR(trans_date, 'yyyy-mm') as month, country,
count(amount) as approved_count, sum(amount) as approved_total_amount
from Transactions
where state='approved'
group by TO_CHAR(trans_date, 'yyyy-mm'), country)

select table1.month, table1.country, table1.trans_count, table2.approved_count, table1.trans_total_amount, table2.approved_total_amount
from table1
INNER JOIN table2
on table1.month=table2.month and table1.country=table2.country;

-----------------------------FIX ex6------------------
SELECT TO_CHAR(trans_date, 'yyyy-mm') as month, country,
COUNT(*) as trans_count,
SUM(CASE 
WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
SUM(amount) as trans_total_amount,
SUM(CASE 
WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY month, country;

--ex7
with table1 as
(select product_id, min(year) as first_year
from sales
group by product_id)
select table1.product_id, table1.first_year, Sales.quantity, Sales.price
from table1
inner join Sales
on table1.product_id=Sales.product_id and table1.first_year=Sales.year;

--ex8
select customer_id
from Customer
group by customer_id
having count(distinct product_key)= (select count(distinct product_key) from product);

--ex9
with table1 as 
(select employee_id
from  Employees
where salary <30000)
select table1.employee_id
from table1
INNER JOIN Employees
on table1.employee_id = Employees.manager_id;

--EX10
select employee_id
from  Employees
where salary <30000 AND manager_id NOT IN (select employee_id from Employees)
order by employee_id;

--ex11
with t1 as
(select user_id, count(rating) as count 
    from MovieRating
    group by user_id),
t2 as
(select movie_id, avg(rating) as avg
    from MovieRating
    where extract(month from created_at)=2 and extract(year from created_at)=2020
    group by movie_id),
t3 as
(select Users.name as results 
from t1
inner join Users
on t1.user_id = Users.user_id
where t1.count=(select Max(count) name from t1)
order by Users.name
limit 1),
t4 as 
(select Movies.title as results 
from t2
inner join Movies
on t2.movie_id = Movies.movie_id
where t2.avg= (select MAX(avg) name from t2) 
order by Movies.title
limit 1)
select results from t3
UNION ALL
select results from t4;

--ex12
with t1 as
(select requester_id, accepter_id from RequestAccepted
UNION
select  accepter_id, requester_id from RequestAccepted)
select requester_id as id, count(accepter_id) as num
from t1
group by requester_id 
order by count(accepter_id) desc
limit 1;






